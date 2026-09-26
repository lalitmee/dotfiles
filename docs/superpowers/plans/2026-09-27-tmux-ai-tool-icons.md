# tmux AI Tool Icons Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Give each AI CLI launched from tmux's `C-a C-i` table a unique, consistent icon across launcher, install/update picker, and help text.

**Architecture:** Keep the existing shell scripts and help table. Update the icon assignment in `tool.sh`, then mirror the chosen mapping in `manage.sh` and `ai-tools.txt`; do not add configuration layers or dependencies.

**Tech Stack:** Zsh, tmux, fzf, plain text help table.

## Global Constraints

- Give every CLI a distinct icon; no two tools may share one.
- Prefer a recognizable brand mark when the current terminal font setup can render it; otherwise use a distinct semantic emoji.
- Preserve a consistent icon-to-tool mapping across all three surfaces.
- Do not change key assignments, commands, install behavior, layouts, or tool membership.
- Keep labels readable if emoji or Nerd Font glyph width varies; icons are decorative identifiers, not the only name/key information.

---

## File Map

- `tmux/.config/tmux/scripts/popup/ai/tool.sh` — owns launcher icon values and uses them in layout chooser and pane/window titles.
- `tmux/.config/tmux/scripts/popup/ai/manage.sh` — renders tool labels in the install/update picker and extracts selected tools.
- `tmux/.config/tmux/scripts/popup/help/tables/ai-tools.txt` — documents key-to-tool descriptions.
- `tmux/.tmux.conf.local` — existing key bindings; inspect/verify only, do not edit.

## Task 1: Choose and apply a distinct CLI icon mapping

**Files:**
- Modify: `tmux/.config/tmux/scripts/popup/ai/tool.sh`
- Modify: `tmux/.config/tmux/scripts/popup/ai/manage.sh`
- Modify: `tmux/.config/tmux/scripts/popup/help/tables/ai-tools.txt`

**Interfaces:**
- Consumes: Existing tool identifiers (`agy`, `claude`, `codex`, `opencode`, `copilot`, `plandex`, `crush`, `kiro`, `grok`, `cursor-agent`).
- Produces: One distinct icon for each identifier, with the same icon displayed in launcher/title, management picker, and help description.

- [ ] **Step 1: Select ten distinct marks.** Prefer recognizable brand glyphs already supported by the configured terminal font where available; select an unambiguous, distinct emoji for tools without a reliable brand glyph. Check the installed Nerd Font mappings/configuration and verify each chosen symbol is unique. Retain tool names and keys in every label.
- [ ] **Step 2: Update the launcher mapping.** Change only each `ICON` assignment in `tool.sh`; preserve commands, pane-title labels, layout selection, and launch behavior.
- [ ] **Step 3: Mirror icons in the management picker.** Update the ten tool labels in `manage.sh`. Keep the selected-line matching and tool extraction correct for the chosen icons; package-manager icons and unrelated status messages remain unchanged.
- [ ] **Step 4: Mirror icons in help text.** Add each corresponding icon to its existing key description in `ai-tools.txt`; leave key assignments and help actions unchanged.
- [ ] **Step 5: Verify shell syntax.** Run:

```bash
zsh -n tmux/.config/tmux/scripts/popup/ai/tool.sh
zsh -n tmux/.config/tmux/scripts/popup/ai/manage.sh
```

Expected: both commands exit successfully without output.

- [ ] **Step 6: Verify mapping and behavior.** Compare all ten tool labels across the three files, confirm there are ten unique icons and each label retains its tool identity. Compare `tmux/.tmux.conf.local` AI bindings to confirm the key-to-tool commands are unchanged.
- [ ] **Step 7: Reload and inspect tmux.** Run `tmux source-file ~/.tmux.conf`, then inspect the live key table with `tmux list-keys -T ai-tools` and open the help table. Confirm all existing bindings work and icons render legibly in the layout picker, pane/window titles, management picker, and help.

## Completion Criteria

- Each of the ten CLIs has its own icon.
- The icon mapping matches across launcher, install/update picker, and help descriptions.
- Both modified shell scripts pass `zsh -n`.
- AI keybindings and tool launch/install commands remain unchanged.
- tmux has been reloaded and the visible labels have been checked.
