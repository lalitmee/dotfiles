local opt = vim.opt_local

opt.expandtab = true
opt.formatoptions = opt.formatoptions - "o" -- don't continue comments on `o` and `O`
opt.indentkeys = { "*<Return>" } -- Fix quirkiness in indentation
opt.linebreak = true
opt.matchpairs = opt.matchpairs + "<:>"
opt.shiftwidth = 2
opt.softtabstop = 2
opt.tabstop = 2
opt.textwidth = 80
opt.wrap = false
