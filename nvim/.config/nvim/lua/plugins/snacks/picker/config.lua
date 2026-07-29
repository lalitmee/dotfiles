return {
    enabled = true,
    hidden = true,
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
        "--glob=!.git-rewrite",
        "--glob=!.superpowers",
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
        layout = {
            width = 0.85,
            height = 0.85,
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
