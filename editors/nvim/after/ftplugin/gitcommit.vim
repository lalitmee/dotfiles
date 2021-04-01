setlocal nolist nonumber norelativenumber

"the queen's English..
setlocal spell spelllang=en_gb

" Disable showing tabs locally
setlocal listchars=tab:\ \ ,

" Set color column at maximum commit summary length
setlocal colorcolumn=50,72
set formatoptions-=o
autocmd FileType gitcommit setlocal sw=2 sts=2 ts=2 et
