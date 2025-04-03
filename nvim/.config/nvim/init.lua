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

-- }}}
----------------------------------------------------------------------

----------------------------------------------------------------------
-- NOTE: sourcing {{{
----------------------------------------------------------------------
-- plugins
require("lazy_init")

-- utils
require("utils")

-- core
require("core")

-- }}}
----------------------------------------------------------------------

-- vim:foldmethod=marker
