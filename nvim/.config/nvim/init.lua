-- ╭──────────────────────────────────────────────────────────╮
-- │           https://github.com/lalitmee/dotfiles           │
-- │                 Created By: Lalit Kumar                  │
-- ╰──────────────────────────────────────────────────────────╯

-- NOTE: globals should be the first thing to load
require("globals")

----------------------------------------------------------------------
-- NOTE: globals {{{
----------------------------------------------------------------------
-- mapping leader and localleader keys
vim.g.mapleader = " " -- NOTE: leader is `<space>`
vim.g.maplocalleader = "," -- NOTE: local leader is ,
vim.g.os = vim.uv.os_uname().sysname
vim.g.open_command = vim.g.os == "Darwin" and "open" or "xdg-open"
-- }}}
----------------------------------------------------------------------

----------------------------------------------------------------------
-- NOTE: sourcing {{{
----------------------------------------------------------------------
-- core
require("config/core")

-- plugins
require("config/lazy")
-- }}}
----------------------------------------------------------------------

--------------------------------------------------------------------------------
--  NOTE: neovide settings {{{
--------------------------------------------------------------------------------
if vim.fn.exists("g:neovide") then
    -- vim.g.neovide_fullscreen = true
    -- vim.g.neovide_cursor_vfx_mode = "torpedo"
    vim.g.neovide_transparency = 0.9
    vim.g.neovide_floating_blur_amount_x = 2.0
    vim.g.neovide_floating_blur_amount_y = 2.0
end
-- }}}
--------------------------------------------------------------------------------

-- vim:foldmethod=marker
