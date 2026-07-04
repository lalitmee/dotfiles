# Second Brain Text Search & File Find Keybindings

Date: 2026-07-04

## Motivation

Provide fast, keyboard-driven access to search text and find files across the user's second brain repositories (personal, work, ai-brain/cursor-brain) from both tmux and i3/sxhkd global context, with consistent UX and cross-machine portability.

## Design

### Brain Detection (Dynamic)

A single shell script detects available brains at runtime by checking for directory existence:

| Brain | Path |
|-------|------|
| Personal | `~/Projects/Personal/Github/second-brain` |
| Work | `~/Projects/Work/Github/second-brain` |
| AI | `~/Projects/Personal/Github/ai-brain` |
| Cursor | `~/Projects/Work/Github/cursor-brain` |

Only brains that exist on the current machine appear in the combined fzf flow. Order is always Personal, Work, then AI/Cursor.

### Script Architecture

Single script at `~/.config/tmux/scripts/popup/second-brain-search.sh`

**Modes** (first arg):
- `text` — `rg --no-heading --line-number` across the brain directory, pipe to fzf, open at `file:line`
- `file` — `fd --type f` across the brain directory, pipe to fzf, open file

**Optional second arg**: brain name (personal/work/ai/cursor) — opens directly in that brain, skipping the combined picker.

**Context detection**: The script checks `$TMUX` to determine launch environment:
- From tmux: on selection, opens `nvim` in a **new tmux window**
- From sxhkd: on selection, opens `neovide` in an **i3 floating scratchpad** (`--x11-wm-class floating-nvim`)

### FZF Combined UX

When no brain arg is given, fzf opens with Personal brain results as default.

- **Header**: `[ Personal ]  alt-1:personal  alt-2:work  alt-3:ai  alt-Tab:next`
- `alt-1/2/3` — `reload()` with different brain, header updates to show current brain
- `alt-Tab` — cycles through available brains in order
- **Preview**: lightweight breadcrumb showing relative file path from brain root, with excerpt for text search
- **On select**: opens file with line number for text search

### Keybindings

#### Tmux Second-Brain Table (`C-a C-b`)

**Changes:**
- Remove old workflow fallbacks (`a`, `A`, `w`, `W`, `k`, `K`) — superseded by tpad-based notes/todos/scratch
- Repurpose `f` from old `search-notes` to combined smart text search

**New bindings:**

| Key | Action |
|-----|--------|
| `f` | Combined text search (default personal, switch via alt-1/2/3/Tab) |
| `g` | Combined file find (same brain-switching UX) |
| `p` | Text search personal |
| `w` | Text search work |
| `a` | Text search ai/cursor |
| `k` | File find personal |
| `h` | File find work |
| `c` | File find ai/cursor |

#### SXHKD Global Bindings

| Key | Action |
|-----|--------|
| `super + ctrl + f` | Combined text search |
| `super + ctrl + g` | Combined file find |

From sxhkd, the script opens results in `neovide --x11-wm-class floating-nvim`. The i3 scratchpad rule floats this window.

### File Changes

**New files:**
- `tmux/.config/tmux/scripts/popup/second-brain-search.sh` — search/find script with combined brain-switching UX

**Modified files:**
- `tmux/.tmux.conf.local`
  - Remove old workflow bindings (lines 1141-1146, `a/A/w/W/k/K`)
  - Remove old `search-notes` tpad instance (line 715-716)
  - Replace `f` binding with new combined text search
  - Add `g`, `p`, `w`, `a`, `k`, `h`, `c` bindings in second-brain table

- `sxhkd/.config/sxhkd/sxhkdrc`
  - Add `super + ctrl + f` command
  - Add `super + ctrl + g` command

- `i3/.config/i3/scratchpads.conf`
  - Add floating rule for `floating-nvim` window class

### Cross-Machine Portability

- Brain detection is fully dynamic — only existing dirs are included
- On work machine, cursor-brain replaces or supplements ai-brain based on what exists
- No hardcoded brain lists — script discovers at runtime
- Fzf header dynamically shows alt-1/2/3 mapped to whatever brains exist
