# Archive Path Fix Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Fix missing `#+ARCHIVE:` directives in source org files, configure `org-archive-location` in Doom Emacs, and normalize stale `:ARCHIVE_FILE:` metadata in personal brain archives.

**Architecture:** Add per-file `#+ARCHIVE:` directive to every source org file in both work and personal brains (except `todos.org` which already has it), so archiving always targets the correct `archive/` directory. Add a per-brain `org-archive-location` fallback in Doom Emacs. Fix stale ARCHIVE_FILE metadata from old machine and pre-restructure paths.

**Tech Stack:** Org mode (Doom Emacs + Neovim), shell scripting for archive metadata fix

---

### Task 1: Add `#+ARCHIVE:` to work brain source files

**Files:**
- Modify: `~/Projects/Work/Github/second-brain/daily/agenda/habits.org`
- Modify: `~/Projects/Work/Github/second-brain/daily/agenda/inbox.org`
- Modify: `~/Projects/Work/Github/second-brain/daily/journal/inbox.org`
- Modify: `~/Projects/Work/Github/second-brain/sandbox/ideas/inbox.org`
- Modify: `~/Projects/Work/Github/second-brain/brain/notes/inbox.org`
- Modify: `~/Projects/Work/Github/second-brain/inbox.org`

- [ ] Prepend `#+ARCHIVE:` as first line to each file

Each addition follows the pattern:
```
#+ARCHIVE: ~/Projects/Work/Github/second-brain/archive/<target>.org::
```

| File | Target |
|------|--------|
| `daily/agenda/habits.org` | `archive/habits.org` |
| `daily/agenda/inbox.org` | `archive/inbox.org` |
| `daily/journal/inbox.org` | `archive/journal.org` |
| `sandbox/ideas/inbox.org` | `archive/ideas.org` |
| `brain/notes/inbox.org` | `archive/notes.org` |
| `inbox.org` (root) | `archive/inbox.org` |

- [ ] Verify no regression: confirm `daily/agenda/todos.org` still has its existing `#+ARCHIVE:` (unchanged)

---

### Task 2: Add `#+ARCHIVE:` to personal brain source files

**Files:**
- Modify: `~/Projects/Personal/Github/second-brain/daily/agenda/habits.org`
- Modify: `~/Projects/Personal/Github/second-brain/daily/agenda/inbox.org`
- Modify: `~/Projects/Personal/Github/second-brain/daily/journal/inbox.org`
- Modify: `~/Projects/Personal/Github/second-brain/sandbox/ideas/inbox.org`
- Modify: `~/Projects/Personal/Github/second-brain/sandbox/ideas/project.org`
- Modify: `~/Projects/Personal/Github/second-brain/sandbox/ideas/application.org`
- Modify: `~/Projects/Personal/Github/second-brain/sandbox/ideas/neovim.org`
- Modify: `~/Projects/Personal/Github/second-brain/brain/notes/inbox.org`
- Modify: `~/Projects/Personal/Github/second-brain/inbox.org`

- [ ] Prepend `#+ARCHIVE:` as first line to each file

Each addition follows the pattern:
```
#+ARCHIVE: ~/Projects/Personal/Github/second-brain/archive/<target>.org::
```

| File | Target |
|------|--------|
| `daily/agenda/habits.org` | `archive/habits.org` |
| `daily/agenda/inbox.org` | `archive/inbox.org` |
| `daily/journal/inbox.org` | `archive/journal.org` |
| `sandbox/ideas/inbox.org` | `archive/ideas.org` |
| `sandbox/ideas/project.org` | `archive/ideas.org` |
| `sandbox/ideas/application.org` | `archive/ideas.org` |
| `sandbox/ideas/neovim.org` | `archive/ideas.org` |
| `brain/notes/inbox.org` | `archive/notes.org` |
| `inbox.org` (root) | `archive/inbox.org` |

---

### Task 3: Set `org-archive-location` in Doom Emacs

**Files:**
- Modify: `doom-emacs/.config/doom/+org-second-brain.el`

- [ ] Add an `org-archive-location` setting that adapts to the active brain

Find the `my/org-second-brain-capture-inbox-file` function or the `set-org-brain-vars` area and add:

```elisp
(defun my/org-second-brain-archive-location ()
  "Return archive location for the current brain context."
  (concat (if (eq my/org-capture-active-brain :work)
              my/org-second-brain-work-root
            my/org-second-brain-personal-root)
          "/archive/inbox.org::"))
```

Then wire it into the capture/resolve flow. The file-level `#+ARCHIVE:` directives (Tasks 1-2) take priority, but this serves as a fallback when no file-level directive is present.

---

### Task 4: Normalize stale `:ARCHIVE_FILE:` metadata

**Files:**
- Modify: `~/Projects/Personal/Github/second-brain/archive/todos.org` (223 lines, 23 stale entries)
- Modify: `~/Projects/Personal/Github/second-brain/archive/inbox.org` (26 lines, 3 stale entries)

The `:ARCHIVE_FILE:` property values in archived entries have stale paths from the old machine (`/home/lalitmee/`) and pre-restructure folder layout (`agenda/` → `daily/agenda/`). These are cosmetic metadata but should be normalized for consistency.

**Substitutions needed:**

For `archive/todos.org`:
- `s|/home/lalitmee/|/Users/lalit.kumar1/|g` (18 entries: 17 old-machine + agenda, 2 old-machine + archive)
- `s|/agenda/todos.org|/daily/agenda/todos.org|g` (21 entries: 17 old-machine + 4 correct-machine)
  Note: The 2 entries with `archive/todos.org` must NOT be caught by this — the pattern `/agenda/` won't match `/archive/` so this is safe.

For `archive/inbox.org`:
- Line 5: `/Users/lalit.kumar1/Projects/Work/Github/second-brain/archive/todos.org` → `/Users/lalit.kumar1/Projects/Personal/Github/second-brain/archive/todos.org` (entry lives in personal archive, ARCHIVE_FILE should reference personal brain)
- Line 13: `/home/lalitmee/Projects/Personal/Github/second-brain/archive/todos.org` → `/Users/lalit.kumar1/Projects/Personal/Github/second-brain/archive/todos.org`
- Line 21: `/home/lalitmee/Projects/Work/Github/second-brain/daily/agenda/todos.org` → `/Users/lalit.kumar1/Projects/Work/Github/second-brain/daily/agenda/todos.org`

- [ ] Apply substitutions to `archive/todos.org`
- [ ] Apply substitutions to `archive/inbox.org`

---

### Task 5: Verify

- [ ] Confirm every modified source org file has `#+ARCHIVE:` as its first line
- [ ] Confirm no stale `/home/lalitmee/` paths remain in personal archive files
- [ ] Confirm no `agenda/` (without `daily/` prefix) paths remain in personal archive files (check `archive/todos.org` only; `archive/inbox.org` entries used `daily/agenda/` already)
- [ ] Confirm `org-archive-location` appears in `+org-second-brain.el`
