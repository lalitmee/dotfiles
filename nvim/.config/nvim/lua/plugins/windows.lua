return {
    ----------------------------------------------------------------------
    --                            edgy.nvim                             --
    ----------------------------------------------------------------------
    {
        "folke/edgy.nvim",
        event = "VeryLazy",
        opts = {
            ----------------------------------------------------------------------
            --                           top windows                            --
            ----------------------------------------------------------------------
            top = {
                {
                    ft = "help",
                    size = { height = 45 },
                    -- only show help buffers
                    filter = function(buf)
                        return vim.bo[buf].buftype == "help"
                    end,
                    wo = { signcolumn = "yes:2" },
                },
                {
                    ft = "fugitive",
                    size = { height = 0.5 },
                    wo = { signcolumn = "yes:2" },
                },
                {
                    ft = "gitcommit",
                    size = { height = 0.5 },
                    wo = { signcolumn = "yes:2" },
                },
            },

            ----------------------------------------------------------------------
            --                          bottom windows                          --
            ----------------------------------------------------------------------
            bottom = {
                {
                    ft = "NeogitPopup",
                    size = { height = 0.4 },
                    wo = { signcolumn = "yes:2" },
                },
                { ft = "qf", title = "QuickFix" },
            },

            ----------------------------------------------------------------------
            --                          right windows                           --
            ----------------------------------------------------------------------
            right = {
                {
                    ft = "spectre_panel",
                    size = { height = 0.4 },
                    wo = { signcolumn = "yes:2" },
                },
            },

            animate = {
                enabled = false,
            },
        },
    },
}
