# Second Brain Search & Find Bindings Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax.

**Goal:** Add text search and file find bindings for second brain repos across tmux, sxhkd, and i3, with dynamic brain detection and combined fzf flow with brain switching.

**Architecture:** Single bash script (`second-brain-search.sh`) with `text` and `file` modes, runtime brain discovery by checking directory existence, and an fzf combined flow with `alt-1/2/3` brain switching and `alt-Tab` cycling. Context detection (`$TMUX`) determines whether results open in a new tmux window or neovide floating scratchpad.

**Tech Stack:** bash, fzf, rg, fd, tmux, sxhkd, i3, neovide

## Global Constraints

- Script must be bash (runs from both tmux and sxhkd, no zsh dependency)
- Brain detection is fully dynamic — only dirs that exist appear in the fzf flow
- Key table changes in tmux must keep `q` for exit and `?` for help
- Fzf bindings: `--bind="change:first"` is the standard pattern across the dotfiles
- All config changes follow existing formatting (4-space indent, fold markers)

---

### Task 1: Create the second-brain-search.sh script

**Files:**
- Create: `tmux/.config/tmux/scripts/popup/second-brain-search.sh`

**Interfaces:**
- Consumes: existing `fzf`, `rg`, `fd` tools
- Produces: executable script called by tmux `run-shell` and sxhkd command

- [ ] **Step 1: Write the script with brain detection and mode routing**

```bash
#!/usr/bin/env bash

# -------------------------------------------------------------------
# NOTE: Brain Detection {{{
# -------------------------------------------------------------------
declare -a BRAIN_NAMES BRAIN_PATHS
BRAIN_NAMES=()
BRAIN_PATHS=()

register_brain() {
    local name="$1" path="$2"
    if [[ -d "$path" ]]; then
        BRAIN_NAMES+=("$name")
        BRAIN_PATHS+=("$path")
    fi
}

register_brain "Personal" "$HOME/Projects/Personal/Github/second-brain"
register_brain "Work"     "$HOME/Projects/Work/Github/second-brain"
register_brain "AI"       "$HOME/Projects/Personal/Github/ai-brain"
register_brain "Cursor"   "$HOME/Projects/Work/Github/cursor-brain"

if [[ ${#BRAIN_NAMES[@]} -eq 0 ]]; then
    echo "No second brain directories found."
    exit 1
fi
# }}}

MODE="${1:-text}"
BRAIN_FILTER="${2:-}"

# Determine initial brain index
CURRENT=0
if [[ -n "$BRAIN_FILTER" ]]; then
    for i in "${!BRAIN_NAMES[@]}"; do
        if [[ "${BRAIN_NAMES[$i],,}" == "${BRAIN_FILTER,,}" ]]; then
            CURRENT=$i
            break
        fi
    done
fi

build_header() {
    local idx=$1
    local parts=()
    parts+=("[ ${BRAIN_NAMES[$idx]} ]")
    for i in "${!BRAIN_NAMES[@]}"; do
        parts+=("alt-$((i+1)):${BRAIN_NAMES[$i],,}")
    done
    parts+=("alt-Tab:next")
    local IFS='  '
    echo "${parts[*]}"
}

build_bindings() {
    local current_idx=$1
    local binds=()
    for i in "${!BRAIN_NAMES[@]}"; do
        if [[ $i -ne $current_idx ]]; then
            if [[ "$MODE" == "text" ]]; then
                binds+=("alt-$((i+1)):reload(rg --no-heading --line-number --color=never . \"${BRAIN_PATHS[$i]}\")")
            else
                binds+=("alt-$((i+1)):reload(fd --type f --color=never . \"${BRAIN_PATHS[$i]}\")")
            fi
        fi
    done
    # Compute next index for alt-Tab cycling
    local next_idx=$(( (current_idx + 1) % ${#BRAIN_NAMES[@]} ))
    if [[ "$MODE" == "text" ]]; then
        binds+=("alt-Tab:reload(rg --no-heading --line-number --color=never . \"${BRAIN_PATHS[$next_idx]}\")")
    else
        binds+=("alt-Tab:reload(fd --type f --color=never . \"${BRAIN_PATHS[$next_idx]}\")")
    fi
    local IFS=','
    echo "${binds[*]}"
}

IS_TMUX=false
[[ -n "$TMUX" ]] && IS_TMUX=true

if [[ "$MODE" == "text" ]]; then
    SOURCE_CMD="rg --no-heading --line-number --color=never . \"${BRAIN_PATHS[$CURRENT]}\""
    PREVIEW_CMD="bat --style=numbers --color=always --highlight-line {2} {1} 2>/dev/null || head -n \$FZF_PREVIEW_LINES {1}"
    OUTPUT_PROCESSOR='awk -F: '\''{print $1 "\t" $2}'\'''
else
    SOURCE_CMD="fd --type f --color=never . \"${BRAIN_PATHS[$CURRENT]}\""
    PREVIEW_CMD="bat --color=always {1} 2>/dev/null || head -n \$FZF_PREVIEW_LINES {1}"
    OUTPUT_PROCESSOR='cat'
fi

HEADER=$(build_header $CURRENT)
BINDS=$(build_bindings $CURRENT)

SELECTION=$(eval "$SOURCE_CMD" | fzf \
    --bind="change:first" \
    --bind="$BINDS" \
    --header="$HEADER" \
    --preview="$PREVIEW_CMD" \
    --preview-window="right:60%:wrap" \
    --delimiter=":" \
    --with-nth="1,2,3")

if [[ -z "$SELECTION" ]]; then
    exit 0
fi

NEOVIDE_CMD="neovide --x11-wm-class floating-nvim"

if [[ "$MODE" == "text" ]]; then
    FILE=$(echo "$SELECTION" | awk -F: '{print $1}')
    LINE=$(echo "$SELECTION" | awk -F: '{print $2}')
    if $IS_TMUX; then
        tmux new-window "nvim +$LINE '$FILE'"
    else
        $NEOVIDE_CMD "+$LINE" "$FILE"
    fi
else
    FILE="$SELECTION"
    if $IS_TMUX; then
        tmux new-window "nvim '$FILE'"
    else
        $NEOVIDE_CMD "$FILE"
    fi
fi
```

