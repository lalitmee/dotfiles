# fzf change:first behavior Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Ensure that whenever query characters filter results in fzf, the selection cursor resets to the first item.

**Architecture:** We will apply this globally via `FZF_DEFAULT_OPTS` and explicitly inside all shell scripts in the repository by adding or appending `change:first` to their `fzf` calls.

**Tech Stack:** Bash, Zsh, Tmux, Fzf

## Global Constraints
- Before trying to update a file, always read it first to ensure you have the correct content.
- Do not commit or push changes without explicit user approval.
- After modifying any code, verify the syntax to ensure correctness and prevent regressions.

---

### Task 1: Global Zsh Configuration

**Files:**
- Modify: `zsh/.fzf_config`

**Interfaces:**
- Produces: Updated global `FZF_DEFAULT_OPTS` setting that interactive shell uses.

- [ ] **Step 1: Read the existing `zsh/.fzf_config`**
  Ensure we have the correct lines for editing.

- [ ] **Step 2: Update the `FZF_DEFAULT_OPTS` definition**
  Modify line 16 of `zsh/.fzf_config` from:
  ```zsh
  --bind=ctrl-a:select-all,ctrl-j:down,ctrl-k:up,ctrl-d:deselect-all'
  ```
  To:
  ```zsh
  --bind=ctrl-a:select-all,ctrl-j:down,ctrl-k:up,ctrl-d:deselect-all,change:first'
  ```

- [ ] **Step 3: Verify the zsh/.fzf_config syntax**
  Run: `zsh -n zsh/.fzf_config`
  Expected: Success (no output)

- [ ] **Step 4: Commit**
  ```bash
  git add zsh/.fzf_config
  git commit -m "chore: add change:first to FZF_DEFAULT_OPTS globally"
  ```

---

### Task 2: Custom Scripts in `bin/.config/bin/`

**Files:**
- Modify:
  - `bin/.config/bin/delete-nvim-sessions`
  - `bin/.config/bin/emoji`
  - `bin/.config/bin/fzf-menu`
  - `bin/.config/bin/fzfub`
  - `bin/.config/bin/git-branch-clean`
  - `bin/.config/bin/install-deb`
  - `bin/.config/bin/install-dots`
  - `bin/.config/bin/install-font`
  - `bin/.config/bin/kitty-font`
  - `bin/.config/bin/make-exec`
  - `bin/.config/bin/remove-apt-repository`
  - `bin/.config/bin/select-mic`
  - `bin/.config/bin/stow-config`
  - `bin/.config/bin/tmux-file-picker`
  - `bin/.config/bin/tsnv`
  - `bin/.config/bin/walls`

- [ ] **Step 1: Update `bin/.config/bin/delete-nvim-sessions`**
  Modify line 4:
  From: `find . | fzf -m | xargs -I {} rm -rf {}`
  To: `find . | fzf -m --bind="change:first" | xargs -I {} rm -rf {}`

- [ ] **Step 2: Update `bin/.config/bin/emoji`**
  Modify line 5:
  From: `selected_emoji=$(echo "$emojis" | fzf)`
  To: `selected_emoji=$(echo "$emojis" | fzf --bind="change:first")`

- [ ] **Step 3: Update `bin/.config/bin/fzf-menu`**
  Modify line 5:
  From: `exec kitty --class="fzf-menu" -e bash -c "fzf-tmux -m $* < /proc/$$/fd/0 | awk 'BEGIN {ORS=\" \"} {print}' > /proc/$$/fd/1"`
  To: `exec kitty --class="fzf-menu" -e bash -c "fzf-tmux --bind=\"change:first\" -m $* < /proc/$$/fd/0 | awk 'BEGIN {ORS=\" \"} {print}' > /proc/$$/fd/1"`

