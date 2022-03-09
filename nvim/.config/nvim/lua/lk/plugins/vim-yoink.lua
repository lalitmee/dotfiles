local nmap = lk.nmap
local xmap = lk.xmap

local map_opts = {}

nmap("<C-n>", "<Plug>(YoinkPostPasteSwapForward)", map_opts)
nmap("<C-p>", "<Plug>(YoinkPostPasteSwapBack)", map_opts)
nmap("p", "<Plug>(YoinkPaste_p)", map_opts)
nmap("P", "<Plug>(YoinkPaste_P)", map_opts)
nmap("gp", "<Plug>(YoinkPaste_gp)", map_opts)
nmap("gP", "<Plug>(YoinkPaste_gP)", map_opts)
nmap("[y", "<Plug>(YoinkRotateBack)", map_opts)
nmap("]y", "<Plug>(YoinkRotateForward)", map_opts)
nmap("y", "<Plug>(YoinkYankPreserveCursorPosition)", map_opts)
nmap("[y", "<Plug>(YoinkRotateBack)", map_opts)
xmap("y", "<Plug>(YoinkYankPreserveCursorPosition)", map_opts)

vim.g.yoinkMaxItems = 100
vim.g.yoinkSavePersistently = 1
vim.g.yoinkIncludeDeleteOperations = 1

-- vim:foldmethod=marker
