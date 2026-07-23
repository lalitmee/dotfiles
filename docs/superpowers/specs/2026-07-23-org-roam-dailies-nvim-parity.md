# Org-roam-dailies Neovim Parity

Date: 2026-07-23

## Motivation

Port the org-roam-dailies functionality already implemented in Emacs
(`+org-second-brain.el`) to Neovim, enabling daily roam notes
(`brain/notes/daily/YYYY-MM-DD.org`) inside each second-brain's roam tree.

The Emacs design is at
`docs/superpowers/specs/2026-07-23-org-roam-dailies-design.md`; this doc
covers only the Neovim-specific implementation.

## Goals

- One daily Org-roam file per calendar day under `brain/notes/daily/YYYY-MM-DD.org`
- Support both personal and work second-brains
- Brain resolution from current buffer context (personal default)
- Explicit work dailies override keybindings for when context is unavailable
- Fast capture of timestamped log entries
- Zero changes to existing journal / inbox / GTD capture templates

## Non-goals

- Any changes outside `nvim/.config/nvim/lua/plugins/org-mode/init.lua`
- Modifying existing capture templates, agenda commands, or roam find bindings
- Replacing the existing journal capture (`daily/journal/inbox.org`)
- Structured day templates (Tasks / Journal / Review sections)
- TODO carry-forward

## Current state

| Piece | Location / behavior |
|-------|---------------------|
| nvim-orgmode | Installed, fully configured with 5 capture groups, custom agenda commands |
| org-roam.nvim | Installed (chipsenkbeil/org-roam.nvim), roam find/insert/buffer working |
| Dailies extension | Not configured — `extensions.dailies` absent from opts |
| Dual-brain pattern | `<localleader>nW` toggle for roam find; separate agenda commands |
| Which-key | `<localleader>nd` group defined but empty |

## Design

### Path layout

```
<brain-root>/
  brain/notes/           ← org-roam-directory
    daily/               ← dailies directory ("daily/")
      2026-07-23.org     ← one node per day
  daily/
    journal/inbox.org    ← existing journal (unchanged)
    agenda/todos.org     ← GTD (unchanged)
```

Filename format is `YYYY-MM-DD.org` (org-roam calendar marking requirement).

### Brain resolution

```lua
local function resolve_brain()
  local cwd = vim.fn.expand("%:p")
  if cwd:find("Projects/Work/") then
    return "work"
  end
  return "personal"  -- everything else (Projects/Personal/*, home, /tmp, etc.)
end
```

A `with_brain` wrapper saves the current roam config, sets directory+database
for the target brain, calls the dailies function, then restores:

```lua
local function with_brain(target, fn)
  local roam = require("org-roam")
  local saved = { directory = roam.config.directory, database = roam.config.database }
  local dir, db = target == "work" and work_dir or personal_dir,
                  target == "work" and work_db  or personal_db
  roam.setup({ directory = dir, database = { path = db } })
  fn():next(function() roam.setup(saved) end)
end
```

### Capture template

```lua
extensions = {
    dailies = {
        directory = "daily/",
        templates = {
            d = {
                description = "default",
                template = "* %<%H:%M> %?",
                target = "%<%Y-%m-%d>.org",
            },
        },
    },
},
```

- First capture creates `brain/notes/daily/YYYY-MM-DD.org` with `#+title: YYYY-MM-DD`
- Subsequent captures append `* HH:MM <content>` under the title

### Keybindings

All under `<localleader>nd` prefix (matching existing which-key group):

#### Personal dailies (auto-detect brain from buffer context)

| Key | Action |
|-----|--------|
| `n` | goto today |
| `N` | capture today |
| `y` | goto yesterday |
| `Y` | capture yesterday |
| `t` | goto tomorrow |
| `T` | capture tomorrow |
| `d` | goto date |
| `D` | capture date |
| `b` | previous daily note |
| `f` | next daily note |
| `.` | find dailies directory |

#### Work dailies (explicit override for when context is unavailable)

| Key | Action |
|-----|--------|
| `Wn` | work goto today |
| `WN` | work capture today |
| `Wy` | work goto yesterday |
| `Wd` | work goto date |

### Bootstrap

No explicit directory creation needed — `mkdir -p` behavior is handled by
nvim-orgmode / org-roam.nvim on first write.

### Config changes

Modify only `nvim/.config/nvim/lua/plugins/org-mode/init.lua`:

- **org-roam.nvim opts**: add `extensions.dailies` block with directory, templates, bindings
- **org-roam.nvim opts**: add brain constants (`personal_dir`, `personal_db`, `work_dir`, `work_db`)
- **org-roam.nvim keys**: add dailies keymaps using `with_brain` wrapper
- **Init block `keys`**: remove stale `<localleader>nd` lazy-loader stubs (not needed — dailies keys are registered inside the plugin spec)
- **which-key**: keep existing `{ "<localleader>nd", group = "dailies" }` — already correct

### Purpose boundaries

| System | Role |
|--------|------|
| org-roam-dailies | Day-scoped log / scratchpad; linkable roam nodes |
| Journal capture (`jj`/`jw`) | Timestamped journal to `daily/journal/inbox.org` |
| Inbox capture (`np`/`nw`) | Quick notes to `brain/notes/inbox.org` |
| GTD tasks (`tp`/`tw`) | Todos to `daily/agenda/todos.org` |

## Verification

1. Reload Neovim / `:Lazy reload org-roam.nvim`
2. `<localleader>ndn` creates personal `brain/notes/daily/<today>.org`
3. From a work project file: same key creates work daily
4. From home dir: `<localleader>ndWn` creates work daily
5. `<localleader>ndN` appends `* HH:MM` entry
6. Existing journal capture still writes to `daily/journal/inbox.org`
7. Existing roam find `<localleader>nf` still works against personal roam
8. `<localleader>nW` roam find toggle still works
