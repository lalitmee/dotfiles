local opt = vim.opt

opt.colorcolumn = { "80" }
opt.formatoptions = opt.formatoptions - "o" -- don't continue comments on `o` and `O`
opt.expandtab = true
opt.shiftwidth = 2
opt.softtabstop = 2
opt.tabstop = 2
opt.textwidth = 80
opt.foldlevel = 99
