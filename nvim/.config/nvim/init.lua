-- [[
-- https://github.com/lalitmee/dotfiles
-- NOTE: Created By: Lalit Kumar
-- ]]
local cmd = vim.api.nvim_command

pcall(require, 'impatient')
-- require'impatient'.enable_profile()

-- require('packer_compiled')

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

-- [[
-- NOTE: orgmode setup starts
-- ]]

local parser_config = require'nvim-treesitter.parsers'.get_parser_configs()
parser_config.org = {
  install_info = {
    url = 'https://github.com/milisims/tree-sitter-org',
    revision = 'f110024d539e676f25b72b7c80b0fd43c34264ef',
    files = { 'src/parser.c', 'src/scanner.cc' },
  },
  filetype = 'org',
}

require'nvim-treesitter.configs'.setup {
  -- If TS highlights are not enabled at all, or disabled via `disable` prop, highlighting will fallback to default Vim syntax highlighting
  highlight = {
    enable = true,
    disable = { 'org' }, -- Remove this to use TS highlighter for some of the highlights (Experimental)
    additional_vim_regex_highlighting = { 'org' }, -- Required since TS highlighter doesn't support all syntax features (conceal)
  },
  ensure_installed = { 'org' }, -- Or run :TSUpdate org
}

-- require('orgmode').setup({
--   org_agenda_files = {'~/Dropbox/org/*', '~/my-orgs/**/*'},
--   org_default_notes_file = '~/Dropbox/org/refile.org',
-- })

-- [[
-- NOTE: orgmode setup ends
-- ]]

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
