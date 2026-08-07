# Phase 1: Dressing Migration + Additions Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Migrate dressing.nvim to snacks.input and enable 4 new snacks modules (dashboard, indent, zen, animate+scroll).

**Architecture:** Modify existing `snacks.lua` opts to enable new modules and add keymaps; remove dressing from `ui.lua`; update filetype reference in `editor.lua` (DressingInput → snacks_input).

**Tech Stack:** Neovim, Lua, snacks.nvim v2.31.0, lazy.nvim

## Global Constraints

- snacks.nvim must remain `lazy = false` with `priority = 1000`
- All changes go through existing config files; no new files created
- All changes are reversible — dressing is archived but still works if reverted
- Run `:checkhealth snacks` after changes to verify config

---

### Task 1: Add snacks.input config and enable dashboard/indent/zen/animate/scroll

**Files:**
- Modify: `nvim/.config/nvim/lua/plugins/snacks.lua:196-254`

**This task touches opt-in changes only.** Nothing removed yet.

- [ ] **Step 1: Add input config and new module enable flags**

Replace the existing `dashboard = { enabled = false }` and add input/indent/zen/animate.

In `nvim/.config/nvim/lua/plugins/snacks.lua`, change the `opts` table. The current state:

```lua
dashboard = { enabled = false },
```

Replace with:

```lua
dashboard = { enabled = true },
indent = { enabled = true },
input = { enabled = true },
```

Then find `scroll = { enabled = false }` and change to:

```lua
animate = { enabled = true },
scroll = { enabled = true },
```

Then add `zen` config after `scroll`:

```lua
zen = { enabled = true },
```

- [ ] **Step 2: Add zen toggle keymaps**

In the `keys` table, add these after the Neovim News block (after the `<leader>N` entry):

```lua
{ -- [[ Toggle Zen Mode ]]
    "<leader>tz",
    function()
        Snacks.zen()
    end,
    desc = "Toggle Zen Mode",
},
{ -- [[ Toggle Zoom ]]
    "<leader>tZ",
    function()
        Snacks.zen.zoom()
    end,
    desc = "Toggle Zoom",
},
```

- [ ] **Step 3: Verify config syntax**

Run: `nvim --headless -c "luafile lua/plugins/snacks.lua" -c "qa"`
Expected: no errors

- [ ] **Step 4: Commit**

```bash
git add nvim/.config/nvim/lua/plugins/snacks.lua
git commit -m "feat(nvim): enable snacks dashboard, indent, input, zen, animate, scroll"
```

---

### Task 2: Update blink.cmp filetype exclusion for snacks.input

**Files:**
- Modify: `nvim/.config/nvim/lua/plugins/editor.lua:71`

- [ ] **Step 1: Replace DressingInput with snacks_input**

In `nvim/.config/nvim/lua/plugins/editor.lua`, line 71, change:

```lua
{ "TelescopePrompt", "DressingInput", "chatgpt-input" },
```

To:

```lua
{ "TelescopePrompt", "snacks_input", "chatgpt-input" },
```

- [ ] **Step 2: Verify syntax**

Run: `nvim --headless -c "luafile lua/plugins/editor.lua" -c "qa"`
Expected: no errors

- [ ] **Step 3: Commit**

```bash
git add nvim/.config/nvim/lua/plugins/editor.lua
git commit -m "fix(nvim): update blink.cmp filetype exclusion for snacks.input"
```

---

### Task 3: Remove dressing.nvim

**Files:**
- Modify: `nvim/.config/nvim/lua/plugins/ui.lua:5-39`

- [ ] **Step 1: Remove dressing plugin spec**

In `nvim/.config/nvim/lua/plugins/ui.lua`, remove lines 5-39 (the entire dressing.nvim plugin spec).

The file currently starts with:

```lua
local command = lk.command
local border, L = lk.style.border.rounded, vim.log.levels

return {
    { --[[ dressing ]]
        "stevearc/dressing.nvim",
        event = "VeryLazy",
        init = function()
            ---@diagnostic disable-next-line: duplicate-set-field
            vim.ui.select = function(...)
                require("lua.lazy").load({ plugins = { "dressing.nvim" } })
                return vim.ui.select(...)
            end
            ---@diagnostic disable-next-line: duplicate-set-field
            vim.ui.input = function(...)
                require("lua.lazy").load({ plugins = { "dressing.nvim" } })
                return vim.ui.input(...)
            end
        end,
        config = function()
            require("dressing").setup({
                input = {
                    insert_only = false,
                    win_options = { winblend = 0 },
                    title_pos = "center",
                    get_config = function(opts)
                        if opts.kind == "browse" then
                            return {
                                relative = "editor",
                                max_width = { 140, 0.9 },
                                min_width = { 40, 0.4 },
                            }
                        end
                    end,
                },
                select = { winblend = 0 },
            })
        end,
    },
```

Delete this block. The `return {` on line 4 should now be `return {` with the remaining plugins. If dressing was the only plugin in the file, the return will need adjustment.

- [ ] **Step 2: Verify the remaining ui.lua is valid**

```bash
nvim --headless -c "luafile lua/plugins/ui.lua" -c "qa"
```

Expected: no errors (dressing was the only plugin in the return block, so verify the return table still has valid content)

- [ ] **Step 3: Start Neovim and verify**

```bash
nvim --headless -c "lua vim.ui.input({prompt='test:'}, function(v) print(v) end)" -c "qa"
```

Expected: snacks.input opens (no error about missing dressing module)

Then open Neovim interactively and test:
- `:lua vim.ui.input({prompt="rename:"}, function(v) print(v) end)` — should open snacks.input
- `:lua vim.ui.select({1,2,3}, {prompt="pick"}, function(v) end)` — should open snacks picker

- [ ] **Step 4: Commit**

```bash
git add nvim/.config/nvim/lua/plugins/ui.lua
git commit -m "feat(nvim): remove dressing.nvim, use snacks.input instead"
```

---

### Verification

After all tasks:

```bash
nvim --headless -c "checkhealth snacks" -c "qa"
```

Expected: all newly enabled modules report OK

```bash
nvim --headless -c "lua print(require('snacks').config.dashboard.enabled)" -c "qa"
```

Expected: `true` for dashboard, indent, input, zen, animate, scroll
