# Feature Implementation Plan: upgrade-nvim-treesitter

## 📋 Todo Checklist
- [ ] Update `nvim-treesitter` plugin spec.
- [ ] Update `nvim-treesitter-textobjects` to be a standalone plugin.
- [ ] Keep `nvim-treesitter-context` as a standalone plugin.
- [ ] Keep `playground` as a standalone plugin.
- [ ] Final Review and Testing

## 🔍 Analysis & Investigation

### Codebase Structure
The user's Neovim configuration is managed with `lazy.nvim`. The `nvim-treesitter` configuration is located at `nvim/.config/nvim/lua/plugins/treesitter.lua`.

### Current Architecture
The current `nvim-treesitter` configuration is using an old, monolithic structure where modules like `textobjects`, `context`, and `playground` are configured as dependencies within the main `nvim-treesitter` plugin.

### Dependencies & Integration Points
The main dependencies are:
- `nvim-treesitter/nvim-treesitter`
- `nvim-treesitter/nvim-treesitter-context`
- `nvim-treesitter/nvim-treesitter-textobjects`
- `nvim-treesitter/playground`
- `Wansmer/treesj`
- `ckolkey/ts-node-action`

The new version of `nvim-treesitter` has spun off many of its modules into separate plugins.

### Considerations & Challenges
The main challenge is to correctly separate the modules into their own plugin specs in the `lazy.nvim` configuration, and to update the configuration of the main `nvim-treesitter` plugin to the new, simpler format.

## 📝 Implementation Plan

### Prerequisites
- The user should be on the latest version of Neovim.

### Step-by-Step Implementation
1. **Step 1**: Update the `nvim-treesitter` configuration in `nvim/.config/nvim/lua/plugins/treesitter.lua`.
   - Files to modify: `nvim/.config/nvim/lua/plugins/treesitter.lua`
   - Changes needed: Replace the existing `nvim-treesitter` spec with the following:

```lua
{ --[[ treesitter ]]
    "nvim-treesitter/nvim-treesitter",
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
        })
        vim.treesitter.language.register("markdown", "octo")
        vim.treesitter.language.register("bash", "zsh")
    end,
},
```
2. **Step 2**: Add `nvim-treesitter-textobjects` as a standalone plugin.
   - Files to modify: `nvim/.config/nvim/lua/plugins/treesitter.lua`
   - Changes needed: Add the following spec to the `treesitter.lua` file:
```lua
{
    "nvim-treesitter/nvim-treesitter-textobjects",
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    config = function()
        require("nvim-treesitter.configs").setup({
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
    end,
},
```
3. **Step 3**: Update `nvim-treesitter-context` to be a standalone plugin.
   - Files to modify: `nvim/.config/nvim/lua/plugins/treesitter.lua`
   - Changes needed: The user's current configuration for `nvim-treesitter-context` is already correct and can be moved to a top-level spec.

### Testing Strategy
1.  Open Neovim and run `:Lazy sync` to update the plugins.
2.  Open a file with a supported language (e.g., a `.lua` file).
3.  Verify that syntax highlighting is working correctly.
4.  Test the textobjects by using the keymaps (e.g., `af`, `if`).
5.  Test the `treesitter-context` by toggling it with `<leader>tc`.
6.  Test the other related plugins (`treesj`, `ts-node-action`) to ensure they still work as expected.

## 🎯 Success Criteria
The `nvim-treesitter` plugin is upgraded to the latest version, and all related functionality (highlighting, textobjects, context) works as expected. The Neovim configuration is cleaner and more modular.
