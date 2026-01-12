#!/usr/bin/env zsh

# ============================================================================
# WORKTREE-SWITCH.SH - Worker Script for Switching to Worktrees
# ============================================================================
# Switches to an existing worktree, copies .env files, and handles dependencies
#
# Arguments:
#   $1 - WORKTREE: Path to the worktree to switch to
#   $2 - BRANCH_NAME: Name of the branch (for window naming)
#   $3 - REPO_ROOT: Path to the root repository

# Get script directory and source libraries
SCRIPT_DIR="$(cd "$(dirname "$0")/.." && pwd)"
source "$SCRIPT_DIR/lib/common.sh"
source "$SCRIPT_DIR/lib/git-utils.sh"
source "$SCRIPT_DIR/lib/deps.sh"

# Setup environment
setup_environment

# Parse positional arguments
WORKTREE="$1"
BRANCH_NAME="$2"
REPO_ROOT="$3"

# Validate arguments
if [ -z "$WORKTREE" ] || [ -z "$BRANCH_NAME" ] || [ -z "$REPO_ROOT" ]; then
    echo "Error: Missing required arguments"
    echo "Usage: worktree-switch.sh <worktree_path> <branch_name> <repo_root>"
    echo "Press Enter to close..."
    read
    exit 1
fi

log "Starting worktree switch process"
log "Worktree: $WORKTREE"
log "Branch: $BRANCH_NAME"
log "Repo Root: $REPO_ROOT"

# Change to worktree
cd "$WORKTREE" || exit 1

log "Switched to worktree $WORKTREE"

# Copy .env files if they don't exist
copy_env_files "$REPO_ROOT" "$WORKTREE"

# Ask about additional files to copy
copy_additional_files "$WORKTREE"

# Launch dependency installation if needed
launch_dependency_install "$WORKTREE" "$BRANCH_NAME"

log "Worktree switch process completed"

# Launch new shell in the worktree
exec zsh

# vim:fdm=marker
