setlocal foldmethod=expr
setlocal foldexpr=nvim_treesitter#foldexpr()
setlocal foldlevel=99

set formatoptions-=o

autocmd FileType lua setlocal sw=2 sts=2 ts=2 tw=80 et


nnoremap <buffer><silent><leader>nl :execute "luafile %"
      \ <bar> :call utils#message('Sourced ' . expand('%'), 'Title')<CR>

