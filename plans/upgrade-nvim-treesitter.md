# Feature Implementation Plan: upgrade-nvim-treesitter (Refined)

## 📋 Todo Checklist
- [ ] Remove the `playground` plugin.
- [ ] Update the `nvim-treesitter` configuration.
- [ ] Keep `nvim-treesitter-context` as a standalone plugin.
- [ ] Final Review and Testing

## 🔍 Analysis & Investigation

### Codebase Structure
The user's Neovim configuration is managed with `lazy.nvim`. The `nvim-treesitter` configuration is located at `nvim/.config/nvim/lua/plugins/treesitter.lua`.

### Current Architecture
The current `nvim-treesitter` configuration is using an old, monolithic structure where modules like `textobjects`, `context`, and `playground` are configured as dependencies within the main `nvim-treesitter` plugin. The new version of `nvim-treesitter` has spun off many of its modules into separate plugins or integrated them into Neovim core. The `master` branch of `nvim-treesitter` and its related plugins is now frozen and all new development is happening on the `main` branch.

### Dependencies & Integration Points
The main dependencies are:
- `nvim-treesitter/nvim-treesitter`
- `nvim-treesitter/nvim-treesitter-context`
- `nvim-treesitter/nvim-treesitter-textobjects` (now integrated into `nvim-treesitter`)
- `nvim-treesitter/playground` (deprecated)
- `Wansmer/treesj`
- `ckolkey/ts-node-action`

### Considerations & Challenges
The main challenge is to correctly update the `nvim-treesitter` configuration to the new, modular format, to remove the deprecated `playground` plugin, and to ensure that the `main` branch of `nvim-treesitter` is being used. The `nvim-treesitter-textobjects` is now part of the main `nvim-treesitter` plugin and should be configured within its `setup` function.

## 📝 Implementation Plan

### Prerequisites
- The user should be on the latest version of Neovim (nightly is recommended for the best experience with `nvim-treesitter`).

### Step-by-Step Implementation
1. **Step 1**: Update the `nvim-treesitter` configuration in `nvim/.config/nvim/lua/plugins/treesitter.lua`.
   - Files to modify: `nvim/.config/nvim/lua/plugins/treesitter.lua`
   - Changes needed: Replace the existing `nvim-treesitter` spec with the following. This will update the main plugin, configure textobjects, remove the playground dependency, and explicitly set the branch to `main`.

```lua
{ --[[ treesitter ]]
    "nvim-treesitter/nvim-treesitter",
    branch = "main", -- Use the main branch for the latest features
    build = ":TSUpdate",
    config = function()
        require("nvim-treesitter.configs").setup({
            ensure_installed = {
                "angular",
                "bash",
                "c",
                "comment",
                "cpp",
                "css",
                "diff",
                "dockerfile",
                "editorconfig",
                "git_rebase",
                "gitattributes",
                "gitcommit",
                "gitignore",
                "go",
                "gomod",
                "gosum",
                "gowork",
                "graphql",
                "html",
                "http",
                "javascript",
                "jsdoc",
                "json",
                "kdl",
                "liquid",
                "lua",
                "markdown",
                "markdown_inline",
                "norg",
                "python",
                "query",
                "regex",
                "rust",
                "scss",
                "toml",
                "tsx",
                "typescript",
                "vim",
                "vimdoc",
                "xml",
                "yaml",
            },
            sync_install = true,
            auto_install = false,
            highlight = {
                enable = true,
                additional_vim_regex_highlighting = { "org" },
            },
            indent = {
                enable = true,
                disable = { "css", "python" },
            },
            textobjects = {
                lookahead = true,
                select = {
                    enable = true,
                    keymaps = {
                        ["af"] = "@function.outer",
                        ["if"] = "@function.inner",
                        ["ac"] = "@class.outer",
                        ["ic"] = "@class.inner",
                        ["aC"] = "@conditional.outer",
                        ["iC"] = "@conditional.inner",
                    },
                },
                swap = {
                    enable = true,
                    swap_next = {
                        ["]w"] = "@parameter.inner",
                    },
                    swap_previous = {
                        ["[w"] = "@parameter.inner",
                    },
                },
                move = {
                    enable = true,
                    set_jumps = true,
                    goto_next_start = {
                        ["]m"] = "@function.outer",
                        ["]k"] = "@class.outer",
                    },
                    goto_next_end = {
                        ["]M"] = "@function.outer",
                        ["]K"] = "@class.outer",
                    },
                    goto_previous_start = {
                        ["[m"] = "@function.outer",
                        ["[k"] = "@class.outer",
                    },
                    goto_previous_end = {
                        ["[M"] = "@function.outer",
                        ["[K"] = "@class.outer",
                    },
                },
                lsp_interop = {
                    enable = true,
                    border = "rounded",
                    peek_definition_code = {
                        ["<leader>lf"] = "@function.outer",
                        ["<leader>lc"] = "@class.outer",
                    },
                },
            },
        })
        vim.treesitter.language.register("markdown", "octo")
        vim.treesitter.language.register("bash", "zsh")
    end,
},
```
2. **Step 2**: Update `nvim-treesitter-context` to be a standalone plugin.
   - Files to modify: `nvim/.config/nvim/lua/plugins/treesitter.lua`
   - Changes needed: The user's current configuration for `nvim-treesitter-context` is already correct and can be moved to a top-level spec. Remove the `on_attach` function as it is no longer necessary.

```lua
{
    "nvim-treesitter/nvim-treesitter-context",
    branch = "main", -- Use the main branch
    event = "BufReadPost",
    keys = {
        {
            "<leader>tc",
            function()
                require("treesitter-context").toggle()
                -- The notification part can be removed as it is not essential
            end,
            desc = "Toggle Context",
            silent = true,
        },
    },
    opts = {
        max_lines = 1,
    },
},
```

### Testing Strategy
1.  Open Neovim and run `:Lazy sync` to update the plugins.
2.  Run `:Lazy show nvim-treesitter` to verify that the `main` branch is being used.
3.  Open a file with a supported language (e.g., a `.lua` file).
4.  Verify that syntax highlighting is working correctly.
5.  Test the textobjects by using the keymaps (e.g., `af`, `if`).
6.  Test the `treesitter-context` by toggling it with `<leader>tc`.
7.  Use the new built-in commands `:InspectTree` and `:Inspect` to verify that the `playground` functionality is working.
8.  Test the other related plugins (`treesj`, `ts-node-action`) to ensure they still work as expected.

## 🎯 Success Criteria
The `nvim-treesitter` plugin is upgraded to the latest version from the `main` branch, and all related functionality (highlighting, textobjects, context) works as expected. The Neovim configuration is cleaner, more modular, and uses the latest recommended configurations. The deprecated `playground` plugin is removed.
