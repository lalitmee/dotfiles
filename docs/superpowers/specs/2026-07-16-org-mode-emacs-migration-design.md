# Design Spec: Org-Mode Emacs Migration & Nvim Refactor

Date: 2026-07-16

## Purpose & Goals

Migrate the nvim-orgmode workflow to Doom Emacs org-mode by enhancing the existing `+org-second-brain.el`, while simultaneously refactoring the nvim `org-mode/init.lua` to eliminate dead weight discovered during the audit. Both configs should converge on the same streamlined workflow.

### What This Is NOT

- Not a clean-room rewrite of the emacs config — we build on the existing `+org-second-brain.el` foundation
- Not an org-roam deep-dive — roam stays as optional infrastructure until actively adopted
- Not a modular file split — single-file `+org-second-brain.el` is fine for a personal dotfiles config

## Scope

### Emacs Changes (enhance `+org-second-brain.el`)

- Add streamlined TODO keywords with cobalt2 faces
- Replace the single "b" inbox capture template with 5 capture groups (13 total sub-templates)
- Add custom agenda commands (Global, Work Focus, Personal Focus, Triage)
- Configure agenda span (14 days, Monday start)
- Add streamlined tag faces (9 tags, cobalt2 palette)
- Add `org-super-agenda` package for grouped views
- Leave org-roam, refile scoping, table auto-align, appearance settings as-is

### Nvim Changes (refactor `org-mode/init.lua`)

- Strip TODO keywords from 10 → 5
- Remove 3 capture template groups (Meeting, Phone, Link)
- Fix habit template bug (`NEXT` → `TODO`)
- Remove 2 unused custom agenda commands (In Progress, Blocked)
- Strip tag faces from 25+ → 9
- Remove `org_special_keyword_faces`
- Keep `org-super-agenda.nvim`, `org-roam.nvim`, `org-modern.nvim`, `org-bullets.nvim`, `org-list.nvim` as-is

## Architecture & Implementation Details

### 1. TODO Keywords & State Machine

Both editors will use the same 5-keyword pipeline:

```
BACKLOG(b) → TODO(t) → IN-PROGRESS(p) | → DONE(d) → CANCELLED(c)
```

#### Emacs (elisp)

```elisp
(setq org-todo-keywords
      '((sequence "BACKLOG(b)" "TODO(t)" "IN-PROGRESS(p)" "|" "DONE(d)" "CANCELLED(c)")))

(setq org-todo-keyword-faces
      '(("BACKLOG"     . (:foreground "#a8a8a8"))
        ("TODO"        . (:foreground "#0088ff" :weight bold))
        ("IN-PROGRESS" . (:foreground "#ffd700" :weight bold))
        ("DONE"        . (:foreground "#5fff5f" :weight bold))
        ("CANCELLED"   . (:foreground "#585858" :weight bold))))
```

#### Nvim (lua)

Strip `org_todo_keywords` to:

```lua
org_todo_keywords = {
    "BACKLOG(b)", "TODO(t)", "IN-PROGRESS(p)",
    "|",
    "DONE(d)", "CANCELLED(c)",
},
```

Strip `org_todo_keyword_faces` to only the 5 matching entries. Remove IN-REVIEW, TESTING, BLOCKED, WAITING, ON-HOLD, REJECTED faces.

### 2. Capture Templates

5 groups, each with personal/work sub-templates. Same structure in both editors.

#### Template Inventory

