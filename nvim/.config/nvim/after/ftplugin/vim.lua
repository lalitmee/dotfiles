local opt = vim.opt

opt.expandtab = true
opt.foldlevel = 99
opt.formatoptions = opt.formatoptions - "o" -- don't continue comments on `o` and `O`
opt.shiftwidth = 4
opt.softtabstop = 4
opt.tabstop = 4
