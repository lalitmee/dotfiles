local ufo = require("ufo")

vim.opt.sessionoptions:append("folds")
-- vim.wo.foldcolumn = "5"
vim.wo.foldlevel = 99 -- feel free to decrease the value
vim.wo.foldenable = true

lk.nnoremap("zR", ufo.openAllFolds, "open all folds")
lk.nnoremap("zM", ufo.closeAllFolds, "close all folds")

ufo.setup({
  open_fold_hl_timeout = 0,
  -- fold_virt_text_handler = handler,
})
