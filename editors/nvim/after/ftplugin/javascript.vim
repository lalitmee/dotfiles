setlocal foldmethod=expr
setlocal foldexpr=nvim_treesitter#foldexpr()
setlocal foldlevel=99

autocmd FileType gitcommit setlocal sw=2 sts=2 ts=2 et

set formatoptions-=o

let g:vim_jsx_pretty_colorful_config = 1

