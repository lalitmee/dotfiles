# Brave YouTube Music PWA Scratchpad Integration Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Configure the Brave YouTube Music PWA as a toggleable i3 scratchpad bound to `super + y`.

**Architecture:** Update `sxhkdrc` to summon the PWA via Brave by instance ID, and configure `scratchpads.conf` to float and size the window matching that instance ID.

**Tech Stack:** i3wm, sxhkd, i3run (i3ass).

---

### Task 1: Update sxhkdrc Configuration

**Files:**
- Modify: `sxhkd/.config/sxhkd/sxhkdrc:312-315`

- [ ] **Step 1: Replace pake-youtubemusic launcher with Brave PWA launcher**

  Replace:
  ```
  # >> music player -> youtube music
  super + y
      i3run --summon --instance pake-youtubemusic -- pake-youtubemusic
  ```
  With:
  ```
  # >> music player -> youtube music (brave pwa)
  super + y
      i3run --summon --instance crx_cinhimbnkkaeohfgghhklpknlkffjgod -- brave-browser --app-id=cinhimbnkkaeohfgghhklpknlkffjgod
  ```

- [ ] **Step 2: Verify the file diff**

  Run: `git diff sxhkd/.config/sxhkd/sxhkdrc`
  Expected:
  ```diff
  -# >> music player -> youtube music
  -super + y
  -    i3run --summon --instance pake-youtubemusic -- pake-youtubemusic
  +# >> music player -> youtube music (brave pwa)
  +super + y
  +    i3run --summon --instance crx_cinhimbnkkaeohfgghhklpknlkffjgod -- brave-browser --app-id=cinhimbnkkaeohfgghhklpknlkffjgod
  ```

- [ ] **Step 3: Commit changes**

  Run:
  ```bash
  git add sxhkd/.config/sxhkd/sxhkdrc
  git commit -m "feat(sxhkd): replace pake-youtubemusic with brave PWA launcher"
  ```

---

### Task 2: Update i3 scratchpads.conf Configuration

**Files:**
- Modify: `i3/.config/i3/scratchpads.conf:32-32`

- [ ] **Step 1: Replace the window rule for pake-youtubemusic with Brave PWA rule**

  Replace:
  ```
  for_window [class="(?i)pake-youtubemusic"] floating enable, resize set 1800 1000, move position center
  ```
  With:
  ```
  for_window [instance="crx_cinhimbnkkaeohfgghhklpknlkffjgod"] floating enable, resize set 1800 1000, move position center
  ```

- [ ] **Step 2: Verify file diff**

  Run: `git diff i3/.config/i3/scratchpads.conf`
  Expected:
  ```diff
  -for_window [class="(?i)pake-youtubemusic"] floating enable, resize set 1800 1000, move position center
  +for_window [instance="crx_cinhimbnkkaeohfgghhklpknlkffjgod"] floating enable, resize set 1800 1000, move position center
  ```

- [ ] **Step 3: Commit changes**

  Run:
  ```bash
  git add i3/.config/i3/scratchpads.conf
  git commit -m "feat(i3): map brave PWA to floating scratchpad rule"
  ```

---

### Task 3: Reload Configurations and Verify

- [ ] **Step 1: Reload i3 and sxhkd configurations**

  Run:
  ```bash
  i3-msg reload && pkill -USR1 -x sxhkd
  ```
  Expected:
  `[{"success":true}]` for i3, and sxhkd reloads keybindings.

- [ ] **Step 2: Verify sxhkd daemon is still running**

  Run: `pgrep sxhkd`
  Expected: Returns process ID of `sxhkd`.

- [ ] **Step 3: Test keybinding**

  Action: Press `super + y` to open YouTube Music.
  Expected: Brave YouTube Music PWA launches, floats, resizes to 1800x1000, and centers.
