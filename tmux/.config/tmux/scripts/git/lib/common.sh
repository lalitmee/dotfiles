#!/usr/bin/env zsh

# ============================================================================
# COMMON.SH - Shared Utilities for Git Worktree Management
# ============================================================================
# Global configuration and common functions used by all scripts

# Global variables
export LOG_DIR="$HOME/.local/share/tmux/logs"
export LOG_FILE="$LOG_DIR/git-worktree.log"
export DEBUG_MODE="${DEBUG_MODE:-false}"

# ============================================================================
# Setup environment with proper PATH
# ============================================================================
setup_environment() {
    export PATH="$HOME/.local/state/fnm_multishells/*/bin:$HOME/.local/bin:/usr/local/bin:/opt/homebrew/bin:$PATH"
    mkdir -p "$LOG_DIR"
}

# ============================================================================
# Logging function (respects DEBUG_MODE)
# Only logs if DEBUG_MODE is set to "true"
# ============================================================================
log() {
    [[ "$DEBUG_MODE" == "true" ]] && echo "$(date +'%Y-%m-%d %H:%M:%S') - $1" >> "$LOG_FILE"
}

# ============================================================================
# Cross-platform timeout function (works on Linux and macOS)
# Usage: timeout_seconds 10 command args...
# ============================================================================
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

# ============================================================================
# Copy .env files from source to target
# Automatically copies all .env* files if they don't exist in target
# Checks root level and nested level (mobile/)
# ============================================================================
copy_env_files() {
    local repo_root="$1"
    local target_path="$2"

    log "Checking for .env files to copy to $target_path"
    
    # Check if repo_root exists
    if [ ! -d "$repo_root" ]; then
        log "Source directory $repo_root does not exist"
        return
    fi

    # Find and copy .env files from root level
    find "$repo_root" -maxdepth 1 -name ".env*" | while read -r source_file; do
        local filename=$(basename "$source_file")
        local target_file="$target_path/$filename"
        
        if [ ! -f "$target_file" ]; then
            rsync "$source_file" "$target_file"
            log "Copied '$filename' to '$target_path'"
        fi
    done

    # Find and copy .env files from nested level (mobile/)
    local nested_dirs=("mobile")
    for nested_dir in "${nested_dirs[@]}"; do
        local nested_path="$repo_root/$nested_dir"
        if [ -d "$nested_path" ]; then
            find "$nested_path" -maxdepth 1 -name ".env*" | while read -r source_file; do
                local filename=$(basename "$source_file")
                local target_dir="$target_path/$nested_dir"
                local target_file="$target_dir/$filename"
                
                # Create nested directory if it doesn't exist
                mkdir -p "$target_dir"
                
                if [ ! -f "$target_file" ]; then
                    rsync "$source_file" "$target_file"
                    log "Copied '$nested_dir/$filename' to '$target_path/$nested_dir'"
                fi
            done
        fi
    done
}

# ============================================================================
# Interactive file copy for additional files beyond .env
# Prompts user to select additional files to copy using fzf
# ============================================================================
copy_additional_files() {
    local target_path="$1"

    log "Prompting user for additional file copies"
    
    if gum confirm "Do you want to select additional files to copy?"; then
        # Exclude environment files from fzf list
        SELECTED_FILES=$(git ls-files | grep -v ".env*" | fzf --multi --preview 'bat --color=always --style=numbers --line-range=:500 {}')

        if [ -n "$SELECTED_FILES" ]; then
            gum spin --spinner dot --title "Copying selected files..." --show-output -- bash -c '
                echo "$SELECTED_FILES" | while read -r file; do
                    rsync -R "$file" "'"$target_path"'/"
                done
            '
            log "Additional files copied to $target_path"
        fi
    fi
}

# ============================================================================
# Copy tasks.json from source to target
# Copies from root repo if exists, otherwise creates from template
# ============================================================================
copy_tasks_json() {
    local repo_root="$1"
    local target_path="$2"

    log "Checking for tasks.json to copy to $target_path"
    
    # Check if repo_root exists
    if [ ! -d "$repo_root" ]; then
        log "Source directory $repo_root does not exist"
        return
    fi

    local target_file="$target_path/.vscode/tasks.json"
    local source_tasks="$repo_root/.vscode/tasks.json"

    # Create .vscode directory in target if it doesn't exist
    mkdir -p "$target_path/.vscode"

    # Default template
    local default_template='{
    "version": "2.0.0",
    "tasks": [
        {
            "label": "Git Commit (no verify)",
            "type": "shell",
            "command": "git commit --no-verify",
            "problemMatcher": [],
            "presentation": {
                "reveal": "always",
                "panel": "shared"
            }
        },
        {
            "label": "Git Push (first time: set upstream)",
            "type": "shell",
            "command": "git push -u origin HEAD",
            "problemMatcher": [],
            "presentation": {
                "reveal": "always",
                "panel": "shared"
            }
        },
        {
            "label": "Git Push (origin, no verify)",
            "type": "shell",
            "command": "git push origin HEAD --no-verify",
            "problemMatcher": [],
            "presentation": {
                "reveal": "always",
                "panel": "shared"
            }
        },
        {
            "label": "Git Pull (rebase) + Push (no verify)",
            "type": "shell",
            "command": "git pull --rebase && git push --no-verify",
            "problemMatcher": [],
            "presentation": {
                "reveal": "always",
                "panel": "shared"
            }
        }
    ]
}'

    if [ -f "$source_tasks" ]; then
        # Copy from root repo
        rsync "$source_tasks" "$target_file"
        log "Copied tasks.json from root repo to '$target_path'"
    else
        # Use default template
        echo "$default_template" > "$target_file"
        log "Created default tasks.json at '$target_path'"
    fi
}

# ============================================================================
# Set git user email in worktree
# Always sets the configured email for the worktree
# ============================================================================
set_git_user() {
    local target_path="$1"
    local git_email="lalit.kumar1@nykaa.com"

    log "Setting git user email in $target_path"

    # Change to target worktree directory
    cd "$target_path" || return

    # Set the git user email
    git config user.email "$git_email"
    
    log "Set git user.email to '$git_email' in worktree"
}

# vim:fdm=marker
