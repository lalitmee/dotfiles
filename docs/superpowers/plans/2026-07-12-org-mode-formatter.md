# Org-Mode Formatting Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Configure visual indentation, native source block formatting, and table auto-alignment on save in Doom Emacs.

**Architecture:** Add helper function and settings inside `+org-second-brain.el` in the `(after! org ...)` block.

**Tech Stack:** Doom Emacs / Emacs Lisp

## Global Constraints

- Configuration changes must compile cleanly via `doom sync`.
- Save hooks must be buffer-local to target only Org buffers and avoid side-effects.

---

### Task 1: Add Formatter Configuration

**Files:**
- Modify: `doom-emacs/.config/doom/+org-second-brain.el`

**Interfaces:**
- Consumes: None
- Produces: Visual/code-block formatting settings and table auto-alignment hook on save.

- [ ] **Step 1: Read the existing `+org-second-brain.el`**
  Ensure we know the contents before editing.

- [ ] **Step 2: Add table alignment helper and formatting configuration**
  Add the following helper function at the top level of `doom-emacs/.config/doom/+org-second-brain.el` (e.g., right before the `(after! org ...)` block):
  ```elisp
  (defun my/org-align-tables-on-save ()
    "Align all tables in the buffer if in Org mode."
    (when (derived-mode-p 'org-mode)
      (org-table-map-tables 'org-table-align)))
  ```

  Inside the `(after! org ...)` block, append the formatting variables and register the local hook:
  ```elisp
    (setq org-startup-indented t)
    (setq org-src-tab-acts-natively t)
    (setq org-src-preserve-indentation nil)
    (add-hook 'org-mode-hook
              (lambda ()
                (add-hook 'before-save-hook #'my/org-align-tables-on-save nil 'local)))
  ```

- [ ] **Step 3: Commit the changes**
  Run:
  ```bash
  git add doom-emacs/.config/doom/+org-second-brain.el
  git commit -m "feat(org): configure visual indentation and save formatting"
  ```

---

### Task 2: Verify Configuration and Synchronization

**Files:**
- Modify: None
- Test: Manual verification in Emacs

- [ ] **Step 1: Synchronize Doom Emacs configuration**
  Run:
  ```bash
  ~/.config/emacs/bin/doom sync
  ```
  Expected: Clean execution without syntax errors.

- [ ] **Step 2: Verify visual indentation and native indentation**
  Open an Org-mode file.
  Press `TAB` inside a source code block, verify that it indents according to language-specific rules.
  Verify `org-indent-mode` is active.

- [ ] **Step 3: Verify table auto-alignment on save**
  Create a table with unaligned columns:
  ```org
  | Name | Age |
  |--|--|
  | John Doe | 30 |
  ```
  Save the file.
  Verify that the table automatically aligns to:
  ```org
  | Name     | Age |
  |----------+-----|
  | John Doe |  30 |
  ```