- [ ] **Step 2: Make script executable**

Run: `chmod +x tmux/.config/tmux/scripts/popup/second-brain-search.sh`

- [ ] **Step 3: Verify script syntax**

Run: `bash -n tmux/.config/tmux/scripts/popup/second-brain-search.sh`
Expected: no output (no syntax errors)

- [ ] **Step 4: Commit**

```bash
git add tmux/.config/tmux/scripts/popup/second-brain-search.sh
git commit -m "feat: add second-brain search/find script with dynamic brain detection"
```

---

### Task 2: Update tmux.conf — remove old bindings and replace search-notes, add new search/find bindings

**Files:**
- Modify: `tmux/.tmux.conf.local:715-716` (remove old search-notes tpad)
- Modify: `tmux/.tmux.conf.local:1141-1146` (remove old workflow fallbacks)
- Modify: `tmux/.tmux.conf.local:1148-1149` (replace `f` binding)
- Modify: `tmux/.tmux.conf.local:1150-1160` (add new bindings)
- Modify: `tmux/.config/tmux/scripts/popup/help/tables/second-brain.txt` (update help table)

**Interfaces:**
- Consumes: the script from Task 1
- Produces: working tmux second-brain key table with `f`, `g`, `p`, `w`, `a`, `k`, `h`, `c` bindings

- [ ] **Step 1: Remove old `search-notes` tpad config**

Remove these two lines from `tmux/.tmux.conf.local`:
```
set -g @tpad-search-notes-cmd 'rg --no-heading --line-number . $HOME/Projects/Personal/Github/second-brain/brain/notes | fzf --bind="change:first"'
set -g @tpad-search-notes-title " Search Notes "
```

