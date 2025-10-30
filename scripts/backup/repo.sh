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
        osascript -e "display notification \"$message\" with title \"$title\" sound name \"default\""
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
    send_notification "🧠 $REPO_NAME Backup Failed" "$ERROR_MSG\n\nCheck: $ERROR_LOG" "critical"
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
        send_notification "🧠 $REPO_NAME Backup Failed" "$ERROR_MSG\n\nCheck: $ERROR_LOG" "critical"
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
                    send_notification "🧠 $REPO_NAME Backup Failed" "$ERROR_MSG\n\nCheck: $ERROR_LOG" "critical"
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
