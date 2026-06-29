# Remove ~/.oh-my-zsh Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Remove the obsolete `~/.oh-my-zsh` folder and variables from Zsh configurations and installer scripts, relocating Znap to `~/.znap/znap`.

**Architecture:** Update variables in configuration files, adjust the installer script, delete the old directory, and trigger the Znap clean bootstrap by spawning a fresh shell.

**Tech Stack:** Zsh, Znap

## Global Constraints
- Do not commit or push changes without explicit user approval.
- Ask for confirmation before editing project files.
- Verify syntax of modified shell scripts using `zsh -n` to prevent regressions.

---

### Task 1: Configuration Updates

**Files:**
- Modify: `zsh/.zshenv`
- Modify: `zsh/.zshrc`
- Modify: `zsh/.zsh_aliases`

**Interfaces:**
- Consumes: None
- Produces: Updated configuration references pointing to `~/.znap/znap`.

- [ ] **Step 1: Modify `zsh/.zshenv`**
  Remove `export ZSH="$HOME/.oh-my-zsh"` from `zsh/.zshenv` (line 39).
  ```zsh
  # Before:
  export ZSH="$HOME/.oh-my-zsh"
  export LANG="en_US.UTF-8"

  # After:
  export LANG="en_US.UTF-8"
  ```

- [ ] **Step 2: Verify `zsh/.zshenv` syntax**
  Run: `zsh -n zsh/.zshenv`
  Expected: Success (no output/errors)

- [ ] **Step 3: Modify `zsh/.zshrc`**
  Update `ZNAP_DIR` path in `zsh/.zshrc` (line 34) to use `~/.znap/znap`.
  ```zsh
  # Before:
  ZNAP_DIR=~/.oh-my-zsh/custom/plugins/znap

  # After:
  ZNAP_DIR=~/.znap/znap
  ```

- [ ] **Step 4: Verify `zsh/.zshrc` syntax**
  Run: `zsh -n zsh/.zshrc`
  Expected: Success (no output/errors)

- [ ] **Step 5: Modify `zsh/.zsh_aliases`**
  Remove the commented-out `ohmyzsh` alias from `zsh/.zsh_aliases` (line 10).
  ```zsh
  # Before:
  # alias ohmyzsh="mate ~/.oh-my-zsh"

  # After:
  # (Line is completely deleted)
  ```

- [ ] **Step 6: Verify `zsh/.zsh_aliases` syntax**
  Run: `zsh -n zsh/.zsh_aliases`
  Expected: Success (no output/errors)

- [ ] **Step 7: Stage updates**
  Run: `git add zsh/.zshenv zsh/.zshrc zsh/.zsh_aliases`

---

### Task 2: Installer Script Updates

**Files:**
- Modify: `scripts/install/phases/03-system-foundation.zsh`

**Interfaces:**
- Consumes: None
- Produces: Updated system foundation installer that pre-clones Znap into the new location.

- [ ] **Step 1: Modify `03-system-foundation.zsh`**
  Remove lines 39-50 (Oh My Zsh installation and Powerlevel10k theme cloning). In their place, add a command to clone Znap directly into `~/.znap/znap`.
  ```zsh
  # Before:
  # Install oh-my-zsh (zsh framework)
  execute_command \
      "sh -c \"\$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)\" \"\" --unattended" \
      "oh-my-zsh installed successfully." \
      "Failed to install oh-my-zsh."

  # Install powerlevel10k theme
  execute_command \
      "git clone --depth=1 https://github.com/romkatv/powerlevel10k.git \${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k" \
      "Powerlevel10k theme installed successfully." \
      "Failed to install Powerlevel10k."

  # After:
  # Install Znap (Zsh plugin manager)
  execute_command \
      "git clone --depth 1 https://github.com/marlonrichert/zsh-snap.git ~/.znap/znap" \
      "Znap plugin manager installed successfully." \
      "Failed to install Znap."
  ```

- [ ] **Step 2: Verify `03-system-foundation.zsh` syntax**
  Run: `zsh -n scripts/install/phases/03-system-foundation.zsh`
  Expected: Success (no output/errors)

- [ ] **Step 3: Stage updates**
  Run: `git add scripts/install/phases/03-system-foundation.zsh`

---

### Task 3: Migration Execution & Cleanup

**Files:** None (commands only)

**Interfaces:**
- Consumes: Task 1 and Task 2 changes.
- Produces: Cleaned home directory and successfully bootstrapped `~/.znap` plugins cache.

- [ ] **Step 1: Delete old `~/.oh-my-zsh` directory**
  Run: `rm -rf ~/.oh-my-zsh`

- [ ] **Step 2: Trigger bootstrap by replacement**
  Run: `exec zsh`
  Expected: Zsh starts and downloads Znap + plugins cleanly into `~/.znap`.

- [ ] **Step 3: Verify plugin installation**
  Run: `ls -la ~/.znap` and `ls -la ~/.znap/repos`
  Expected: Znap repository and folders for autosuggestions, fzf-tab, zsh-vi-mode, and fast-syntax-highlighting exist.
