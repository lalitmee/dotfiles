local edgy = {
    "folke/edgy.nvim",
    event = "VeryLazy",
    opts = {
        top = {
            {
                ft = "fugitive",
                size = { height = 0.5 },
                wo = { signcolumn = "yes:2" },
            },
        },
    },
    enabled = false,
}

return {
    edgy,
}
