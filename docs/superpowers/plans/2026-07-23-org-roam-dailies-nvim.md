# Org-roam-dailies Neovim Parity Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Enable org-roam-dailies in Neovim with dual-brain support (personal/work).

**Architecture:** Add `extensions.dailies` config to existing org-roam.nvim setup, disable auto keybindings, register custom keymaps with brain-resolution wrappers in the plugin's `config` function.

**Tech Stack:** Neovim, Lua, lazy.nvim, org-roam.nvim (chipsenkbeil), nvim-orgmode

## Global Constraints

- Single file change: `nvim/.config/nvim/lua/plugins/org-mode/init.lua`
- Brain roots: `~/Projects/{Personal,Work}/Github/second-brain`
- Dailies directory: `brain/notes/daily/` (relative to brain root)
- All changes go in the org-roam.nvim spec block (lines 410-468)
- No changes to existing journal, inbox, or GTD capture templates
- Which-key `<localleader>nd` group already defined — leave unchanged

---
### Task 1: Add dailies config, brain helpers, and custom keymaps

**Files:**
- Modify: `nvim/.config/nvim/lua/plugins/org-mode/init.lua` (org-roam.nvim spec block, lines 448-468)

**Interfaces:**
- Consumes: existing org-roam.nvim opts + keys table
- Produces: working dailies under `<localleader>nd*` prefix

- [ ] **Step 1: Convert `opts` to `config` + `opts`**

Replace the static `opts` table (448-467) with a `config` function + `opts` that includes `extensions.dailies`. The `config` function calls `require("org-roam").setup(opts)` and registers our custom keymaps.

Current:
```lua
opts = {
    directory = "~/Projects/Personal/Github/second-brain/brain/notes",
    bindings = {
        prefix = "<localleader>n",
    },
    templates = {
        capture = {
            {
                description = "default",
                template = "#+title: %[title]\n%?",
                target = "%[slug].org",
            },
        },
        immediate = {
            description = "default",
            template = "#+title: %[title]\n%?",
            target = "%[slug].org",
        },
    },
},
```

Replace with:
```lua
opts = {
    directory = "~/Projects/Personal/Github/second-brain/brain/notes",
    bindings = {
        prefix = "<localleader>n",
    },
    templates = {
        capture = {
            {
                description = "default",
                template = "#+title: %[title]\n%?",
                target = "%[slug].org",
            },
        },
        immediate = {
            description = "default",
            template = "#+title: %[title]\n%?",
            target = "%[slug].org",
        },
    },
    extensions = {
        dailies = {
            directory = "daily/",
            bindings = false,
            templates = {
                d = {
                    description = "default",
                    template = "* %<%H:%M> %?",
                    target = "%<%Y-%m-%d>.org",
                },
            },
        },
    },
},
config = function(_, opts)
    require("org-roam").setup(opts)

    local personal_dir = "~/Projects/Personal/Github/second-brain/brain/notes"
    local personal_db  = "~/Projects/Personal/Github/second-brain/.org-roam.db"
    local work_dir     = "~/Projects/Work/Github/second-brain/brain/notes"
    local work_db      = "~/Projects/Work/Github/second-brain/.org-roam.db"

    local function resolve_brain()
        local cwd = vim.fn.expand("%:p")
        if cwd:find("Projects/Work/") then
            return "work"
        end
        return "personal"
    end

    local function with_brain(target, fn)
        local roam = require("org-roam")
        local saved = {
            directory = roam.config.directory,
            database = roam.config.database,
        }
        local dir, db = target == "work" and work_dir or personal_dir,
                        target == "work" and work_db or personal_db
        roam.setup({
            directory = dir,
            database = { path = db },
        })
        fn():next(function()
            roam.setup(saved)
        end)
    end

    -- ponytail: direct keymap registration instead of auto-bindings
    -- to support brain-aware routing. Add `vim.keymap.set` calls for
    -- each dailies function here: goto_today, capture_today, etc.
    --
    -- Example:
    -- vim.keymap.set("n", "<localleader>ndn", function()
    --     with_brain(resolve_brain(),
    --         require("org-roam.extensions.dailies").goto_today)
    -- end, { desc = "dailies goto today" })
end,
```

- [ ] **Step 2: Verify `vim.keymap.set` calls match the dailies API**

Test by running Neovim and checking `:lua print(vim.inspect(require("org-roam.extensions.dailies")))` to expose the available function names.

Expected names (from DOCS.org): `goto_today`, `goto_yesterday`, `goto_tomorrow`, `goto_date`, `goto_next_date`, `goto_prev_date`, `capture_today`, `capture_yesterday`, `capture_tomorrow`, `capture_date`, `find_directory`.

