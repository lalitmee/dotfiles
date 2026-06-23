# Windsurf AI Integration Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Re-integrate the `windsurf.vim` plugin in the Neovim AI configuration using custom keybindings to avoid conflicts.

**Architecture:** We will configure the plugin in `nvim/.config/nvim/lua/plugins/ai/misc.lua` and disable the default `<Tab>` capture so that `blink.cmp` continues to work. Then we will bind `<C-g>` to accept suggestions in insert mode.

**Tech Stack:** Neovim, Lua, lazy.nvim, windsurf.vim

---

### Task 1: Append Windsurf configuration block to misc.lua

**Files:**
- Modify: [misc.lua](file:///home/lalitmee/dotfiles/nvim/.config/nvim/lua/plugins/ai/misc.lua)

- [ ] **Step 1: Open [misc.lua](file:///home/lalitmee/dotfiles/nvim/.config/nvim/lua/plugins/ai/misc.lua) and append the `Exafunction/windsurf.vim` plugin block to the returned table.**

The code to add to the end of the returned list in `misc.lua` (before the final closing bracket `}`):

```lua
    -- Windsurf AI completion integration
    {
        "Exafunction/windsurf.vim",
        event = "BufEnter",
        init = function()
            -- Disable default keybindings so we can map them customly
            vim.g.codeium_disable_bindings = 1
        end,
        config = function()
            -- Disable by default and enable for specific programming languages
            vim.g.codeium_filetypes_disabled_by_default = true
            vim.g.codeium_filetypes = {
                c = true,
                cpp = true,
                gitcommit = true,
                go = true,
                javascript = true,
                javascriptreact = true,
                lua = true,
                python = true,
                rust = true,
                typescript = true,
                typescriptreact = true,
                vim = true,
                yaml = true,
            }

            -- Custom keymaps (using Ctrl) to avoid conflicts with Copilot/<Tab>
            vim.keymap.set("i", "<C-g>", function()
                return vim.fn["codeium#Accept"]()
            end, { expr = true, silent = true, desc = "Windsurf: Accept suggestion" })

            vim.keymap.set("i", "<C-;>", function()
                return vim.fn["codeium#CycleCompletions"](1)
            end, { expr = true, silent = true, desc = "Windsurf: Next suggestion" })

            vim.keymap.set("i", "<C-,>", function()
                return vim.fn["codeium#CycleCompletions"](-1)
            end, { expr = true, silent = true, desc = "Windsurf: Prev suggestion" })

            vim.keymap.set("i", "<C-x>", function()
                return vim.fn["codeium#Clear"]()
            end, { expr = true, silent = true, desc = "Windsurf: Clear suggestion" })
        end,
    },
```

- [ ] **Step 2: Verify syntax correctness of modified file**

Run: `luac -p nvim/.config/nvim/lua/plugins/ai/misc.lua`
Expected: No output (exit code 0), verifying syntax is correct.

- [ ] **Step 3: Commit changes**

```bash
git add nvim/.config/nvim/lua/plugins/ai/misc.lua
git commit -m "feat(ai): integrate windsurf.vim with custom Ctrl keymaps"
```

---

### Task 2: Launch Neovim and verify installation/functionality

- [ ] **Step 1: Launch Neovim**

Instruct the user to open Neovim. Verify that `lazy.nvim` starts downloading and compiling `windsurf.vim`.
Alternatively, run `:Lazy` to check if `windsurf.vim` is listed.

- [ ] **Step 2: Test ghost text behavior**

Open a whitelisted file (e.g. `nvim/.config/nvim/lua/plugins/ai/misc.lua`).
Go to insert mode and type some code to trigger a recommendation.
Verify:
1. Press `<C-g>` to accept suggestion.
2. Press `<C-x>` to clear suggestion.
