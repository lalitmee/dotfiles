setlocal sw=2 sts=2 et

setlocal textwidth=120

setlocal shiftwidth=2
setlocal tabstop=2
setlocal formatoptions-=o


autocmd FileType lua setlocal foldmethod=expr
autocmd FileType lua setlocal foldexpr=nvim_treesitter#foldexpr()
