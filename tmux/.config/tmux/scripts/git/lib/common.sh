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

    # Find and copy .env files
    find "$repo_root" -maxdepth 1 -name ".env*" | while read -r source_file; do
        local filename=$(basename "$source_file")
        local target_file="$target_path/$filename"
        
        if [ ! -f "$target_file" ]; then
            rsync "$source_file" "$target_file"
            log "Copied '$filename' to '$target_path'"
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

# vim:fdm=marker
