" selected item
highlight TelescopeSelection      guifg=#A3BE8C gui=bold

" selection caret
highlight TelescopeSelectionCaret guifg=#B48EAD

" Used for highlighting characters that you match.
highlight TelescopeMatching       guifg=#BF616A
" highlight TelescopeMatching       guifg=#EBCB8B

" Used for the prompt prefix
highlight TelescopePromptPrefix   guifg=#A3BE8C

" Border highlight groups.
highlight TelescopeBorder         guifg=#88C0D0
highlight TelescopePromptBorder   guifg=#88C0D0
highlight TelescopeResultsBorder  guifg=#88C0D0
highlight TelescopePreviewBorder  guifg=#88C0D0

nnoremap <silent> <Leader>jf :lua require'telescope.builtin'.find_files(require('telescope.themes').get_dropdown({}))<cr>

" Change an option
nnoremap <silent> <Leader>jw :lua require'telescope.builtin'.find_files(require('telescope.themes').get_dropdown({ winblend = 30 }))<cr>

nnoremap <silent> <Leader>js :lua require'telescope.builtin'.symbols{ sources = {'emoji'} }<cr>


nnoremap <silent> <leader>jn :lua require'finders'.fd_in_nvim()<cr>
nnoremap <silent> <leader>jd :lua require'finders'.fd()<cr>

