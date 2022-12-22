-- ╭──────────────────────────────────────────────────────────╮
-- │           https://github.com/lalitmee/dotfiles           │
-- │                 Created By: Lalit Kumar                  │
-- ╰──────────────────────────────────────────────────────────╯

-- impatient
pcall(require, "impatient")
pcall(function()
    require("impatient").enable_profile()
end)

----------------------------------------------------------------------
-- NOTE: leaders {{{
----------------------------------------------------------------------
-- mapping leader and localleader keys
vim.g.mapleader = " " -- NOTE: leader is `<space>`
vim.g.maplocalleader = "," -- NOTE: local leader is ,
-- }}}
----------------------------------------------------------------------

----------------------------------------------------------------------
-- NOTE: sourcing {{{
----------------------------------------------------------------------
-- globals
require("lk/globals")

-- packer plugins
require("lk/lazy")

-- }}}
----------------------------------------------------------------------

--------------------------------------------------------------------------------
--  NOTE: neovide settings {{{
--------------------------------------------------------------------------------
if vim.fn.exists("g:neovide") then
    -- vim.g.neovide_fullscreen = true
    -- vim.g.neovide_cursor_vfx_mode = "torpedo"
    vim.g.neovide_transparency = 0.8
    vim.g.neovide_floating_blur_amount_x = 2.0
    vim.g.neovide_floating_blur_amount_y = 2.0
end
-- }}}
--------------------------------------------------------------------------------

-- vim:foldmethod=marker
