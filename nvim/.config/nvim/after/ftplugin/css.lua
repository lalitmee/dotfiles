local opt = vim.opt_local

opt.formatoptions = opt.formatoptions - "o" -- don't continue comments on `o` and `O`
opt.iskeyword = opt.iskeyword + "-"
opt.foldenable = true
opt.foldlevelstart = 99
opt.shiftwidth = 2
opt.softtabstop = 2
opt.tabstop = 2
opt.expandtab = true
