" " " selected item
" highlight TelescopeSelection    guibg=#3E5D75  gui=bold

" " selection caret
" highlight TelescopeSelectionCaret guibg=#3E5D75 guifg=#FFFFFF

" " " Used for highlighting characters that you match.
" highlight TelescopeMatching       guifg=#CC6666

" " Used for the prompt prefix
" highlight TelescopePromptPrefix   guifg=#FFFFFF

nnoremap <silent> <leader>ja :lua require('config.telescope.finders').search_dotfiles()<cr>
nnoremap <silent> <Leader>jb :lua require('telescope.builtin').buffers({ entry_maker = require('config.telescope.my_make_entry').gen_from_buffer_like_leaderf() }) <cr>
nnoremap <silent> <leader>jc :lua require('telescope_checkout.init').checkout{}<CR>
nnoremap <silent> <leader>jd :lua require('config.telescope.finders').fd()<cr>
nnoremap <silent> <leader>je :lua require('config.telescope.finders').search_nvim_config()<cr>
nnoremap <silent> <leader>jf :lua require('config.telescope.finders').fd_files_dropdown()<cr>
nnoremap <silent> <leader>jg :lua require('config.telescope.finders').fd_full()<cr>
nnoremap <silent> <leader>jw :lua require('config.telescope').extensions.fzf_writer.staged_grep()<cr>
nnoremap <silent> <leader>ji :lua require('telescope.builtin').symbols{sources = {'emoji'}}<cr>



autocmd User TelescopePreviewerLoaded setlocal wrap
