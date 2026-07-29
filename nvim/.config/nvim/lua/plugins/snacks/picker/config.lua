return {
    enabled = true,
    ripgrep_args = {
        "rg",
        "--hidden",
        "--color=never",
        "--no-heading",
        "--with-filename",
        "--line-number",
        "--column",
        "--smart-case",
        "--trim",
        "--glob=!yarn.lock",
        "--glob=!package-lock.json",
        "--glob=!**/.git",
        "--glob=!**/.nx",
        "--glob=!**/dist",
        "--glob=!**/build",
        "--glob=!**/node_modules",
        "--ignore",
    },
    file_ignore_patterns = {
        "%.otf",
        "%.ttf",
        "%.DS_Store",
        "%.git",
        "node_modules",
    },
    sorting_strategy = "ascending",
    layout = {
        width = 0.95,
        height = 0.95,
    },
    win = {
        input = {
            keys = {
                ["<Esc>"] = { "close", mode = { "n", "i" } },
            },
        },
        list = {
            keys = {
                ["<c-t>"] = function(...)
                    return require("trouble.sources.snacks").actions.open(...)
                end,
            },
        },
    },
    formatters = {
        file = {
            filename_first = true,
        },
    },
}