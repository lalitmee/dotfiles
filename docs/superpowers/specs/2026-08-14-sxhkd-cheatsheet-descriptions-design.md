# SXHKD Cheatsheet Keybinding Descriptions — Design

**Date:** 2026-08-14
**Status:** Approved

## Goal

Enhance the `super + alt + s` cheatsheet menu ([`sxhkd-cheatsheet`](file:///home/lalitmee/dotfiles/bin/.config/bin/sxhkd-cheatsheet)) to display human-readable descriptions for keybindings extracted directly from comments in [`sxhkdrc`](file:///home/lalitmee/dotfiles/sxhkd/.config/sxhkd/sxhkdrc).

## Context & Motivation

Currently, `sxhkd-cheatsheet` displays columns `SECTION | KEYBINDING | COMMAND`. For custom scripts or complex pipelines (e.g. Pomodoro timer controls, dictation toggles, scratchpads), the raw command does not intuitively convey what the keybinding does.

Extracting description comments preceding keybindings in `sxhkdrc` allows self-documenting keybindings with a clean `SECTION | KEYBINDING | DESCRIPTION` layout in Rofi.

## Architecture & Parsing Logic

### 1. Enhanced AWK Parser in `sxhkd-cheatsheet`

The AWK script in [`bin/.config/bin/sxhkd-cheatsheet`](file:///home/lalitmee/dotfiles/bin/.config/bin/sxhkd-cheatsheet) will process `sxhkdrc` as follows:

- **Section Tracking:** Match section markers `/^# NOTE: (.+) {{{/` and extract section names.
- **Ignore Noise:** Skip separator lines (`/^#[-=]{3,}/`), fold openers (`/#\s*{{{/`), fold closers (`/#\s*}}}/`), and blank lines.
- **Comment Buffer:** For general comment lines (`/^\s*#\s*(.+)/`), extract the comment text and store it in a `desc` buffer.
- **Keybinding Line (`/^\S/`):**
  - Extract the hotkey text.
  - Read the subsequent command line using `getline cmd_line` and trim leading whitespace.
  - If `desc` is populated, use `desc` as the description.
  - If `desc` is empty, fallback to `cmd_line` as the description.
  - Print formatted record: `section "|" key "|" description`.
  - Reset `desc` to empty so it does not leak into subsequent keybindings.

### 2. Output & Rofi Integration

- Pipe output through `column -t -s '|'` for aligned column tabular formatting.
- Display via Rofi dmenu using existing cheatsheet theme:
  ```sh
  get_keybinds | column -t -s '|' | rofi -dmenu -i -p "Search Keybindings: " -theme "~/.config/rofi/cheatsheet.rasi" -font "Operator Mono Lig 11"
  ```
- Output headers: `SECTION | KEYBINDING | DESCRIPTION`.

## Keybinding Annotations Plan

Systematically audit and annotate all custom keybindings in [`sxhkd/.config/sxhkd/sxhkdrc`](file:///home/lalitmee/dotfiles/sxhkd/.config/sxhkd/sxhkdrc) with concise summary comments:

- **Pomodoro:**
  - `super + alt + r`: Reset Pomodoro timer
  - `super + alt + w`: Start custom work timer (prompt for minutes)
- **Dictation:**
  - `super + w`: Toggle live speech-to-text (Nerd Dictation)
  - `super + ctrl + w`: Toggle headset profile for dictation
  - `super + alt + d`: Toggle Whisper dictation
- **Cheatsheet & Wallpapers:**
  - `super + alt + s`: Searchable keybinding cheatsheet
  - `super + ctrl + r`: Set random wallpaper
  - `super + ctrl + s`: Select wallpaper interactively
- **Scratchpads & Applications:**
  - Ensure all scratchpads (Claude, Gemini, ChatGPT, Discord, Slack, etc.) have clear descriptions.
- **Window Management & Media:**
  - Add descriptive comments for audio playback controls, volume controls, and i3 actions where applicable.

## Verification & Testing

1. **Parser Unit Verification:** Run `~/.config/bin/sxhkd-cheatsheet` or test `get_keybinds` directly to ensure:
   - Header is `SECTION | KEYBINDING | DESCRIPTION`.
   - Descriptions appear properly populated for annotated keybindings.
   - Unannotated / standard keybindings gracefully fallback to the command.
   - Column formatting aligns correctly.
2. **Interactive UI Verification:** Trigger `super + alt + s` and verify Rofi display, searchability, and formatting.
3. **Configuration Reload:** Reload `sxhkd` (`sxhkd-reload` / `super + Escape`) to ensure no syntax errors exist in `sxhkdrc`.
