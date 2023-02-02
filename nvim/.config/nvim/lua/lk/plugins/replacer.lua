local M = {
    "gabrielpoca/replacer.nvim",
    cmd = {
        "Replacer",
        "ReplacerFiles",
    },
}

function M.config()
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
end

return M
