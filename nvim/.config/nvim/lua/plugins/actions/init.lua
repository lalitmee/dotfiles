local autolist = {
    "gaoDean/autolist.nvim",
    ft = {
        "gitcommit",
        "markdown",
        "plaintex",
        "tex",
        "text",
    },
    config = true,
    init = function()
        local autolist = require("autolist")
        autolist.create_mapping_hook("i", "<CR>", autolist.new)
        autolist.create_mapping_hook("i", "<Tab>", autolist.indent)
        autolist.create_mapping_hook("i", "<S-Tab>", autolist.indent, "<C-D>")
        autolist.create_mapping_hook("n", "dd", autolist.force_recalculate)
        autolist.create_mapping_hook("n", "o", autolist.new)
        autolist.create_mapping_hook("n", "O", autolist.new_before)
        autolist.create_mapping_hook("n", ">>", autolist.indent)
        autolist.create_mapping_hook("n", "<<", autolist.indent)
        autolist.create_mapping_hook("n", "<C-r>", autolist.force_recalculate)
        autolist.create_mapping_hook(
            "n",
            "<leader>x",
            autolist.invert_entry,
            ""
        )
    end,
}

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
    autolist,
}
