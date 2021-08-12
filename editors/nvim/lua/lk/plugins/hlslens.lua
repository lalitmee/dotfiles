-- custom setup for showing the virtual text
require('hlslens').setup({ calm_down = true })

vim.cmd [[nnoremap <silent> n <Cmd>execute('normal! ' . v:count1 . 'n')<CR><Cmd>lua require('hlslens').start()<CR>]]
vim.cmd [[nnoremap <silent> N <Cmd>execute('normal! ' . v:count1 . 'N')<CR><Cmd>lua require('hlslens').start()<CR>]]
vim.cmd [[nnoremap * *<Cmd>lua require('hlslens').start()<CR>]]
vim.cmd [[nnoremap # #<Cmd>lua require('hlslens').start()<CR>]]
vim.cmd [[nnoremap g* g*<Cmd>lua require('hlslens').start()<CR>]]
vim.cmd [[nnoremap g# g#<Cmd>lua require('hlslens').start()<CR>]]
