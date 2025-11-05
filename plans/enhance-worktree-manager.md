# Feature Implementation Plan: Enhance Git Worktree Manager

## 📋 Todo Checklist
- [✅] Analyze the existing `git-worktree.sh` script.
- [✅] Implement automatic copying of environment files (e.g., `.env`, `.env.local`).
- [✅] Add a confirmation prompt before initiating the `fzf` file selection process.
- [✅] Ensure automatically copied files are excluded from the `fzf` list.
- [✅] Update function calls to reflect the new logic.
- [✅] Define a testing strategy to verify the new functionality.
- [✅] Final Review and Testing.

## 🔍 Analysis & Investigation

### Codebase Structure
The core logic for the git worktree manager is located in a single shell script: `~/.config/tmux/scripts/git/git-worktree.sh`. This script is called from the tmux configuration file `~/.tmux.conf.local` via keybindings. The script handles creating, switching, and deleting git worktrees.

### Current Architecture
The script is composed of several functions:
- `main_menu()`: Displays the main menu to the user.
- `_handle_file_copy()`: Manages copying files to the new worktree. It uses `fzf` for interactive file selection.
- `_handle_dependency_installation()`: Handles installing npm/yarn dependencies.
- `create_worktree()`: Logic for creating a new worktree.
- `switch_worktree()`: Logic for switching to an existing worktree.
- `delete_worktree()`: Logic for deleting a worktree.

The `create_worktree` function currently calls `_handle_file_copy` in a way that bypasses an initial confirmation, taking the user directly to the `fzf` file selection.

### Dependencies & Integration Points
- **tmux**: The script is designed to be run within a tmux session, using `tmux new-window` and `tmux display-message`.
- **gum**: Used for creating styled prompts, spinners, and confirmation dialogs.
- **fzf**: Used for interactive file and worktree selection.
- **bat**: Used for file previews within `fzf`.

### Considerations & Challenges
- The script should correctly identify a comprehensive list of environment file patterns.
- The automatically copied environment files must be excluded from the list of files presented in the `fzf` popup to avoid redundant copying.
- The confirmation prompt should be clear and allow the user to gracefully cancel the file copying process.

## 📝 Implementation Plan

### Prerequisites
- Ensure `gum`, `fzf`, and `bat` are installed and available in the shell's `PATH`.

### Step-by-Step Implementation

1.  **Step 1: Modify the `_handle_file_copy` function**
    -   **Files to modify**: `~/.config/tmux/scripts/git/git-worktree.sh`
    -   **Changes needed**:
        1.  **Automatically copy environment files**: Before the `fzf` command, add a section to find and copy environment files. A `find` command can be used to locate files matching patterns like `.env*`. These files will be copied to the target worktree path. A `gum spin` can be used to provide visual feedback during this process.
        2.  **Exclude environment files from fzf**: Modify the `git ls-files` command that pipes into `fzf`. Add a `grep -v` to filter out the environment file patterns that were just copied.
        3.  **Add confirmation prompt**: The existing `gum confirm` logic is sufficient, but it's currently bypassed. The `confirmation_needed` parameter should be removed, and the `gum confirm` should be unconditional.

    -   **Proposed Code Changes for `_handle_file_copy`**:

        ```bash
        _handle_file_copy() {
            local target_worktree_path="$1"

            # Automatically copy environment files
            gum spin --spinner dot --title "Copying environment files..." --show-output -- bash -c '
                find . -maxdepth 1 -name ".env*" -exec cp --parents {} "'$target_worktree_path'/" \;
            '

            if gum confirm "Do you want to select additional files to copy?"; then
                # Exclude environment files from fzf list
                SELECTED_FILES=$(git ls-files | grep -v ".env*" | fzf --multi --preview 'bat --color=always --style=numbers --line-range=:500 {}')

                if [ -n "$SELECTED_FILES" ]; then
                    gum spin --spinner dot --title "Copying selected files..." --show-output -- bash -c '
                        for file in $SELECTED_FILES; do
                            cp --parents "$file" "'$target_worktree_path'/"
                        done
                    '
                fi
            fi
        }
        ```

2.  **Step 2: Update calls to `_handle_file_copy`**
    -   **Files to modify**: `~/.config/tmux/scripts/git/git-worktree.sh`
    -   **Changes needed**: In the `create_worktree` and `switch_worktree` functions, the calls to `_handle_file_copy` pass a second argument (`true` or `false`). This argument needs to be removed since the `_handle_file_copy` function will no longer accept it.

    -   **Proposed Code Changes**:
        -   In `create_worktree()`:
            -   Change `_handle_file_copy "$WORKTREE_DIR/$BRANCH_NAME" false` to `_handle_file_copy "$WORKTREE_DIR/$BRANCH_NAME"`.
        -   In `switch_worktree()`:
            -   Change `_handle_file_copy "$WORKTREE" true` to `_handle_file_copy "$WORKTREE"`.

### Testing Strategy
1.  Create a temporary git repository for testing.
2.  Inside the repository, create a few files, including environment files like `.env`, `.env.local`, and `.env.production`.
3.  Run the `git-worktree.sh create` command.
4.  **Verification**:
    -   Confirm that the script automatically copies the `.env*` files to the new worktree directory.
    -   Confirm that a prompt appears asking if you want to select additional files.
    -   If "Yes", confirm that the `fzf` window appears and that the `.env*` files are *not* in the list.
    -   Select a file from the `fzf` list and confirm it is copied to the new worktree.
    -   If "No" at the confirmation prompt, confirm that the `fzf` window does not appear and no other files are copied.
5.  Run the `switch_worktree` command and perform similar verifications.

## 🎯 Success Criteria
- When creating or switching to a worktree, all files matching the `.env*` pattern in the root of the repository are automatically copied to the worktree's root.
- After the automatic copy, the user is prompted to confirm if they want to copy additional files.
- If the user confirms, an `fzf` window appears, listing all files tracked by git *except* for the `.env*` files that were already copied.
- If the user declines, the script proceeds without showing the `fzf` window.
- The dependency installation process remains unaffected.
