# Org-Mode Emacs Migration & Nvim Refactor — Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Port the streamlined nvim-orgmode workflow to Doom Emacs and simultaneously refactor the nvim config to remove dead weight, producing two aligned configs.

**Architecture:** Enhance the existing `+org-second-brain.el` by adding TODO keywords, capture templates, agenda commands, tag faces, and org-super-agenda. Refactor `org-mode/init.lua` by stripping unused keywords, captures, agenda commands, and tag faces. Both editors converge on the same 5-keyword, 5-capture-group, 9-tag workflow.

**Tech Stack:** Doom Emacs (elisp), Neovim (Lua, nvim-orgmode plugin), org-super-agenda (emacs package)

## Global Constraints

- Emacs config location: `~/dotfiles/doom-emacs/.config/doom/`
- Nvim config location: `~/dotfiles/nvim/.config/nvim/lua/plugins/org-mode/`
- Personal brain root: `~/Projects/Personal/Github/second-brain`
- Work brain root: `~/Projects/Work/Github/second-brain`
- Color palette: cobalt2
- Do NOT auto-commit — ask user first
- After emacs changes, run `doom sync` to verify
- After nvim changes, open nvim and verify org loads without errors

---

### Task 1: Nvim — Streamline TODO Keywords & Faces

**Files:**
- Modify: `nvim/.config/nvim/lua/plugins/org-mode/init.lua:142-182`

**Interfaces:**
- Consumes: nothing
- Produces: streamlined 5-keyword config that Task 2 (agenda commands) depends on

- [ ] **Step 1: Replace the `org_todo_keywords` block**

Replace lines 142-164 with:

```lua
            org_todo_keywords = {
                "BACKLOG(b)",
                "TODO(t)",
                "IN-PROGRESS(p)",
                "|",
                "DONE(d)",
                "CANCELLED(c)",
            },
```

- [ ] **Step 2: Replace the `org_todo_keyword_faces` block**

Replace lines 166-182 with:

```lua
            org_todo_keyword_faces = {
                BACKLOG = ":foreground #a8a8a8",
                TODO = ":foreground #0088ff :weight bold",
                ["IN-PROGRESS"] = ":foreground #ffd700 :weight bold",
                DONE = ":foreground #5fff5f :weight bold",
                CANCELLED = ":foreground #585858 :weight bold",
            },
```

- [ ] **Step 3: Verify in nvim**

Open nvim and run `:lua print(vim.inspect(require("orgmode").config:get_todo_keywords():keys()))` — should list only the 5 keywords.

Open any `.org` file and press `C-c C-t` — the TODO state picker should show only: BACKLOG, TODO, IN-PROGRESS, DONE, CANCELLED.

---

### Task 2: Nvim — Streamline Agenda Commands, Tag Faces & Special Faces

**Files:**
- Modify: `nvim/.config/nvim/lua/plugins/org-mode/init.lua:87-249`

**Interfaces:**
- Consumes: Task 1's streamlined keywords
- Produces: cleaned agenda/tag config

- [ ] **Step 1: Remove unused agenda commands**

Remove the `i` (In Progress View, lines 128-133) and `b` (Blocked / Waiting, lines 134-139) entries from `org_agenda_custom_commands`. Keep `A`, `w`, `p`, `T`.

The resulting `org_agenda_custom_commands` should be:

```lua
            org_agenda_custom_commands = {
                A = {
                    description = "📅 Agenda & All Tasks (Global)",
                    types = {
                        { type = "agenda" },
                        { type = "tags_todo" },
                    },
                },
                w = {
                    description = "💼 Work Focus",
                    types = {
                        {
                            type = "agenda",
                            org_agenda_files = { "~/Projects/Work/Github/second-brain/**/*" },
                        },
                        {
                            type = "tags_todo",
                            org_agenda_files = { "~/Projects/Work/Github/second-brain/**/*" },
                        },
                    },
                },
                p = {
                    description = "🏠 Personal Focus",
                    types = {
                        {
                            type = "agenda",
                            org_agenda_files = { "~/Projects/Personal/Github/second-brain/**/*" },
                        },
                        {
                            type = "tags_todo",
                            org_agenda_files = { "~/Projects/Personal/Github/second-brain/**/*" },
                        },
                    },
                },
                T = {
                    description = "📋 Triage / Planning",
                    types = {
                        { type = "tags_todo", match = "BACKLOG" },
                    },
                },
            },
```

- [ ] **Step 2: Replace `org_tag_faces` with streamlined 9-tag set**

