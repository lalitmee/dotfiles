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
require("plugins")
require("lk/globals")
require("lk/settings")
require("lk/highlights")
require("lk/colors")
require("lk/plugins")
require("lk/lsp")
require("lk/telescope")
-- }}}
----------------------------------------------------------------------

-- Cache the humungous packer_compiled.lua file with impatient.nvim
-- for a solid speedup
require("packer_compiled")

-- vim:foldmethod=marker
