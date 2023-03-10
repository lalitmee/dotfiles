local opt = vim.opt_local

opt.colorcolumn = { "80" }
opt.formatoptions = opt.formatoptions - "o" -- don't continue comments on `o` and `O`
opt.expandtab = true
opt.shiftwidth = 4
opt.softtabstop = 4
opt.tabstop = 4
opt.textwidth = 80
opt.foldlevel = 99
