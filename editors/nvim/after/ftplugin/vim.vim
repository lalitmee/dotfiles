setlocal foldmethod=marker
setlocal foldmarker={{{,}}}
setlocal foldlevel=0

autocmd FileType vim setlocal ts=2 sw=2 sts=2 et

nnoremap <silent><buffer><leader>nl :source % <bar> :call utils#message('Sourced ' . expand('%'), 'Title')<CR>
set formatoptions-=o
