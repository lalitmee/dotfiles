-- org filetype configuration

-- Use treesitter for folding
vim.opt_local.foldmethod = "expr"
vim.opt_local.foldexpr = "nvim_treesitter#foldexpr()"
vim.opt_local.foldlevel = 99 -- Start with all folds open

-- Better looking org files
vim.opt_local.conceallevel = 2
