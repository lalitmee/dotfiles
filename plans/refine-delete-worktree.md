# Feature Implementation Plan: Refine Git Worktree Deletion

## 📋 Todo Checklist
- [✅] Analyze the existing `delete_worktree` function in `git-worktree.sh`.
- [✅] Modify the `delete_worktree` function to perform the deletion in a new, non-blocking tmux window.
- [✅] Ensure a spinner is shown for both regular and forced deletion within the new window.
- [✅] Define a testing strategy to verify the new non-blocking behavior.
- [✅] Final Review and Testing.

## 🔍 Analysis & Investigation

### Current `delete_worktree` Function
The current implementation of the `delete_worktree` function has two issues:
1.  **Inconsistent Spinner:** A `gum spin` progress indicator is only shown for a *forced* deletion (`--force`). A regular deletion is a blocking operation with no visual feedback.
2.  **Blocking UI:** When the spinner is shown, it runs within the existing popup window, blocking the user from performing any other actions until the deletion is complete.

### User Request
The user wants the deletion process to be non-blocking and to provide clear visual feedback. Specifically:
- The deletion command (both regular and forced) should run in a new tmux window.
- This new window should display a spinner to indicate that the process is running.

## 📝 Implementation Plan

### Prerequisites
- Ensure `tmux` and `gum` are installed and available in the shell's `PATH`.

### Step-by-Step Implementation

1.  **Step 1: Modify the `delete_worktree` function**
    -   **Files to modify**: `~/.config/tmux/scripts/git/git-worktree.sh`
    -   **Changes needed**:
        1.  **Create a command for the new window**: For both the regular and forced deletion paths, construct a command string that will be executed in a new tmux window. This command will use `gum spin` to wrap the `git worktree remove` command.
        2.  **Launch a new tmux window**: Use `tmux new-window -d -n "deleting-worktree" "<command>"` to execute the deletion command in a detached window named "deleting-worktree". This will make the process non-blocking.
        3.  **Provide immediate feedback**: After launching the new window, use `tmux display-message` to inform the user that the deletion is in progress in a new window.

    -   **Proposed Code Changes for `delete_worktree`**:

        ```bash
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
                    DELETE_COMMAND="gum spin --spinner dot --title \"Deleting worktree '$WORKTREE_TO_DELETE'...\" --show-output -- git worktree remove \"$WORKTREE_TO_DELETE\""
                    if ! git worktree remove "$WORKTREE_TO_DELETE" > /dev/null 2>&1; then
                        log "Failed to delete worktree '$WORKTREE_TO_DELETE'. It may have modified files."
                        gum style --foreground "212" "Failed to delete worktree. It may have modified files. Use <C-d> to force delete."
                        sleep 3
                    else
                        tmux new-window -d -n "$WINDOW_NAME" "$DELETE_COMMAND; read -p 'Press Enter to close...'"
                        tmux display-message "Deleting worktree in a new window..."
                    fi
                fi
            else
                log "Worktree deletion cancelled."
            fi
        }
        ```

### Testing Strategy
1.  Create a temporary git repository and add a worktree.
2.  Run the `git-worktree.sh delete` command.
3.  Select the worktree to delete and press Enter (for a regular delete).
4.  **Verification**:
    -   Confirm that a new tmux window named "deleting-worktree" is created.
    -   Switch to the new window and confirm that a `gum spin` process is running and displaying progress.
    -   Confirm that the original popup window closes immediately and you can continue to use tmux.
    -   Once the deletion is complete, confirm the worktree is gone by running `git worktree list`.
5.  Repeat the process, but this time press `ctrl-d` to perform a forced delete. Verify the same non-blocking behavior.

## 🎯 Success Criteria
- When a worktree deletion is initiated (either regular or forced), the deletion process runs in a new, separate tmux window.
- The user is not blocked and can immediately continue using the terminal.
- The new tmux window shows a `gum spin` progress indicator during the deletion.
- The worktree is successfully deleted in the background.
