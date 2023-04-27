local M = {
    "nvim-neorg/neorg",
    cmd = { "Neorg" },
    ft = "norg",
    build = ":Neorg sync-parsers",
    opts = {
        load = {
            ["core.defaults"] = {},
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

return M
