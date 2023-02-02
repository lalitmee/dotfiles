local M = {
    "ThePrimeagen/refactoring.nvim",
    keys = { "<leader>rr" },
    dependencies = {
        { "nvim-lua/plenary.nvim" },
        { "nvim-treesitter/nvim-treesitter" },
    },
}

M.config = function()
    require("refactoring").setup({})

    require("telescope").load_extension("refactoring")
end

return M
