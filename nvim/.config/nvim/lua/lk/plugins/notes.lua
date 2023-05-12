local orgmode = {
    "nvim-orgmode/orgmode",
    ft = { "org" },
    dependencies = {
        {
            "akinsho/org-bullets.nvim",
            config = true,
        },
    },
    config = function()
        local orgmode = require("orgmode")
        orgmode.setup({
            org_agenda_files = { "~/org" },
            org_default_notes_file = "~/Desktop/Github/dNotes/notes/index.org",
        })
        orgmode.setup_ts_grammar()
    end,
}

local neorg = {
    "nvim-neorg/neorg",
    cmd = { "Neorg" },
    ft = "norg",
    build = ":Neorg sync-parsers",
    opts = {
        load = {
            ["core.defaults"] = {},
            ["core.clipboard"] = {},
            ["core.clipboard.code-blocks"] = {},
            ["core.concealer"] = {},
            ["core.keybinds"] = {},
            ["core.integrations.telescope"] = {},
            ["core.completion"] = {
                config = {
                    engine = "nvim-cmp",
                },
            },
            ["core.dirman"] = {
                config = {
                    workspaces = {
                        notes = "~/Desktop/Github/notes",
                        ["work-notes"] = "~/Documents/notes",
                    },
                },
            },
        },
    },
    dependencies = {
        { "nvim-lua/plenary.nvim" },
        { "nvim-neorg/neorg-telescope" },
    },
}

return {
    orgmode,
    neorg,
}
