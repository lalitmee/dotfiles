-- custom setup for showing the virtual text
require('hlslens').setup({ calm_down = true })

vim.cmd [[noremap <silent> n <Cmd>execute('normal! ' . v:count1 . 'n')<CR><Cmd>lua require('hlslens').start()<CR>]]
vim.cmd [[noremap <silent> N <Cmd>execute('normal! ' . v:count1 . 'N')<CR><Cmd>lua require('hlslens').start()<CR>]]
vim.cmd [[noremap * *<Cmd>lua require('hlslens').start()<CR>]]
vim.cmd [[noremap # #<Cmd>lua require('hlslens').start()<CR>]]
vim.cmd [[noremap g* g*<Cmd>lua require('hlslens').start()<CR>]]
vim.cmd [[noremap g# g#<Cmd>lua require('hlslens').start()<CR>]]
