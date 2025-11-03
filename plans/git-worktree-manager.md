# Feature Implementation Plan: Git Worktree Manager

## 📋 Todo Checklist
- [x] ✅ Create the `git-worktree.sh` script.
- [x] ✅ Create the `git-mode.txt` help file.
- [x] ✅ Update `tmux/.tmux.conf.local` with the new `git-mode` table and keybindings.
- [x] ✅ Final Review and Testing.

## 🔍 Analysis & Investigation

### Codebase Structure
- The tmux configuration is located at `tmux/.tmux.conf.local`.
- Custom scripts are located in `tmux/.config/tmux/scripts/`.
- The configuration uses key tables to group related keybindings (e.g., `ai-tools`, `dev-mode`).
- Scripts are launched in popups using `display-popup`.
- There is an existing help system that uses `.txt` files in `tmux/.config/tmux/scripts/help/tables/`.

### Current Architecture
- The architecture is modular, with different functionalities separated into different scripts and key tables.
- The user prefers interactive scripts using `fzf` and `gum` for a better user experience.
- The `runner.sh` script provides a good example of how to create interactive, persistent windows for running commands.

### Dependencies & Integration Points
- **fzf**: For interactive filtering and selection.
- **gum**: For creating styled menus and prompts.
- **git**: For worktree management.
- **tmux**: For creating new windows and popups.

### Considerations & Challenges
- **Error Handling**: The script must handle cases where it's not run in a git repository, or when git commands fail.
- **User Experience**: The script should provide clear feedback to the user at every step.
- **Path Management**: The script needs to correctly handle paths for creating and switching to worktrees.
- **Logging**: The script should log all actions to a file for debugging and tracking purposes.

## 📝 Implementation Plan

### Prerequisites
- Ensure `fzf`, `gum`, and `git` are installed on the system.

### Step-by-Step Implementation

1.  **Create the `git` script directory**
    - Create a new directory: `tmux/.config/tmux/scripts/git/`

2.  **Create the `git-worktree.sh` script**
    - Files to modify: `tmux/.config/tmux/scripts/git/git-worktree.sh` (new file)
    - Changes needed: Create the following script:

    ```bash
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
    if ! git rev-parse --is-inside-work-tree > /dev/null 2>&1;
 then
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
    ```

3.  **Make the script executable**
    - Run `chmod +x tmux/.config/tmux/scripts/git/git-worktree.sh`

4.  **Create the `git-mode.txt` help file**
    - Files to modify: `tmux/.config/tmux/scripts/help/tables/git-mode.txt` (new file)
    - Changes needed: Create the following file:

    ```tsv
    Key	Description
    w	Interactive worktree management
    c	Create a new worktree
    s	Switch to a worktree
    d	Delete a worktree
    q	Quit git mode
    ?	Show help
    ```

5.  **Update `tmux/.tmux.conf.local`**
    - Files to modify: `tmux/.tmux.conf.local`
    - Changes needed: Add the following lines to the keybindings section:

    ```tmux
    #-------------------------------------------------------------------------------
    # --- NOTE: Git Mode {{{1
    #           Parent block for all git-mode functionality.
    #           Enter git-mode by pressing C-a C-g.
    #-------------------------------------------------------------------------------

    # Git mode trigger
    bind-key C-g switch-client -T git-mode

    #-------------------------------------------------------------------------------
    # --- NOTE: Git Mode - Keybindings {{{2
    #-------------------------------------------------------------------------------

    # Launch the git worktree management script (interactive).
    bind-key -T git-mode w display-popup -w 80% -h 80% -E "~/.config/tmux/scripts/git/git-worktree.sh"

    # Create a new worktree.
    bind-key -T git-mode c display-popup -w 80% -h 80% -E "~/.config/tmux/scripts/git/git-worktree.sh create"

    # Switch to a worktree.
    bind-key -T git-mode s display-popup -w 80% -h 80% -E "~/.config/tmux/scripts/git/git-worktree.sh switch"

    # Delete a worktree.
    bind-key -T git-mode d display-popup -w 80% -h 80% -E "~/.config/tmux/scripts/git/git-worktree.sh delete"

    #-------------------------------------------------------------------------------
    # }}}
    #-------------------------------------------------------------------------------

    #-------------------------------------------------------------------------------
    # --- NOTE: Git Mode - Help & Navigation {{{2
    #-------------------------------------------------------------------------------

    # Help for git mode
    bind-key -T git-mode ? run-shell "$HOME/.config/tmux/scripts/popup/help/help.sh git-mode"

    # Exit git mode
    bind-key -T git-mode q switch-client -T root

    #-------------------------------------------------------------------------------
    # }}}
    #-------------------------------------------------------------------------------


    #-------------------------------------------------------------------------------
    # }}}
    #-------------------------------------------------------------------------------
    ```

### Testing Strategy
- Open tmux and reload the configuration (`C-a r`).
- Press `C-a C-g` to enter `git-mode`.
- Press `c` to create a worktree and test both the "Create new branch" and "Select existing branch" options. Verify that a new window is opened in the new worktree directory.
- When deleting a worktree, press `<CR>` on a worktree with modified files to see the error message.
- When deleting a worktree, press `<C-d>` on a worktree with modified files to force delete it.
- Check the log file at `~/.local/share/tmux/logs/git-worktree.log` to ensure all actions are being logged.
- When deleting a worktree, verify that a tmux notification is displayed upon completion.
- Test running the script outside of a git repository to ensure the error message is displayed.

## 🎯 Success Criteria
- The `git-mode` table is successfully created and can be accessed with `C-a C-g`.
- The `git-worktree.sh` script launches correctly in a popup.
- The script can successfully create a worktree from a new or existing branch and open it in a new window.
- The script can successfully create, switch, and delete git worktrees, both interactively and via command-line arguments.
- The script can force delete a worktree with modified files.
- All actions are logged to `~/.local/share/tmux/logs/git-worktree.log`.
- A notification is displayed in tmux after a worktree is deleted.
- The help system for `git-mode` is updated and works as expected.
- The implementation follows the existing coding style and conventions of the dotfiles repository.