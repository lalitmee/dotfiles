local opt = vim.opt

opt.wrap = true
opt.colorcolumn = {}
opt.list = false
opt.number = false
opt.relativenumber = false
opt.formatoptions = opt.formatoptions - "o" -- don't continue comments on `o` and `O`

lk.nnoremap("q", "<cmd>quit<CR>", { silent = true, buffer = 0 })
