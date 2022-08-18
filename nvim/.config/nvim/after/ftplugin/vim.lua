local opt = vim.opt

opt.expandtab = true
opt.foldlevel = 99
opt.formatoptions = opt.formatoptions - "o" -- don't continue comments on `o` and `O`
opt.shiftwidth = 2
opt.softtabstop = 2
opt.tabstop = 2
