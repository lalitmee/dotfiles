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
            { "ys", mode = "v" },
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
}
