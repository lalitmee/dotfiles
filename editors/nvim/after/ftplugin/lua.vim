setlocal expandtab
setlocal tabstop=2
setlocal softtabstop=2
setlocal shiftwidth=2
setlocal textwidth=80

nnoremap <buffer><silent><leader>nl :execute "luafile %"
      \ <bar> :call utils#message('Sourced ' . expand('%'), 'Title')<CR>

