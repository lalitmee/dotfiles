setlocal foldmethod=expr
setlocal foldexpr=nvim_treesitter#foldexpr()
setlocal foldlevel=99
noremap <TAB> za

setlocal expandtab
setlocal tabstop=2
setlocal softtabstop=2
setlocal shiftwidth=2

" set fillchars=fold:━
" let g:crease_foldtext = { 'default': '%{repeat("-", v:foldlevel)} %l lines: %t ' }

let g:vim_jsx_pretty_colorful_config = 1

