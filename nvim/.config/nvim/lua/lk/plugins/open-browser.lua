local nmap = lk.nmap
local vmap = lk.vmap
local xnoremap = lk.xnoremap
local nnoremap = lk.nnoremap

vim.g.openbrowser_default_search = "google"

nmap("gx", [[<Plug>(openbrowser-smart-search)]])
vmap("gx", [[<Plug>(openbrowser-smart-search)]])

xnoremap(
  "<A-s>",
  [[:<C-u>execute printf('OpenBrowserSmartSearch -devdocs %s %s', &filetype, helpers#general#getwords_last_visual())<CR>]]
)
nnoremap("<A-s>", [[:<C-r>=printf('OpenBrowserSmartSearch -devdocs %s ', &filetype)<CR>]])
