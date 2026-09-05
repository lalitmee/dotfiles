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

local bufname = vim.api.nvim_buf_get_name(0)

-- Explicitly disable spell check for guh buffers
if bufname:match("^guh://") then
    opt.spell = false
end

local commit_msg = require("plugins.git.commit_msg")

-- Keymap to manually regenerate commit message on demand
vim.keymap.set("n", "<localleader>cg", function()
    commit_msg.generate(0)
end, { buffer = true, desc = "Regenerate AI Commit Message" })

-- Auto-generate on buffer load
if not vim.b.gitcommit_loaded then
    vim.b.gitcommit_loaded = true
    commit_msg.auto_generate(0)
end
