local M = {
    "kevinhwang91/nvim-ufo",
    dependencies = { "kevinhwang91/promise-async" },
    event = "BufReadPost",
}

M.config = function()
    local ufo = require("ufo")

    vim.opt.sessionoptions:append("folds")
    vim.o.foldcolumn = "0"
    vim.o.foldlevel = 1
    vim.o.foldlevelstart = 99
    vim.o.foldenable = true

    lk.nnoremap("zR", ufo.openAllFolds, { desc = "open all folds" })
    lk.nnoremap("zM", ufo.closeAllFolds, { desc = "close all folds" })
    lk.nnoremap(
        "zr",
        require("ufo").openFoldsExceptKinds,
        { desc = "open folds except kinds" }
    )
    lk.nnoremap(
        "zm",
        require("ufo").closeFoldsWith,
        { desc = "close folds with" }
    )
    lk.nnoremap("zk", function()
        local winid = require("ufo").peekFoldedLinesUnderCursor()
        if not winid then
            vim.lsp.buf.hover()
        end
    end, { desc = "preview fold" })

    ufo.setup({
        open_fold_hl_timeout = 0,
        provider_selector = function()
            return { "treesitter", "indent" }
        end,
    })
end

return M
