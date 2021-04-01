" Set indent width to two spaces
autocmd FileType html setlocal ts=2 sw=2 sts=2 et

" Fix quirkiness in indentation
setlocal indentkeys-=*<Return>

" Make lines longer, and don't break them automatically
setlocal tw=80 linebreak textwidth=80
setlocal nowrap
setlocal matchpairs+=<:>
set formatoptions-=o
