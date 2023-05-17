local cobalt2 = {
    dir = "~/Desktop/Github/cobalt2.nvim",
    lazy = false,
    priority = 1000,
    dependencies = { "tjdevries/colorbuddy.nvim" },
    init = function()
        require("colorbuddy").colorscheme("cobalt2")
    end,
    dev = true,
    -- enabled = false,
}

local catppuccin = {
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
    enabled = false,
}

local rose_pine = {
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
}

local vscode = {
    "Mofiqul/vscode.nvim",
    lazy = false,
    priority = 1000,
    init = function()
        require("vscode").setup({
            transparent = true,
            italic_comments = true,
            disable_nvimtree_bg = true,
        })
        require("vscode").load()
    end,
    enabled = false,
}

local function colorschemes()
    return {
        cobalt2,
        rose_pine,
        catppuccin,
        rose_pine,
        vscode,
    }
end

local colorizer = {
    "NvChad/nvim-colorizer.lua",
    cmd = { "ColorizerToggle" },
    config = true,
}
local colortils = {
    "nvim-colortils/colortils.nvim",
    cmd = { "Colortils" },
    opts = {},
}

return {
    colorschemes(),
    colorizer,
    colortils,
}