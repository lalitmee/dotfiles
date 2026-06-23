# Neovide Floating Scratchpads Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Comment out the existing terminal-based scratchpads for notes, todos, and sandbox scratch, and replace them with standalone Neovide instances assigned to custom window classes.

**Architecture:** We will update `sxhkdrc` to bind keys to `i3run` executing `neovide` with custom `--x11-wm-class` options. Then we will add `for_window` matching rules in i3's `scratchpads.conf` to float, center, and size these Neovide windows correctly.

**Tech Stack:** i3wm, sxhkd, i3run (i3ass), Neovide.

---

### Task 1: Update SXHKD Keybindings

**Files:**
- Modify: `sxhkd/.config/sxhkd/sxhkdrc`

- [ ] **Step 1: Edit `sxhkdrc` to replace nvim command with neovide command**

Modify the bindings for `super + shift + n`, `super + shift + t`, and `super + alt + k` to comment out the old `ghostty` commands and add the new `neovide` commands.

Target content in `sxhkd/.config/sxhkd/sxhkdrc` (Lines 332-343):
```sxhkdrc
# >> floating-notes -> ghostty
super + shift + n
    i3run --summon --title floating-notes -- ghostty --title=floating-notes -e nvim ~/Projects/Personal/Github/second-brain/brain/notes/system/inbox.org

# >> todos -> ghostty
super + shift + t
    i3run --summon --title floating-todos -- ghostty --title=floating-todos -e nvim ~/Projects/Personal/Github/second-brain/daily/agenda/inbox.org

# >> scratch -> ghostty
super + alt + k
    i3run --summon --title floating-scratch -- ghostty --title=floating-scratch -e nvim ~/Projects/Personal/Github/second-brain/sandbox/scratch/inbox.org
```

Replacement content:
```sxhkdrc
# >> floating-notes -> ghostty
# super + shift + n
#     i3run --summon --title floating-notes -- ghostty --title=floating-notes -e nvim ~/Projects/Personal/Github/second-brain/brain/notes/system/inbox.org
# >> floating-notes -> neovide
super + shift + n
    i3run --summon --class neovide-notes -- neovide --x11-wm-class neovide-notes ~/Projects/Personal/Github/second-brain/brain/notes/system/inbox.org

# >> todos -> ghostty
# super + shift + t
#     i3run --summon --title floating-todos -- ghostty --title=floating-todos -e nvim ~/Projects/Personal/Github/second-brain/daily/agenda/inbox.org
# >> todos -> neovide
super + shift + t
    i3run --summon --class neovide-todos -- neovide --x11-wm-class neovide-todos ~/Projects/Personal/Github/second-brain/daily/agenda/inbox.org

# >> scratch -> ghostty
# super + alt + k
#     i3run --summon --title floating-scratch -- ghostty --title=floating-scratch -e nvim ~/Projects/Personal/Github/second-brain/sandbox/scratch/inbox.org
# >> scratch -> neovide
super + alt + k
    i3run --summon --class neovide-scratch -- neovide --x11-wm-class neovide-scratch ~/Projects/Personal/Github/second-brain/sandbox/scratch/inbox.org
```

---

### Task 2: Configure i3 Floating Window Rules

**Files:**
- Modify: `i3/.config/i3/scratchpads.conf`

- [ ] **Step 1: Add new rules for neovide scratchpad window classes**

Open `i3/.config/i3/scratchpads.conf` and insert rules to match `neovide-notes`, `neovide-todos`, and `neovide-scratch`.

Target location: Insert below the existing `for_window [title="floating-notes"]` lines:
```i3config
for_window [title="floating-notes"] floating enable, resize set 1800 1000, move position center
for_window [title="floating-scratch"] floating enable, resize set 1800 1000, move position center
for_window [title="floating-todos"] floating enable, resize set 1800 1000, move position center
```

Insert below those lines:
```i3config
for_window [class="neovide-notes"] floating enable, resize set 1800 1000, move position center
for_window [class="neovide-todos"] floating enable, resize set 1800 1000, move position center
for_window [class="neovide-scratch"] floating enable, resize set 1800 1000, move position center
```

---

### Task 3: Reload Configuration and Validate

**Files:**
- None (commands only)

- [ ] **Step 1: Reload sxhkd configuration**

Run: `sxhkd-reload` (or trigger reload binding `super + Escape` or restart `sxhkd`).
Since we are editing, we can reload using:
```bash
killall -USR1 sxhkd
```
Expected: sxhkd reloads keybindings without error.

- [ ] **Step 2: Reload i3 configuration**

Run:
```bash
i3-msg reload
```
Expected: `[{"success":true}]`

- [ ] **Step 3: Manually test keybindings**

*   Press `super + shift + n` to summon the Neovide Notes window. Verify it opens centered and floating. Press the shortcut again to verify it hides.
*   Press `super + shift + t` to summon the Neovide Todos window. Verify it opens centered and floating. Press the shortcut again to verify it hides.
*   Press `super + alt + k` to summon the Neovide Scratch window. Verify it opens centered and floating. Press the shortcut again to verify it hides.
