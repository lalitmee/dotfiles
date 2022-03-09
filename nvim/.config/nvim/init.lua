-- ╭──────────────────────────────────────────────────────────╮
-- │           https://github.com/lalitmee/dotfiles           │
-- │                 Created By: Lalit Kumar                  │
-- ╰──────────────────────────────────────────────────────────╯

pcall(require, "impatient")
pcall(function()
  require("impatient").enable_profile()
end)

require("lk/profile")
if require("lk/first_load")() then
  return
end

----------------------------------------------------------------------
-- NOTE: leaders {{{
----------------------------------------------------------------------
-- mapping leader and localleader keys
vim.g.mapleader = " " -- NOTE: leader is `<space>`
vim.g.maplocalleader = "," -- NOTE: local leader is ,
-- }}}
----------------------------------------------------------------------

----------------------------------------------------------------------
-- NOTE: sourcing namespace {{{
----------------------------------------------------------------------
require("lk")
-- }}}
----------------------------------------------------------------------

-- vim:foldmethod=marker
