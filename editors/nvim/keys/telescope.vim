nnoremap <silent> <Leader>jf :lua require'telescope.builtin'.find_files(require('telescope.themes').get_dropdown({}))<cr>

" Change an option
nnoremap <silent> <Leader>jw :lua require'telescope.builtin'.find_files(require('telescope.themes').get_dropdown({ winblend = 30 }))<cr>

nnoremap <silent> <Leader>js :lua require'telescope.builtin'.symbols{ sources = {'emoji'} }<cr>


nnoremap <silent> <leader>jn :lua require'finders'.fd_in_nvim()<cr>
nnoremap <silent> <leader>jd :lua require'finders'.fd()<cr>

