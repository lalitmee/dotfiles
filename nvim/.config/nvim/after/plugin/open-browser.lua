vim.g.openbrowser_default_search = "google"

vim.cmd([[nmap gx <Plug>(openbrowser-smart-search)]])
vim.cmd([[vmap gx <Plug>(openbrowser-smart-search)]])

-- devdocs
vim.cmd([[xnoremap <A-s> :<C-u>execute printf('OpenBrowserSmartSearch -devdocs %s %s', &filetype, helpers#general#getwords_last_visual())<CR>]])
vim.cmd([[nnoremap <A-s> :<C-r>=printf('OpenBrowserSmartSearch -devdocs %s ', &filetype)<CR>]])
