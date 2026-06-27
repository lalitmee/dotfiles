# Brave ChatGPT PWA Scratchpad Integration Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Configure the ChatGPT Brave PWA (`super + c`) as a toggleable i3 scratchpad.

**Architecture:**
1. Update `sxhkdrc` to bind `super + c` to ChatGPT using its specific Brave PWA app-id `cadlkienfkclaiaibeoongdcgmdikeeg`.
2. Configure `scratchpads.conf` to float and size the ChatGPT PWA window.

**Tech Stack:** i3wm, sxhkd, i3run (i3ass).

## Global Constraints
- Do not commit or push changes without explicit user approval.
- Ask for confirmation before making any changes.
- After modifying any code, verify the syntax to ensure correctness and prevent regressions.

---

### Task 1: Update sxhkdrc Configuration

**Files:**
- Modify: [sxhkdrc](file:///home/lalitmee/dotfiles/sxhkd/.config/sxhkd/sxhkdrc#L316-L320)

- [ ] **Step 1: Add ChatGPT launcher to sxhkdrc**

  In [sxhkdrc](file:///home/lalitmee/dotfiles/sxhkd/.config/sxhkd/sxhkdrc), add the following section right below the Gemini launcher:
  ```
  # >> assistant -> chatgpt (brave pwa)
  super + c
      i3run --summon --instance crx_cadlkienfkclaiaibeoongdcgmdikeeg -- brave-browser --app-id=cadlkienfkclaiaibeoongdcgmdikeeg
  ```

- [ ] **Step 2: Verify the file diff**

  Run: `git diff sxhkd/.config/sxhkd/sxhkdrc`

- [ ] **Step 3: Commit changes**

  Ask the user for approval first, then run:
  ```bash
  git add sxhkd/.config/sxhkd/sxhkdrc
  git commit -m "feat(sxhkd): add chatgpt brave PWA scratchpad keybinding"
  ```

---

### Task 2: Update i3 scratchpads.conf Configuration

**Files:**
- Modify: [scratchpads.conf](file:///home/lalitmee/dotfiles/i3/.config/i3/scratchpads.conf#L30-L35)

- [ ] **Step 1: Add the window rule for Brave ChatGPT PWA**

  In [scratchpads.conf](file:///home/lalitmee/dotfiles/i3/.config/i3/scratchpads.conf), append:
  ```
  for_window [instance="crx_cadlkienfkclaiaibeoongdcgmdikeeg"] floating enable, resize set 1800 1000, move position center
  ```

- [ ] **Step 2: Verify the file diff**

  Run: `git diff i3/.config/i3/scratchpads.conf`

- [ ] **Step 3: Commit changes**

  Ask the user for approval first, then run:
  ```bash
  git add i3/.config/i3/scratchpads.conf
  git commit -m "feat(i3): map chatgpt brave PWA to floating scratchpad"
  ```

---

### Task 3: Reload and Verify

- [ ] **Step 1: Reload configurations**

  Run:
  ```bash
  i3-msg reload && pkill -USR1 -x sxhkd
  ```

- [ ] **Step 2: Test keybinding**

  Action: Press `super + c` to open ChatGPT.
  Expected: Brave ChatGPT PWA launches, floats, resizes to 1800x1000, and centers.
