# Design Specification: Consistent tmux AI Tool Icons

## Overview

Make each AI CLI launched from the tmux `C-a C-i` (`ai-tools`) key table visually identifiable with its own icon. Keep the icon consistent wherever the tool is named in the launcher UI, install/update picker, and keybinding help table.

## Current Problem

`tmux/.config/tmux/scripts/popup/ai/tool.sh` currently assigns icons used in the layout chooser and pane/window title. Antigravity and Claude both use `✨`; some other tools have generic or inconsistent marks. `manage.sh` repeats the icon list independently, while `ai-tools.txt` contains no icons. Separate lists can drift.

## Scope

- Update `tmux/.config/tmux/scripts/popup/ai/tool.sh` icon assignments and launcher labels.
- Update `tmux/.config/tmux/scripts/popup/ai/manage.sh` install/update picker labels to match.
- Update `tmux/.config/tmux/scripts/popup/help/tables/ai-tools.txt` descriptions to include the matching icons.
- Cover the existing tools: Antigravity (`agy`), Claude, Codex, OpenCode, Copilot, Plandex, Crush, Kiro, Grok, and Cursor Agent.

Do not change key assignments, commands, install behavior, layouts, or tool membership.

## Icon Selection

- Give every CLI a distinct icon; no two tools may share one.
- Prefer a recognizable brand mark when the current terminal font setup can render it.
- Otherwise use a distinct semantic emoji with a clear visual association to that CLI.
- Preserve a consistent icon-to-tool mapping across all three surfaces.
- Keep labels readable if emoji or Nerd Font glyph width varies; icons are decorative identifiers, not the only name/key information.

## Implementation Shape

Use the existing icon assignments in `tool.sh` as the launcher source of truth during implementation. Mirror that mapping in the existing picker and help text; do not add a framework or new dependency solely for icon data. If maintaining the same mapping becomes awkward, prefer the smallest clear representation rather than introducing generic configuration machinery.

## Verification

- Run `zsh -n` on the modified shell scripts.
- Check that each of the ten tools has exactly one distinct icon in all applicable UIs.
- Reload tmux with `tmux source-file ~/.tmux.conf` and inspect the live AI-tools key table/help display.
- Confirm no keybinding or launch command changed.
