# Pake Applications Integration Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Integrate the seven Pake applications into the i3 workspace routing and `sxhkd` hotkey system.

**Architecture:** Use `sxhkd` to define keyboard shortcuts that trigger `i3run --summon` for scratchpad behavior, configure i3 window manager rules to make the new windows floating and sized properly, and update the Python-based `i3-smart-assign` JSON configuration to route specific applications to their respective workspaces.

**Tech Stack:** i3wm, sxhkd, i3ass (i3run), JSON.

---

### Task 1: Update keybindings in `sxhkdrc`

**Files:**
- Modify: `sxhkd/.config/sxhkd/sxhkdrc`

- [ ] **Step 1: Edit sxhkdrc**
  Modify `/home/lalitmee/dotfiles/sxhkd/.config/sxhkd/sxhkdrc` to comment out `super + t` and `super + c` bindings, swap `cmus` with `MusicForProgramming` (Program Music), and add new bindings for Gemini, ChatGPT, WhatsApp, YouTube Music, and Excalidraw. Make sure all edits preserve existing fold markers (`{{{` and `}}}`) and indentation styling.
  
  Specific blocks to add/modify:
  
  For ChatGPT (`super + c`):
  ```ini
  # editor -> chatgpt
  super + c
      i3run --summon --class pake-chatgpt -- pake-chatgpt
  ```
  
  For Gemini (`super + g`):
  ```ini
  # >> assistant -> gemini
  super + g
      i3run --summon --class pake-gemini -- pake-gemini
  ```

  For Todoist (`super + alt + g`):
  ```ini
  # >> todo tracker -> todoist
  super + alt + g
      i3run --summon --instance todoist -- todoist
  ```
  
  For WhatsApp (`super + i`):
  ```ini
  # >> communication -> whatsapp
  super + i
      i3run --class pake-whatsapp --summon -- pake-whatsapp
  ```

  For Twitter (`super + t`):
  ```ini
  # >> social -> twitter
  super + t
      i3run --class pake-twitter --summon -- pake-twitter
  ```

  For YouTube Music (`super + y`):
  ```ini
  # >> music player -> youtube music
  super + y
      i3run --summon --class pake-youtubemusic -- pake-youtubemusic
  ```

  For MusicForProgramming (`super + shift + m`):
  ```ini
  # >> music player -> music for programming
  super + shift + m
      i3run --summon --class pake-programmusic -- pake-programmusic
  ```

  For cmus (`super + ctrl + m`):
  ```ini
  # >> terminal music player -> cmus
  super + ctrl + m
      i3run --summon --title terminal-music-player -- ghostty --title=terminal-music-player -e cmus
  ```

  For Excalidraw (`super + x`):
  ```ini
  # >> design -> excalidraw
  super + x
      i3run --summon --class pake-excalidraw -- pake-excalidraw
  ```

  For Dunst test notification (`super + shift + i`):
  ```ini
  # dunst
  super + shift + i
      test-noti
  ```

- [ ] **Step 2: Dry-run sxhkd reload**
  Run: `~/.config/bin/sxhkd-reload`
  Expected: Reload runs successfully without errors.

- [ ] **Step 3: Commit changes**
  ```bash
  git add sxhkd/.config/sxhkd/sxhkdrc
  git commit -m "feat(sxhkd): add keybindings for Pake applications and re-arrange media/social hotkeys"
  ```

---

### Task 2: Configure floating scratchpad window rules

**Files:**
- Modify: `i3/.config/i3/scratchpads.conf`

- [ ] **Step 1: Edit scratchpads.conf**
  Add the following lines to `/home/lalitmee/dotfiles/i3/.config/i3/scratchpads.conf`:
  ```ini
  for_window [class="(?i)pake-chatgpt"] floating enable, resize set 1680 900, move position center
  for_window [class="(?i)pake-gemini"] floating enable, resize set 1680 900, move position center
  for_window [class="(?i)pake-whatsapp"] floating enable, resize set 1680 900, move position center
  for_window [class="(?i)pake-twitter"] floating enable, resize set 1680 900, move position center
  for_window [class="(?i)pake-youtubemusic"] floating enable, resize set 1680 900, move position center
  for_window [class="(?i)pake-programmusic"] floating enable, resize set 1680 900, move position center
  ```

- [ ] **Step 2: Validate i3 configuration syntax**
  Run: `i3 -C`
  Expected: Output `Checking configuration file: .../i3/config: syntax OK`

- [ ] **Step 3: Commit changes**
  ```bash
  git add i3/.config/i3/scratchpads.conf
  git commit -m "feat(i3): add floating scratchpad window rules for Pake applications"
  ```

---

### Task 3: Map workspace assignments

**Files:**
- Modify: `i3/.config/i3/scripts/assignments.json`

- [ ] **Step 1: Edit assignments.json**
  Modify `/home/lalitmee/dotfiles/i3/.config/i3/scripts/assignments.json` to append:
  ```json
      "pake-youtubemusic": {
          "classes": ["pake-youtubemusic", "Pake-youtubemusic"],
          "workspace": "5"
      },
      "pake-programmusic": {
          "classes": ["pake-programmusic", "Pake-programmusic"],
          "workspace": "5"
      },
      "pake-excalidraw": {
          "classes": ["pake-excalidraw", "Pake-excalidraw"],
          "workspace": "6"
      }
  ```

- [ ] **Step 2: Validate JSON format**
  Run: `jq . i3/.config/i3/scripts/assignments.json`
  Expected: JSON parses correctly without syntax errors.

- [ ] **Step 3: Commit changes**
  ```bash
  git add i3/.config/i3/scripts/assignments.json
  git commit -m "feat(i3): map YouTube Music, MusicForProgramming, and Excalidraw to workspaces in assignments.json"
  ```