Also remove `search-notes` from the tpad instance loop on line 633:
Old: `journal-personal journal-work search-notes backup-logs scratchpad \`
New: `journal-personal journal-work backup-logs scratchpad \`

- [ ] **Step 2: Remove old workflow fallback bindings**

Remove these 6 lines (1141-1146):
```
bind-key -T second-brain a display-popup -w 90% -h 90% -E "~/.config/tmux/scripts/popup/second-brain.sh notes personal"
bind-key -T second-brain A display-popup -w 90% -h 90% -E "~/.config/tmux/scripts/popup/second-brain.sh notes work"
bind-key -T second-brain w display-popup -w 90% -h 90% -E "~/.config/tmux/scripts/popup/second-brain.sh todos personal"
bind-key -T second-brain W display-popup -w 90% -h 90% -E "~/.config/tmux/scripts/popup/second-brain.sh todos work"
bind-key -T second-brain k display-popup -w 90% -h 90% -E "~/.config/tmux/scripts/popup/second-brain.sh scratch personal"
bind-key -T second-brain K display-popup -w 90% -h 90% -E "~/.config/tmux/scripts/popup/second-brain.sh scratch work"
```

- [ ] **Step 3: Replace `f` binding and add new search/find bindings**

Replace the old `f` binding (line 1149):
```
bind-key -T second-brain f run-shell "#{@tpad-path} toggle search-notes"
```
With:
```
bind-key -T second-brain f display-popup -w 90% -h 90% -E "~/.config/tmux/scripts/popup/second-brain-search.sh text"
bind-key -T second-brain g display-popup -w 90% -h 90% -E "~/.config/tmux/scripts/popup/second-brain-search.sh file"
bind-key -T second-brain p display-popup -w 90% -h 90% -E "~/.config/tmux/scripts/popup/second-brain-search.sh text personal"
bind-key -T second-brain w display-popup -w 90% -h 90% -E "~/.config/tmux/scripts/popup/second-brain-search.sh text work"
bind-key -T second-brain a display-popup -w 90% -h 90% -E "~/.config/tmux/scripts/popup/second-brain-search.sh text ai"
bind-key -T second-brain k display-popup -w 90% -h 90% -E "~/.config/tmux/scripts/popup/second-brain-search.sh file personal"
bind-key -T second-brain h display-popup -w 90% -h 90% -E "~/.config/tmux/scripts/popup/second-brain-search.sh file work"
bind-key -T second-brain c display-popup -w 90% -h 90% -E "~/.config/tmux/scripts/popup/second-brain-search.sh file ai"
```

- [ ] **Step 4: Update the help table for second-brain mode**

Update `tmux/.config/tmux/scripts/popup/help/tables/second-brain.txt` — remove old workflow entries, update `f` description, add new search/find entries.

Old content:
```
Key	Description
a	Notes (personal old workflow)
A	Notes (work old workflow)
d	Todos Daily (personal)
D	Todos Daily (work)
f	Search notes
i	AI Notes
I	AI Journal
j	Journal (personal)
J	Journal (work)
k	Scratch (personal old workflow)
K	Scratch (work old workflow)
l	Backup logs
n	Notes (personal)
N	Notes (work)
s	Scratch (personal)
S	Scratch (work)
t	Todos (personal)
T	Todos (work)
w	Todos (personal old workflow)
W	Todos (work old workflow)
q	Quit table
?	Show help
```

New content:
```
Key	Description
d	Todos Daily (personal)
D	Todos Daily (work)
f	Search text (all brains)
g	Find file (all brains)
i	AI Notes
I	AI Journal
j	Journal (personal)
J	Journal (work)
l	Backup logs
n	Notes (personal)
N	Notes (work)
p	Search text (personal)
w	Search text (work)
a	Search text (ai/cursor)
k	Find file (personal)
h	Find file (work)
c	Find file (ai/cursor)
s	Scratch (personal)
S	Scratch (work)
t	Todos (personal)
T	Todos (work)
q	Quit table
?	Show help
```

- [ ] **Step 5: Test tmux config syntax**

Run: `tmux source-file ~/.config/tmux/.tmux.conf.local`
Expected: no error output, config loads cleanly

- [ ] **Step 6: Commit**

```bash
git add tmux/.tmux.conf.local tmux/.config/tmux/scripts/popup/help/tables/second-brain.txt
git commit -m "feat(tmux): add second-brain search/find keybindings, remove old fallbacks and update help table"
```

---

### Task 3: Update sxhkdrc and i3 scratchpads config

**Files:**
- Modify: `sxhkd/.config/sxhkd/sxhkdrc`
- Modify: `i3/.config/i3/scratchpads.conf`

**Interfaces:**
- Consumes: the script from Task 1
- Produces: global keybindings for text search and file find from i3

- [ ] **Step 1: Add sxhkd bindings for combined search/find**

Add these blocks to `sxhkd/.config/sxhkd/sxhkdrc`. Place them in the brain-related section near the neovide/second-brain scratchpad bindings (around line 360, after the `super + alt + k` block):

```
# >> second brain text search
super + ctrl + f
    ~/.config/tmux/scripts/popup/second-brain-search.sh text

