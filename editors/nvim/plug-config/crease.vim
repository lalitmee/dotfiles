set fillchars=fold:-
let g:crease_foldtext = { 'default': '+-%{repeat("-", v:foldlevel)} %l lines: %t ' }

" set fillchars=fold:\    " space
" let g:crease_foldtext = { 'marker': '%=- %t -%=' }

" set fillchars=fold:━
" let g:crease_foldtext = { 'default': '%f%f┫ %t%{CreaseChanged()} ┣%=┫ %l lines ┣%f%f' }

" function! CreaseChanged()
"   return gitgutter#fold#is_changed() ? ' *' : ''
" endfunction
