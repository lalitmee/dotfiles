# Spec: robust fzf change:first behavior

## 1. Problem Statement
When using `fzf`, if a user types query characters to filter the list and they were previously not on the first line, the selection does not automatically reset to the first filtered result. Instead, the selection highlight stays at the previous index, which may be empty or point to a non-ideal match.

The desired behavior is that whenever the filter query changes, the selection jumps back to the first match in the filtered list. This is done by adding/binding `change:first` to `fzf` invocations.

---

## 2. Proposed Changes
We will apply a two-layer solution:
1. **Global Configuration:** Update `FZF_DEFAULT_OPTS` in `zsh/.fzf_config` to include `change:first`.
2. **Explicit Script Hardening:** Explicitly append `--bind="change:first"` (or merge with existing `--bind` strings) in all standalone scripts in `bin/.config/bin/` and `tmux/` scripts. This ensures robust behavior even when scripts are run in environment-isolated contexts (like tmux popups or run-shell commands that do not inherit interactive zsh environments).

---

## 3. Scope of Modifications

### A. Zsh Configuration
* **[zsh/.fzf_config](file:///home/lalitmee/dotfiles/zsh/.fzf_config)**: Update `FZF_DEFAULT_OPTS` bindings:
  ```zsh
  --bind=ctrl-a:select-all,ctrl-j:down,ctrl-k:up,ctrl-d:deselect-all,change:first
  ```

### B. Standalone Scripts (`bin/.config/bin/`)
* **[delete-nvim-sessions](file:///home/lalitmee/dotfiles/bin/.config/bin/delete-nvim-sessions)**: Add `--bind="change:first"`
* **[emoji](file:///home/lalitmee/dotfiles/bin/.config/bin/emoji)**: Add `--bind="change:first"`
* **[fzf-menu](file:///home/lalitmee/dotfiles/bin/.config/bin/fzf-menu)**: Add `--bind="change:first"`
* **[fzfub](file:///home/lalitmee/dotfiles/bin/.config/bin/fzfub)**: Add `--bind="change:first"`
* **[git-branch-clean](file:///home/lalitmee/dotfiles/bin/.config/bin/git-branch-clean)**: Add `--bind="change:first"` to all 4 fzf invocations
* **[install-deb](file:///home/lalitmee/dotfiles/bin/.config/bin/install-deb)**: Add `--bind="change:first"`
* **[install-dots](file:///home/lalitmee/dotfiles/bin/.config/bin/install-dots)**: Add `--bind="change:first"`
* **[install-font](file:///home/lalitmee/dotfiles/bin/.config/bin/install-font)**: Add `--bind="change:first"`
* **[kitty-font](file:///home/lalitmee/dotfiles/bin/.config/bin/kitty-font)**: Add `--bind="change:first"`
* **[make-exec](file:///home/lalitmee/dotfiles/bin/.config/bin/make-exec)**: Append `,change:first` to existing `--bind` argument
* **[remove-apt-repository](file:///home/lalitmee/dotfiles/bin/.config/bin/remove-apt-repository)**: Add `--bind="change:first"`
* **[select-mic](file:///home/lalitmee/dotfiles/bin/.config/bin/select-mic)**: Add `--bind="change:first"` to both fzf invocations
* **[stow-config](file:///home/lalitmee/dotfiles/bin/.config/bin/stow-config)**: Add `--bind="change:first"`
* **[tmux-file-picker](file:///home/lalitmee/dotfiles/bin/.config/bin/tmux-file-picker)**: Add `--bind="change:first"` to both fzf invocations
* **[tsnv](file:///home/lalitmee/dotfiles/bin/.config/bin/tsnv)**: Add `--bind="change:first"`
* **[walls](file:///home/lalitmee/dotfiles/bin/.config/bin/walls)**: Add `--bind="change:first"` to both fzf invocations

### C. Tmux Configurations & Scripts (`tmux/`)
* **[tmux/.tmux.conf.local](file:///home/lalitmee/dotfiles/tmux/.tmux.conf.local)**: Update keybinding command for `@tpad-search-notes-cmd` to add `--bind="change:first"`
* **[tmux/.config/tmux/scripts/git/git-worktree.sh](file:///home/lalitmee/dotfiles/tmux/.config/tmux/scripts/git/git-worktree.sh)**: Add `--bind="change:first"`
* **[tmux/.config/tmux/scripts/git/lib/common.sh](file:///home/lalitmee/dotfiles/tmux/.config/tmux/scripts/git/lib/common.sh)**: Add `--bind="change:first"`
* **[tmux/.config/tmux/scripts/kill-process.sh](file:///home/lalitmee/dotfiles/tmux/.config/tmux/scripts/kill-process.sh)**: Add `--bind="change:first"`
* **[tmux/.config/tmux/scripts/popup/ai/tool.sh](file:///home/lalitmee/dotfiles/tmux/.config/tmux/scripts/popup/ai/tool.sh)**: Add `--bind="change:first"`
* **[tmux/.config/tmux/scripts/popup/runner/project-runner-toggle.sh](file:///home/lalitmee/dotfiles/tmux/.config/tmux/scripts/popup/runner/project-runner-toggle.sh)**: Add `--bind="change:first"`
* **[tmux/.config/tmux/scripts/popup/runner/runner.sh](file:///home/lalitmee/dotfiles/tmux/.config/tmux/scripts/popup/runner/runner.sh)**: Add `--bind="change:first"`
* **[tmux/.config/tmux/scripts/popup/search-keybindings.sh](file:///home/lalitmee/dotfiles/tmux/.config/tmux/scripts/popup/search-keybindings.sh)**: Add `--bind="change:first"`
* **[tmux/.config/tmux/scripts/popup/second-brain.sh](file:///home/lalitmee/dotfiles/tmux/.config/tmux/scripts/popup/second-brain.sh)**: Add `--bind="change:first"` to all 4 fzf invocations
* **[tmux/.config/tmux/scripts/sesh/fzf.sh](file:///home/lalitmee/dotfiles/tmux/.config/tmux/scripts/sesh/fzf.sh)**: Add `--bind="change:first"`
* **[tmux/.config/tmux/scripts/tmux-sessionizer.sh](file:///home/lalitmee/dotfiles/tmux/.config/tmux/scripts/tmux-sessionizer.sh)**: Add `--bind="change:first"`
* **[tmux/.config/tmux/scripts/tmuxinator-sessionizer.sh](file:///home/lalitmee/dotfiles/tmux/.config/tmux/scripts/tmuxinator-sessionizer.sh)**: Add `--bind="change:first"`
* **[tmux/.config/tmux/scripts/work-sessions/work-sessions.sh](file:///home/lalitmee/dotfiles/tmux/.config/tmux/scripts/work-sessions/work-sessions.sh)**: Add `--bind="change:first"` to all 4 fzf invocations

---

## 4. Verification and Testing

### Syntax Verification
Each modified shell script will be verified using static analysis:
```bash
bash -n <script_path>   # for bash scripts
zsh -n <script_path>    # for zsh scripts
```

### Functional Testing
1. Source `zsh/.fzf_config` in the current shell.
2. Run standard `fzf` and filter results to check if the selection jumps to the first item when a query is modified.
3. Test key scripts manually (like `skill-manager` and `tmux-file-picker`) to verify functionality.
