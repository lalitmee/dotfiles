# Feature Implementation Plan: update-context-md

## 📋 Todo Checklist
- [x] ✅ Update Tmux Configuration Section
- [x] ✅ Update Installation Scripts Section
- [x] ✅ Review and Update Key Directories Section
- [x] ✅ Final Review of CONTEXT.md

## 🔍 Analysis & Investigation

### Codebase Structure
The dotfiles repository is well-structured, with clear separation of configurations for different tools. The `CONTEXT.md` file serves as a central documentation hub, but it has fallen out of sync with the actual repository structure in several key areas.

### Current Architecture
The `CONTEXT.md` file is a manually maintained markdown file. The discrepancies are due to the natural evolution of the dotfiles repository, where scripts and configurations are added or moved without updating the documentation.

### Dependencies & Integration Points
The `CONTEXT.md` file is a standalone documentation file with no external dependencies.

### Considerations & Challenges
The main challenge is to ensure that the `CONTEXT.md` file is updated accurately and that a process is in place to keep it up-to-date in the future. This plan will focus on correcting the current discrepancies.

## 📝 Implementation Plan

### Prerequisites
- A text editor to modify the `CONTEXT.md` file.

### Step-by-Step Implementation

1. **Step 1: Update Tmux Configuration Section**
   - **Files to modify:** `CONTEXT.md`
   - **Changes needed:**
     - Correct the `Theme Files` path from `~/dotfiles/tmux/tmux-themes/` to `~/dotfiles/tmux/.config/tmux/themes/`.
     - Update the `Script Organization Structure` to reflect the actual contents of the `~/.config/tmux/scripts/` directory. This includes:
       - Adding entries for `git/`, `ddg-bangs.sh`, `doc-finder.sh`, `git-pull-merge.sh`, `kill-process.sh`, `resize-pane.sh`, `tmux-sessionizer.sh`, `tmuxinator-sessionizer.sh`, and `windowizer.sh`.
       - Moving `ai/`, `runner/`, and `help/` to be under the `popup/` directory.
       - Adding entries for `notes.sh`, `scratch.sh`, and `search-keybindings.sh` under the `popup/` directory.
       - Removing the entry for `popup/todo.sh` as it is missing.

2. **Step 2: Update Installation Scripts Section**
   - **Files to modify:** `CONTEXT.md`
   - **Changes needed:**
     - Update the `Installation Scripts Structure` to include the missing files: `basic-utilites`, `brave-browser`, `coding`, `gum`, `monaco-font`, `README.md`, `spotify`, `sticky-notes`, `tmux-latest`.
     - Add the `09-nerd-dictation.zsh` phase to the list of installation phases under the `phases/` directory.

3. **Step 3: Review and Update Key Directories Section**
    - **Files to modify:** `CONTEXT.md`
    - **Changes needed:**
        - Re-evaluate the contents of `nvim/`, `zsh/`, and `bin/` directories, considering that they might contain hidden files (e.g., `.config/nvim/`) due to `stow` symlinking.
        - Use `ls -A` or `ls -a` to reveal all files, including hidden ones, within these directories.
        - Based on the actual contents (including hidden files), ensure the descriptions for `nvim/`, `zsh/`, `scripts/`, and `bin/` in `CONTEXT.md` are accurate and provide a good overview of their purpose and contents.
        - Correct any descriptions that were previously marked as "currently empty" if hidden files are found.

4. **Step 4: Final Review of CONTEXT.md**
   - **Files to modify:** `CONTEXT.md`
   - **Changes needed:**
     - Read through the entire `CONTEXT.md` file one last time to check for any other inconsistencies or outdated information that may have been missed.
     - Ensure the formatting is correct and the document is easy to read.

### Testing Strategy
- After updating the `CONTEXT.md` file, manually review the changes to ensure they accurately reflect the current state of the dotfiles repository.
- Compare the updated `CONTEXT.md` file with the actual directory structures to verify the corrections.

## 🎯 Success Criteria
- The `CONTEXT.md` file accurately reflects the structure of the dotfiles repository, especially the `tmux` and `scripts/install` sections.
- All identified discrepancies have been corrected.
- The `CONTEXT.md` file is a reliable source of information for understanding the dotfiles repository.