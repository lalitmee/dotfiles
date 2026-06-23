# Windsurf AI Integration Design Spec

We are re-integrating the `Exafunction/windsurf.vim` plugin (the Codeium AI-completion engine) back into the Neovim configuration. To prevent keybinding conflicts with the existing Copilot/Blink.cmp setups on `<Tab>`, we will configure custom `<C-...>` keybindings for Windsurf.

## User Review Required

No breaking changes are introduced. However, we are adding new key combinations for insert mode completion:
* `<C-g>` for accepting Windsurf completions.
* `<C-;>` for cycling to the next suggestion.
* `<C-,>` for cycling to the previous suggestion.
* `<C-x>` for clearing suggestions.

## Proposed Changes

### Neovim AI Configuration

#### [MODIFY] [misc.lua](file:///home/lalitmee/dotfiles/nvim/.config/nvim/lua/plugins/ai/misc.lua)
We will append the `Exafunction/windsurf.vim` plugin block to the list of plugins returned by `misc.lua`.

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

## Verification Plan

### Manual Verification
1. Open Neovim and run `:Lazy` to verify that `windsurf.vim` is listed and starts installing.
2. Open a whitelisted file (e.g. any `.lua` or `.py` file).
3. Type some code to trigger a ghost-text suggestion.
4. Verify key combinations:
   * Press `<C-g>` to accept the suggestion.
   * Press `<C-x>` to clear the suggestion.
   * Use `<C-;>` and `<C-,>` to cycle suggestions if multiple are available.
