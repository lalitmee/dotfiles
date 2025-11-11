# Feature Implementation Plan: fix-worktree-env-and-deps

## 📋 Todo Checklist
- [ ] Modify `_handle_file_copy` function in `~/.config/tmux/scripts/git/git-worktree.sh`.
- [ ] Modify `_handle_dependency_installation` function in `~/.config/tmux/scripts/git/git-worktree.sh`.
- [ ] Test the changes.
- [ ] Final Review and Testing

## 🔍 Analysis & Investigation

### Codebase Structure
The relevant logic is contained within a single shell script: `~/.config/tmux/scripts/git/git-worktree.sh`. This script is called from `tmux/.tmux.conf.local` with different arguments to create, switch, or delete git worktrees.

The script has three main functions:
- `create_worktree`: Creates a new worktree.
- `switch_worktree`: Switches to an existing worktree.
- `delete_worktree`: Deletes a worktree.

These functions call two helper functions:
- `_handle_file_copy`: Copies `.env` files and other selected files.
- `_handle_dependency_installation`: Installs npm/yarn dependencies.

### Current Architecture
The script uses `gum` for user interaction (menus, confirmations) and `fzf` for fuzzy finding worktrees. It creates new tmux windows to run background tasks like dependency installation.

### Dependencies & Integration Points
- `tmux`: The script is tightly integrated with tmux for window management and popups.
- `git`: The script is a wrapper around `git worktree` commands.
- `gum`: Used for all UI elements.
- `fzf`: Used for selecting worktrees.
- `bat`: Used for file previews in `fzf`.
- `rsync`: Used for copying files.

### Considerations & Challenges
The main challenge is to modify the script to be more intelligent about when to perform certain actions, specifically:
1.  **Dependency Installation:** Avoid asking for confirmation when it's clear that dependencies need to be installed (i.e., `node_modules` directory is missing).
2.  **`.env` file copying:** Avoid overwriting existing `.env` files in the destination worktree and only copy if the source has `.env` files and the destination does not. The `rsync -R` command was also being used incorrectly.

## 📝 Implementation Plan

### Prerequisites
- The user should have `gum`, `fzf`, and `bat` installed and configured.

### Step-by-Step Implementation
1. **Step 1**: Modify the `_handle_file_copy` function.
   - **Files to modify**: `~/.config/tmux/scripts/git/git-worktree.sh`
   - **Changes needed**:
     - Replace the `gum spin` block for copying `.env` files with a loop that checks for the existence of each `.env` file in the target worktree before copying.
     - Use `cp` instead of `rsync -R` for copying the `.env` files to avoid creating incorrect directory structures.

2. **Step 2**: Modify the `_handle_dependency_installation` function.
   - **Files to modify**: `~/.config/tmux/scripts/git/git-worktree.sh`
   - **Changes needed**:
     - Add a check at the beginning of the function to see if the `node_modules` directory exists in the target worktree.
     - If `node_modules` does not exist, force the `confirmation_needed` variable to `false` to ensure that dependencies are installed automatically without a prompt.

### Testing Strategy
1.  **Create a new worktree:**
    - Verify that dependencies are installed automatically.
    - Verify that `.env` files from the main worktree are copied to the new worktree.
2.  **Switch to a worktree:**
    - **Scenario 1: `node_modules` and `.env` files exist.**
      - Verify that the script asks for confirmation before installing dependencies.
      - Verify that existing `.env` files are not overwritten.
    - **Scenario 2: `node_modules` does not exist, but `.env` files exist.**
      - Verify that dependencies are installed automatically without confirmation.
      - Verify that existing `.env` files are not overwritten.
    - **Scenario 3: `node_modules` exists, but `.env` files do not exist.**
      - Verify that the script asks for confirmation before installing dependencies.
      - Verify that `.env` files from the source worktree are copied to the target worktree.
    - **Scenario 4: Neither `node_modules` nor `.env` files exist.**
      - Verify that dependencies are installed automatically.
      - Verify that `.env` files are copied from the source worktree.

## 🎯 Success Criteria
- Dependency installation is automatic and reliable when creating a new worktree or switching to a worktree without a `node_modules` directory.
- `.env` files are correctly copied from the source worktree to the destination worktree only if they do not already exist in the destination.
- The user is no longer prompted for actions that should be automatic.
