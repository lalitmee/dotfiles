# Feature Implementation Plan: Extensible Backup System

## 📋 Todo Checklist
- [ ] Create `scripts/backup/config.json`
- [ ] Create `scripts/backup/repo.sh`
- [ ] Make `scripts/backup/repo.sh` executable
- [ ] Modify `scripts/backup/run-cron-jobs`
- [ ] Modify `cron/second-brain.cron`
- [ ] Remove `scripts/backup/second-brain`
- [ ] Final Review and Testing

## 🔍 Analysis & Investigation

### Codebase Structure
The current backup system consists of two scripts: `scripts/backup/run-cron-jobs` and `scripts/backup/second-brain`. `run-cron-jobs` is a wrapper that calls `second-brain` with either a "personal" or "work" argument. The `second-brain` script contains the logic for backing up the second-brain repositories, with hardcoded paths. The cron jobs are defined in `cron/second-brain.cron`.

### Current Architecture
The current architecture is not extensible. Adding a new repository to the backup system requires modifying the `second-brain` script, which is not ideal. The `run-cron-jobs` script is also tightly coupled to the `second-brain` script.

### Dependencies & Integration Points
The backup scripts use `git` for version control and `notify-send` or `dunstify` for notifications on Linux, and `osascript` for notifications on macOS. The new system will also use `jq` to parse the JSON configuration file.

### Backup Strategy: Sequential vs. Parallel

The new backup system will back up repositories **sequentially**. This means that the `run-cron-jobs` script will iterate through the list of repositories in the `config.json` file and back them up one after another. As soon as one backup process finishes, the next one will begin, with no time interval in between.

**Why a Sequential Approach?**

*   **Simplicity and Reliability:** A sequential approach is simpler to implement and less prone to race conditions or other concurrency-related issues.
*   **Resource Management:** Running backups sequentially prevents resource contention. If multiple backups were to run in parallel, they would compete for CPU, network, and I/O resources, which could slow down the system and potentially cause backups to fail.
*   **Predictability:** A sequential approach is more predictable. The backups will run in a known order, and the total time to complete all backups will be the sum of the time it takes to back up each repository.

**Future Considerations**

While a sequential approach is the best choice for this use case, the system could be modified to support parallel backups in the future if the number of repositories grows significantly and the backup time becomes an issue. This could be achieved by using a tool like `xargs` with the `-P` option to run multiple instances of the `repo.sh` script in parallel.

### Considerations & Challenges
- The new system should be backward compatible with the existing cron jobs, if possible.
- The new system should be easy to configure and use.
- The new system should have robust error handling and logging.

## 📝 Implementation Plan

### Prerequisites
- `jq` must be installed on the system.

### Step-by-Step Implementation
1. **Step 1**: Create `scripts/backup/config.json`
   - Files to modify: `scripts/backup/config.json` (new file)
   - Changes needed: Create a new JSON file with the following content. This file will store the configuration for the repositories to be backed up.

```json
{
  "repositories": [
    {
      "name": "personal-second-brain",
      "path": "$HOME/Projects/Personal/Github/second-brain"
    },
    {
      "name": "work-second-brain",
      "path": "$HOME/Projects/Work/Github/second-brain"
    },
    {
      "name": "dotfiles",
      "path": "$HOME/dotfiles"
    }
  ]
}
```

2. **Step 2**: Create `scripts/backup/repo.sh`
   - Files to modify: `scripts/backup/repo.sh` (new file)
   - Changes needed: Create a new shell script that will perform the backup for a single repository.

