# Neovide Floating Scratchpads Integration Design

This document details the design for replacing the current Ghostty + Neovim floating scratchpads with graphical Neovide-based equivalents in the i3 workspace routing and `sxhkd` hotkey system.

## Goal
To comment out the existing terminal-based scratchpads for notes, todos, and sandbox scratch, replacing them with standalone Neovide instances. We will assign unique window classes (`neovide-notes`, `neovide-todos`, `neovide-scratch`) and update i3wm window rules to make them floating and properly sized.

## Keybindings & Mapped Commands

The keybindings will remain unchanged, but the mapped execution commands will be updated as follows:

| Keybinding | Application | Current Command (Commented Out) | New Command (Neovide) |
| :--- | :--- | :--- | :--- |
| **`super + shift + n`** | **Floating Notes** | `i3run --summon --title floating-notes -- ghostty --title=floating-notes -e nvim ~/Projects/Personal/Github/second-brain/brain/notes/system/inbox.org` | `i3run --summon --class neovide-notes -- neovide --x11-wm-class neovide-notes ~/Projects/Personal/Github/second-brain/brain/notes/system/inbox.org` |
| **`super + shift + t`** | **Todos** | `i3run --summon --title floating-todos -- ghostty --title=floating-todos -e nvim ~/Projects/Personal/Github/second-brain/daily/agenda/inbox.org` | `i3run --summon --class neovide-todos -- neovide --x11-wm-class neovide-todos ~/Projects/Personal/Github/second-brain/daily/agenda/inbox.org` |
| **`super + alt + k`** | **Scratch** | `i3run --summon --title floating-scratch -- ghostty --title=floating-scratch -e nvim ~/Projects/Personal/Github/second-brain/sandbox/scratch/inbox.org` | `i3run --summon --class neovide-scratch -- neovide --x11-wm-class neovide-scratch ~/Projects/Personal/Github/second-brain/sandbox/scratch/inbox.org` |

---

## Detailed Component Changes

### 1. `sxhkd/.config/sxhkd/sxhkdrc`
*   Comment out the three Ghostty/Nvim scratchpad bindings:
    *   `super + shift + n`
    *   `super + shift + t`
    *   `super + alt + k`
*   Add the new Neovide equivalents under the same keybindings.
*   Ensure that `--x11-wm-class` is passed to `neovide` so that the window managers can match the target window class.

### 2. `i3/.config/i3/scratchpads.conf`
*   Add window rules to match the new classes, ensuring that the scratchpads are set to floating, sized to `1800 1000`, and centered:
    ```i3config
    for_window [class="neovide-notes"] floating enable, resize set 1800 1000, move position center
    for_window [class="neovide-todos"] floating enable, resize set 1800 1000, move position center
    for_window [class="neovide-scratch"] floating enable, resize set 1800 1000, move position center
    ```

---

## Verification Plan

### Automated/Syntax Validation
1. Verify `sxhkdrc` syntax and reload `sxhkd` via `sxhkd-reload` (or `super + Escape`).
2. Verify `scratchpads.conf` syntax and reload i3 via `i3-msg reload`.

### Manual Verification
*   Press `super + shift + n` and confirm it launches Neovide showing `inbox.org` in a centered, floating window.
*   Press `super + shift + t` and confirm it launches Neovide showing `inbox.org` for todos.
*   Press `super + alt + k` and confirm it launches Neovide showing `inbox.org` for sandbox scratch.
*   Verify that pressing the keys again hides/summons the window appropriately (managed by `i3run`).
