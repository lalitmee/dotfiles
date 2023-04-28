return {
    "catppuccin/nvim",
    event = { "ColorSchemePre" },
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
            dim_inactive = {
                enabled = false,
                shade = "dark",
                percentage = 0.15,
            },
            no_italic = false, -- Force no italic
            no_bold = false, -- Force no bold
            styles = {
                comments = { "italic" },
                conditionals = { "italic" },
                loops = {},
                functions = {},
                keywords = { "italic" },
                strings = {},
                variables = {},
                numbers = {},
                booleans = {},
                properties = {},
                types = {},
                operators = {},
            },
            color_overrides = {},
            custom_highlights = {},
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
    -- enabled = false,
}
