-- require("colorbuddy").colorscheme("cobalt2")

--------------------------------------------------------------------------------
--  NOTE: Catppuccin {{{
--------------------------------------------------------------------------------
vim.g.catppuccin_flavour = "macchiato"
-- vim.g.catppuccin_flavour = "frappe"
-- vim.g.catppuccin_flavour = "mocha"
-- vim.g.catppuccin_flavour = "latte"
require("catppuccin").setup({
    transparent_background = true,
    term_colors = true,
})
vim.api.nvim_command([[colorscheme catppuccin]])
-- }}}
--------------------------------------------------------------------------------
