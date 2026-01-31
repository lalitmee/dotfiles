#!/usr/bin/env zsh

# ============================================================================
# GIT-WORKTREE.SH - Main Entry Point for Git Worktree Management
# ============================================================================
# Simple, clean main script that orchestrates worktree operations
#
# Usage:
#   git-worktree.sh              # Interactive menu
#   git-worktree.sh create       # Create new worktree
#   git-worktree.sh switch       # Switch to worktree
#   git-worktree.sh delete       # Delete worktree
#   git-worktree.sh --debug      # Run with debug logging enabled

# Get script directory
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

# Source libraries
source "$SCRIPT_DIR/lib/common.sh"
source "$SCRIPT_DIR/lib/git-utils.sh"

# Check for debug flag
if [[ "$1" == "--debug" ]]; then
    export DEBUG_MODE="true"
    log "Debug mode enabled"
    shift
fi

# Setup environment
setup_environment

# Ensure we're in a git repo
ensure_git_repo

# Get repository information
REPO_INFO=$(get_repo_info)
REPO_ROOT=$(echo "$REPO_INFO" | cut -d'|' -f1)
REPO_NAME=$(echo "$REPO_INFO" | cut -d'|' -f2)
WORKTREE_DIR=$(echo "$REPO_INFO" | cut -d'|' -f3)

log "Repo Root: $REPO_ROOT"
log "Repo Name: $REPO_NAME"
log "Worktree Dir: $WORKTREE_DIR"

# Ensure the worktrees directory exists
mkdir -p "$WORKTREE_DIR"

# ============================================================================
# Main Menu
# ============================================================================
main_menu()
            {
    echo -e "Create\nSwitch\nDelete" | gum filter --header "Git Worktree Manager"
}

# ============================================================================
# Create Worktree Function
# ============================================================================
create_worktree()
                  {
    log "Attempting to create a new worktree"

    # Use fzf instead of gum to avoid TTY issues in tmux popups
    if command -v fzf >/dev/null 2>&1; then
        CREATE_OPTION=$(echo -e "Create new branch\nSelect existing branch" | fzf --prompt="Choose option:")
    else
        # Fallback to simple input if fzf not available
        CREATE_OPTION=$(echo -e "Create new branch\nSelect existing branch" | head -1)
    fi

    if [ "$CREATE_OPTION" = "Create new branch" ]; then
        log "User selected: Create new branch"

        # Use fzf instead of gum to avoid TTY issues in tmux popups
        if command -v fzf >/dev/null 2>&1; then
            BASE_BRANCH=$(git branch | fzf --prompt="Select a base branch for the new worktree")
            BASE_BRANCH=$(echo "$BASE_BRANCH" | sed 's/^[* ]*//' | xargs)
        else
            # Fallback to simple selection if fzf not available
            BASE_BRANCH=$(git branch | head -5 | tail -1 | sed 's/^[* ]*//' | xargs)
        fi

        if [ -z "$BASE_BRANCH" ]; then
            log "Worktree creation failed: No base branch selected"
            gum style --foreground "212" "No base branch selected. Exiting..."
            sleep 2
            exit 1
        fi

        BRANCH_NAME=$(gum input --placeholder "Enter new branch name")

        if [ -z "$BRANCH_NAME" ]; then
            log "Worktree creation failed: Branch name was empty"
            gum style --foreground "212" "Branch name cannot be empty. Exiting..."
            sleep 2
            exit 1
        fi

        log "Preparing to create worktree for new branch '$BRANCH_NAME' from '$BASE_BRANCH'"
        
        # Prompt for folder name
        FOLDER_NAME=$(prompt_folder_name "$BRANCH_NAME" "$WORKTREE_DIR")
        if [ $? -ne 0 ]; then
            log "Worktree creation failed: Folder name selection cancelled or failed"
            gum style --foreground "212" "Folder name selection cancelled. Exiting..."
            sleep 2
            exit 1
        fi
        
        WINDOW_NAME=$(generate_window_name "$FOLDER_NAME")

        # CLEAN CALL - NO COMPLEX ESCAPING!
        tmux new-window -c "$REPO_ROOT" -n "$WINDOW_NAME" \
            "$SCRIPT_DIR/workers/worktree-create.sh '$REPO_ROOT' '$WORKTREE_DIR' '$BRANCH_NAME' '$BASE_BRANCH' '$FOLDER_NAME'"

    elif [ "$CREATE_OPTION" = "Select existing branch" ]; then
        log "User selected: Select existing branch"

        # Use fzf instead of gum to avoid TTY issues in tmux popups
        if command -v fzf >/dev/null 2>&1; then
            BRANCH_NAME=$(git branch | fzf --prompt="Select a branch")
            BRANCH_NAME=$(echo "$BRANCH_NAME" | sed 's/^[* ]*//' | xargs)
        else
            # Fallback to simple selection if fzf not available
            BRANCH_NAME=$(git branch | head -5 | tail -1 | sed 's/^[* ]*//' | xargs)
        fi

        if [ -z "$BRANCH_NAME" ]; then
            log "Worktree creation failed: No branch selected"
            gum style --foreground "212" "No branch selected. Exiting..."
            sleep 2
            exit 1
        fi

        log "Preparing to create worktree for existing branch '$BRANCH_NAME'"
        
        # Prompt for folder name
        FOLDER_NAME=$(prompt_folder_name "$BRANCH_NAME" "$WORKTREE_DIR")
        if [ $? -ne 0 ]; then
            log "Worktree creation failed: Folder name selection cancelled or failed"
            gum style --foreground "212" "Folder name selection cancelled. Exiting..."
            sleep 2
            exit 1
        fi
        
        WINDOW_NAME=$(generate_window_name "$FOLDER_NAME")

        # CLEAN CALL - NO COMPLEX ESCAPING!
        tmux new-window -c "$REPO_ROOT" -n "$WINDOW_NAME" \
            "$SCRIPT_DIR/workers/worktree-create.sh '$REPO_ROOT' '$WORKTREE_DIR' '$BRANCH_NAME' '' '$FOLDER_NAME'"
    fi
}

