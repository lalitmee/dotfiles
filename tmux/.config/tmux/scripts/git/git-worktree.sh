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

    if [ -f "$target_worktree_path/package.json" ]; then
        # If node_modules doesn't exist, force install without confirmation.
        if [ ! -d "$target_worktree_path/node_modules" ]; then
            confirmation_needed=false
        fi

        if [ "$confirmation_needed" = "false" ] || gum confirm "Install dependencies in $target_worktree_path?"; then
            local PACKAGE_MANAGER
            if [ -f "$target_worktree_path/yarn.lock" ]; then
                PACKAGE_MANAGER="yarn"
            elif [ -f "$target_worktree_path/package-lock.json" ]; then
                PACKAGE_MANAGER="npm"
            else
                PACKAGE_MANAGER="npm" # Default to npm
            fi

            local worktree_name=$(basename "$target_worktree_path")
            local window_name="deps-$worktree_name"

            INSTALL_COMMAND="cd $target_worktree_path && $PACKAGE_MANAGER install"
            tmux new-window -d -n "$window_name" "$INSTALL_COMMAND; read -p 'Press Enter to close...'"
            tmux display-message "Installing dependencies with $PACKAGE_MANAGER in window '$window_name'..."
        fi
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
        tmux new-window -c "$WORKTREE_DIR/$BRANCH_NAME"
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
        tmux new-window -c "$WORKTREE_DIR/$BRANCH_NAME"
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
        tmux new-window -c "$WORKTREE"
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