Replace lines 184-243 with:

```lua
            org_tag_faces = {
                -- By type
                IDEA = ":foreground #ffc600 :weight bold",
                RAW = ":foreground #af87ff :slant italic",
                PROJECT = ":foreground #ffc600",
                APPLICATION = ":foreground #ffc600",
                TASK = ":foreground #0088ff",
                NOTE = ":foreground #9effff :slant italic",
                HABIT = ":foreground #ff9d00",
                -- By context
                WORK = ":foreground #a5ff90",
                NEOVIM = ":foreground #a5ff90 :weight bold",
            },
```

- [ ] **Step 3: Remove `org_special_keyword_faces`**

Delete lines 245-249 entirely:

```lua
            org_special_keyword_faces = {
                SCHEDULED = ":foreground #8a8a8a",
                DEADLINE = ":foreground #8a8a8a",
                CLOSED = ":foreground #8a8a8a",
            },
```

- [ ] **Step 4: Verify in nvim**

Open nvim, run `<leader>oa` — agenda should load. Press the dispatch key and verify only `A`, `w`, `p`, `T` appear (no `i` or `b`).

Open an `.org` file with tags — verify cobalt2 colors render for the 9 surviving tags.

---

### Task 3: Nvim — Remove Unused Capture Templates & Fix Habit Bug

**Files:**
- Modify: `nvim/.config/nvim/lua/plugins/org-mode/init.lua` (capture templates section — originally lines 251-415, but line numbers will have shifted after Tasks 1-2 modify earlier sections of the same file. Search for `org_capture_templates` to locate.)

**Interfaces:**
- Consumes: Task 1's keywords (habits now use `TODO` not `NEXT`)
- Produces: cleaned capture config with 5 groups

- [ ] **Step 1: Remove Meeting capture group**

Delete lines 350-366 (the `m` Meeting group):

```lua
                m = {
                    description = "🤝 Meeting",
                    subtemplates = {
                        p = {
                            description = "🏠 Personal",
                            template = "* MEETING with %? :MEETING:\n  SCHEDULED: %t",
                            target = "~/Projects/Personal/Github/second-brain/daily/agenda/calls.org",
                            properties = { empty_lines = { before = 1 } },
                        },
                        w = {
                            description = "💼 Work",
                            template = "* MEETING with %? :MEETING:WORK:\n  SCHEDULED: %t",
                            target = "~/Projects/Work/Github/second-brain/agenda/calls.org",
                            properties = { empty_lines = { before = 1 } },
                        },
                    },
                },
```

- [ ] **Step 2: Remove Phone Call capture group**

Delete lines 368-384 (the `p` Phone Call group):

```lua
                p = {
                    description = "📞 Phone Call",
                    subtemplates = {
                        p = {
                            description = "🏠 Personal",
                            template = "* CALL with %? :PHONE:\n  SCHEDULED: %t",
                            target = "~/Projects/Personal/Github/second-brain/daily/agenda/calls.org",
                            properties = { empty_lines = { before = 1 } },
                        },
                        w = {
                            description = "💼 Work",
                            template = "* CALL with %? :PHONE:WORK:\n  SCHEDULED: %t",
                            target = "~/Projects/Work/Github/second-brain/agenda/calls.org",
                            properties = { empty_lines = { before = 1 } },
                        },
                    },
                },
```

- [ ] **Step 3: Remove Link capture group**

Delete lines 404-414 (the `l` Link group):

```lua
                l = {
                    description = "🔗 Link",
                    subtemplates = {
                        r = {
                            description = "🔗 Useful resource links",
                            template = "  - [[%^{Link||}][%^{Description}]] :LINK:",
                            headline = "Useful resource links",
                            target = "~/Projects/Personal/Github/second-brain/brain/vocabulary/links.org",
                        },
                    },
                },
```

- [ ] **Step 4: Fix habit templates — change `NEXT` → `TODO`**

In the `h` Habit group, update both personal and work templates:

Personal template — change from:

```lua
                            template = "* NEXT %? :HABIT:\n  SCHEDULED: %t\n  :PROPERTIES:\n  :STYLE: habit\n  :REPEAT_TO_STATE: NEXT\n  :END:",
```

To:

```lua
                            template = "* TODO %? :HABIT:\n  SCHEDULED: %t\n  :PROPERTIES:\n  :STYLE: habit\n  :REPEAT_TO_STATE: TODO\n  :END:",
```

Work template — same change: `NEXT` → `TODO` in both the headline and `REPEAT_TO_STATE`.

