local opt = vim.opt_local

opt.formatoptions = opt.formatoptions - "o" -- don't continue comments on `o` and `O`
opt.shiftwidth = 4
opt.softtabstop = 4
opt.tabstop = 4
opt.expandtab = true
