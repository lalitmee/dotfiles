local refactoring = {
    "ThePrimeagen/refactoring.nvim",
    event = "VeryLazy",
    dependencies = {
        { "nvim-lua/plenary.nvim" },
        { "nvim-treesitter/nvim-treesitter" },
    },
    config = function()
        require("refactoring").setup()

        require("telescope").load_extension("refactoring")
    end,
}

local debugprint = {
    "andrewferrier/debugprint.nvim",
    keys = {
        "g?",
        { "g?", mode = "v" },
    },
    cmd = { "DeleteDebugPrints" },
    opts = {},
}

return {
    refactoring,
    debugprint,
}
