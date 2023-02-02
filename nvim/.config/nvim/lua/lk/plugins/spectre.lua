local M = {
    "nvim-pack/nvim-spectre",
    cmd = {
        "SpectreOpen",
        "SpectreCurWord",
        "SpectreVisual",
        "SpectreCurFileSearch",
    },
}

 M.config = function()
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
end

return M
