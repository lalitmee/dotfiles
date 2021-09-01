-- :h g:incsearch#auto_nohlsearch
vim.cmd [[let g:incsearch#auto_nohlsearch = 1]]
vim.cmd [[map n  <Plug>(incsearch-nohl-n)<Cmd>lua require('hlslens').start()<CR>]]
vim.cmd [[map N  <Plug>(incsearch-nohl-N)<Cmd>lua require('hlslens').start()<CR>]]
vim.cmd [[map *  <Plug>(incsearch-nohl-*)<Cmd>lua require('hlslens').start()<CR>]]
vim.cmd [[map #  <Plug>(incsearch-nohl-#)<Cmd>lua require('hlslens').start()<CR>]]
vim.cmd [[map g* <Plug>(incsearch-nohl-g*)<Cmd>lua require('hlslens').start()<CR>]]
vim.cmd [[map g# <Plug>(incsearch-nohl-g#)<Cmd>lua require('hlslens').start()<CR>]]