| Key | Group | Sub | Description | Tags | Target (Personal) | Target (Work) |
|-----|-------|-----|-------------|------|--------------------|----------------|
| `i` | 💡 Idea | `i` | Raw Idea | `:IDEA:RAW:` | `sandbox/ideas/inbox.org` | — |
| `i` | | `p` | Project | `:IDEA:PROJECT:` | `sandbox/ideas/project.org` | — |
| `i` | | `a` | Application | `:IDEA:APPLICATION:` | `sandbox/ideas/application.org` | — |
| `i` | | `n` | Neovim | `:IDEA:NEOVIM:` | `sandbox/ideas/neovim.org` | — |
| `i` | | `w` | Work | `:IDEA:WORK:` | — | `ideas/inbox.org` |
| `t` | 📋 Task | `p` | Personal | `:TASK:` | `daily/agenda/todos.org` | — |
| `t` | | `n` | Neovim | `:NEOVIM:TASK:` | `daily/agenda/todos.org` | — |
| `t` | | `w` | Work | `:TASK:WORK:` | — | `agenda/todos.org` |
| `n` | 📓 Note | `p` | Personal | `:NOTE:` | `brain/notes/system/inbox.org` | — |
| `n` | | `w` | Work | `:NOTE:WORK:` | — | `notes/inbox.org` |
| `j` | 📝 Journal | `p` | Personal | — | `daily/journal/inbox.org` | — |
| `j` | | `w` | Work | `:WORK:` | — | `journal/inbox.org` |
| `h` | ⚡ Habit | `p` | Personal | `:HABIT:` | `daily/agenda/habits.org` | — |
| `h` | | `w` | Work | `:HABIT:WORK:` | — | `agenda/habits.org` |

#### Emacs Implementation

Replace the existing single `"b"` template push with the full set. Use `expand-file-name` relative to the brain roots for portability:

```elisp
(setq org-capture-templates
      `(;; Ideas
        ("i" "💡 Idea")
        ("ii" "💡 Raw Idea" entry
         (file ,(expand-file-name "sandbox/ideas/inbox.org" my/org-second-brain-personal-root))
         "* %? :IDEA:RAW:" :empty-lines-before 1)
        ("ip" "🚀 Project" entry
         (file ,(expand-file-name "sandbox/ideas/project.org" my/org-second-brain-personal-root))
         "* %? :IDEA:PROJECT:" :empty-lines-before 1)
        ("ia" "💻 Application" entry
         (file ,(expand-file-name "sandbox/ideas/application.org" my/org-second-brain-personal-root))
         "* %? :IDEA:APPLICATION:" :empty-lines-before 1)
        ("in" "💤 Neovim" entry
         (file ,(expand-file-name "sandbox/ideas/neovim.org" my/org-second-brain-personal-root))
         "* %? :IDEA:NEOVIM:" :empty-lines-before 1)
        ("iw" "💼 Work" entry
         (file ,(expand-file-name "ideas/inbox.org" my/org-second-brain-work-root))
         "* %? :IDEA:WORK:" :empty-lines-before 1)

        ;; Tasks
        ("t" "📋 Task")
        ("tp" "🏠 Personal" entry
         (file ,(expand-file-name "daily/agenda/todos.org" my/org-second-brain-personal-root))
         "* TODO %? :TASK:\n  SCHEDULED: %U DEADLINE: %t" :empty-lines-before 1)
        ("tn" "💤 Neovim" entry
         (file ,(expand-file-name "daily/agenda/todos.org" my/org-second-brain-personal-root))
         "* TODO %? :NEOVIM:TASK:\n  SCHEDULED: %U DEADLINE: %t" :empty-lines-before 1)
        ("tw" "💼 Work" entry
         (file ,(expand-file-name "agenda/todos.org" my/org-second-brain-work-root))
         "* TODO %? :TASK:WORK:\n  SCHEDULED: %U DEADLINE: %t" :empty-lines-before 1)

        ;; Notes
        ("n" "📓 Note")
        ("np" "🏠 Personal" entry
         (file ,(expand-file-name "brain/notes/system/inbox.org" my/org-second-brain-personal-root))
         "* %^{Title} :NOTE:\n  %U\n\n%?" :empty-lines-before 1)
        ("nw" "💼 Work" entry
         (file ,(expand-file-name "notes/inbox.org" my/org-second-brain-work-root))
         "* %^{Title} :NOTE:WORK:\n  %U\n\n%?" :empty-lines-before 1)

        ;; Journal
        ("j" "📝 Journal")
        ("jp" "🏠 Personal" entry
         (file+olp+datetree ,(expand-file-name "daily/journal/inbox.org" my/org-second-brain-personal-root))
         "**** [%<%I:%M %p>] %?" :tree-type day)
        ("jw" "💼 Work" entry
         (file+olp+datetree ,(expand-file-name "journal/inbox.org" my/org-second-brain-work-root))
         "**** [%<%I:%M %p>] %? :WORK:" :tree-type day)

        ;; Habits
        ("h" "⚡ Habit")
        ("hp" "🏠 Personal" entry
         (file ,(expand-file-name "daily/agenda/habits.org" my/org-second-brain-personal-root))
         "* TODO %? :HABIT:\n  SCHEDULED: %t\n  :PROPERTIES:\n  :STYLE: habit\n  :REPEAT_TO_STATE: TODO\n  :END:" :empty-lines-before 1)
        ("hw" "💼 Work" entry
         (file ,(expand-file-name "agenda/habits.org" my/org-second-brain-work-root))
          "* TODO %? :HABIT:WORK:\n  SCHEDULED: %t\n  :PROPERTIES:\n  :STYLE: habit\n  :REPEAT_TO_STATE: TODO\n  :END:" :empty-lines-before 1)

        ;; Quick inbox — used by SPC n B c/W/P shortcuts
        ("b" "📥 Inbox (second-brain)" entry
         (file my/org-second-brain-capture-inbox-file)
         "* %?\n%U\n" :empty-lines-before 1)))
