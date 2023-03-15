local M = {
    "Wansmer/treesj",
    cmd = { "TSJToggle", "TSJSplit", "TSJJoin" },
    keys = { "gS", "gJ" },
    enabled = false,
}

M.config = function()
    require("treesj").setup({})

    local nnoremap = lk.nnoremap
    local opts = { silent = true }

    nnoremap("gS", [[<cmd>TSJSplit<CR>]], opts)
    nnoremap("gJ", [[<cmd>TSJJoin<CR>]], opts)
end

return M