# ============================================================================
# Switch Worktree Function
# ============================================================================
switch_worktree()
                  {
    log "Attempting to switch to a worktree"

    WORKTREE=$(git worktree list | fzf --prompt="Select a worktree to switch to: " | awk '{print $1}')

    if [ -n "$WORKTREE" ]; then
        log "Switching to worktree '$WORKTREE'"
        BRANCH_NAME=$(basename "$WORKTREE")
        WINDOW_NAME=$(generate_window_name "$BRANCH_NAME")

        # CLEAN CALL - NO COMPLEX ESCAPING!
        tmux new-window -c "$WORKTREE" -n "$WINDOW_NAME" \
            "$SCRIPT_DIR/workers/worktree-switch.sh '$WORKTREE' '$BRANCH_NAME' '$REPO_ROOT'"
    else
        log "Worktree switch cancelled"
    fi
}

# ============================================================================
# Delete Worktree Function
# ============================================================================
delete_worktree()
                  {
    log "Attempting to delete a worktree"

    FZF_OUTPUT=$(git worktree list | fzf --prompt="Select a worktree to delete: " --expect=ctrl-d)
    KEY=$(echo "$FZF_OUTPUT" | head -n1)
    WORKTREE_TO_DELETE=$(echo "$FZF_OUTPUT" | tail -n1 | awk '{print $1}')

    if [ -n "$WORKTREE_TO_DELETE" ]; then
        worktree_name=$(basename "$WORKTREE_TO_DELETE")
        cleaned_name=$(generate_window_name "$worktree_name")
        WINDOW_NAME="delete:${cleaned_name}"
        FORCE_FLAG=""

        if [ "$KEY" = "ctrl-d" ]; then
            FORCE_FLAG="--force"
            log "Preparing to force delete worktree '$WORKTREE_TO_DELETE'"
        else
            log "Preparing to delete worktree '$WORKTREE_TO_DELETE'"
        fi

        # CLEAN CALL - NO COMPLEX ESCAPING!
        tmux new-window -n "$WINDOW_NAME" \
            "$SCRIPT_DIR/workers/worktree-delete.sh '$WORKTREE_TO_DELETE' '$FORCE_FLAG'"
    else
        log "Worktree deletion cancelled"
    fi
}

# ============================================================================
# Main Logic
# ============================================================================
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
        log "Unknown action: $ACTION"
        exit 1
        ;;
esac

# vim:fdm=marker
