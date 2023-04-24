local M = {
    "ThePrimeagen/refactoring.nvim",
    event = "VeryLazy",
    dependencies = {
        { "nvim-lua/plenary.nvim" },
        { "nvim-treesitter/nvim-treesitter" },
    },
}

M.config = function()
    require("refactoring").setup()

    require("telescope").load_extension("refactoring")
end

return M
