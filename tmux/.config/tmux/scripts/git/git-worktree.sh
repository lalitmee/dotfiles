#!/usr/bin/env bash

# Ensure PATH includes common gemini installation locations
export PATH="$HOME/.local/state/fnm_multishells/*/bin:$HOME/.local/bin:/usr/local/bin:/opt/homebrew/bin:$PATH"

# Flag to disable AI naming (set to 1 to disable)
DISABLE_AI_NAMING=${DISABLE_AI_NAMING:-0}

LOG_DIR="$HOME/.local/share/tmux/logs"
LOG_FILE="$LOG_DIR/git-worktree.log"
CACHE_FILE="$LOG_DIR/git-worktree-cache.txt"

# Ensure the log directory exists
mkdir -p "$LOG_DIR"

# Logging function
log() {
    echo "$(date +'%Y-%m-%d %H:%M:%S') - $1" >> "$LOG_FILE"
}

# Cache management functions
get_cached_window_name() {
    local branch_name="$1"
    if [[ -f "$CACHE_FILE" ]]; then
        # Look for the branch in cache (format: branch_name=window_name)
        local cached_name
        cached_name=$(grep "^${branch_name}=" "$CACHE_FILE" 2>/dev/null | cut -d'=' -f2)
        if [[ -n "$cached_name" ]]; then
            log "Found cached window name for branch '$branch_name': '$cached_name'"
            echo "$cached_name"
            return 0
        fi
    fi
    return 1  # Not found in cache
}

cache_window_name() {
    local branch_name="$1"
    local window_name="$2"

    # Ensure cache directory exists
    mkdir -p "$LOG_DIR"

    # Remove existing entry for this branch (if any)
    if [[ -f "$CACHE_FILE" ]]; then
        sed -i.bak "/^${branch_name}=/d" "$CACHE_FILE" && rm -f "${CACHE_FILE}.bak"
    fi

    # Add new entry
    echo "${branch_name}=${window_name}" >> "$CACHE_FILE"
    log "Cached window name for branch '$branch_name': '$window_name'"
}

# Cross-platform timeout function (works on Linux and macOS)
# Usage: timeout_seconds command args...
timeout_seconds() {
    local timeout_duration="$1"
    shift

    # Use timeout command if available (Linux)
    if command -v timeout &> /dev/null; then
        timeout "$timeout_duration" "$@"
        return $?
    fi

    # Fallback for macOS and other systems without timeout
    local pid
    ("$@") &
    pid=$!

    # Wait for the process with timeout
    local count=0
    while kill -0 "$pid" 2>/dev/null && [ $count -lt $timeout_duration ]; do
        sleep 1
        ((count++))
    done

    # If process is still running, kill it
    if kill -0 "$pid" 2>/dev/null; then
        kill "$pid" 2>/dev/null
        wait "$pid" 2>/dev/null
        return 124  # Same exit code as GNU timeout
    else
        wait "$pid" 2>/dev/null
        return $?
    fi
}

