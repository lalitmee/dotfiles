local nnoremap = lk.nnoremap
local opt = vim.opt_local

local map_opts = { silent = true, buffer = 0 }

nnoremap("<Left>", ":call quickfixed#older()<CR>", map_opts)
nnoremap("<Right>", ":call quickfixed#newer()<CR>", map_opts)

opt.formatoptions = opt.formatoptions - "o" -- don't continue comments on `o` and `O`
