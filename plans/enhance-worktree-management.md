# Feature Implementation Plan: enhance-worktree-management

## 📋 Todo Checklist
- [ ] Add interactive file copying feature to `git-worktree.sh`.
- [ ] Add automatic dependency installation feature to `git-worktree.sh`.
- [ ] Final Review and Testing

## 🔍 Analysis & Investigation

### Codebase Structure
The relevant files are:
- `tmux/.tmux.conf.local`: This is the main tmux configuration file where the git worktree script is called.
- `tmux/.config/tmux/scripts/git/git-worktree.sh`: This is the shell script that manages git worktrees.

### Current Architecture
The `git-worktree.sh` script is a bash script that uses `gum` and `fzf` to provide an interactive menu for managing git worktrees. It currently supports creating, switching, and deleting worktrees. The script is invoked from the `tmux/.tmux.conf.local` file.

### Dependencies & Integration Points
- **fzf:** Used for interactive filtering and selection.
- **gum:** Used for creating stylish command-line interfaces.
- **tmux:** Used for window and pane management.
- **git:** The script is heavily dependent on git commands for worktree management.

### Considerations & Challenges
- **User Experience:** The new features should be integrated smoothly into the existing interactive workflow.
- **Error Handling:** The script should handle potential errors gracefully, such as when the user cancels a prompt or when a command fails.
- **Flexibility:** The file copying feature should be flexible enough to allow the user to select any files they want to copy.

## 📝 Implementation Plan

### Prerequisites
- Ensure `fzf`, `gum`, and `bat` are installed on the system.

### Step-by-Step Implementation
1. **Step 1**: Add interactive file copying to `create_worktree` function in `git-worktree.sh`.
   - **Files to modify**: `tmux/.config/tmux/scripts/git/git-worktree.sh`
   - **Changes needed**:
     - After creating the new worktree, add a prompt to ask the user if they want to copy files from the current worktree.
     - If the user agrees, use `git ls-files` and `fzf --multi` to allow the user to select multiple files.
     - Use `cp --parents` to copy the selected files to the new worktree, preserving the directory structure.

     ```bash
     # ... after worktree creation ...

     if gum confirm "Copy files from current worktree?"; then
       SELECTED_FILES=$(git ls-files | fzf --multi --preview 'bat --color=always --style=numbers --line-range=:500 {}')

       if [ -n "$SELECTED_FILES" ]; then
         gum spin --spinner dot --title "Copying files..." --show-output -- bash -c '
           for file in $SELECTED_FILES; do
             cp --parents "$file" "$WORKTREE_DIR/$BRANCH_NAME/"
           done
         '
       fi
     fi
     ```

2. **Step 2**: Add automatic dependency installation to `create_worktree` function in `git-worktree.sh`.
   - **Files to modify**: `tmux/.config/tmux/scripts/git/git-worktree.sh`
   - **Changes needed**:
     - After the file copying step, check for the existence of `package.json` in the new worktree.
     - If `package.json` exists, detect the package manager by checking for `yarn.lock` or `package-lock.json`.
     - Create a new tmux window and run the appropriate installation command (`yarn install` or `npm install`).

     ```bash
     # ... after file copying ...

     if [ -f "$WORKTREE_DIR/$BRANCH_NAME/package.json" ]; then
       if gum confirm "Install dependencies?"; then
         if [ -f "$WORKTREE_DIR/$BRANCH_NAME/yarn.lock" ]; then
           PACKAGE_MANAGER="yarn"
         elif [ -f "$WORKTREE_DIR/$BRANCH_NAME/package-lock.json" ]; then
           PACKAGE_MANAGER="npm"
         else
           PACKAGE_MANAGER="npm" # Default to npm
         fi

         INSTALL_COMMAND="cd $WORKTREE_DIR/$BRANCH_NAME && $PACKAGE_MANAGER install"
         tmux new-window -d -n "deps" "$INSTALL_COMMAND"
         tmux display-message "Installing dependencies with $PACKAGE_MANAGER in a new window..."
       fi
     fi
     ```

### Testing Strategy
- **Manual Testing:**
  - Create a new worktree and test the file copying feature by selecting a few files.
  - Create a new worktree for a Node.js project and test the automatic dependency installation with both `yarn` and `npm`.
  - Test all existing functionalities (create, switch, delete worktree) to ensure no regressions were introduced.
- **Code Review:**
  - Review the changes in `git-worktree.sh` to ensure they are clean, efficient, and well-documented.

## 🎯 Success Criteria
- The user can interactively select and copy files from the current worktree to a new worktree.
- The script automatically detects the package manager and installs dependencies in a new tmux window when a `package.json` file is present.
- The new features are well-integrated into the existing workflow and do not introduce any regressions.
