#!/usr/bin/env zsh

# ============================================================================
# WORKTREE-CREATE.SH - Worker Script for Creating Worktrees
# ============================================================================
# Handles creation of new worktrees for both new and existing branches
# Copies .env files, installs dependencies, and opens new shell
#
# Arguments:
#   $1 - REPO_ROOT: Path to the root repository
#   $2 - WORKTREE_DIR: Path to worktrees directory
#   $3 - BRANCH_NAME: Name of the branch to create worktree for
#   $4 - BASE_BRANCH: (Optional) Base branch for new branches
#   $5 - FOLDER_NAME: (Optional) Custom folder name (defaults to branch name if not provided)

# Get script directory and source libraries
SCRIPT_DIR="$(cd "$(dirname "$0")/.." && pwd)"
source "$SCRIPT_DIR/lib/common.sh"
source "$SCRIPT_DIR/lib/git-utils.sh"
source "$SCRIPT_DIR/lib/deps.sh"

# Setup environment
setup_environment

# Parse positional arguments
REPO_ROOT="$1"
WORKTREE_DIR="$2"
BRANCH_NAME="$3"
BASE_BRANCH="$4"  # Optional - only for new branches
FOLDER_NAME="$5"  # Optional - custom folder name

# Use custom folder name if provided, otherwise use branch name
if [[ -n "$FOLDER_NAME" ]]; then
    TARGET_WORKTREE="$WORKTREE_DIR/$FOLDER_NAME"
else
    TARGET_WORKTREE="$WORKTREE_DIR/$BRANCH_NAME"
fi

# Validate required arguments
if [ -z "$REPO_ROOT" ] || [ -z "$WORKTREE_DIR" ] || [ -z "$BRANCH_NAME" ]; then
    log "Error: Missing required arguments"
    echo "Error: Missing required arguments"
    echo "Usage: worktree-create.sh <repo_root> <worktree_dir> <branch_name> [base_branch] [folder_name]"
    echo "Press Enter to close..."
    read
    exit 1
fi

log "Starting worktree creation process"
log "Repo Root: $REPO_ROOT"
log "Worktree Dir: $WORKTREE_DIR"
log "Branch Name: $BRANCH_NAME"
log "Base Branch: $BASE_BRANCH"
log "Folder Name: ${FOLDER_NAME:-$BRANCH_NAME} (using branch name as default)"
log "Target Worktree: $TARGET_WORKTREE"

# Change to repo root
cd "$REPO_ROOT" || exit 1

# Create worktree (with or without base branch)
if [ -n "$BASE_BRANCH" ]; then
    # New branch from base branch
    log "Creating worktree for new branch $BRANCH_NAME from base branch $BASE_BRANCH"

    if gum spin --spinner dot --title "Creating worktree for ${FOLDER_NAME:-$BRANCH_NAME}..." --show-output -- \
        git worktree add "$TARGET_WORKTREE" -b "$BRANCH_NAME" "$BASE_BRANCH"; then
        log "Worktree for new branch $BRANCH_NAME created at $TARGET_WORKTREE"
    else
        log "Failed to create worktree for new branch $BRANCH_NAME"
        echo "Failed to create worktree. Check logs for details."
        echo "Press Enter to close..."
        read
        exit 1
    fi
else
    # Existing branch
    log "Creating worktree for existing branch $BRANCH_NAME"

    if gum spin --spinner dot --title "Creating worktree for ${FOLDER_NAME:-$BRANCH_NAME}..." --show-output -- \
        git worktree add "$TARGET_WORKTREE" "$BRANCH_NAME"; then
        log "Worktree for existing branch $BRANCH_NAME created at $TARGET_WORKTREE"
    else
        log "Failed to create worktree for existing branch $BRANCH_NAME"
        echo "Failed to create worktree. Check logs for details."
        echo "Press Enter to close..."
        read
        exit 1
    fi
fi

# Change to new worktree
cd "$TARGET_WORKTREE" || exit 1

log "Changed to worktree directory: $TARGET_WORKTREE"

# Copy .env files
copy_env_files "$REPO_ROOT" "$TARGET_WORKTREE"

# Ask about additional files to copy
copy_additional_files "$TARGET_WORKTREE"

# Launch dependency installation if needed
launch_dependency_install "$TARGET_WORKTREE" "$BRANCH_NAME"

log "Worktree creation process completed"

echo "Worktree created successfully."

# Launch new shell in the worktree
exec zsh

# vim:fdm=marker
