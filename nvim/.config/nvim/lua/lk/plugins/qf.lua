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
    config = function()
        local replacer = require("replacer")

        ----------------------------------------------------------------------
        -- NOTE: replacer.nvim commands {{{
        ----------------------------------------------------------------------
        local command = lk.command

        -- this can rename or replace everything in quickfix
        command("ReplacerFiles", function()
            replacer.run()
        end, {})

        -- this will not rename or move file names
        command("Replacer", function()
            replacer.run({ rename_files = false })
        end, {})
        -- }}}
        ----------------------------------------------------------------------
    end,
}

return {
    nvim_bqf,
    replacer,
}
