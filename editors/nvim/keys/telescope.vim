" " " selected item
" highlight TelescopeSelection    guibg=#3E5D75  gui=bold

" " selection caret
" highlight TelescopeSelectionCaret guibg=#3E5D75 guifg=#FFFFFF

" " " Used for highlighting characters that you match.
" highlight TelescopeMatching       guifg=#CC6666

" " Used for the prompt prefix
" highlight TelescopePromptPrefix   guifg=#FFFFFF

nnoremap <silent> <Leader>obf :lua require('telescope.builtin').buffers({ entry_maker = require('config.telescope.my_make_entry').gen_from_buffer_like_leaderf() }) <cr>
" nnoremap <silent> <leader>ogc :lua require('telescope_checkout.init').checkout{}<CR>
nnoremap <silent> <leader>ofd :lua require('config.telescope.finders').fd_files_dropdown()<cr>
nnoremap <silent> <leader>ow :lua require('config.telescope').extensions.fzf_writer.staged_grep()<cr>
nnoremap <silent> <leader>oa :lua require('telescope.builtin').symbols{sources = {'emoji'}}<cr>


" nnoremap <silent> <leader>ota :lua require('config.telescope.customs').coc_list()<cr>


autocmd User TelescopePreviewerLoaded setlocal wrap