- [ ] **Step 5: Fix journal work template — separate from personal**

In the `j` Journal group, update the work sub-template target. Change from:

```lua
                        w = {
                            description = "💼 Work",
                            target = "~/Projects/Personal/Github/second-brain/daily/journal/inbox.org",
                            template = "**** [%<%I:%M %p>] %? :WORK:",
                            datetree = { tree_type = "day", reversed = true },
                            properties = { empty_lines = { before = 1 } },
                        },
```

To:

```lua
                        w = {
                            description = "💼 Work",
                            target = "~/Projects/Work/Github/second-brain/journal/inbox.org",
                            template = "**** [%<%I:%M %p>] %? :WORK:",
                            datetree = { tree_type = "day", reversed = true },
                            properties = { empty_lines = { before = 1 } },
                        },
```

- [ ] **Step 6: Verify in nvim**

Open nvim, press `<leader>oc` — capture menu should show 5 groups: Ideas (i), Task (t), Note (n), Journal (j), Habit (h). No Meeting, Phone, or Link.

Press `<leader>oc h p` — the template should show `* TODO` not `* NEXT`.

Press `<leader>oc j w` — verify the target file path shows `~/Projects/Work/Github/second-brain/journal/inbox.org` (not the personal brain's path).

---

### Task 4: Emacs — Add TODO Keywords, Agenda Settings, Tag Faces & Curated Subdirs

**Files:**
- Modify: `doom-emacs/.config/doom/+org-second-brain.el:26-28` (curated subdirs var)
- Modify: `doom-emacs/.config/doom/+org-second-brain.el:171-192` (the `(after! org ...)` block)

**Interfaces:**
- Consumes: nothing
- Produces: TODO keywords, agenda settings, tag faces, and updated curated subdirs that Task 5 (capture) and Task 6 (agenda commands) depend on

- [ ] **Step 1: Add `"journal"` to curated subdirs**

This ensures the work brain's `journal/` directory gets scanned for agenda files. Change line 27 from:

```elisp
  '("daily" "brain" "sandbox" "meta")
```

To:

```elisp
  '("daily" "brain" "sandbox" "meta" "journal")
```

- [ ] **Step 2: Add TODO keywords, agenda settings, and tag faces to the `(after! org ...)` block**

Insert the following lines after `(setq org-image-actual-width 300)` (line 180) and before `(my/org-second-brain-set-global-agenda-files)` (line 181):

```elisp
  ;; TODO keywords — streamlined 5-state pipeline
  (setq org-todo-keywords
        '((sequence "BACKLOG(b)" "TODO(t)" "IN-PROGRESS(p)" "|" "DONE(d)" "CANCELLED(c)")))
  (setq org-todo-keyword-faces
        '(("BACKLOG"     . (:foreground "#a8a8a8"))
          ("TODO"        . (:foreground "#0088ff" :weight bold))
          ("IN-PROGRESS" . (:foreground "#ffd700" :weight bold))
          ("DONE"        . (:foreground "#5fff5f" :weight bold))
          ("CANCELLED"   . (:foreground "#585858" :weight bold))))

  ;; Agenda — 14-day span starting Monday
  (setq org-agenda-span 14)
  (setq org-agenda-start-on-weekday 1)

  ;; Tag faces — cobalt2 palette, only auto-applied tags
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

- [ ] **Step 3: Verify syntax**

Run `doom sync` from the terminal — it must complete without errors.

```bash
~/.config/emacs/bin/doom sync
```

Expected: completes with `✓ Finished!` (or equivalent success message).

---

### Task 5: Emacs — Replace Capture Templates

**Files:**
- Modify: `doom-emacs/.config/doom/+org-second-brain.el:185-188` (the existing `unless/push` capture block inside `(after! org ...)`)

**Interfaces:**
- Consumes: Task 4's TODO keywords and brain root vars (lines 15-21)
- Produces: full capture template set (14 sub-templates across 5 groups + quick inbox)

- [ ] **Step 1: Replace the single "b" inbox capture template with the full 5-group set**

Replace these lines inside the `(after! org ...)` block:

```elisp
  (unless (seq-find (lambda (tpl) (equal (car tpl) "b")) org-capture-templates)
    (push '("b" "Inbox (second-brain)" entry (file my/org-second-brain-capture-inbox-file)
            "* %?\n%U\n" :empty-lines 1)
          org-capture-templates))
