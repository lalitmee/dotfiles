local opt = vim.opt

opt.colorcolumn = { "80" }
opt.formatoptions = opt.formatoptions - "o" -- don't continue comments on `o` and `O`
