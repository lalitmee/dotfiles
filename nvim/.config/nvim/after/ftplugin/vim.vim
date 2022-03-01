setlocal foldmethod=marker
setlocal foldmarker={{{,}}}
setlocal foldlevel=0

autocmd FileType vim setlocal ts=2 sw=2 sts=2 et

nnoremap <buffer><silent><leader>nl :source % <bar> :lua vim.notify('  ' .. vim.fn.expand('%'), 'info', { title = 'Sourced File' })<CR>

set formatoptions-=o
