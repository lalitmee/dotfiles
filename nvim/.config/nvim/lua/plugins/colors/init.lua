require("plugins.colors.util")

return {
    { --[[ colorschemes ]]

        { --[[ cobalt2 ]]
            -- enabled = false,
            "lalitmee/cobalt2.nvim",
            dependencies = { "tjdevries/colorbuddy.nvim", tag = "v1.0.0" },
            dev = true,
            lazy = false,
            priority = 1000,
        },

        {
            enabled = false,
            "lifepillar/vim-gruvbox8",
            lazy = false,
            config = function()
                vim.cmd("colorscheme gruvbox8")
            end,
        },

        { --[[ catppuccin ]]
            enabled = false,
            "catppuccin/nvim",
            lazy = false,
            priority = 1000,
            name = "catppuccin",
            init = function()
                require("catppuccin").setup({
                    flavour = "mocha", -- latte, frappe, macchiato, mocha
                    background = { -- :h background
                        light = "latte",
                        dark = "mocha",
                    },
                    transparent_background = true,
                    show_end_of_buffer = false, -- show the '~' characters after the end of buffers
                    term_colors = true,
                    integrations = {
                        cmp = true,
                        fidget = true,
                        gitsigns = true,
                        harpoon = true,
                        hop = true,
                        notify = true,
                        octo = true,
                        overseer = true,
                        semantic_tokens = true,
                        telescope = true,
                        treesitter_context = true,
                        which_key = true,
                    },
                })

                vim.cmd.colorscheme("catppuccin")
            end,
        },

        { --[[ rose-pine ]]
            "rose-pine/neovim",
            lazy = false,
            priority = 1000,
            name = "rose-pine",
            init = function()
                require("rose-pine").setup({
                    --- @usage 'auto'|'main'|'moon'|'dawn'
                    variant = "main",
                    --- @usage 'main'|'moon'|'dawn'
                    dark_variant = "main",
                    bold_vert_split = false,
                    dim_nc_background = false,
                    disable_background = true,
                    disable_float_background = true,
                    disable_italics = false,

                    -- Change specific vim highlight groups
                    -- https://github.com/rose-pine/neovim/wiki/Recipes
                    highlight_groups = {
                        ColorColumn = { bg = "rose" },

                        -- Blend colours against the "base" background
                        CursorLine = { bg = "foam", blend = 10 },
                        StatusLine = { fg = "love", bg = "love", blend = 10 },
                    },
                })

                -- Set colorscheme after options
                vim.cmd.colorscheme("rose-pine")
            end,
            enabled = false,
        },

        { --[[ vscode ]]
            enabled = false,
            "Mofiqul/vscode.nvim",
            lazy = false,
            priority = 1000,
            init = function()
                require("vscode").setup({
                    transparent = true,
                    italic_comments = true,

                    group_overrides = {
                        NormalFloat = { bg = nil },
                    },
                })
                require("vscode").load()
            end,
        },

        { --[[ tokyonight ]]
            enabled = false,
            "folke/tokyonight.nvim",
            lazy = false,
            priority = 1000,
            opts = {},
            init = function()
                vim.cmd.colorscheme("tokyonight")
            end,
        },

        { --[[ github theme ]]
            enabled = false,
            "projekt0n/github-nvim-theme",
            name = "github-theme",
            lazy = false,
            priority = 1000,
            config = function()
                require("github-theme").setup({})

                vim.cmd("colorscheme github_dark")
            end,
        },
    },

    { --[[ colorizer ]]
        "NvChad/nvim-colorizer.lua",
        cmd = { "ColorizerToggle" },
        keys = {
            { "<leader>ac", ":ColorizerToggle<CR>", desc = "Toggle Colorizer" },
        },
        config = true,
    },
}
