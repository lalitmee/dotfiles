local hop = {
    "phaazon/hop.nvim",
    branch = "v2",
    cmd = {
        "HopPattern",
        "HopChar1AC",
        "HopChar1BC",
        "HopChar1",
        "HopChar2",
        "HopLineStart",
        "HopLine",
        "HopChar2AC",
        "HopChar2BC",
        "HopWord",
        "HopWordMW",
    },
    config = true,
    init = function()
        local wk = require("which-key")
        wk.register({
            ["j"] = {
                ["name"] = "+jump",
                ["/"] = { ":HopPattern<CR>", "pattern" },
                ["a"] = { ":HopAnywhere<CR>", "anywhere" },
                ["f"] = { ":HopChar1AC<CR>", "char1-ac" },
                ["F"] = { ":HopChar1BC<CR>", "char1-bc" },
                ["j"] = { ":HopChar1<CR>", "char1" },
                ["k"] = { ":HopChar2<CR>", "char2" },
                ["l"] = { ":HopLineStart<CR>", "line-start" },
                ["L"] = { ":HopLine<CR>", "line" },
                ["t"] = { ":HopChar2AC<CR>", "char2-ac" },
                ["T"] = { ":HopChar2BC<CR>", "char2-bc" },
                ["w"] = { ":HopWord<CR>", "word" },
                ["W"] = { ":HopWordMW<CR>", "word-mw" },
            },
        }, { mode = "n", prefix = "<leader>" })
    end,
}

local spectre = {
    "nvim-pack/nvim-spectre",
    cmd = {
        "Spectre",
        "SpectreOpen",
        "SpectreCurWord",
        "SpectreVisual",
        "SpectreCurFileSearch",
    },
    config = function()
        local spectre = require("spectre")

        spectre.setup({
            default = {
                find = {
                    options = { "ignore-case", "hidden", "line-number" },
                },
            },
        })

        ----------------------------------------------------------------------
        -- NOTE: commands {{{
        ----------------------------------------------------------------------
        local command = lk.command

        command("SpectreOpen", function()
            spectre.open()
        end, {})

        command("SpectreCurWord", function()
            spectre.open_visual({ select_word = true })
        end, {})

        command("SpectreVisual", function()
            spectre.open_visual()
        end, { range = "%" })

        command("SpectreCurFileSearch", function()
            spectre.open_file_search()
        end, { range = "%" })

        -- }}}
        ----------------------------------------------------------------------
    end,
}

local vim_cool = {
    "romainl/vim-cool",
    event = { "VeryLazy" },
}

return {
    hop,
    spectre,
    vim_cool,
}
