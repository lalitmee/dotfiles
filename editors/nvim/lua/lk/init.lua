vim.g.mapleader = ' ' -- Remap leader key
vim.g.maplocalleader = ',' -- Local leader is ,

require('lk.utils')
require('lk.globals')
require('lk.settings')
require('lk.highlights')
require('lk.folds')
-- require('lk.functions')
-- require('lk.mappings')

require('lk.colorscheme')
require('lk.plugins')
require('lk.statusline')

function _G.__lk_setup_configs()
  require('lk.whitespace').setup()
end
-- delay setting up of some configs like lsp till vim has started
vim.cmd [[autocmd! VimEnter * ++once lua __lk_setup_configs()]]
