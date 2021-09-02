-- custom setup for showing the virtual text
-- require('hlslens').setup({ calm_down = true })
-- vim.cmd [[nnoremap  n <Plug>(incsearch-nohl-n)<Cmd>execute('normal! ' . v:count1 . 'n')<CR><Cmd>lua require('hlslens').start()<CR>]]
-- vim.cmd [[nnoremap  N <Plug>(incsearch-nohl-N)<Cmd>execute('normal! ' . v:count1 . 'N')<CR><Cmd>lua require('hlslens').start()<CR>]]
-- vim.cmd [[nnoremap * <Plug>(incsearch-nohl-*)*<Cmd>lua require('hlslens').start()<CR>]]
-- vim.cmd [[nnoremap # <Plug>(incsearch-nohl-#)#<Cmd>lua require('hlslens').start()<CR>]]
-- vim.cmd [[nnoremap g* <Plug>(incsearch-nohl-g*)g*<Cmd>lua require('hlslens').start()<CR>]]
-- vim.cmd [[nnoremap g# <Plug>(incsearch-nohl-g#)g#<Cmd>lua require('hlslens').start()<CR>]]

vim.cmd [[let g:incsearch#auto_nohlsearch = 1]]
vim.cmd [[map n  <Plug>(incsearch-nohl-n)<Cmd>lua require('hlslens').start()<CR>]]
vim.cmd [[map N  <Plug>(incsearch-nohl-N)<Cmd>lua require('hlslens').start()<CR>]]
vim.cmd [[map *  <Plug>(incsearch-nohl-*)<Cmd>lua require('hlslens').start()<CR>]]
vim.cmd [[map #  <Plug>(incsearch-nohl-#)<Cmd>lua require('hlslens').start()<CR>]]
vim.cmd [[map g* <Plug>(incsearch-nohl-g*)<Cmd>lua require('hlslens').start()<CR>]]
vim.cmd [[map g# <Plug>(incsearch-nohl-g#)<Cmd>lua require('hlslens').start()<CR>]]
