# Feature Implementation Plan: Refine Deps Window Naming

## 📋 Todo Checklist
- [✅] Analyze the existing `_handle_dependency_installation` function in `git-worktree.sh`.
- [✅] Modify the function to generate a unique name for the dependency installation window.
- [✅] Ensure the new window name includes the worktree or branch name.
- [✅] Define a testing strategy to verify the new window naming convention.
- [✅] Final Review and Testing.

## 🔍 Analysis & Investigation

### Current `_handle_dependency_installation` Function
The current implementation creates a new tmux window for dependency installation with a static name: `deps`. This is problematic when running installations for multiple worktrees simultaneously, as it becomes difficult to distinguish which window belongs to which worktree.

### User Request
The user wants to improve the window naming to make it unique for each worktree. The suggestion is to include the worktree folder name or the branch name in the window title.

## 📝 Implementation Plan

### Prerequisites
- Ensure `tmux` is installed and available in the shell's `PATH`.

### Step-by-Step Implementation

1.  **Step 1: Modify the `_handle_dependency_installation` function**
    -   **Files to modify**: `~/.config/tmux/scripts/git/git-worktree.sh`
    -   **Changes needed**:
        1.  **Extract the worktree name**: Use the `basename` command to get the folder name from the `target_worktree_path` variable.
        2.  **Construct a dynamic window name**: Create a new variable for the window name that combines the static prefix `deps-` with the dynamic worktree name (e.g., `deps-my-feature-branch`).
        3.  **Update the `tmux new-window` command**: Use the new dynamic window name variable in the `tmux new-window -n` option.

    -   **Proposed Code Changes for `_handle_dependency_installation`**:

        ```bash
        _handle_dependency_installation() {
            local target_worktree_path="$1"
            local confirmation_needed="$2"

            if [ -f "$target_worktree_path/package.json" ]; then
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
        ```

### Testing Strategy
1.  Create a temporary git repository and add a worktree that contains a `package.json` file.
2.  Run the `git-worktree.sh create` command and choose to install dependencies.
3.  **Verification**:
    -   Confirm that a new tmux window is created.
    -   Check the name of the new window and confirm that it follows the `deps-<worktree-name>` format.
    -   Create a second worktree and repeat the process to ensure a second, uniquely named window is created.

## 🎯 Success Criteria
- When installing dependencies for a worktree, the new tmux window is named dynamically using the pattern `deps-<worktree-name>`.
- The user can easily identify which dependency installation window belongs to which worktree.
