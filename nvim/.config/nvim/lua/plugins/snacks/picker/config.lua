return {
    enabled = true,
    hidden = true,
    grep = {
        hidden = true,
        exclude = {
            ".git",
            ".git-rewrite",
            ".nx",
            ".superpowers",
            "**/build",
            "**/dist",
            "**/node_modules",
            "yarn.lock",
            "package-lock.json",
        },
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
        layout = {
            width = 0.90,
            height = 0.90,
        },
        config = function(layout)
            for _, child in ipairs(layout.layout or {}) do
                if child.win == "preview" then
                    child.width = 0.6
                end
            end
        end,
    },
    win = {
        input = {
            keys = {
                ["<Esc>"] = { "close", mode = { "i", "n" } },
                ["<C-c>"] = { "close", mode = { "i", "n" } },
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
