return {
    ----------------------------------------------------------------------
    --                            edgy.nvim                             --
    ----------------------------------------------------------------------
    {
        "folke/edgy.nvim",
        event = "VeryLazy",
        opts = {
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
                    ft = "gitcommit",
                    size = { height = 0.5 },
                    wo = { signcolumn = "yes:2" },
                },
            },

            bottom = {
                {
                    ft = "NeogitPopup",
                    size = { height = 0.4 },
                    wo = { signcolumn = "yes:2" },
                },
                { ft = "qf", title = "QuickFix" },
            },

            right = {
                {
                    ft = "fugitive",
                    size = { width = 0.5 },
                    wo = { signcolumn = "yes:2" },
                },
                {
                    ft = "spectre_panel",
                    size = { width = 0.5 },
                    wo = { signcolumn = "yes:2" },
                },
                {
                    ft = "oil",
                    size = { width = 0.5 },
                    wo = { signcolumn = "yes:2" },
                    filter = function(_, win)
                        return vim.api.nvim_win_get_config(win).relative == ""
                    end,
                },
            },

            left = {},

            animate = {
                enabled = false,
            },
        },
    },
}