- [ ] **Step 3: Register all personal dailies keymaps**

For each dailies function, add a `vim.keymap.set` call in the `config` function body:

```lua
vim.keymap.set("n", "<localleader>ndn", function()
    with_brain(resolve_brain(), require("org-roam.extensions.dailies").goto_today)
end, { desc = "dailies goto today" })

vim.keymap.set("n", "<localleader>ndN", function()
    with_brain(resolve_brain(), require("org-roam.extensions.dailies").capture_today)
end, { desc = "dailies capture today" })

vim.keymap.set("n", "<localleader>ndy", function()
    with_brain(resolve_brain(), require("org-roam.extensions.dailies").goto_yesterday)
end, { desc = "dailies goto yesterday" })

vim.keymap.set("n", "<localleader>ndY", function()
    with_brain(resolve_brain(), require("org-roam.extensions.dailies").capture_yesterday)
end, { desc = "dailies capture yesterday" })

vim.keymap.set("n", "<localleader>ndt", function()
    with_brain(resolve_brain(), require("org-roam.extensions.dailies").goto_tomorrow)
end, { desc = "dailies goto tomorrow" })

vim.keymap.set("n", "<localleader>ndT", function()
    with_brain(resolve_brain(), require("org-roam.extensions.dailies").capture_tomorrow)
end, { desc = "dailies capture tomorrow" })

vim.keymap.set("n", "<localleader>ndd", function()
    with_brain(resolve_brain(), require("org-roam.extensions.dailies").goto_date)
end, { desc = "dailies goto date" })

vim.keymap.set("n", "<localleader>ndD", function()
    with_brain(resolve_brain(), require("org-roam.extensions.dailies").capture_date)
end, { desc = "dailies capture date" })

vim.keymap.set("n", "<localleader>ndb", function()
    with_brain(resolve_brain(), require("org-roam.extensions.dailies").goto_prev_date)
end, { desc = "dailies prev note" })

vim.keymap.set("n", "<localleader>ndf", function()
    with_brain(resolve_brain(), require("org-roam.extensions.dailies").goto_next_date)
end, { desc = "dailies next note" })

vim.keymap.set("n", "<localleader>nd.", function()
    with_brain(resolve_brain(), require("org-roam.extensions.dailies").find_directory)
end, { desc = "dailies find directory" })
```

- [ ] **Step 4: Register work dailies override keymaps**

Add these after the personal dailies block, with `"work"` hardcoded:

```lua
vim.keymap.set("n", "<localleader>ndWn", function()
    with_brain("work", require("org-roam.extensions.dailies").goto_today)
end, { desc = "work dailies goto today" })

vim.keymap.set("n", "<localleader>ndWN", function()
    with_brain("work", require("org-roam.extensions.dailies").capture_today)
end, { desc = "work dailies capture today" })

vim.keymap.set("n", "<localleader>ndWy", function()
    with_brain("work", require("org-roam.extensions.dailies").goto_yesterday)
end, { desc = "work dailies goto yesterday" })

vim.keymap.set("n", "<localleader>ndWd", function()
    with_brain("work", require("org-roam.extensions.dailies").goto_date)
end, { desc = "work dailies goto date" })
```

- [ ] **Step 5: Add lazy-loading stubs to `keys` table**

Add stubs to the existing `keys` table to trigger lazy-loading for all dailies keys. These are no-callback entries — lazy.nvim removes them after loading:

```lua
{ "<localleader>ndn" },
{ "<localleader>ndN" },
{ "<localleader>ndy" },
{ "<localleader>ndY" },
{ "<localleader>ndt" },
{ "<localleader>ndT" },
{ "<localleader>ndd" },
{ "<localleader>ndD" },
{ "<localleader>ndb" },
{ "<localleader>ndf" },
{ "<localleader>nd." },
{ "<localleader>ndWn" },
{ "<localleader>ndWN" },
{ "<localleader>ndWy" },
{ "<localleader>ndWd" },
```

- [ ] **Step 6: Commit**

```bash
git add nvim/.config/nvim/lua/plugins/org-mode/init.lua
git commit -m "feat(nvim): add org-roam-dailies with dual-brain support"
```

### Verification

1. Reload Neovim (`<leader>lr` or `:Lazy reload org-roam.nvim`)
2. `<localleader>ndn` creates/holds personal `brain/notes/daily/<today>.org`
3. From a buffer under `~/Projects/Work/`: same key creates work daily
4. `<localleader>ndWn` from home dir creates work daily
5. `<localleader>ndN` appends `* HH:MM` entry
6. `:checkhealth org-roam` shows no errors
7. Existing journal capture, roam find `<localleader>nf`, and `<localleader>nW` toggle still work
