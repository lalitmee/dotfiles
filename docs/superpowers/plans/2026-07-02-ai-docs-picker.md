# AI Docs Picker Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Add a `C-a C-f d` key binding that picks `.md` files from configurable project folders and opens them in nvim in a new tmux window.

**Architecture:** A Zsh script sourced from a `display-popup` binds `fd` + `fzf` with `bat` preview. A global config file (`~/.config/tmux/ai-docs-picker.conf`) lists project-relative folder names. The script resolves the git root from `#{pane_current_path}`, searches each folder for `*.md`, and opens the selection via `tmux new-window nvim`.

**Tech Stack:** Zsh, tmux, fd, fzf, bat, nvim

## Global Constraints

- Config file at `~/.config/tmux/ai-docs-picker.conf` — user-managed, not in repo
- Script under `tmux/.config/tmux/scripts/` following existing conventions
- Key binding `d` inside `file-picker-mode` table (`C-a C-f d`)
- FZF must use `--bind="change:first"` and `bat` preview (existing convention)
- Markdown files only (`*.md`), respecting `.gitignore` (no `-H` flag on fd)

---

### Task 1: Create ai-docs-picker.sh script

**Files:**
- Create: `tmux/.config/tmux/scripts/ai-docs-picker.sh`

**Produces:** A standalone Zsh script that:
- Sources `$HOME/.config/tmux/ai-docs-picker.conf` for `$AI_DOCS_FOLDERS`
- Gets pane path via `tmux display-message -p "#{pane_current_path}"`
- Resolves git root with `git rev-parse --show-toplevel`
- Runs `fd --type f --extension md` in each configured folder (relative to git root)
- Pipes deduplicated results to FZF with `bat` preview
- Opens selected file with `tmux new-window -n "docs" nvim <absolute_path>`

- [ ] **Step 1: Write the script**

```zsh
#!/usr/bin/env zsh

# Source the user's Zsh profile for PATH/environment
[[ -f ~/.zprofile ]] && source ~/.zprofile

# -------------------------------------------------------------------
# Config
# -------------------------------------------------------------------
CONFIG_FILE="$HOME/.config/tmux/ai-docs-picker.conf"

# -------------------------------------------------------------------
# Check dependencies
# -------------------------------------------------------------------
if ! command -v fd >/dev/null 2>&1; then
  tmux display-message "Error: 'fd' not found. Please install it."
  exit 1
fi

if ! command -v fzf >/dev/null 2>&1; then
  tmux display-message "Error: 'fzf' not found. Please install it."
  exit 1
fi

# -------------------------------------------------------------------
# Source config
# -------------------------------------------------------------------
AI_DOCS_FOLDERS=()
if [[ -f "$CONFIG_FILE" ]]; then
  source "$CONFIG_FILE"
else
  tmux display-message "Warning: $CONFIG_FILE not found. Create it with AI_DOCS_FOLDERS array."
  exit 0
fi

if [[ ${#AI_DOCS_FOLDERS[@]} -eq 0 ]]; then
  tmux display-message "Warning: AI_DOCS_FOLDERS is empty in $CONFIG_FILE."
  exit 0
fi

# -------------------------------------------------------------------
# Resolve git root
# -------------------------------------------------------------------
pane_dir=$(tmux display-message -p '#{pane_current_path}')
git_root=$(git -C "$pane_dir" rev-parse --show-toplevel 2>/dev/null || true)

if [[ -z "$git_root" ]]; then
  tmux display-message "Error: Not inside a git repository."
  exit 0
fi

# -------------------------------------------------------------------
# Build fd search for each configured folder
# -------------------------------------------------------------------
fd_cmd="fd"
preview_cmd="cat {}"
if command -v bat >/dev/null 2>&1; then
  preview_cmd="bat --style=numbers --color=always {}"
elif command -v batcat >/dev/null 2>&1; then
  preview_cmd="batcat --style=numbers --color=always {}"
fi

results_file=$(mktemp)
trap "rm -f '$results_file'" EXIT

for folder in "${AI_DOCS_FOLDERS[@]}"; do
  target_dir="$git_root/$folder"
  if [[ -d "$target_dir" ]]; then
    "$fd_cmd" --type f --extension md . "$target_dir" >> "$results_file" 2>/dev/null
  fi
done

# -------------------------------------------------------------------
# Sort and deduplicate
# -------------------------------------------------------------------
sorted_file=$(sort -u "$results_file" 2>/dev/null || true)
if [[ -z "$sorted_file" ]]; then
  tmux display-message "No .md files found in configured folders."
  exit 0
fi

# -------------------------------------------------------------------
# FZF picker
# -------------------------------------------------------------------
selected=$(echo "$sorted_file" | fzf --bind="change:first" --reverse \
  --preview "$preview_cmd" \
  --prompt "AI Docs > " || true)

if [[ -z "$selected" ]]; then
  exit 0
fi

# -------------------------------------------------------------------
# Open in new tmux window with nvim
# -------------------------------------------------------------------
tmux new-window -n "docs" nvim "$selected"
```

