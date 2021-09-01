local cmd = vim.api.nvim_command
-- [[
-- https://github.com/lalitmee/dotfiles
-- NOTE: Created By: Lalit Kumar
-- ]]
require('lk/profile')
if require 'lk/first_load'() then
  return
end
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
require('scripts')
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
function Autosync()
  require('nvim-reload').Reload()
  cmd('PackerInstall')
  cmd('PackerCompile')
end
function Autoreload()
  require('nvim-reload').Reload()
end
-- cmd('augroup AutoSync')
-- cmd('autocmd BufWritePost ~/.config/nvim/lua/plugins.lua lua Autosync()')
-- cmd('augroup END')
cmd('augroup AutoReload')
cmd('autocmd BufWritePost ~/.config/nvim/init.lua lua Autoreload()')
cmd('autocmd BufWritePost ~/.config/nvim/lua/*.lua lua Autoreload()')
cmd('augroup END')
