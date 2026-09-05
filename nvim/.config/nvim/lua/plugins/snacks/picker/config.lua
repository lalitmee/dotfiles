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
        config = function(layout)
            local tree = layout.layout
            if not tree then
                return
            end

            local is_standard_picker = #tree == 2 and (tree[1].win == "preview" or tree[2].win == "preview")

            if is_standard_picker then
                local stacked = vim.o.columns < vim.o.lines or vim.o.columns < 180
                tree.box = stacked and "vertical" or "horizontal"
                tree.width = 0.90
                tree.height = 0.90
                for _, child in ipairs(tree) do
                    if child.win == "preview" then
                        if stacked then
                            child.width = nil
                            child.height = 0.65
                        else
                            child.width = 0.60
                            child.height = nil
                        end
                    end
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
