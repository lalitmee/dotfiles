" set fillchars=fold:-
" let g:crease_foldtext = { 'default': '+-%{repeat("-", v:foldlevel)} %l lines: %t ' }

" set fillchars=fold:\    " space
" let g:crease_foldtext = { 'marker': '%=- %t -%=' }

set fillchars=fold:━
let g:crease_foldtext = { 'default': '%f%f┫ %t ┣%=┫ %l lines ┣%f%f' }

" set fillchars=fold:━
" let g:crease_foldtext = { 'default': '%{repeat("-", v:foldlevel)} %l lines: %t ' }

" set fillchars=fold:‧
" let g:crease_foldtext = { 'default': '%{repeat("  ", v:foldlevel - 1)}%t %= %l lines %f%f' }
