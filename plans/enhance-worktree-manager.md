# Feature Implementation Plan: Enhance Git Worktree Manager

## 📋 Todo Checklist
- [✅] Analyze the existing `git-worktree.sh` script.
- [✅] Implement automatic copying of environment files (e.g., `.env`, `.env.local`).
- [✅] Add a confirmation prompt before initiating the `fzf` file selection process.
- [✅] Ensure automatically copied files are excluded from the `fzf` list.
- [✅] Update function calls to reflect the new logic.
- [✅] Fix `cp` command illegal arguments error on macOS.
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
- The `cp --parents` command is not available on macOS, causing an "illegal arguments" error. This needs to be replaced with a compatible alternative like `rsync -R`.

## 📝 Implementation Plan

### Prerequisites
- Ensure `gum`, `fzf`, `bat`, and `rsync` are installed and available in the shell's `PATH`.

### Step-by-Step Implementation

1.  **Step 1: Modify the `_handle_file_copy` function**
    -   **Files to modify**: `~/.config/tmux/scripts/git/git-worktree.sh`
    -   **Changes needed**:
        1.  **Replace `cp --parents` with `rsync -R`**: The `cp --parents` command is not portable and fails on macOS. It will be replaced with `rsync -R` to ensure compatibility.
        2.  **Handle filenames with spaces**: The script will be improved to correctly handle filenames that contain spaces by using `while read` loops.

    -   **Proposed Code Changes for `_handle_file_copy`**:

        ```bash
        _handle_file_copy() {
            local target_worktree_path="$1"

            # Automatically copy environment files
            gum spin --spinner dot --title "Copying environment files..." --show-output -- bash -c '
                find . -maxdepth 1 -name ".env*" | while read -r file; do
                    rsync -R "$file" "'$target_worktree_path'/"
                done
            '

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
1.  Create a temporary git repository for testing on a macOS machine.
2.  Inside the repository, create a few files, including environment files like `.env`, `.env.local`, and a file with spaces in its name (e.g., `"my test file.txt"`).
3.  Run the `git-worktree.sh create` command.
4.  **Verification**:
    -   Confirm that the script runs without any `cp: illegal option` errors.
    -   Confirm that the environment files and the file with spaces are copied correctly to the new worktree directory.
    -   Confirm that a prompt appears asking if you want to select additional files.
    -   If "Yes", confirm that the `fzf` window appears and that the `.env*` files are *not* in the list.
    -   Select a file from the `fzf` list and confirm it is copied to the new worktree.

## 🎯 Success Criteria
- The `cp: illegal option` error is resolved on macOS.
- When creating or switching to a worktree, all files matching the `.env*` pattern in the root of the repository are automatically copied to the worktree's root.
- Files with spaces in their names are copied correctly.
- The user is prompted to confirm if they want to copy additional files.
- The dependency installation process remains unaffected.