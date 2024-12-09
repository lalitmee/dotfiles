return {
    "folke/snacks.nvim",
    priority = 1000,
    lazy = false,
    opts = {
        bigfile = { enabled = true },
        dashboard = { enabled = false },
        notifier = {
            enabled = true,
            timeout = 3000,
            style = "compact",
            top_down = false,
            margin = { bottom = 1 },
            icons = {
                -- error = " ",
                -- warn = " ",
                -- info = " ",
                -- debug = " ",
                -- trace = " ",

                debug = " ",
                error = " ",
                info = " ",
                trace = "🖉",
                warn = " ",
            },
        },
        quickfile = { enabled = true },
        statuscolumn = { enabled = true },
        words = { enabled = true },
        styles = {
            notification = {
                wo = { wrap = true }, -- Wrap notifications
            },
        },
    },
}