- [ ] **Step 2: Verify syntax**

Run: `zsh -n tmux/.config/tmux/scripts/ai-docs-picker.sh`
Expected: no output (syntax OK)

- [ ] **Step 3: Make executable**

Run: `chmod +x tmux/.config/tmux/scripts/ai-docs-picker.sh`

- [ ] **Step 4: Commit**

```bash
git add tmux/.config/tmux/scripts/ai-docs-picker.sh
git commit -m "feat: add ai-docs-picker script for browsing project .md files"
```

---

### Task 2: Add tmux key binding and help table entry

**Files:**
- Modify: `tmux/.tmux.conf.local` (add binding after line 904)
- Modify: `tmux/.config/tmux/scripts/popup/help/tables/file-picker-mode.txt`

**Produces:** A working `C-a C-f d` binding that opens the doc picker popup.

- [ ] **Step 1: Add key binding to tmux config**

After line 904 (`# Default file picker` binding), insert:

```tmux
# AI docs picker (markdown files from configured folders)
bind-key -T file-picker-mode d display-popup -h 80% -w 80% -E \
  "$HOME/.config/tmux/scripts/ai-docs-picker.sh"
```

- [ ] **Step 2: Update help table**

Replace the existing file-picker-mode.txt with:

```
Key	Description
f	Default file picker
g	Git root
z	Zoxide
v	Zoxide (directory only)
x	Zoxide (git root)
d	AI docs (md files in docs/plans/specs)
?	Help
q	Quit
```

- [ ] **Step 3: Reload tmux config**

Run: `tmux source-file ~/.config/tmux/.tmux.conf`

- [ ] **Step 4: Verify binding is registered**

Run: `tmux list-keys -T file-picker-mode | grep d`
Expected: line showing `d` → `display-popup` → `ai-docs-picker.sh`

- [ ] **Step 5: Commit**

```bash
git add tmux/.tmux.conf.local tmux/.config/tmux/scripts/popup/help/tables/file-picker-mode.txt
git commit -m "feat: add C-a C-f d binding for AI docs picker"
```

---

### Task 3: User setup and verification

**Files:**
- Create (user): `~/.config/tmux/ai-docs-picker.conf`

**Produces:** A working end-to-end flow.

- [ ] **Step 1: Create the config file**

The user creates `~/.config/tmux/ai-docs-picker.conf` with their desired folders:

```zsh
# Directories (relative to git root) to search for .md files
AI_DOCS_FOLDERS=(
  "docs"
  "plans"
  "specs"
  "docs/agents"
  "docs/adr"
)
```

- [ ] **Step 2: End-to-end test**

From a git repo with `.md` files in the configured folders:
1. Press `C-a C-f d`
2. Verify FZF popup appears with `.md` files listed
3. Select a file → new tmux window named "docs" opens with nvim
4. Press Escape on empty FZF → popup closes, no window created

- [ ] **Step 3: Test edge cases**
- Outside a git repo → warning message
- Config file missing → warning message
- No `.md` files in configured folders → warning message
