local opt = vim.opt_local

opt.colorcolumn = { "50", "72" }
opt.expandtab = true
opt.formatoptions = opt.formatoptions - "o" -- don't continue comments on `o` and `O`
opt.list = false
opt.number = false
opt.relativenumber = false
opt.shiftwidth = 4
opt.softtabstop = 4
opt.tabstop = 4
opt.spell = true

vim.keymap.set(
    "n",
    "<leader>cc",
    ":CodeCompanion /commit<CR>",
    { desc = "Generate Commit Msg (CodeCompanion)", buffer = true }
)
