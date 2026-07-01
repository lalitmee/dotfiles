# Design Spec: Integrating guh.nvim

Integration of `justinmk/guh.nvim` to provide minimal GitHub interaction directly within Neovim.

## Goal

Add the minimalist GitHub plugin [guh.nvim](https://github.com/justinmk/guh.nvim) to Neovim. The plugin will be configured to lazy-load on command and will use `<leader>gg` as the keybinding.

## Constraints & Requirements

- Must be added to the git plugins config file: [plugins/git/init.lua](file:///home/lalitmee/dotfiles/nvim/.config/nvim/lua/plugins/git/init.lua)
- Must be lazy-loaded on the `Guh` command.
- Must map `<leader>gg` to `:Guh<CR>` to trigger the plugin.
- Must follow Lua styling rules (4 spaces, double quotes for strings, EmmyLua style).

## Proposed Changes

### [plugins/git/init.lua](file:///home/lalitmee/dotfiles/nvim/.config/nvim/lua/plugins/git/init.lua)

Add the lazy specification block for `justinmk/guh.nvim`:

```lua
    { --[[ guh.nvim ]]
        "justinmk/guh.nvim",
        cmd = { "Guh" },
        keys = {
            { "<leader>gg", ":Guh<CR>", desc = "Guh (GitHub)", silent = true },
        },
    },
```

Place it directly after the `octo.nvim` block.

## Verification Plan

1. Verify Lua syntax of modified configuration.
2. Launch Neovim and run `:Lazy` to ensure `guh.nvim` is listed but not loaded.
3. Run `:Guh` or press `<leader>gg` to verify that `guh.nvim` loads and runs successfully (it should query GitHub using the `gh` CLI).
