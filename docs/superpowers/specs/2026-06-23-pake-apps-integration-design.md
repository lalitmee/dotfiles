# Pake Applications i3 & sxhkd Integration Design

This document details the design for integrating seven Pake-built native Linux applications into the i3 workspace routing and `sxhkd` hotkey system.

## Goal
To assign dedicated keybindings, workspace routing, and window properties for seven Pake applications to enable seamless workflows, fast scratchpad access, and clear spatial organization across two monitors (`DP-1` and `DP-2`).

## Decided Keybindings

The final keybinding assignments have been approved as follows:

| Keybinding | Action / Application | Mapped Executable | Status / Notes |
| :--- | :--- | :--- | :--- |
| **`super + c`** | **ChatGPT** | `pake-chatgpt` | **New** (Mnemonic `c` for Chat) |
| **`super + g`** | **Gemini** | `pake-gemini` | **New** (Heavy use - swapped from Todoist) |
| **`super + i`** | **WhatsApp** | `pake-whatsapp` | **New** (Heavy use - replaces Dunst test) |
| **`super + t`** | **Twitter** | `pake-twitter` | **New** (Mnemonic `t` for Twitter) |
| **`super + y`** | **YouTube Music** | `pake-youtubemusic` | **New** (Mnemonic `y` for YouTube) |
| **`super + shift + m`** | **MusicForProgramming** | `pake-programmusic` | **New** (Swapped with cmus) |
| **`super + ctrl + m`** | **cmus** (Terminal Music) | `ghostty ... -e cmus` | **Moved** (Swapped with MusicForProgramming) |
| **`super + x`** | **Excalidraw** | `pake-excalidraw` | **New** (Mnemonic E**x**calidraw / Ws 6) |
| **`super + alt + g`** | **Todoist** | `todoist` | **Moved** (Freed `super + g` for Gemini) |
| **`super + shift + i`** | **Dunst Test** | `test-noti` | **Moved** (Freed `super + i` for WhatsApp) |
| **`super + shift + b`** | **Bluetooth Manager** | `blueman-manager` | **Unchanged** |
| *`super + t`* | *Scratch Terminal* | `ghostty ...` | **Commented Out** (As requested) |
| *`super + c`* | *Battery Capacity* | `battery-capacity` | **Commented Out** (As requested) |

## Window Properties (Scratchpads)
The following applications will be registered as floating scratchpads with centered positions and a standard resolution size of `1680x900`:
*   `pake-chatgpt`
*   `pake-gemini`
*   `pake-whatsapp`
*   `pake-twitter`
*   `pake-youtubemusic`
*   `pake-programmusic`

## Workspace Routing (`assignments.json` & `workspaces.conf`)
*   **Workspace 5 (`$ws5` on DP-1)**:
    *   `pake-youtubemusic`
    *   `pake-programmusic`
*   **Workspace 6 (`$ws6` on DP-2)**:
    *   `pake-excalidraw`

---

## Detailed Component Changes

### 1. `sxhkd/.config/sxhkd/sxhkdrc`
*   Comment out `super + t` (scratch-terminal) and `super + c` (battery-capacity).
*   Add bindings for new apps and adjust re-mapped targets.
*   Update comments to align with the snake_case naming style.

### 2. `i3/.config/i3/scratchpads.conf`
*   Add standard size/floating constraints for new scratchpad applications using class selectors matching `pake-*`.

### 3. `i3/.config/i3/scripts/assignments.json`
*   Update `assignments.json` to assign classes `pake-youtubemusic`, `pake-programmusic` to Workspace 5, and `pake-excalidraw` to Workspace 6.

---

## Verification Plan

### Automated/Syntax Validation
1. Verify `sxhkdrc` configurations are valid.
2. Verify `assignments.json` has valid JSON format using `jq`.
3. Reload `sxhkd` via `super + Escape` (running `sxhkd-reload`).
4. Reload `i3` via `super + r`.

### Manual Checklist
*   Press `super + c` and confirm ChatGPT opens in a centered scratchpad.
*   Press `super + g` and confirm Gemini opens in a centered scratchpad.
*   Press `super + alt + g` and confirm Todoist opens.
*   Press `super + t` and confirm Twitter opens.
*   Press `super + i` and confirm WhatsApp opens.
*   Press `super + y` and confirm YouTube Music opens.
*   Press `super + shift + m` and confirm MusicForProgramming opens.
*   Press `super + ctrl + m` and confirm cmus opens.
*   Press `super + x` and confirm Excalidraw opens on Workspace 6.
