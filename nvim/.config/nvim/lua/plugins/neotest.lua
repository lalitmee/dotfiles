return {
    "nvim-neotest/neotest",
    dependencies = {
        "nvim-lua/plenary.nvim",
        "nvim-treesitter/nvim-treesitter",
        "antoinemadec/FixCursorHold.nvim",
        "haydenmeade/neotest-jest",
    },
    config = function()
        require("neotest").setup({
            adapters = {
                require("neotest-jest")({
                    jestCommand = "jest",
                    jestConfigFile = "package.json",
                    env = { jsdom = true },
                    cwd = function()
                        vim.notify("cwd: " .. vim.fn.getcwd())
                        return vim.fn.getcwd()
                    end,
                }),
            },
        })
    end,
}
