# SXHKD Cheatsheet Keybinding Descriptions Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Enhance the `super + alt + s` cheatsheet menu (`sxhkd-cheatsheet`) to parse and display human-readable descriptions from comments in `sxhkdrc` with tabular formatting in Rofi.

**Architecture:** Update `sxhkd-cheatsheet` with an improved single-pass AWK parser that captures section headers, comment descriptions (skipping decorative markers/dividers), keybindings, and command fallbacks. Systematically audit and annotate all keybindings in `sxhkdrc` with clear description comments.

**Tech Stack:** Zsh, AWK, `column`, Rofi, sxhkd.

## Global Constraints

- Shell scripts must use 4-space indentation, fold markers (`# {{{ func_name ... # }}}`), and preserve existing script conventions.
- Do not auto-commit or push without explicit user approval.
- Preserve all existing keybinding functionality; only add or improve documentation comments in `sxhkdrc`.

---

### Task 1: Update Parser in `bin/.config/bin/sxhkd-cheatsheet`

**Files:**
- Modify: [`bin/.config/bin/sxhkd-cheatsheet`](file:///home/lalitmee/dotfiles/bin/.config/bin/sxhkd-cheatsheet)

**Interfaces:**
- Consumes: `~/.config/sxhkd/sxhkdrc`
- Produces: Formatted output stream `SECTION|KEYBINDING|DESCRIPTION` piped to `column -t -s '|'` and `rofi`.

- [ ] **Step 1: Update `sxhkd-cheatsheet` parser script**

Replace [`bin/.config/bin/sxhkd-cheatsheet`](file:///home/lalitmee/dotfiles/bin/.config/bin/sxhkd-cheatsheet) with the enhanced parser logic:

```zsh
#!/usr/bin/env zsh

sxhkdrc_file="$HOME/.config/sxhkd/sxhkdrc"

# {{{ get_keybinds
# This function parses the sxhkdrc file and outputs '|' separated values
get_keybinds() {
    echo "SECTION|KEYBINDING|DESCRIPTION"
    awk '
        # Handle section headers
        /^#\s*NOTE:\s*(.+)\s*{{{/ {
            match($0, /#\s*NOTE:\s*(.+)\s*{{{/, g)
            section = g[1]
            desc = ""
            next
        }

        # Ignore fold markers and decorative divider lines
        /^#[-=]{3,}/ || /#\s*{{{/ || /#\s*}}}/ { next }

        # Capture description comment
        /^\s*#\s*(.+)/ {
            match($0, /^\s*#\s*(.+)/, g)
            raw_comment = g[1]
            # Strip leading ">> " or "-> " if present for cleaner display
            sub(/^(>>\s*|->\s*)/, "", raw_comment)
            desc = raw_comment
            next
        }

        # Skip blank lines
        /^\s*$/ { next }

        # Process a keybinding line (starts with non-whitespace)
        /^\S/ {
            key = $0
            # Get the next line which contains the command
            getline cmd_line
            sub(/^\s+/, "", cmd_line)

            # Use comment description if available, otherwise fallback to command
            description = (desc != "") ? desc : cmd_line
            print section "|" key "|" description
            desc = ""
        }
    ' "$sxhkdrc_file"
}
# }}}

# Pipe the output through the 'column' command to create a table, then to rofi
get_keybinds | column -t -s '|' | rofi -dmenu -i -p "Search Keybindings: " -theme "~/.config/rofi/cheatsheet.rasi" -font "Operator Mono Lig 11"
```

- [ ] **Step 2: Verify parser output on current `sxhkdrc`**

Run:
```zsh
zsh -c 'source ./bin/.config/bin/sxhkd-cheatsheet; get_keybinds | head -n 25'
```
Expected: Output showing `SECTION|KEYBINDING|DESCRIPTION` with extracted descriptions and fallbacks.

---

### Task 2: Audit and Annotate Keybindings in `sxhkd/.config/sxhkd/sxhkdrc`

**Files:**
- Modify: [`sxhkd/.config/sxhkd/sxhkdrc`](file:///home/lalitmee/dotfiles/sxhkd/.config/sxhkd/sxhkdrc)

**Interfaces:**
- Consumes: Keybinding definitions in `sxhkdrc`
- Produces: Uniform `# <Description>` comments directly above active keybindings across all sections.

- [ ] **Step 1: Clean and annotate must-have, rofi, audio, i3, gaps, and custom scripts sections**

Ensure every keybinding has a clear, concise description comment directly above it, and clean up any broken fold marker syntax (e.g. line 413 `#}}}````).

Examples of updated annotations:
- `super + Escape`: `# Reload sxhkd configuration`
- `super + Return`: `# Open Ghostty terminal`
- `ctrl + space`: `# Open Ulauncher`
- `alt + space`: `# Search Espanso snippets`
- `super + o`: `# Open Rofi application launcher`
- `super + p`: `# Open Rofi powermenu`
- `super + shift + s`: `# Take screenshot with Flameshot`
- `super + shift + w`: `# Open i3 layout manager`
- `XF86AudioPlay` / `ctrl + alt + p`: `# Play / Pause audio`
- `XF86AudioNext` / `ctrl + shift + period`: `# Next audio track`
- `XF86AudioPrev` / `ctrl + shift + comma`: `# Previous audio track`
- `XF86AudioStop`: `# Stop audio playback`
- `alt + {h,j,k,l}`: `# Control MPD {prev,next,play,pause}`
- `super + {1-9,0}`: `# Switch to workspace {1-10}`
- `super + shift + {1-9,0}`: `# Move container to workspace {1-10}`
- `super + r`: `# Reload i3 configuration`
- `super + shift + r`: `# Restart i3 in-place`
- `super + shift + e`: `# Exit i3 session`
- `super + q`: `# Kill focused window`
- `super + shift + period`: `# Suspend system`
- `super + shift + x`: `# Lock screen`
- `super + f`: `# Toggle fullscreen`
- `super + e`: `# Toggle layout (split / tabbed / stacking)`
- `super + v`: `# Split horizontally`
- `super + s`: `# Split vertically`
- `super + z`: `# Toggle Zen workspace`
- `super + grave`: `# Scratchpad overview (Mission Control)`
- `super + alt + p`: `# Start Pomodoro timer`
- `super + alt + b`: `# Start Pomodoro break`
- `super + alt + c`: `# Toggle Pomodoro pause`
- `super + alt + Up`: `# Add 1 minute to Pomodoro`
- `super + alt + Down`: `# Subtract 1 minute from Pomodoro`
- `super + alt + r`: `# Reset Pomodoro timer`
- `super + alt + w`: `# Start custom work timer (prompt for minutes)`
- `super + w`: `# Toggle live speech-to-text (Nerd Dictation)`
- `super + ctrl + w`: `# Toggle headset profile for dictation`
- `super + alt + d`: `# Toggle Whisper dictation`
- `super + alt + s`: `# Search keybinding cheatsheet`
- `super + ctrl + r`: `# Set random wallpaper`
- `super + ctrl + s`: `# Select wallpaper interactively`

- [ ] **Step 2: Validate `sxhkdrc` syntax and parser output**

Run:
```zsh
zsh -c 'source ./bin/.config/bin/sxhkd-cheatsheet; get_keybinds | column -t -s "|"'
```
Expected: Clean tabular output with aligned columns and readable descriptions for every keybinding.

---

### Task 3: Reload & End-to-End Verification

**Files:**
- None (Runtime verification)

- [ ] **Step 1: Test sxhkd configuration reload**

Run:
```zsh
~/.config/bin/sxhkd-reload
```
Expected: Command exits successfully with 0 status code and sxhkd reloads cleanly without syntax errors.

- [ ] **Step 2: Verify Rofi Cheatsheet invocation**

Verify by running `~/.config/bin/sxhkd-cheatsheet` in dry-run or testing pipeline to ensure Rofi receives valid input and all columns format without truncation or misalignment.
