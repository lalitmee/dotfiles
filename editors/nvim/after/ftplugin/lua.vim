autocmd FileType lua setlocal sw=2 sts=2 ts=2 tw=80 et
set formatoptions-=o

nnoremap <buffer><silent><leader>nl :execute "luafile %"
      \ <bar> :call utils#message('Sourced ' . expand('%'), 'Title')<CR>