```bash
#!/bin/bash

REPO_NAME="$1"
CONFIG_FILE="$HOME/dotfiles/scripts/backup/config.json"

if [[ -z "$REPO_NAME" ]]; then
    echo "❌ ERROR: Please specify a repository name as the first argument"
    exit 1
fi

REPO_PATH=$(jq -r --arg name "$REPO_NAME" '.repositories[] | select(.name == $name) | .path' "$CONFIG_FILE")

if [[ -z "$REPO_PATH" ]]; then
    echo "❌ ERROR: Repository '$REPO_NAME' not found in $CONFIG_FILE"
    exit 1
fi

# Expand the home directory
REPO_PATH=$(eval echo "$REPO_PATH")

LOG_DIR="$HOME/.local/share/backup-logs/$REPO_NAME"
SUCCESS_LOG="$LOG_DIR/success.log"
ERROR_LOG="$LOG_DIR/error.log"
MAX_LOG_SIZE=$((5 * 1024 * 1024)) # 5 MB in bytes
SUCCESS_RETENTION_DAYS=7
ERROR_RETENTION_DAYS=30

ICON_PATH="$HOME/.config/icons/brain.png"

mkdir -p "$LOG_DIR"

rotate_log_if_needed() {
    local log_file="$1"
    if [[ -f "$log_file" ]]; then
        local log_size=$(stat -f%z "$log_file" 2> /dev/null || stat -c%s "$log_file" 2> /dev/null)
        if [[ $log_size -gt $MAX_LOG_SIZE ]]; then
            mv "$log_file" "${log_file}.old"
            echo "🔄 Rotated log file (exceeded 5 MB)" > "$log_file"
        fi
    fi
}

cleanup_old_logs() {
    find "$LOG_DIR" -name "*.log*" -type f -mtime +$SUCCESS_RETENTION_DAYS -delete 2> /dev/null
}

start_log_session() {
    local log_file="$1"
    rotate_log_if_needed "$log_file"
    {
        echo ""
        echo "============================================================"
        echo "[$(date '+%Y-%m-%d %H:%M:%S')] Backup Run Started"
        echo "------------------------------------------------------------"
    } >> "$log_file"
}

end_log_session() {
    local log_file="$1"
    echo "============================================================" >> "$log_file"
}

log_message() {
    local log_file="$1"
    local message="$2"
    echo "$message" >> "$log_file"
}

send_notification() {
    local title="$1"
    local message="$2"
    local urgency="${3:-normal}"
    local icon="${4:-$ICON_PATH}"

    if [[ "$OSTYPE" == "darwin"* ]]; then
        osascript -e "display notification "$message" with title "$title" sound name "default""
    else
        if command -v notify-send &> /dev/null; then
            notify-send -u "$urgency" -i "$icon" "$title" "$message"
        elif command -v dunstify &> /dev/null; then
            dunstify -u "$urgency" -i "$icon" "$title" "$message"
        fi
    fi
}

echo "------------------------------------------------------------"
echo "🧠 $REPO_NAME backup started at: $(date '+%Y-%m-%d %H:%M:%S')"

start_log_session "$SUCCESS_LOG"
cleanup_old_logs

if ! cd "$REPO_PATH" 2> /dev/null; then
    ERROR_MSG="Failed to cd into $REPO_PATH"
    echo "❌ ERROR: $ERROR_MSG"
    start_log_session "$ERROR_LOG"
    log_message "$ERROR_LOG" "CD Failed: $ERROR_MSG"
    end_log_session "$ERROR_LOG"
    end_log_session "$SUCCESS_LOG"
    send_notification "🧠 $REPO_NAME Backup Failed" "$ERROR_MSG" "critical"
    exit 1
fi

git rebase --abort 2> /dev/null

echo "📥 Pulling latest changes..."
log_message "$SUCCESS_LOG" "Pull started..."

PULL_OUTPUT=$(git pull --rebase --no-edit 2>&1)
PULL_STATUS=$?

if [[ $PULL_STATUS -ne 0 ]]; then
    ERROR_MSG="Git pull failed for $REPO_NAME"
    echo "❌ ERROR: $ERROR_MSG"
    start_log_session "$ERROR_LOG"
    log_message "$ERROR_LOG" "Pull Failed:"
    log_message "$ERROR_LOG" "$PULL_OUTPUT"
    end_log_session "$ERROR_LOG"
    end_log_session "$SUCCESS_LOG"
    send_notification "🧠 $REPO_NAME Backup Failed" "$ERROR_MSG

Check: $ERROR_LOG" "critical"
    exit 1
else
    log_message "$SUCCESS_LOG" "Pull completed successfully"
fi

HAS_CHANGES=false
if ! git diff --quiet || ! git diff --cached --quiet || [ -n "$(git ls-files --others --exclude-standard)" ]; then
    HAS_CHANGES=true
    echo "📝 Changes detected, committing..."
    log_message "$SUCCESS_LOG" "Commit started..."

    git add --all
    COMMIT_OUTPUT=$(git commit -m "auto: $REPO_NAME backup on $(date '+%Y-%m-%d %H:%M:%S')" 2>&1)
    COMMIT_STATUS=$?

    if [[ $COMMIT_STATUS -ne 0 ]]; then
        ERROR_MSG="Git commit failed for $REPO_NAME"
        echo "❌ ERROR: $ERROR_MSG"
        start_log_session "$ERROR_LOG"
        log_message "$ERROR_LOG" "Commit Failed:"
        log_message "$ERROR_LOG" "$COMMIT_OUTPUT"
        end_log_session "$ERROR_LOG"
        end_log_session "$SUCCESS_LOG"
        send_notification "🧠 $REPO_NAME Backup Failed" "$ERROR_MSG

Check: $ERROR_LOG" "critical"
        exit 1
    else
        echo "✅ Changes committed"
        log_message "$SUCCESS_LOG" "Commit successful"
    fi
else
    echo "✅ No local changes to commit"
    log_message "$SUCCESS_LOG" "No changes to commit"
fi

if git rev-parse @{u} > /dev/null 2>&1; then
    LOCAL=$(git rev-parse @)
    REMOTE=$(git rev-parse @{u})

    if [ "$LOCAL" != "$REMOTE" ]; then
        echo "📤 Local is ahead of remote, pushing..."
        log_message "$SUCCESS_LOG" "Push started..."

        MAX_RETRIES=3
        RETRY_DELAY=5
        PUSH_SUCCESS=false

        for i in $(seq 1 $MAX_RETRIES); do
            PUSH_OUTPUT=$(git push 2>&1)
            PUSH_STATUS=$?

            if [[ $PUSH_STATUS -eq 0 ]]; then
                echo "✅ $REPO_NAME backup pushed successfully"
                log_message "$SUCCESS_LOG" "Push successful"
                PUSH_SUCCESS=true
                send_notification "🧠 $REPO_NAME Backup Success" "$REPO_NAME backed up successfully" "normal"
                break
            else
                if [ $i -lt $MAX_RETRIES ]; then
                    echo "⚠️  Push failed, retrying in ${RETRY_DELAY}s... (attempt $i/$MAX_RETRIES)"
                    sleep $RETRY_DELAY
                else
                    ERROR_MSG="Git push failed after $MAX_RETRIES attempts for $REPO_NAME"
                    echo "❌ ERROR: $ERROR_MSG"
                    start_log_session "$ERROR_LOG"
                    log_message "$ERROR_LOG" "Push Failed (after $MAX_RETRIES attempts):"
                    log_message "$ERROR_LOG" "$PUSH_OUTPUT"
                    end_log_session "$ERROR_LOG"
                    end_log_session "$SUCCESS_LOG"
                    send_notification "🧠 $REPO_NAME Backup Failed" "$ERROR_MSG

Check: $ERROR_LOG" "critical"
                    exit 1
                fi
            fi
        done
    else
        echo "✅ Already up to date with remote"
        log_message "$SUCCESS_LOG" "Already up to date with remote"
    fi
else
    WARNING_MSG="No upstream branch configured for $REPO_NAME"
    echo "⚠️  $WARNING_MSG, skipping push check"
    log_message "$SUCCESS_LOG" "$WARNING_MSG"
    send_notification "🧠 $REPO_NAME Warning" "$WARNING_MSG" "normal"
fi

echo "✅ $REPO_NAME backup completed at: $(date '+%Y-%m-%d %H:%M:%S')"
log_message "$SUCCESS_LOG" "Backup completed successfully"
end_log_session "$SUCCESS_LOG"
```

