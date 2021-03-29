vim.g.mapleader = ' ' -- Remap leader key
vim.g.maplocalleader = ',' -- Local leader is ,

require('lk.utils')
require('lk.globals')
require('lk.settings')
require('lk.highlights')
-- require('lk.functions')
-- require('lk.mappings')

require('lk.colorscheme')
require('lk.plugins')
require('lk.status-line')

require('lk.lsp')
