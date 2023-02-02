local M = {
    "kevinhwang91/nvim-ufo",
    dependencies = { "kevinhwang91/promise-async" },
    event = "BufReadPost",
}

 M.config = function()
    local ufo = require("ufo")

    vim.opt.sessionoptions:append("folds")
    -- vim.o.foldcolumn = "5"
    vim.o.foldlevel = 99
    vim.o.foldenable = true

    lk.nnoremap("zR", ufo.openAllFolds, { desc = "open all folds" })
    lk.nnoremap("zM", ufo.closeAllFolds, { desc = "close all folds" })

    ufo.setup({
        open_fold_hl_timeout = 0,
        -- fold_virt_text_handler = handler,
    })
end

return M

-- vim:fdm=marker