3. **Step 3**: Make `scripts/backup/repo.sh` executable
   - Files to modify: `scripts/backup/repo.sh`
   - Changes needed: Make the script executable.
   - Command: `chmod +x scripts/backup/repo.sh`

4. **Step 4**: Modify `scripts/backup/run-cron-jobs`
   - Files to modify: `scripts/backup/run-cron-jobs`
   - Changes needed: Modify the script to read the configuration file and loop through the repositories, running the backups sequentially.

```bash
#!/bin/bash

CONFIG_FILE="$HOME/dotfiles/scripts/backup/config.json"
BACKUP_SCRIPT="$HOME/dotfiles/scripts/backup/repo.sh"

if ! command -v jq &> /dev/null; then
    echo "❌ ERROR: jq is not installed. Please install it to continue."
    exit 1
fi

REPO_NAMES=$(jq -r '.repositories[].name' "$CONFIG_FILE")

for repo_name in $REPO_NAMES; do
    echo "--- Starting backup for $repo_name ---"
    /bin/bash "$BACKUP_SCRIPT" "$repo_name"
    echo "--- Finished backup for $repo_name ---"
done
```

5. **Step 5**: Modify `cron/second-brain.cron`
   - Files to modify: `cron/second-brain.cron`
   - Changes needed: Comment out the old cron jobs and add a new one for the new backup system.

```cron
# personal-brain backup (on the hour)
# 0 */3 * * * /bin/bash /home/lalitmee/dotfiles/scripts/backup/run-cron-jobs personal >/dev/null 2>&1

# work-brain backup (30 minutes after the hour)
# 30 */3 * * * /bin/bash /home/lalitmee/dotfiles/scripts/backup/run-cron-jobs work >/dev/null 2>&1

# New backup system
0 */3 * * * /bin/bash /home/lalitmee/dotfiles/scripts/backup/run-cron-jobs >/dev/null 2>&1

# * * * * * /bin/bash /home/lalitmee/dotfiles/scripts/test/test-home

# * * * * * /bin/bash /home/lalitmee/dotfiles/scripts/backup/test-cron
```

6. **Step 6**: Remove `scripts/backup/second-brain`
   - Files to modify: `scripts/backup/second-brain`
   - Changes needed: Remove the old backup script.
   - Command: `rm scripts/backup/second-brain`

### Testing Strategy
- Run the `run-cron-jobs` script manually and check the logs for each repository in `$HOME/.local/share/backup-logs/`.
- Verify that the notifications are sent correctly.
- Add a new repository to the `config.json` file and run the `run-cron-jobs` script again to ensure that the new repository is backed up.
- Remove a repository from the `config.json` file and run the `run-cron-jobs` script again to ensure that the removed repository is no longer backed up.

## 🎯 Success Criteria
- The `dotfiles` repository is automatically backed up.
- The backup system is easily extensible by modifying the `config.json` file.
- The old `second-brain` script is removed.
- The cron job is updated to use the new backup system.
- The new system is working as expected.
