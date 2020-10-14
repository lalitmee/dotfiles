nnoremap <Leader>i <cmd>lua require'telescope.builtin'.git_files{}<CR>
nnoremap <Leader>j <cmd>lua require'telescope.builtin'.find_files{}<CR>
nnoremap <silent> gr <cmd>lua require'telescope.builtin'.lsp_references{}<CR>
nnoremap <Leader>d <cmd>lua require'telescope.builtin'.find_files{ cwd = "~/.config/nvim/" }<CR>
