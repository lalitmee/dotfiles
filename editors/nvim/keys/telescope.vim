" NOTE: Telescope settings

" Telescope key mappings {{{

nnoremap <silent> <Leader>obf :lua
      \ require('telescope.builtin')
      \ .buffers({
      \ entry_maker = require('lk.plugins.telescope.my_make_entry')
      \ .gen_from_buffer_like_leaderf() })<cr>

" nnoremap <silent> <leader>ogc :lua require('telescope_checkout.init').checkout{}<CR>

nnoremap <silent> <leader>ofd :lua require('lk.plugins.telescope.finders').fd_files_dropdown()<cr>
nnoremap <silent> <leader>ow :lua require('telescope').extensions.fzf_writer.staged_grep{}<cr>
nnoremap <silent> <leader>oa :lua require('telescope.builtin').symbols{sources = {'emoji'}}<cr>

" nnoremap <silent> <leader>ota :lua require('config.telescope.customs').coc_list()<cr>

" }}}

autocmd User TelescopePreviewerLoaded setlocal wrap
