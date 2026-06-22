# Pake Applications Scratchpad Debugging Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Fix the scratchpad toggling and workspace routing issues for the new Pake applications and Spotify.

**Architecture:** 
1. Convert all `sxhkdrc` entries to use case-correct `--instance` selectors instead of `--class` for matching Pake applications, resolving case-sensitivity issues with `i3run` matching.
2. Remove `spotify`, `pake-youtubemusic`, and `pake-programmusic` from the `assignments.json` workspace routing configurations to allow scratchpads to open on the active workspace rather than being forced to Workspace 5.

**Tech Stack:** i3wm, sxhkd, i3run (i3ass), JSON.

---

### Task 1: Update `sxhkdrc` selectors to use `--instance`

**Files:**
- Modify: `sxhkd/.config/sxhkd/sxhkdrc`

- [ ] **Step 1: Edit sxhkdrc**
  Modify `/home/lalitmee/dotfiles/sxhkd/.config/sxhkd/sxhkdrc` to replace `--class` with `--instance` for all Pake applications:
  
  Specific remapping replacements:
  - ChatGPT:
    ```diff
    -    i3run --summon --class pake-chatgpt -- pake-chatgpt
    +    i3run --summon --instance pake-chatgpt -- pake-chatgpt
    ```
  - Gemini:
    ```diff
    -    i3run --summon --class pake-gemini -- pake-gemini
    +    i3run --summon --instance pake-gemini -- pake-gemini
    ```
  - WhatsApp:
    ```diff
    -    i3run --summon --class pake-whatsapp -- pake-whatsapp
    +    i3run --summon --instance pake-whatsapp -- pake-whatsapp
    ```
  - Twitter:
    ```diff
    -    i3run --summon --class pake-twitter -- pake-twitter
    +    i3run --summon --instance pake-twitter -- pake-twitter
    ```
  - YouTube Music:
    ```diff
    -    i3run --summon --class pake-youtubemusic -- pake-youtubemusic
    +    i3run --summon --instance pake-youtubemusic -- pake-youtubemusic
    ```
  - MusicForProgramming:
    ```diff
    -    i3run --summon --class pake-programmusic -- pake-programmusic
    +    i3run --summon --instance pake-programmusic -- pake-programmusic
    ```
  - Excalidraw:
    ```diff
    -    i3run --summon --class pake-excalidraw -- pake-excalidraw
    +    i3run --summon --instance pake-excalidraw -- pake-excalidraw
    ```

- [ ] **Step 2: Reload sxhkd configuration**
  Run: `~/.config/bin/sxhkd-reload`
  Expected: Reload runs successfully without errors.

- [ ] **Step 3: Commit sxhkdrc changes**
  ```bash
  git add sxhkd/.config/sxhkd/sxhkdrc
  git commit -m "fix(sxhkd): use case-correct --instance selectors for Pake applications to enable toggling"
  ```

---

### Task 2: Remove scratchpads from `assignments.json`

**Files:**
- Modify: `i3/.config/i3/scripts/assignments.json`

- [ ] **Step 1: Edit assignments.json**
  Modify `/home/lalitmee/dotfiles/i3/.config/i3/scripts/assignments.json` to remove the `spotify`, `pake-youtubemusic`, and `pake-programmusic` mappings. The `pake-excalidraw` workspace mapping must be retained.
  
  Target file contents after deletion:
  ```json
  {
      "slack": {
          "classes": ["slack", "Slack"],
          "workspace": "1"
      },
      "brave-browser": {
          "classes": ["brave-browser", "Brave-browser"],
          "workspace": "2"
      },
      "ghostty": {
          "classes": ["ghostty", "com.mitchellh.ghostty"],
          "workspace": "3"
      },
      "vivaldi": {
          "classes": ["vivaldi-stable", "Vivaldi-stable"],
          "workspace": "4"
      },
      "pake-excalidraw": {
          "classes": ["pake-excalidraw", "Pake-excalidraw"],
          "workspace": "6"
      }
  }
  ```

- [ ] **Step 2: Validate JSON format**
  Run: `jq . i3/.config/i3/scripts/assignments.json`
  Expected: Output displays valid formatted JSON.

- [ ] **Step 3: Commit assignments.json changes**
  ```bash
  git add i3/.config/i3/scripts/assignments.json
  git commit -m "fix(i3): remove music scratchpads from assignments.json so they launch on active workspace"
  ```

---

### Task 3: Reload and Verify

- [ ] **Step 1: Reload i3**
  Run: `i3-msg reload`
  Expected: Success output from i3-msg.

- [ ] **Step 2: Manual scratchpad validation**
  - Verify toggling (show/hide) works by pressing the key binding twice (e.g. `super + c` for ChatGPT).
  - Verify that scratchpads (e.g. Spotify, YouTube Music, MusicForProgramming) launch on the workspace where they were triggered instead of always routing to Workspace 5.
