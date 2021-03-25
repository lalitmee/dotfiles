setlocal foldmethod=marker
setlocal foldmarker={{{,}}}
setlocal foldlevel=0
" noremap <TAB> za

nnoremap <silent><buffer><leader>nl :source % <bar> :call utils#message('Sourced ' . expand('%'), 'Title')<CR>
