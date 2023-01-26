local opt = vim.opt_local

opt.expandtab = true
opt.formatoptions = opt.formatoptions - "o" -- don't continue comments on `o` and `O`
opt.shiftwidth = 4
opt.softtabstop = 4
opt.tabstop = 4

vim.opt_local.makeprg = "python %"
