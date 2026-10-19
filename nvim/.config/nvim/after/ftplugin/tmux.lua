local opt = vim.opt_local

opt.formatoptions = opt.formatoptions - "o"
opt.expandtab = true
opt.shiftwidth = 2
opt.softtabstop = 2
opt.tabstop = 2
opt.textwidth = 80
opt.foldlevel = 99

-- Ensure treesitter doesn't try to highlight tmux
vim.b.treesitter_highlight = false
