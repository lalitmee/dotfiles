# Design Spec: Org-Mode Formatting in Doom Emacs
Date: 2026-07-12

## Purpose & Goals
Configure automatic and on-demand formatting settings for Org-mode buffers within a Doom Emacs environment. The solution must ensure structural cleanliness (via visual indentation and native code-block indentation) and automatic layout correction (via table auto-alignment on save).

## Scope
- Modifying `$DOOMDIR/+org-second-brain.el` to append the formatting settings.
- Restricting table auto-alignment to Org-mode buffers locally to prevent performance issues in unrelated major modes.

## Architecture & Implementation Details

### Target File
- `/home/lalitmee/dotfiles/doom-emacs/.config/doom/+org-second-brain.el`

### 1. Helper Function
Define `my/org-align-tables-on-save` at the top level of the file:
```elisp
(defun my/org-align-tables-on-save ()
  "Align all tables in the buffer if in Org mode."
  (when (derived-mode-p 'org-mode)
    (org-table-map-tables 'org-table-align)))
```

### 2. Configuration Settings
Inside the `(after! org ...)` block, set the following:
- `org-startup-indented` to `t` for visual indentation.
- `org-src-tab-acts-natively` to `t` for code block formatting.
- `org-src-preserve-indentation` to `nil` to allow normal code blocks indent.
- Register `my/org-align-tables-on-save` locally to `before-save-hook` inside `org-mode-hook`:
```elisp
(add-hook 'org-mode-hook
          (lambda ()
            (add-hook 'before-save-hook #'my/org-align-tables-on-save nil 'local)))
```

## Verification & Testing Plan
- Run `doom sync` to ensure configuration compiles correctly.
- Open an Org-mode file, create an unaligned table, edit it, and save the buffer to verify table auto-alignment.
- Verify `org-indent-mode` is activated visually.
- Verify pressing `TAB` inside a source block indents code natively.
