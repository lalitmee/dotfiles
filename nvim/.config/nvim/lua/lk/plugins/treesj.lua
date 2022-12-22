local M = {
    "Wansmer/treesj",
    cmd = { "TSJToggle", "TSJSplit", "TSJJoin" },
    keys = { "gS", "gJ" },
}

function M.config()
    local ok, treesj = lk.require("treesj")
    if not ok then
        return
    end

    treesj.setup({})

    local opts = { silent = true }

    lk.nnoremap("gS", [[<cmd>TSJSplit<CR>]], opts)
    lk.nnoremap("gJ", [[<cmd>TSJJoin<CR>]], opts)
end

return M
