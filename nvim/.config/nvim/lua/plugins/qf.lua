local nvim_bqf = {
    "kevinhwang91/nvim-bqf",
    ft = "qf",
    dependencies = {
        url = "https://gitlab.com/yorickpeterse/nvim-pqf.git",
        ft = "qf",
        config = function()
            require("pqf").setup()
        end,
    },
    config = function()
        require("bqf").setup({
            auto_enable = true,
            preview = { auto_previw = true, win_height = 25, win_vheight = 25 },
            filter = {
                fzf = {
                    extra_opts = {
                        "--bind",
                        "ctrl-s:select-all,ctrl-d:deselect-all",
                        "--prompt",
                        "Filter > ",
                    },
                },
            },
        })
    end,
}

local replacer = {
    "gabrielpoca/replacer.nvim",
    cmd = {
        "Replacer",
        "ReplacerFiles",
    },
    init = function()
        local wk = require("which-key")
        local replacer = require("replacer")

        wk.register({
            ["q"] = {
                ["f"] = {
                    function()
                        replacer.run()
                    end,
                    "replacer-files",
                },
                ["r"] = {
                    function()
                        replacer.run({ rename_files = false })
                    end,
                    "replacer",
                },
            },
        }, { mode = "n", prefix = "<leader>" })
    end,
}

return {
    nvim_bqf,
    replacer,
}
