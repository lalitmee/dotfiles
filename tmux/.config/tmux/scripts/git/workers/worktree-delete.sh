#!/usr/bin/env zsh

# ============================================================================
# WORKTREE-DELETE.SH - Worker Script for Deleting Worktrees
# ============================================================================
# Handles normal and force deletion of git worktrees
#
# Arguments:
#   $1 - WORKTREE_TO_DELETE: Path to the worktree to delete
#   $2 - FORCE_FLAG: "--force" for force delete, empty for normal delete

# Get script directory and source libraries
SCRIPT_DIR="$(cd "$(dirname "$0")/.." && pwd)"
source "$SCRIPT_DIR/lib/common.sh"

# Setup environment
setup_environment

# Parse positional arguments
WORKTREE_TO_DELETE="$1"
FORCE_FLAG="$2"

# Validate arguments
if [ -z "$WORKTREE_TO_DELETE" ]; then
    echo "Error: No worktree path provided"
    echo "Press Enter to close..."
    read
    exit 1
fi

log "Starting worktree deletion process"
log "Worktree: $WORKTREE_TO_DELETE"
log "Force flag: $FORCE_FLAG"

# Handle force deletion
if [ "$FORCE_FLAG" = "--force" ]; then
    log "Force deleting worktree $WORKTREE_TO_DELETE"

    # Extract worktree name for display
    worktree_display_name=$(basename "$WORKTREE_TO_DELETE")

    # Extract relative path (worktree directory from repo parent)
    repo_parent=$(dirname "$(git rev-parse --show-toplevel)")
    relative_path="${WORKTREE_TO_DELETE#$repo_parent/}"

    # Display info
    echo "Force deleting worktree: ${worktree_display_name}"
    echo "===================================="
    echo "Path: ${relative_path}"
    echo ""

    # Run force delete with spinner
    if gum spin --spinner dot --title "Force removing files..." --show-output -- \
        git worktree remove --force "$WORKTREE_TO_DELETE"; then
        log "Worktree $WORKTREE_TO_DELETE force deleted successfully"
        echo ""
        echo "Worktree force deleted successfully."
    else
        log "Failed to force delete worktree $WORKTREE_TO_DELETE"
        echo ""
        echo "Failed to force delete worktree. Check logs for details."
    fi
else
    log "Deleting worktree $WORKTREE_TO_DELETE"

    # Extract worktree name for display
    worktree_display_name=$(basename "$WORKTREE_TO_DELETE")

    # Extract relative path (worktree directory from repo parent)
    repo_parent=$(dirname "$(git rev-parse --show-toplevel)")
    relative_path="${WORKTREE_TO_DELETE#$repo_parent/}"

    # Display info
    echo "Deleting worktree: ${worktree_display_name}"
    echo "===================================="
    echo "Path: ${relative_path}"
    echo ""

    # Run delete with spinner
    if gum spin --spinner dot --title "Removing files..." --show-output -- \
        git worktree remove "$WORKTREE_TO_DELETE"; then
        log "Worktree $WORKTREE_TO_DELETE deleted successfully"
        echo ""
        echo "Worktree deleted successfully."
    else
        log "Failed to delete worktree $WORKTREE_TO_DELETE"
        echo ""
        echo "Failed to delete worktree. It may have modified files."
        echo "Use <C-d> in the selection to force delete."
    fi
fi

echo "Press Enter to close..."
read

# vim:fdm=marker
