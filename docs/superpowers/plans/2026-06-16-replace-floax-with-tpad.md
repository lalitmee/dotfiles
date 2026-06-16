# Replace tmux-floax with tmux-tpad Scratchpad Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Replace the `tmux-floax` floating scratchpad with a custom `tmux-tpad` scratchpad instance accessible via `C-a C-d s`.

**Architecture:** We will clean up the `omerxx/tmux-floax` plugin declaration and settings from `tmux/.tmux.conf.local`. Then, we will configure a new named `tpad` instance `scratchpad` running the default shell, bind it inside the `dev-mode` key table, and update the corresponding help documentation tables.

**Tech Stack:** Tmux, Zsh

---

### Task 1: Remove tmux-floax Configuration

**Files:**
- Modify: [tmux/.tmux.conf.local](file:///home/lalitmee/dotfiles/tmux/.tmux.conf.local)

- [ ] **Step 1: Edit `tmux/.tmux.conf.local` to remove `tmux-floax`**

  Remove the entire block of code between lines 576 and 591 in `/home/lalitmee/dotfiles/tmux/.tmux.conf.local`:
  ```tmux
  # --- NOTE: Floax (Floating Panes) {{{
  #-------------------------------------------------------------------------------

  set -g @plugin 'omerxx/tmux-floax'

  set -g @floax-title 'scratchpad'

  # Set the keybinding to toggle a floating pane.
  set -g @floax-bind 'm'
  set -g @floax-width '90%'
  set -g @floax-height '90%'

  # Set the border color for floating panes.
  set -g @floax-border-color '#00AAFF'
  set -g @floax-text-color '#FFFFFF'

  #-------------------------------------------------------------------------------
  # }}}
  #-------------------------------------------------------------------------------
  ```

---

### Task 2: Configure the new tpad Scratchpad Instance

**Files:**
- Modify: [tmux/.tmux.conf.local](file:///home/lalitmee/dotfiles/tmux/.tmux.conf.local)

- [ ] **Step 1: Add `scratchpad` to the dynamic styling list**

  In `/home/lalitmee/dotfiles/tmux/.tmux.conf.local` around line 663 (within the `tpad` dynamic style loop), append `scratchpad` to the end of the loop list:
  ```tmux
    for inst in lazygit lazydocker gh-dash process-viewer grimoire \
                notes-personal notes-work todos-personal todos-work \
                daily-personal-todo daily-work-todo scratch-personal scratch-work \
                journal-personal journal-work search-notes backup-logs scratchpad; do
  ```

- [ ] **Step 2: Add instance options configuration**

  Add configuration for `@tpad-scratchpad-cmd` and `@tpad-scratchpad-title` below the grimoire section in `/home/lalitmee/dotfiles/tmux/.tmux.conf.local`:
  ```tmux
  set -g @tpad-scratchpad-cmd ""
  set -g @tpad-scratchpad-title " Scratchpad "
  ```

---

### Task 3: Bind the Scratchpad Key in Dev-Mode

**Files:**
- Modify: [tmux/.tmux.conf.local](file:///home/lalitmee/dotfiles/tmux/.tmux.conf.local)

- [ ] **Step 1: Add keybinding under dev-mode**

  In `/home/lalitmee/dotfiles/tmux/.tmux.conf.local` around line 1360 (inside the dev-mode keybindings block), add the following line:
  ```tmux
  bind -T dev-mode s run-shell "#{@tpad-path} toggle scratchpad"
  ```
  *(Note: We use `bind` instead of `bind-key` per formatting standard).*

---

### Task 4: Update Help Tables

**Files:**
- Modify: [tmux/.config/tmux/scripts/popup/help/tables/global.txt](file:///home/lalitmee/dotfiles/tmux/.config/tmux/scripts/popup/help/tables/global.txt)
- Modify: [tmux/.config/tmux/scripts/popup/help/tables/dev-mode.txt](file:///home/lalitmee/dotfiles/tmux/.config/tmux/scripts/popup/help/tables/dev-mode.txt)

- [ ] **Step 1: Update `global.txt`**

  In `/home/lalitmee/dotfiles/tmux/.config/tmux/scripts/popup/help/tables/global.txt`, remove line 9:
  ```text
  C-a C-	tmux-floax (floating pane)
  ```

- [ ] **Step 2: Update `dev-mode.txt`**

  In `/home/lalitmee/dotfiles/tmux/.config/tmux/scripts/popup/help/tables/dev-mode.txt`, add a line for `s` after `a` and before `q` (use tab character to align):
  ```text
  s	Scratchpad
  ```

---

### Task 5: Update AGENTS.md

**Files:**
- Modify: [AGENTS.md](file:///home/lalitmee/dotfiles/AGENTS.md)

- [ ] **Step 1: Document keybinding migration**

  Under the Tmux Configuration section in `/home/lalitmee/dotfiles/AGENTS.md`, document that `C-a m` has been removed and the scratchpad has been migrated to `C-a C-d s`.

---

### Task 6: Syntax Check & Verification

**Files:**
- None

- [ ] **Step 1: Validate tmux syntax**

  Run:
  ```bash
  tmux -f /home/lalitmee/dotfiles/tmux/.tmux.conf.local -c "echo 'valid'"
  ```
  Expected output: `valid` with no errors.

- [ ] **Step 2: Reload tmux configuration**

  Run:
  ```bash
  tmux source-file ~/.config/tmux/.tmux.conf
  ```
  Expected output: Reloads successfully without errors.

- [ ] **Step 3: Test new keybinding**

  In active tmux session, press `C-a C-d` followed by `s`.
  Verify: Floating scratchpad opens with `zsh` session and can be toggled closed using `C-a C-d s` again.
