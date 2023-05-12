local M = {
    "Wansmer/treesj",
    cmd = {
        "TSJToggle",
        "TSJSplit",
        "TSJJoin",
    },
    keys = { "gS", "gJ" },
    dependencies = {
        "nvim-treesitter/nvim-treesitter",
    },
}

M.config = function()
    require("treesj").setup({
        use_defaul_keymaps = true,
    })

    local nnoremap = lk.nnoremap
    local opts = { silent = true }

    nnoremap("gS", [[<cmd>TSJSplit<CR>]], opts)
    nnoremap("gJ", [[<cmd>TSJJoin<CR>]], opts)
end

return M
