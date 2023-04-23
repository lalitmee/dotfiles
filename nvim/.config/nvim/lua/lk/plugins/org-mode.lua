local M = {
    "nvim-orgmode/orgmode",
    ft = { "org" },
    dependencies = {
        {
            "akinsho/org-bullets.nvim",
            config = true,
        },
    },
}

M.config = function()
    local orgmode = require("orgmode")
    orgmode.setup({
        org_agenda_files = { "~/org" },
        org_default_notes_file = "~/Desktop/Github/dNotes/notes/index.org",
    })
    orgmode.setup_ts_grammar()
end

return M
