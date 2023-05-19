return {
    {
        "andymass/vim-matchup",
        event = "BufReadPost",
        config = function()
            vim.g.matchup_matchparen_offscreen = { method = "status_manual" }
        end,
    },
    {
        "christoomey/vim-sort-motion",
        keys = {
            "gs",
            { "gs", mode = "v" },
        },
    },
    {
        "famiu/bufdelete.nvim",
        cmd = { "Bdelete" },
    },
    {
        "godlygeek/tabular",
        cmd = { "Tabularize" },
    },
    {
        "kylechui/nvim-surround",
        keys = {
            "ds",
            "ys",
            "cs",
        },
        opts = {},
    },
    {
        "mizlan/iswap.nvim",
        cmd = { "ISwapWith", "ISwap" },
    },
    {
        "kevinhwang91/nvim-fundo",
        dependencies = { "kevinhwang91/promise-async" },
        build = function()
            require("fundo").install()
        end,
    },
    {
        "Pocco81/auto-save.nvim",
        event = { "VeryLazy" },
        cmd = { "ASToggle" },
        opts = {
            enabled = true,
        },
        init = function()
            local wk = require("which-key")
            wk.register({
                ["a"] = {
                    ["s"] = { ":ASToggle<CR>", "toggle-auto-save" },
                },
            }, { mode = "n", prefix = "<leader>" })
        end,
        enabled = false,
    },
}
