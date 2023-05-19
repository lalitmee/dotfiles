local refactoring = {
    "ThePrimeagen/refactoring.nvim",
    event = "VeryLazy",
    dependencies = {
        { "nvim-lua/plenary.nvim" },
        { "nvim-treesitter/nvim-treesitter" },
    },
    init = function()
        local refactoring = require("refactoring")
        require("telescope").load_extension("refactoring")
        local wk = require("which-key")
        wk.register({
            ["r"] = {
                name = "+debug",
                ["k"] = {
                    function()
                        refactoring.debug.printf({ below = false })
                    end,
                    "printf-above",
                },
                ["a"] = {
                    function()
                        refactoring.debug.print_var({ normal = true })
                    end,
                    "print-var-normal",
                },
                ["p"] = {
                    function()
                        refactoring.debug.print_var({})
                    end,
                    "print-var",
                },
                ["d"] = {
                    function()
                        refactoring.debug.cleanup({})
                    end,
                    "print-var",
                },
            },
        }, { mode = "n", prefix = "<leader>" })

        wk.register({
            ["r"] = {
                ["p"] = {
                    function()
                        refactoring.debug.print_var({})
                    end,
                    "print-var",
                },
            },
        }, { mode = "v", prefix = "<leader>" })
    end,
    config = true,
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