- [ ] **Step 4: Update `bin/.config/bin/fzfub`**
  Modify line 13:
  From: `fzf --preview="ueberzug cmd -s $SOCKET -i fzfpreview -a add -x $X -y 1 --max-width $FZF_PREVIEW_COLUMNS --max-height $FZF_PREVIEW_LINES -f {}" --reverse "$@"`
  To: `fzf --bind="change:first" --preview="ueberzug cmd -s $SOCKET -i fzfpreview -a add -x $X -y 1 --max-width $FZF_PREVIEW_COLUMNS --max-height $FZF_PREVIEW_LINES -f {}" --reverse "$@"`

- [ ] **Step 5: Update `bin/.config/bin/git-branch-clean`**
  Modify lines 19, 24, 41, 46 to include `--bind="change:first"`.
  Line 19 from:
  `BRANCH_TYPE=$(printf "local\nremote" | fzf --prompt="Branch type to delete: ")`
  To:
  `BRANCH_TYPE=$(printf "local\nremote" | fzf --bind="change:first" --prompt="Branch type to delete: ")`
  Line 24 from:
  `fzf --multi --preview="branch_preview {}" --prompt="Select local branches to delete: ")`
  To:
  `fzf --bind="change:first" --multi --preview="branch_preview {}" --prompt="Select local branches to delete: ")`
  Line 41 from:
  `REMOTE=$(git remote | fzf --prompt="Choose remote: ")`
  To:
  `REMOTE=$(git remote | fzf --bind="change:first" --prompt="Choose remote: ")`
  Line 46 from:
  `fzf --multi --preview="branch_preview $REMOTE/{}" --prompt="Select remote branches to delete: ")`
  To:
  `fzf --bind="change:first" --multi --preview="branch_preview $REMOTE/{}" --prompt="Select remote branches to delete: ")`

- [ ] **Step 6: Update `bin/.config/bin/install-deb`**
  Modify line 19:
  From: `deb_file=$(find "$HOME/Downloads" -name "*.deb" | fzf --prompt="Select a .deb file to install")`
  To: `deb_file=$(find "$HOME/Downloads" -name "*.deb" | fzf --bind="change:first" --prompt="Select a .deb file to install")`

- [ ] **Step 7: Update `bin/.config/bin/install-dots`**
  Modify line 13:
  From: `selected_scripts=$(find "$INSTALL_DIR" -type f ! -name "*.sh" ! -name "*.zsh" | fzf -m)`
  To: `selected_scripts=$(find "$INSTALL_DIR" -type f ! -name "*.sh" ! -name "*.zsh" | fzf --bind="change:first" -m)`

- [ ] **Step 8: Update `bin/.config/bin/install-font`**
  Modify line 16:
  From: `selected_fonts=$(echo "$fonts" | fzf --multi --preview 'echo {}' --preview-window=up:50%:wrap)`
  To: `selected_fonts=$(echo "$fonts" | fzf --bind="change:first" --multi --preview 'echo {}' --preview-window=up:50%:wrap)`

- [ ] **Step 9: Update `bin/.config/bin/kitty-font`**
  Modify line 10:
  From: `selected_font=$(echo "$fonts" | fzf)`
  To: `selected_font=$(echo "$fonts" | fzf --bind="change:first")`

- [ ] **Step 10: Update `bin/.config/bin/make-exec`**
  Modify line 57:
  From: `selected_files=$(echo "$non_executable_scripts" | fzf -m --bind "ctrl-a:select-all,ctrl-d:deselect-all,ctrl-t:toggle-all")`
  To: `selected_files=$(echo "$non_executable_scripts" | fzf -m --bind "ctrl-a:select-all,ctrl-d:deselect-all,ctrl-t:toggle-all,change:first")`

- [ ] **Step 11: Update `bin/.config/bin/remove-apt-repository`**
  Modify line 17:
  From: `selected_repos=$(echo "$repo_files" | fzf --multi --prompt="Select repositories to remove: " --preview="cat {}")`
  To: `selected_repos=$(echo "$repo_files" | fzf --bind="change:first" --multi --prompt="Select repositories to remove: " --preview="cat {}")`

