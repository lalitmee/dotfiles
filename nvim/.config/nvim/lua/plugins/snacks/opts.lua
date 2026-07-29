local picker_config = require("plugins.snacks.picker.config")

return {
    scope = { enabled = true },
    bigfile = { enabled = true },
    dashboard = { enabled = true },
    indent = { enabled = true },
    input = { enabled = true },
    notifier = {
        enabled = true,
        timeout = 3000,
        style = "compact",
        top_down = false,
        margin = { bottom = 1 },
        icons = {
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
    scroll = { enabled = true },
    zen = { enabled = true },
    animate = { enabled = true },
    styles = {
        notification = {
            wo = { wrap = true },
        },
        scratch = {
            width = 120,
            height = 30,
            border = "rounded",
        },
    },
    image = { enabled = true },
    terminal = { enabled = true },
    gh = { enabled = true },
    picker = picker_config,
}