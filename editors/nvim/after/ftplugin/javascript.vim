setlocal foldmethod=expr
setlocal foldexpr=nvim_treesitter#foldexpr()

" function! JSFolds()
"   let thisline = getline(v:lnum)
"   if thisline =~? '\v^\s*$'
"     return '-1'
"   endif

"   if thisline =~ '^import.*$'
"     return 1
"   else
"     return indent(v:lnum) / &shiftwidth
"   endif
" endfunction


" autocmd FileType javascript,typescript,javascriptreact,typescriptreact,svelte,vim
"       \ setlocal sw=2 sts=2 et

set fillchars=fold:━
let g:crease_foldtext = { 'default': '%{repeat("-", v:foldlevel)} %l lines: %t ' }
