# Tmux Navigator Key Pass-Through Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Enable sending raw Ctrl+h, Ctrl+j, Ctrl+k, and Ctrl+l keys to the active terminal pane under tmux by using the tmux prefix (C-a), preventing tmux-navigator from intercepting these keys.

**Architecture:** Bind `C-h`, `C-j`, `C-k`, and `C-l` under prefix mode in tmux config to send the corresponding keys to the pane, and update the global tmux help table to document this escape hatch.

**Tech Stack:** Tmux config

---

## User Review Required

### Keybinding Conflict Analysis
During research, we scanned all active prefix keybindings (`tmux list-keys -T prefix`) and `.tmux.conf.local`:
* **`C-a C-j`**: Unbound (Free)
* **`C-a C-k`**: Unbound (Free)
* **`C-a C-h`**: Bound to `previous-window` (Conflict with gpakosz/.tmux base template)
* **`C-a C-l`**: Bound to `next-window` (Conflict with gpakosz/.tmux base template)

> [!NOTE]
> You also have `C-a C-p` bound to `previous-window` and `C-a C-n` bound to `next-window`, meaning you have alternative shortcuts for window navigation.

### Options
1. **Option A (Recommended)**: Map all four (`C-a C-h/j/k/l`) to `send-keys`. This overwrites `C-a C-h` and `C-a C-l` window switching, but lets you pass through all four Ctrl keys to terminal apps. Window navigation remains fully accessible via `C-a C-p` and `C-a C-n`.
2. **Option B**: Only map `C-a C-j` and `C-a C-k` to `send-keys`. This preserves window navigation on `C-a C-h`/`C-a C-l`, but means you cannot pass raw `Ctrl+h` or `Ctrl+l` to terminal applications.

---

## Open Questions

> [!IMPORTANT]
> Which option would you like to proceed with? Please let me know if we should implement Option A (map all four) or Option B (only map `C-a C-j` and `C-a C-k`).

---

## Proposed Changes

### Tmux Configuration

#### [MODIFY] [tmux/.tmux.conf.local](file:///home/lalitmee/dotfiles/tmux/.tmux.conf.local)

Insert the fallback prefix bindings right after the smart pane switching section (around line 793):
```tmux
# Fallbacks to send raw ctrl keys to the active pane after pressing prefix
bind C-h send-keys C-h
bind C-j send-keys C-j
bind C-k send-keys C-k
bind C-l send-keys C-l
```
*(Note: If Option B is chosen, we will omit `C-h` and `C-l` bindings).*

### Help Documentation

#### [MODIFY] [global.txt](file:///home/lalitmee/dotfiles/tmux/.config/tmux/scripts/popup/help/tables/global.txt)

Append the description for the fallback keys (using a tab separator):
```text
C-a C-h/j/k/l	Send raw C-h/j/k/l keys
```

---

## Verification Plan

### Automated Tests
- Syntax validation: `tmux -f ~/dotfiles/tmux/.tmux.conf.local -c "echo 'valid'"`

### Manual Verification
1. Reload tmux config: `tmux source-file ~/.tmux.conf.local`
2. Run `tmux list-keys -T prefix | grep -E "C-(h|j|k|l)"` to verify the bindings are applied.
3. Open help table popup `~/.config/tmux/scripts/popup/help/help.sh global` to ensure formatting is correct and new shortcuts are listed.
