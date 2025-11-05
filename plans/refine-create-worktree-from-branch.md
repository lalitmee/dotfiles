# Feature Implementation Plan: Refine Worktree Creation from Branch

## 📋 Todo Checklist
- [✅] Analyze the existing `create_worktree` function in `git-worktree.sh`.
- [✅] Add a step to select a base branch using `fzf` when creating a new branch.
- [✅] Modify the `git worktree add` command to use the selected base branch.
- [✅] Define a testing strategy to verify the new creation flow.
- [✅] Final Review and Testing.

## 🔍 Analysis & Investigation

### Current `create_worktree` Function
The current implementation for creating a new branch for a worktree (`Create new branch` option) creates the new branch from the current `HEAD`. It does not allow the user to specify a different base branch.

### User Request
The user wants to be prompted to select a base branch from a list of existing branches when creating a new worktree with a new branch. This will allow for more flexible worktree creation, such as creating a feature branch from `develop` instead of `main`.

## 📝 Implementation Plan

### Prerequisites
- Ensure `fzf` and `gum` are installed and available in the shell's `PATH`.

### Step-by-Step Implementation

1.  **Step 1: Modify the `create_worktree` function**
    -   **Files to modify**: `~/.config/tmux/scripts/git/git-worktree.sh`
    -   **Changes needed**:
        1.  **Add a base branch selection**: After the user chooses to "Create new branch", and before asking for the new branch name, add a step to select a base branch. This can be done by piping the output of `git branch` into `fzf`.
        2.  **Get the new branch name**: After selecting the base branch, prompt the user for the new branch name using `gum input`.
        3.  **Update `git worktree add` command**: Modify the `git worktree add` command to create the new branch from the selected base branch. The command will look like this: `git worktree add -b <new-branch-name> <path> <base-branch-name>`.

    -   **Proposed Code Changes for `create_worktree`**:

        ```bash
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
        ```

### Testing Strategy
1.  Create a temporary git repository with at least two branches (e.g., `main` and `develop`).
2.  Run the `git-worktree.sh create` command and select the "Create new branch" option.
3.  **Verification**:
    -   Confirm that a `fzf` (or `gum filter`) prompt appears, listing the existing branches.
    -   Select a base branch (e.g., `develop`).
    -   Enter a name for the new branch (e.g., `feature-x`).
    -   After the script completes, navigate to the new worktree directory.
    -   Run `git log` and confirm that the commit history matches the selected base branch (`develop`), not the branch you were on when you ran the script.

## 🎯 Success Criteria
- When creating a new worktree with a new branch, the user is first prompted to select a base branch from a list of existing branches.
- The new worktree and branch are created based on the user's selection.
- The process remains intuitive and provides clear prompts to the user.