- [ ] **Step 12: Update `bin/.config/bin/select-mic`**
  Modify lines 28, 54.
  Line 28 from:
  `selected=$(echo "$sources" | fzf \`
  To:
  `selected=$(echo "$sources" | fzf --bind="change:first" \`
  Line 54 from:
  `selected_port=$(echo "$ports" | fzf \`
  To:
  `selected_port=$(echo "$ports" | fzf --bind="change:first" \`

- [ ] **Step 13: Update `bin/.config/bin/stow-config`**
  Modify line 24:
  From: `selected_folder=$(find $DOTFILES_DIR -mindepth 1 -maxdepth 1 -type d | fzf)`
  To: `selected_folder=$(find $DOTFILES_DIR -mindepth 1 -maxdepth 1 -type d | fzf --bind="change:first")`

- [ ] **Step 14: Update `bin/.config/bin/tmux-file-picker`**
  Modify lines 19, 154.
  Line 19 from:
  `dir=$(zoxide query -l | fzf --reverse --preview "$zoxide_preview_cmd" || true)`
  To:
  `dir=$(zoxide query -l | fzf --bind="change:first" --reverse --preview "$zoxide_preview_cmd" || true)`
  Line 154 from:
  `selected_files_str=$(cd "$search_dir" && $fd_cmd $=fd_flags | fzf --multi --reverse --preview "$preview_cmd" || true)`
  To:
  `selected_files_str=$(cd "$search_dir" && $fd_cmd $=fd_flags | fzf --bind="change:first" --multi --reverse --preview "$preview_cmd" || true)`

- [ ] **Step 15: Update `bin/.config/bin/tsnv`**
  Modify line 35:
  From: `'.' . | fzf --ansi --delimiter : --nth 1,2,3 \`
  To: `'.' . | fzf --bind="change:first" --ansi --delimiter : --nth 1,2,3 \`

- [ ] **Step 16: Update `bin/.config/bin/walls`**
  Modify lines 8, 28.
  Line 8 from:
  `find ~/Projects/Personal/Github/wallpapers -type f \( -name "*.jpg" -o -name "*.png" -o -name "*.*" \) | grep -iE '\.(jpg|png)$' | fzf --preview 'chafa --size=180x {}' --preview-window=right:70%`
  To:
  `find ~/Projects/Personal/Github/wallpapers -type f \( -name "*.jpg" -o -name "*.png" -o -name "*.*" \) | grep -iE '\.(jpg|png)$' | fzf --bind="change:first" --preview 'chafa --size=180x {}' --preview-window=right:70%`
  Line 28 from:
  `selected=$(echo -e "random\nselection" | fzf)`
  To:
  `selected=$(echo -e "random\nselection" | fzf --bind="change:first")`

- [ ] **Step 17: Verify syntax of all modified scripts**
  Run: `for f in delete-nvim-sessions emoji fzf-menu fzfub git-branch-clean install-deb install-dots install-font kitty-font make-exec remove-apt-repository select-mic stow-config tmux-file-picker tsnv walls; do bash -n "bin/.config/bin/$f" || zsh -n "bin/.config/bin/$f"; done`
  Expected: Success

- [ ] **Step 18: Commit**
  ```bash
  git add bin/.config/bin/
  git commit -m "chore: add change:first to fzf calls in bin/ scripts"
  ```

---

### Task 3: Tmux Scripts and Keybindings

**Files:**
- Modify:
  - `tmux/.tmux.conf.local`
  - `tmux/.config/tmux/scripts/git/git-worktree.sh`
  - `tmux/.config/tmux/scripts/git/lib/common.sh`
  - `tmux/.config/tmux/scripts/kill-process.sh`
  - `tmux/.config/tmux/scripts/popup/ai/tool.sh`
  - `tmux/.config/tmux/scripts/popup/runner/project-runner-toggle.sh`
  - `tmux/.config/tmux/scripts/popup/runner/runner.sh`
  - `tmux/.config/tmux/scripts/popup/search-keybindings.sh`
  - `tmux/.config/tmux/scripts/popup/second-brain.sh`
  - `tmux/.config/tmux/scripts/sesh/fzf.sh`
  - `tmux/.config/tmux/scripts/tmux-sessionizer.sh`
  - `tmux/.config/tmux/scripts/tmuxinator-sessionizer.sh`
  - `tmux/.config/tmux/scripts/work-sessions/work-sessions.sh`

- [ ] **Step 1: Update `tmux/.tmux.conf.local`**
  Modify line 711:
  From:
  `set -g @tpad-search-notes-cmd 'rg --no-heading --line-number . $HOME/Projects/Personal/Github/second-brain/brain/notes | fzf'`
  To:
  `set -g @tpad-search-notes-cmd 'rg --no-heading --line-number . $HOME/Projects/Personal/Github/second-brain/brain/notes | fzf --bind="change:first"'`

- [ ] **Step 2: Update `tmux/.config/tmux/scripts/git/git-worktree.sh`**
  Modify line 183:
  From: `FZF_OUTPUT=$(git worktree list | fzf --prompt="Select a worktree to delete: " --expect=ctrl-d)`
  To: `FZF_OUTPUT=$(git worktree list | fzf --bind="change:first" --prompt="Select a worktree to delete: " --expect=ctrl-d)`

- [ ] **Step 3: Update `tmux/.config/tmux/scripts/git/lib/common.sh`**
  Modify line 132:
  From: `SELECTED_FILES=$(git ls-files | grep -v ".env*" | fzf --multi --preview 'bat --color=always --style=numbers --line-range=:500 {}')`
  To: `SELECTED_FILES=$(git ls-files | grep -v ".env*" | fzf --bind="change:first" --multi --preview 'bat --color=always --style=numbers --line-range=:500 {}')`

- [ ] **Step 4: Update `tmux/.config/tmux/scripts/kill-process.sh`**
  Modify line 9:
  From: `selection=$(echo "$process_list" | fzf -m)`
  To: `selection=$(echo "$process_list" | fzf --bind="change:first" -m)`

- [ ] **Step 5: Update `tmux/.config/tmux/scripts/popup/ai/tool.sh`**
  Modify line 79:
  From: `MODE=$(echo -e "popup\nsplit\nwindow" | fzf --height=5 --header="$FZF_HEADER" --ansi)`
  To: `MODE=$(echo -e "popup\nsplit\nwindow" | fzf --bind="change:first" --height=5 --header="$FZF_HEADER" --ansi)`

- [ ] **Step 6: Update `tmux/.config/tmux/scripts/popup/runner/project-runner-toggle.sh`**
  Modify line 9:
  From: `selection=$(get_yarn_scripts | fzf --prompt="yarn> " --header="Project Runner" ...`
  To: `selection=$(get_yarn_scripts | fzf --bind="change:first" --prompt="yarn> " --header="Project Runner" ...`

- [ ] **Step 7: Update `tmux/.config/tmux/scripts/popup/runner/runner.sh`**
  Modify line 262:
  From: `selection=$(print -r -- "$available_scripts" | fzf --prompt="Select a script to run > " --height="100%" --layout=reverse --print-query)`
  To: `selection=$(print -r -- "$available_scripts" | fzf --bind="change:first" --prompt="Select a script to run > " --height="100%" --layout=reverse --print-query)`

- [ ] **Step 8: Update `tmux/.config/tmux/scripts/popup/search-keybindings.sh`**
  Modify line 43:
  From: `selected=\$(fzf --ansi \`
  To: `selected=\$(fzf --bind="change:first" --ansi \`

- [ ] **Step 9: Update `tmux/.config/tmux/scripts/popup/second-brain.sh`**
  Modify lines 82, 101, 104, 144.
  Line 82 from:
  `context=$(printf "%s\n" "${CONTEXTS[@]}" | fzf --prompt="Select Context > ")`
  To:
  `context=$(printf "%s\n" "${CONTEXTS[@]}" | fzf --bind="change:first" --prompt="Select Context > ")`
  Line 101 from:
  `selection=$(echo "$note_list" | fzf --prompt="Find or Create Note > ")`
  To:
  `selection=$(echo "$note_list" | fzf --bind="change:first" --prompt="Find or Create Note > ")`
  Line 104 from:
  `selection=$(echo "" | fzf --prompt="No notes found. Type a note name to create > " --print-query --query="" | head -1)`
  To:
  `selection=$(echo "" | fzf --bind="change:first" --prompt="No notes found. Type a note name to create > " --print-query --query="" | head -1)`
  Line 144 from:
  `scratch_type=$(printf "%s\n" "${full_scratch_list[@]}" | fzf --prompt="Select Scratchpad Type > ")`
  To:
  `scratch_type=$(printf "%s\n" "${full_scratch_list[@]}" | fzf --bind="change:first" --prompt="Select Scratchpad Type > ")`

- [ ] **Step 10: Update `tmux/.config/tmux/scripts/sesh/fzf.sh`**
  Modify line 25:
  From: `sesh list --icons | fzf \`
  To: `sesh list --icons | fzf --bind="change:first" \`

- [ ] **Step 11: Update `tmux/.config/tmux/scripts/tmux-sessionizer.sh`**
  Modify line 23:
  From: `done | fzf`
  To: `done | fzf --bind="change:first"`

- [ ] **Step 12: Update `tmux/.config/tmux/scripts/tmuxinator-sessionizer.sh`**
  Modify line 7:
  From: `selected=$(ls "$tmuxinator_dir" | sed 's/\.yml$//' | fzf)`
  To: `selected=$(ls "$tmuxinator_dir" | sed 's/\.yml$//' | fzf --bind="change:first")`

- [ ] **Step 13: Update `tmux/.config/tmux/scripts/work-sessions/work-sessions.sh`**
  Modify lines 316, 330, 429, 454.
  Line 316 from:
  `selected_dirs=$(ls -1 "$only_path" 2>/dev/null | fzf \`
  To:
  `selected_dirs=$(ls -1 "$only_path" 2>/dev/null | fzf --bind="change:first" \`
  Line 330 from:
  `done <<< "$valid_paths" | fzf \`
  To:
  `done <<< "$valid_paths" | fzf --bind="change:first" \`
  Line 429 from:
  `local selected=$(printf '%s\n' "${options[@]}" | fzf --prompt="Select preset: " \`
  To:
  `local selected=$(printf '%s\n' "${options[@]}" | fzf --bind="change:first" --prompt="Select preset: " \`
  Line 454 from:
  `local selected=$(echo "$sessions" | fzf \`
  To:
  `local selected=$(echo "$sessions" | fzf --bind="change:first" \`

- [ ] **Step 14: Verify syntax of all modified scripts**
  Run: `for f in git/git-worktree.sh git/lib/common.sh kill-process.sh popup/ai/tool.sh popup/runner/project-runner-toggle.sh popup/runner/runner.sh popup/search-keybindings.sh popup/second-brain.sh sesh/fzf.sh tmux-sessionizer.sh tmuxinator-sessionizer.sh work-sessions/work-sessions.sh; do bash -n "tmux/.config/tmux/scripts/$f" || zsh -n "tmux/.config/tmux/scripts/$f"; done`
  Expected: Success

- [ ] **Step 15: Commit**
  ```bash
  git add tmux/
  git commit -m "chore: add change:first to fzf calls and configurations in tmux"
  ```
