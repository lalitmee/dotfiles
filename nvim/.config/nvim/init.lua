-- ╭──────────────────────────────────────────────────────────╮
-- │           https://github.com/lalitmee/dotfiles           │
-- │                 Created By: Lalit Kumar                  │
-- ╰──────────────────────────────────────────────────────────╯

-- nvim ui2
require("vim._core.ui2")

-- NOTE: globals should be the first thing to load
require("globals")
require("core.env")

----------------------------------------------------------------------
-- NOTE: globals {{{
----------------------------------------------------------------------

-- mapping leader and localleader keys
vim.g.mapleader = " " -- NOTE: leader is `<space>`
vim.g.maplocalleader = "," -- NOTE: local leader is ,

-- }}}
----------------------------------------------------------------------

----------------------------------------------------------------------
-- NOTE: sourcing {{{
----------------------------------------------------------------------
-- plugins
require("pack_init")

-- utils
require("utils")

-- core
require("core")

-- plugin configuration
require("plugins")

-- }}}
----------------------------------------------------------------------

-- vim:foldmethod=marker
