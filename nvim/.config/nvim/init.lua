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

vim.api.nvim_exec(
  [[
   augroup vimrc
   autocmd!
   augroup END
  ]],
  ""
)

-- mapping leader and localleader keys
vim.g.mapleader = " " -- Remap leader key
vim.g.maplocalleader = "," -- Local leader is ,

-- sourcing plugins
require("plugins")
require("lk")
