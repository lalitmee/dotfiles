# Spec: AI Docs Picker — tmux + FZF for AI-Generated Documents

## 1. Problem Statement

When working on projects, AI assistants generate documentation, plans, specs, ADRs, and other `.md` files in well-known directories (e.g., `docs/`, `plans/`, `specs/`). There's no quick way to browse and open these files from within tmux. The user wants a key binding that:

1. Finds all `.md` files inside a configurable set of project subdirectories
2. Presents them in an FZF picker with preview
3. Opens the selected file in neovim in a new tmux window

---

## 2. Proposed Solution

A single tmux key binding inside the existing **file-picker-mode** table (`C-a C-f d`) that runs a dedicated script. The script reads a global config file listing project-relative folder names, resolves the git root of the current pane, finds `.md` files in those folders, pipes to FZF, and opens the selection with `tmux new-window nvim`.

---

## 3. Components

### 3A. Global Config File

**Path:** `~/.config/tmux/ai-docs-picker.conf`

**Format:** Zsh-config style (sourced by the script), following the existing `work-sessions.conf` pattern.

```zsh
# Directories (relative to git root) to search for .md files
AI_DOCS_FOLDERS=(
  "docs"
  "plans"
  "specs"
)
```

### 3B. Script

**Path:** `tmux/.config/tmux/scripts/ai-docs-picker.sh`

**Shebang:** `#!/usr/bin/env zsh`

**Behavior:**
1. Source the global config file (`~/.config/tmux/ai-docs-picker.conf`)
2. Detect the current pane's directory via `tmux display-message -p "#{pane_current_path}"`
3. Resolve the git root with `git rev-parse --show-toplevel`
4. For each folder in `$AI_DOCS_FOLDERS`, run `fd` to find `.md` files relative to the git root
5. Pipe results to FZF with `bat` preview (`--bind="change:first"` for consistency)
6. On selection: `tmux new-window -n "docs" nvim <selected_file>`
7. If no selection (user cancels), exit silently

**Error handling:**
- Config file missing → show a warning via `tmux display-message`
- Not in a git repo → show a warning, exit
- No `.md` files found → show a warning via `tmux display-message`

### 3C. Tmux Key Binding

**File:** `tmux/.tmux.conf.local`

Added inside the `file-picker-mode` key table block (after line 904):

```tmux
# AI docs picker
bind-key -T file-picker-mode d display-popup -h 80% -w 80% -E \
  "$HOME/.config/tmux/scripts/ai-docs-picker.sh"
```

### 3D. Help Table Update

**File:** `tmux/.config/tmux/scripts/popup/help/tables/file-picker-mode.txt`

Add a row:
```
d	AI docs (md files in docs/plans/specs)
```

---

## 4. Files Modified

| File | Action |
|------|--------|
| `tmux/.config/tmux/scripts/ai-docs-picker.sh` | **Create** — main script |
| `tmux/.tmux.conf.local` | **Edit** — add `d` binding in file-picker-mode |
| `tmux/.config/tmux/scripts/popup/help/tables/file-picker-mode.txt` | **Edit** — add `d` row |
| `~/.config/tmux/ai-docs-picker.conf` | **Create manually by user** — global config |

---

## 5. Verification

1. Syntax check: `zsh -n tmux/.config/tmux/scripts/ai-docs-picker.sh`
2. Reload tmux: `tmux source-file ~/.config/tmux/.tmux.conf`
3. From a git repo with `docs/` or `plans/` containing `.md` files:
   - Press `C-a C-f d`
   - Verify FZF popup shows `.md` files
   - Press Enter on a file → new tmux window opens with nvim
   - Press Escape → popup closes, no window created
4. Test outside a git repo → warning message
5. Test with no config file → warning message