# Generate window name from branch name using Gemini AI with caching
generate_window_name() {
    local branch_name="$1"

    # Handle main/master branches (keep simple)
    if [[ "$branch_name" == "main" || "$branch_name" == "master" ]]; then
        echo "main"
        return
    fi

    # Handle develop branch (keep simple)
    if [[ "$branch_name" == "develop" ]]; then
        echo "develop"
        return
    fi

    # Check cache first
    local cached_name
    if cached_name=$(get_cached_window_name "$branch_name"); then
        echo "$cached_name"
        return
    fi

    # Try to use Gemini AI to generate a meaningful name (unless disabled)
    if [[ $DISABLE_AI_NAMING -eq 0 ]]; then
        log "Checking for Gemini CLI with PATH: $PATH"

        # Check multiple possible locations for gemini CLI
        GEMINI_CMD=""
        if command -v gemini &> /dev/null; then
            # Get the full path to gemini
            GEMINI_CMD=$(command -v gemini)
            log "Found gemini at: $GEMINI_CMD"
        elif [[ -e "/Users/lalit.kumar1/.local/state/fnm_multishells/50899_1764946590486/bin/gemini" ]]; then
            GEMINI_CMD="/Users/lalit.kumar1/.local/state/fnm_multishells/50899_1764946590486/bin/gemini"
            log "Found gemini at fnm path: $GEMINI_CMD"
        elif [[ -e "$HOME/.local/bin/gemini" ]]; then
            GEMINI_CMD="$HOME/.local/bin/gemini"
            log "Found gemini at ~/.local/bin: $GEMINI_CMD"
        elif [[ -e "/usr/local/bin/gemini" ]]; then
            GEMINI_CMD="/usr/local/bin/gemini"
            log "Found gemini at /usr/local/bin: $GEMINI_CMD"
        elif [[ -e "/opt/homebrew/bin/gemini" ]]; then
            GEMINI_CMD="/opt/homebrew/bin/gemini"
            log "Found gemini at /opt/homebrew/bin: $GEMINI_CMD"
        else
            log "Gemini CLI not found in any standard location"
        fi

        if [[ -n "$GEMINI_CMD" ]]; then
            log "Will use Gemini command: $GEMINI_CMD"
        local ai_response ai_name exit_code

        # Add 60-second timeout to account for Gemini CLI startup time (cross-platform)
        # Set environment variables for non-interactive mode
        export NODE_TLS_REJECT_UNAUTHORIZED="0"
        log "Executing: $GEMINI_CMD with branch: $branch_name"
        ai_response=$(timeout_seconds 60 env PATH="$PATH" NODE_TLS_REJECT_UNAUTHORIZED="0" $GEMINI_CMD "Generate a short tmux window name (max 15 chars) for git branch: $branch_name. Remove JIRA codes like NYS-1232. Return only the name." --output-format json 2>&1)
        exit_code=$?

        if [[ $exit_code -eq 124 ]]; then
            log "AI request timed out after 10 seconds"
        elif [[ $exit_code -ne 0 ]]; then
            log "AI command failed with exit code $exit_code"
        else
            # Try to extract the response from JSON
            ai_name=$(echo "$ai_response" | jq -r '.response' 2>/dev/null | tr -d '\n' | sed 's/^[[:space:]]*//;s/[[:space:]]*$//' | cut -c1-15)

            # Filter out Gemini CLI greeting messages
            if [[ "$ai_name" == "Hello! I'm read"* || "$ai_response" == *"Hello! I'm ready to help"* ]]; then
                ai_name=""
            fi

            # If we got an empty response, try alternative extraction
            if [[ -z "$ai_name" ]]; then
                ai_name=$(echo "$ai_response" | grep -o '"response":\s*"[^"]*"' | cut -d'"' -f4 | tr -d '\n' | sed 's/^[[:space:]]*//;s/[[:space:]]*$//' | cut -c1-15)
                if [[ "$ai_name" == "Hello! I'm read"* ]]; then
                    ai_name=""
                fi
            fi

            # Validate the AI-generated name
            if [[ -n "$ai_name" && "$ai_name" != "null" && ${#ai_name} -le 15 ]]; then
                # Remove any special characters that might break tmux
                ai_name=$(echo "$ai_name" | sed 's/[^a-zA-Z0-9_-]//g')
                log "Sanitized AI name: '$ai_name'"

                if [[ -n "$ai_name" ]]; then
                    log "AI successfully generated window name: $ai_name"
                    # Cache the successful AI-generated name
                    cache_window_name "$branch_name" "$ai_name"
                    echo "$ai_name"
                    return
                else
                    log "AI name became empty after sanitization"
                fi
            else
                log "AI name validation failed - name: '$ai_name', length: ${#ai_name}"
            fi
        fi

        log "AI name generation failed, falling back to simple naming"
        else
            log "Gemini CLI not found, falling back to simple naming"
        fi
    fi

    # Fallback: Simple naming logic (NO CACHING for fallbacks)
    if [[ "$branch_name" == feature/* ]]; then
        local feature_name="${branch_name#feature/}"
        if [[ ${#feature_name} -gt 12 ]]; then
            feature_name="${feature_name%%-*}"
            if [[ ${#feature_name} -gt 12 ]]; then
                feature_name="${feature_name:0:12}"
            fi
        fi
        echo "$feature_name"
    elif [[ "$branch_name" == bugfix/* ]]; then
        local bug_name="${branch_name#bugfix/}"
        if [[ ${#bug_name} -gt 12 ]]; then
            bug_name="${bug_name%%-*}"
            if [[ ${#bug_name} -gt 12 ]]; then
                bug_name="${bug_name:0:12}"
            fi
        fi
        echo "$bug_name"
    elif [[ "$branch_name" == hotfix/* ]]; then
        local hotfix_name="${branch_name#hotfix/}"
        if [[ ${#hotfix_name} -gt 12 ]]; then
            hotfix_name="${hotfix_name%%-*}"
            if [[ ${#hotfix_name} -gt 12 ]]; then
                hotfix_name="${hotfix_name:0:12}"
            fi
        fi
        echo "$hotfix_name"
    elif [[ "$branch_name" == release/* ]]; then
        local release_name="${branch_name#release/}"
        if [[ ${#release_name} -gt 12 ]]; then
            release_name="${release_name%%-*}"
            if [[ ${#release_name} -gt 12 ]]; then
                release_name="${release_name:0:12}"
            fi
        fi
        echo "$release_name"
    else
        # For other branches, use the name as-is but truncate if needed
        local fallback_name="$branch_name"
        if [[ ${#fallback_name} -gt 15 ]]; then
            fallback_name="${fallback_name:0:15}"
        fi
        echo "$fallback_name"
    fi
}

# Check if we are in a git repository
if ! git rev-parse --is-inside-work-tree > /dev/null 2>&1; then
    log "Script run outside of a git repository."
    gum style --foreground "212" "Not a git repository. Exiting..."
    sleep 2
    exit 1
fi

REPO_ROOT=$(git rev-parse --show-toplevel)
REPO_NAME=$(basename "$REPO_ROOT")
WORKTREE_DIR="$REPO_ROOT/../${REPO_NAME}-worktrees"

# Ensure the worktrees directory exists
mkdir -p "$WORKTREE_DIR"

# Main menu
main_menu() {
    echo -e "Create\nSwitch\nDelete" | gum filter --header "Git Worktree Manager"
}

# -------------------------------------------------------------------
# # NOTE: _handle_file_copy {{{
# -------------------------------------------------------------------

_handle_file_copy() {
    local target_worktree_path="$1"

    log "Checking for .env files to copy to $target_worktree_path"
    # Automatically copy environment files if they don't exist in the target
    find . -maxdepth 1 -name ".env*" | while read -r source_file; do
        local filename
        filename=$(basename "$source_file")
        local target_file="$target_worktree_path/$filename"
        if [ ! -f "$target_file" ]; then
            rsync "$source_file" "$target_file"
            log "Copied '$filename' to '$target_worktree_path'"
        fi
    done

    if gum confirm "Do you want to select additional files to copy?"; then
        # Exclude environment files from fzf list
        SELECTED_FILES=$(git ls-files | grep -v ".env*" | fzf --multi --preview 'bat --color=always --style=numbers --line-range=:500 {}')

        if [ -n "$SELECTED_FILES" ]; then
            gum spin --spinner dot --title "Copying selected files..." --show-output -- bash -c '
                echo "$SELECTED_FILES" | while read -r file; do
                    rsync -R "$file" "'$target_worktree_path'/"
                done
            '
        fi
    fi
}

# -------------------------------------------------------------------
# }}}
# -------------------------------------------------------------------

# -------------------------------------------------------------------
# # NOTE: _handle_dependency_installation {{{
# -------------------------------------------------------------------

_handle_dependency_installation() {
    local target_worktree_path="$1"
    local confirmation_needed="$2"

    log "Checking for package.json in $target_worktree_path"
    if [ -f "$target_worktree_path/package.json" ]; then
        log "Found package.json, checking node_modules"
        # If node_modules doesn't exist, force install without confirmation.
        if [ ! -d "$target_worktree_path/node_modules" ]; then
            confirmation_needed=false
        fi

        if [ "$confirmation_needed" = "false" ] || gum confirm "Install dependencies in $target_worktree_path?"; then
            local PACKAGE_MANAGER
            local INSTALL_CMD
            if [ -f "$target_worktree_path/yarn.lock" ]; then
                PACKAGE_MANAGER="yarn"
                # Check yarn version to use appropriate install command
                YARN_VERSION=$(yarn --version 2>/dev/null | cut -d. -f1)
                if [ "$YARN_VERSION" = "1" ]; then
                    INSTALL_CMD="yarn install --frozen-lockfile"
                else
                    INSTALL_CMD="yarn install --immutable"
                fi
            elif [ -f "$target_worktree_path/package-lock.json" ]; then
                PACKAGE_MANAGER="npm"
                INSTALL_CMD="npm ci"
            else
                PACKAGE_MANAGER="npm" # Default to npm
                INSTALL_CMD="npm install"
            fi

            log "Installing dependencies with $INSTALL_CMD in $target_worktree_path"
            local worktree_name=$(basename "$target_worktree_path")
            local window_name="deps-$worktree_name"

            log "Running tmux command: tmux new-window -c $target_worktree_path -n $window_name zsh -c 'source ~/.zshrc; $INSTALL_CMD; echo \"Press Enter to close...\"; read'"
            tmux new-window -c "$target_worktree_path" -n "$window_name" "zsh -c 'source ~/.zshrc; $INSTALL_CMD; echo \"Press Enter to close...\"; read'"
            tmux display-message "Installing dependencies with $PACKAGE_MANAGER in window '$window_name'..."
        fi
    else
        log "No package.json found in $target_worktree_path"
    fi
}

# -------------------------------------------------------------------
# }}}
# -------------------------------------------------------------------

#-------------------------------------------------------------------------------
# # NOTE: Create a new worktree {{{
#-------------------------------------------------------------------------------

create_worktree() {
    log "Attempting to create a new worktree."

    CREATE_OPTION=$(gum choose "Create new branch" "Select existing branch")

    if [ "$CREATE_OPTION" = "Create new branch" ]; then
        BASE_BRANCH=$(git branch | gum filter --placeholder "Select a base branch for the new worktree")
        BASE_BRANCH=$(echo "$BASE_BRANCH" | sed 's/..//' | xargs)
        if [ -z "$BASE_BRANCH" ]; then
            log "Worktree creation failed: No base branch selected."
            gum style --foreground "212" "No base branch selected. Exiting..."
            sleep 2
            exit 1
        fi

        BRANCH_NAME=$(gum input --placeholder "Enter new branch name")
        if [ -z "$BRANCH_NAME" ]; then
            log "Worktree creation failed: Branch name was empty."
            gum style --foreground "212" "Branch name cannot be empty. Exiting..."
            sleep 2
            exit 1
        fi

        log "Creating worktree for new branch '$BRANCH_NAME' from '$BASE_BRANCH'."
        git worktree add "$WORKTREE_DIR/$BRANCH_NAME" -b "$BRANCH_NAME" "$BASE_BRANCH"
        log "Worktree for new branch '$BRANCH_NAME' created at $WORKTREE_DIR/$BRANCH_NAME."
        WINDOW_NAME=$(generate_window_name "$BRANCH_NAME")
        tmux new-window -c "$WORKTREE_DIR/$BRANCH_NAME" -n "$WINDOW_NAME"
        _handle_file_copy "$WORKTREE_DIR/$BRANCH_NAME"
        _handle_dependency_installation "$WORKTREE_DIR/$BRANCH_NAME" false
        sleep 2

    elif [ "$CREATE_OPTION" = "Select existing branch" ]; then
        BRANCH_NAME=$(git branch | gum filter --placeholder "Select a branch")
        BRANCH_NAME=$(echo "$BRANCH_NAME" | sed 's/..//' | xargs) # remove leading '* ' and whitespace
        if [ -z "$BRANCH_NAME" ]; then
            log "Worktree creation failed: No branch selected."
            gum style --foreground "212" "No branch selected. Exiting..."
            sleep 2
            exit 1
        fi

        log "Creating worktree for existing branch '$BRANCH_NAME'."
        git worktree add "$WORKTREE_DIR/$BRANCH_NAME" "$BRANCH_NAME"
        log "Worktree for existing branch '$BRANCH_NAME' created at $WORKTREE_DIR/$BRANCH_NAME."
        gum style --foreground "212" "Worktree for existing branch '$BRANCH_NAME' created at $WORKTREE_DIR/$BRANCH_NAME"
        WINDOW_NAME=$(generate_window_name "$BRANCH_NAME")
        tmux new-window -c "$WORKTREE_DIR/$BRANCH_NAME" -n "$WINDOW_NAME"
        _handle_file_copy "$WORKTREE_DIR/$BRANCH_NAME"
        _handle_dependency_installation "$WORKTREE_DIR/$BRANCH_NAME" false
        sleep 2
    fi
}

#-------------------------------------------------------------------------------
# }}}
#-------------------------------------------------------------------------------

#-------------------------------------------------------------------------------
# # NOTE: Switch to a worktree {{{
#-------------------------------------------------------------------------------

switch_worktree() {
    log "Attempting to switch to a worktree."
    WORKTREE=$(git worktree list | fzf --prompt="Select a worktree to switch to: " | awk '{print $1}')
    if [ -n "$WORKTREE" ]; then
        log "Switching to worktree '$WORKTREE'."
        BRANCH_NAME=$(basename "$WORKTREE")
        WINDOW_NAME=$(generate_window_name "$BRANCH_NAME")
        tmux new-window -c "$WORKTREE" -n "$WINDOW_NAME"
        _handle_file_copy "$WORKTREE"
        _handle_dependency_installation "$WORKTREE" true
    else
        log "Worktree switch cancelled."
    fi
}

#-------------------------------------------------------------------------------
# }}}
#-------------------------------------------------------------------------------

#-------------------------------------------------------------------------------
# # NOTE: Delete a worktree {{{
#-------------------------------------------------------------------------------

delete_worktree() {
    log "Attempting to delete a worktree."

    FZF_OUTPUT=$(git worktree list | fzf --prompt="Select a worktree to delete: " --expect=ctrl-d)
    KEY=$(echo "$FZF_OUTPUT" | head -n1)
    WORKTREE_TO_DELETE=$(echo "$FZF_OUTPUT" | tail -n1 | awk '{print $1}')

    if [ -n "$WORKTREE_TO_DELETE" ]; then
        local DELETE_COMMAND
        local WINDOW_NAME="deleting-worktree"

        if [ "$KEY" = "ctrl-d" ]; then
            log "Force deleting worktree '$WORKTREE_TO_DELETE'."
            DELETE_COMMAND="gum spin --spinner dot --title \"Force deleting worktree '$WORKTREE_TO_DELETE'...\" --show-output -- git worktree remove --force \"$WORKTREE_TO_DELETE\""
            tmux new-window -d -n "$WINDOW_NAME" "$DELETE_COMMAND; read -p 'Press Enter to close...'"
            tmux display-message "Force deleting worktree in a new window..."
        else
            log "Deleting worktree '$WORKTREE_TO_DELETE'."
            if ! git worktree remove "$WORKTREE_TO_DELETE" > /dev/null 2>&1; then
                log "Failed to delete worktree '$WORKTREE_TO_DELETE'. It may have modified files."
                gum style --foreground "212" "Failed to delete worktree. It may have modified files. Use <C-d> to force delete."
                sleep 3
            else
                DELETE_COMMAND="gum spin --spinner dot --title \"Deleting worktree '$WORKTREE_TO_DELETE'...\" --show-output -- git worktree remove \"$WORKTREE_TO_DELETE\""
                tmux new-window -d -n "$WINDOW_NAME" "$DELETE_COMMAND; read -p 'Press Enter to close...'"
                tmux display-message "Deleting worktree in a new window..."
            fi
        fi
    else
        log "Worktree deletion cancelled."
    fi
}

#-------------------------------------------------------------------------------
# }}}
#-------------------------------------------------------------------------------

# Main logic
if [ -n "$1" ]; then
    ACTION=$1
else
    ACTION=$(main_menu)
fi

case "$ACTION" in
    "Create" | "create")
        create_worktree
        ;;
    "Switch" | "switch")
        switch_worktree
        ;;
    "Delete" | "delete")
        delete_worktree
        ;;
    *)
        exit 1
        ;;
esac

# vim:fdm=marker
