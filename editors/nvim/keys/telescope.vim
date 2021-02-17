" " selected item
" highlight TelescopeSelection    guibg=#81A1C1  guifg=#EBCB8B gui=bold
" " highlight TelescopeSelection    guibg=#D8DEE9  guifg=black gui=bold
" " highlight TelescopeSelection    guibg=#5d7589  guifg=white gui=bold

" " selection caret
" highlight TelescopeSelectionCaret guifg=#B48EAD

" " Used for highlighting characters that you match.
" highlight TelescopeMatching       guifg=#BF616A
" " highlight TelescopeMatching       guifg=#fddc16
" " highlight TelescopeMatching       guifg=yellow

" " Used for the prompt prefix
" highlight TelescopePromptPrefix   guifg=#A3BE8C

" " Border highlight groups.
" highlight TelescopeBorder         guifg=#c78b2a
" highlight TelescopePromptBorder   guifg=#c78b2a
" highlight TelescopeResultsBorder  guifg=#c78b2a
" highlight TelescopePreviewBorder  guifg=#c78b2a

nnoremap <silent> <Leader>jf :lua require'telescope.builtin'.find_files(require('telescope.themes').get_dropdown({}))<cr>

" Change an option
nnoremap <silent> <Leader>jw :lua require'telescope.builtin'.find_files(require('telescope.themes').get_dropdown({ winblend = 30 }))<cr>

nnoremap <silent> <Leader>js :lua require'telescope.builtin'.symbols{ sources = {'emoji'} }<cr>


nnoremap <silent> <leader>jn :lua require'finders'.fd_in_nvim()<cr>
nnoremap <silent> <leader>jd :lua require'finders'.fd()<cr>

