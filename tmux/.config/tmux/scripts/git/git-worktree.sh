#!/usr/bin/env bash

LOG_DIR="$HOME/.local/share/tmux/logs"
LOG_FILE="$LOG_DIR/git-worktree.log"

# Ensure the log directory exists
mkdir -p "$LOG_DIR"

# Logging function
log() {
  echo "$(date +'%Y-%m-%d %H:%M:%S') - $1" >> "$LOG_FILE"
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

# Create a new worktree
    create_worktree() {
      log "Attempting to create a new worktree."
      
      CREATE_OPTION=$(gum choose "Create new branch" "Select existing branch")

      if [ "$CREATE_OPTION" = "Create new branch" ]; then
        BRANCH_NAME=$(gum input --placeholder "Enter new branch name")
        if [ -z "$BRANCH_NAME" ]; then
          log "Worktree creation failed: Branch name was empty."
          gum style --foreground "212" "Branch name cannot be empty. Exiting..."
          sleep 2
          exit 1
        fi
        
        log "Creating worktree for new branch '$BRANCH_NAME'."
        git worktree add "$WORKTREE_DIR/$BRANCH_NAME" -b "$BRANCH_NAME"
        log "Worktree for new branch '$BRANCH_NAME' created at $WORKTREE_DIR/$BRANCH_NAME."
        gum style --foreground "212" "Worktree for new branch '$BRANCH_NAME' created at $WORKTREE_DIR/$BRANCH_NAME"
        tmux new-window -c "$WORKTREE_DIR/$BRANCH_NAME"
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
        tmux new-window -c "$WORKTREE_DIR/$BRANCH_NAME"
        sleep 2
      fi
    }
# Switch to a worktree
switch_worktree() {
  log "Attempting to switch to a worktree."
  WORKTREE=$(git worktree list | fzf --prompt="Select a worktree to switch to: " | awk '{print $1}')
  if [ -n "$WORKTREE" ]; then
    log "Switching to worktree '$WORKTREE'."
    tmux new-window -c "$WORKTREE"
  else
    log "Worktree switch cancelled."
  fi
}

# Delete a worktree
    delete_worktree() {
      log "Attempting to delete a worktree."
      
      FZF_OUTPUT=$(git worktree list | fzf --prompt="Select a worktree to delete: " --expect=ctrl-d)
      KEY=$(echo "$FZF_OUTPUT" | head -n1)
      WORKTREE_TO_DELETE=$(echo "$FZF_OUTPUT" | tail -n1 | awk '{print $1}')

      if [ -n "$WORKTREE_TO_DELETE" ]; then
        if [ "$KEY" = "ctrl-d" ]; then
          log "Force deleting worktree '$WORKTREE_TO_DELETE'."
          gum spin --spinner dot --title "Force deleting worktree..." --show-output -- git worktree remove --force "$WORKTREE_TO_DELETE"
          log "Worktree '$WORKTREE_TO_DELETE' force deleted."
          tmux display-message "Worktree '$WORKTREE_TO_DELETE' force deleted."
        else
          log "Deleting worktree '$WORKTREE_TO_DELETE'."
          if ! git worktree remove "$WORKTREE_TO_DELETE"; then
            log "Failed to delete worktree '$WORKTREE_TO_DELETE'. It may have modified files."
            gum style --foreground "212" "Failed to delete worktree. It may have modified files. Use <C-d> to force delete."
            sleep 3
          else
            log "Worktree '$WORKTREE_TO_DELETE' deleted."
            tmux display-message "Worktree '$WORKTREE_TO_DELETE' deleted."
          fi
        fi
        sleep 2
      else
        log "Worktree deletion cancelled."
      fi
    }
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
