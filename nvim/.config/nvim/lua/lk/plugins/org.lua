local M = {
    "nvim-orgmode/orgmode",
    ft = "org",
    dependencies = {
        "akinsho/org-bullets.nvim",
    },
}

M.config = function()
    require("orgmode").setup_ts_grammar()
    require("orgmode").setup({
        org_agenda_files = { "~/Desktop/Github/dNotes/agenda/index.org" },
        org_default_notes_file = "~/Desktop/Github/dNotes/notes/index.org",
    })
    require("org-bullets").setup({
        concealcursor = false, -- If false then when the cursor is on a line underlying characters are visible
        symbols = {
            list = "•",
            headlines = { "◉", "○", "✸", "✿" },
            checkboxes = {
                half = { "", "OrgTSCheckboxHalfChecked" },
                done = { "✓", "OrgDone" },
                todo = { "˟", "OrgTODO" },
            },
        },
    })
end

return M