```

> [!IMPORTANT]
> The `"b"` quick-inbox template is preserved at the end of the list because the existing `my/org-second-brain-capture-generic` / `capture-work` / `capture-personal` functions (and their `SPC n B c/W/P` keybindings) call `(org-capture nil "b")`. The full capture menu (`SPC x`) now shows all 5 groups as the primary entry point, while `SPC n B c/W/P` remains as a fast brain-aware inbox shortcut.

#### Nvim Changes

- Remove `m` (Meeting), `p` (Phone Call), `l` (Link) capture template groups from `org_capture_templates`
- Fix habit template: `"* NEXT %?"` → `"* TODO %?"` and `REPEAT_TO_STATE: NEXT` → `REPEAT_TO_STATE: TODO`
- Fix journal work template: target changes to `~/Projects/Work/Github/second-brain/journal/inbox.org`

### 3. Custom Agenda Commands

#### Emacs

```elisp
(setq org-agenda-custom-commands
      `(("A" "📅 Agenda & All Tasks (Global)"
         ((agenda "")
          (alltodo "")))
        ("w" "💼 Work Focus"
         ((agenda "" ((org-agenda-files (my/org-second-brain-agenda-files :work))))
          (alltodo "" ((org-agenda-files (my/org-second-brain-agenda-files :work))))))
        ("p" "🏠 Personal Focus"
         ((agenda "" ((org-agenda-files (my/org-second-brain-agenda-files :personal))))
          (alltodo "" ((org-agenda-files (my/org-second-brain-agenda-files :personal))))))
        ("T" "📋 Triage / Backlog"
         ((todo "BACKLOG")))))
```

#### Agenda Settings (Emacs)

```elisp
(setq org-agenda-span 14)
(setq org-agenda-start-on-weekday 1) ;; Monday
```

#### Nvim Changes

Remove `i` (In Progress View) and `b` (Blocked / Waiting) from `org_agenda_custom_commands`. Keep `A`, `w`, `p`, `T`.

Update `T` (Triage) — it currently matches `BACKLOG` which is still valid.

### 4. Tag Faces

9 tags with cobalt2 palette. Both editors use the same set.

#### Emacs

```elisp
(setq org-tag-faces
      '(("IDEA"        . (:foreground "#ffc600" :weight bold))
        ("RAW"         . (:foreground "#af87ff" :slant italic))
        ("PROJECT"     . (:foreground "#ffc600"))
        ("APPLICATION" . (:foreground "#ffc600"))
        ("TASK"        . (:foreground "#0088ff"))
        ("NOTE"        . (:foreground "#9effff" :slant italic))
        ("HABIT"       . (:foreground "#ff9d00"))
        ("WORK"        . (:foreground "#a5ff90"))
        ("NEOVIM"      . (:foreground "#a5ff90" :weight bold))))
```

#### Nvim Changes

Strip `org_tag_faces` to only these 9 entries. Remove all "BY EVENT", "MANUAL DEV TAGS", "MANUAL PRIORITY TAGS" sections. Remove `org_special_keyword_faces` entirely.

### 5. Appearance & UI

**No changes needed.** Both editors already have working appearance configs:

- Emacs: `org-modern` stars, ellipsis, indentation, inline images, table auto-align — all in place
- Nvim: `org-bullets.nvim`, `org-modern.nvim` — stays as-is

### 6. Org-Super-Agenda

#### Emacs

Add to `packages.el`:

```elisp
(package! org-super-agenda)
```

Add to `+org-second-brain.el`:

```elisp
(use-package! org-super-agenda
  :after org-agenda
  :config
  (org-super-agenda-mode)
  (setq org-super-agenda-groups
        '((:name "🔥 In Progress" :todo "IN-PROGRESS" :order 1)
          (:name "📋 Today" :time-grid t :scheduled today :order 2)
          (:name "📅 Upcoming" :deadline future :scheduled future :order 3)
          (:name "⚡ Habits" :habit t :order 4)
          (:name "📥 Backlog" :todo "BACKLOG" :order 5)
          (:name "✅ Done" :todo "DONE" :order 10)
          (:name "❌ Cancelled" :todo "CANCELLED" :order 11))))
```

#### Nvim

No changes — `org-super-agenda.nvim` stays as-is.

### 7. Org-Roam

**No changes in either editor.** Left as optional infrastructure:

- Emacs: Per-brain roam dirs already configured, keybindings present at `SPC n B r/R`
- Nvim: `org-roam.nvim` pointed at `~/Projects/Personal/Github/notes` — divergent path noted but left as-is until org-roam is actively adopted

## Files Modified

### Emacs

| File | Change |
|------|--------|
| `doom-emacs/.config/doom/+org-second-brain.el` | Add TODO keywords, capture templates, agenda commands, agenda settings, tag faces, org-super-agenda config |
| `doom-emacs/.config/doom/packages.el` | Add `(package! org-super-agenda)` |

### Nvim

| File | Change |
|------|--------|
| `nvim/.config/nvim/lua/plugins/org-mode/init.lua` | Strip TODO keywords (10→5), remove 3 capture groups, fix habit bug, remove 2 agenda commands, strip tag faces (25+→9), remove special keyword faces |

## Verification & Testing Plan

### Emacs

1. Run `doom sync` — must complete without errors
2. Open emacs, press `SPC x` — capture menu should show 5 groups (i/t/n/j/h)
3. Capture a task with `SPC x t p` — should create entry in `daily/agenda/todos.org` with `TODO` keyword and `:TASK:` tag
4. Open agenda with `SPC n B a` — should show 14-day span starting Monday
5. Verify custom agenda dispatch: `M-x org-agenda` then `A`/`w`/`p`/`T` — each should filter correctly
6. Verify tag faces: open a file with tagged headings, confirm cobalt2 colors render
7. Verify org-super-agenda grouping: agenda view should group by In Progress/Today/Upcoming/etc.

### Nvim

1. Open nvim, press `<leader>oa` — agenda should load without errors
2. Press `<leader>oc` — capture menu should show 5 groups (no Meeting/Phone/Link)
3. Capture a habit with `<leader>oc h p` — template should use `TODO` not `NEXT`
4. Verify `<leader>o.` (super-agenda) still works
5. Check that removed custom agenda keys (`i`, `b`) no longer appear in agenda dispatch
