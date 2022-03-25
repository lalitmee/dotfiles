" setlocal foldmethod=expr
" setlocal foldexpr=nvim_treesitter#foldexpr()
" setlocal foldlevel=99

set formatoptions-=o
setlocal colorcolumn=120

autocmd FileType lua setlocal sw=2 sts=2 ts=2 tw=80 et