```

With:

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

- [ ] **Step 2: Verify syntax**

Run `doom sync` — must succeed.

```bash
~/.config/emacs/bin/doom sync
```

---

### Task 6: Emacs — Add Custom Agenda Commands

**Files:**
- Modify: `doom-emacs/.config/doom/+org-second-brain.el` (inside the `(after! org ...)` block, after the agenda settings added in Task 4)

**Interfaces:**
- Consumes: Task 4's agenda settings, `my/org-second-brain-agenda-files` function (line 77)
- Produces: 4 custom agenda dispatch commands

- [ ] **Step 1: Add custom agenda commands**

Insert after the `org-agenda-start-on-weekday` line (added in Task 4), before the tag faces:

```elisp
  ;; Custom agenda commands — matching nvim workflow
  (setq org-agenda-custom-commands
        `(("A" "📅 Agenda & All Tasks (Global)"
           ((agenda "")
            (alltodo "")))
          ("w" "💼 Work Focus"
           ((agenda "" ((org-agenda-files ',(my/org-second-brain-agenda-files :work))))
            (alltodo "" ((org-agenda-files ',(my/org-second-brain-agenda-files :work))))))
          ("p" "🏠 Personal Focus"
           ((agenda "" ((org-agenda-files ',(my/org-second-brain-agenda-files :personal))))
            (alltodo "" ((org-agenda-files ',(my/org-second-brain-agenda-files :personal))))))
          ("T" "📋 Triage / Backlog"
           ((todo "BACKLOG")))))
```

- [ ] **Step 2: Verify syntax**

Run `doom sync` — must succeed.

```bash
~/.config/emacs/bin/doom sync
```

---

### Task 7: Emacs — Add org-super-agenda Package & Config

**Files:**
- Modify: `doom-emacs/.config/doom/packages.el` (append to end of file)
- Modify: `doom-emacs/.config/doom/+org-second-brain.el` (add `use-package!` block after the `(after! org-roam ...)` block)

**Interfaces:**
- Consumes: Task 4's TODO keywords (for grouping by state)
- Produces: grouped agenda views via org-super-agenda

- [ ] **Step 1: Add package declaration**

Append to `doom-emacs/.config/doom/packages.el`:

```elisp
;; Grouped/categorized agenda views (mirrors nvim org-super-agenda)
(package! org-super-agenda)
```

- [ ] **Step 2: Add org-super-agenda config to `+org-second-brain.el`**

Insert after the `(after! org-roam ...)` block (line 200) and before the `(eval ...)` keybinding block (line 202):

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

- [ ] **Step 3: Run `doom sync` to install the package**

```bash
~/.config/emacs/bin/doom sync
```

Expected: `org-super-agenda` is downloaded and compiled. Sync completes without errors.

---

### Task 8: Full Verification — Both Editors

**Files:**
- Read-only verification of all changes

**Interfaces:**
- Consumes: all previous tasks

- [ ] **Step 1: Verify nvim org-mode loads without errors**

Open nvim and run:

```
:checkhealth orgmode
```

Should report no errors.

- [ ] **Step 2: Verify nvim capture menu**

Press `<leader>oc` — should show 5 groups: Ideas (i), Task (t), Note (n), Journal (j), Habit (h).

Verify `<leader>oc h p` shows `* TODO` in the template (not `* NEXT`).

- [ ] **Step 3: Verify nvim agenda dispatch**

Press `<leader>oa` then check the dispatch menu — should show `A`, `w`, `p`, `T` only (no `i` or `b`).

- [ ] **Step 4: Verify emacs capture menu**

Open emacs, press `SPC x` — should show 5 groups with sub-templates plus the "b" quick inbox.

Test `SPC x t p` — should create a TODO entry in `daily/agenda/todos.org`.

Test `SPC n B c` — should prompt for brain selection and open inbox capture ("b" template).

- [ ] **Step 5: Verify emacs agenda**

Run `M-x org-agenda` — dispatch should show `A`, `w`, `p`, `T`.

Press `a` for default agenda — should show 14-day span starting Monday.

- [ ] **Step 6: Verify emacs org-super-agenda grouping**

In the agenda view, items should be grouped under headers: 🔥 In Progress, 📋 Today, 📅 Upcoming, ⚡ Habits, 📥 Backlog.

- [ ] **Step 7: Verify emacs tag faces**

Open an `.org` file with tagged headings (e.g. `:IDEA:RAW:`) — tags should render in cobalt2 colors.

- [ ] **Step 8: Verify emacs TODO keyword faces**

In any `.org` file, cycle through TODO states with `C-c C-t` — should show only 5 states with correct cobalt2 colors.
