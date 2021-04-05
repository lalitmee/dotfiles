-- [[
-- https://github.com/lalitmee/dotfiles
-- NOTE: Created By: Lalit Kumar
-- ]]
vim.api.nvim_exec([[
   augroup vimrc -- Ensure all autocommands are cleared
   autocmd!
   augroup END
  ]], '')

-- mapping leader and localleader keys
vim.g.mapleader = ' ' -- Remap leader key
vim.g.maplocalleader = ',' -- Local leader is ,

-- sourcing plugins
require('plugins')
require('lk')

-- The operating system is assigned to a global variable that
-- that can be used elsewhere for conditional system based logic
local uname = vim.loop.os_uname()
if uname.sysname == 'Darwin' then
  vim.g.open_command = 'open'
  vim.g.system_name = 'macOS'
  vim.g.is_mac = true
elseif uname.sysname == 'Linux' then
  vim.g.open_command = 'xdg-open'
  vim.g.system_name = 'Linux'
  vim.g.is_linux = true
end