# >> second brain file find
super + ctrl + g
    ~/.config/tmux/scripts/popup/second-brain-search.sh file
```

- [ ] **Step 2: Add i3 floating rule for neovide search results**

Add to `i3/.config/i3/scratchpads.conf` after the neovide scratchpad block (line 24):

```
for_window [class="floating-nvim"] floating enable, resize set 1200 800, move position center
```

- [ ] **Step 3: Verify sxhkd syntax**

Run: `sxhkd -c sxhkd/.config/sxhkd/sxhkdrc -t 1`
Expected: sxhkd parses config successfully

- [ ] **Step 4: Reload sxhkd**

Run: `pkill -USR1 sxhkd`
Expected: sxhkd reloads with new bindings

- [ ] **Step 5: Commit**

```bash
git add sxhkd/.config/sxhkd/sxhkdrc i3/.config/i3/scratchpads.conf
git commit -m "feat: add global second-brain search/find keybindings for sxhkd and i3"
```

---

### Task 4: Verify and test the complete feature

**Files:**
- No file changes — integration testing

- [ ] **Step 1: Test text search from tmux**

In a tmux session, press `C-a C-b f`. Verify:
- Fzf popup appears with Personal brain results
- Header shows `[ Personal ]` with brain switching hints
- Press `alt-2` to switch to Work brain, verify results change
- Press `alt-Tab` to cycle brains
- Select a result, verify a new tmux window opens with nvim at that file

- [ ] **Step 2: Test file find from tmux**

In a tmux session, press `C-a C-b g`. Verify:
- Fzf popup appears with file list from Personal brain
- Brain switching via alt-1/2/3 and alt-Tab works
- Select a file, verify a new tmux window opens with nvim

- [ ] **Step 3: Test per-brain direct keys from tmux**

Test each:
- `C-a C-b p` → text search, Personal brain only
- `C-a C-b w` → text search, Work brain only
- `C-a C-b a` → text search, AI brain only
- `C-a C-b k` → file find, Personal brain only
- `C-a C-b h` → file find, Work brain only
- `C-a C-b c` → file find, AI brain only

Verify each opens directly in the correct brain without the combined picker.

- [ ] **Step 4: Test from sxhkd**

From any i3 window (no tmux):
- Press `super + ctrl + f` → verify neovide opens in a floating window with the selected file
- Press `super + ctrl + g` → verify neovide opens in a floating window
- Verify the floating window is positioned center and sized at 1200x800

- [ ] **Step 5: Create full commit of any remaining uncommitted changes**

```bash
git status
# Review changes, then:
git add -A
git commit -m "feat: complete second-brain search/find bindings integration"
```
