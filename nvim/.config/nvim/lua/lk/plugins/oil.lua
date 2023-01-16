local M = {
    "stevearc/oil.nvim",
    keys = { "-" },
    cmd = { "Oil" },
}

function M.init()
    vim.keymap.set("n", "-", require("oil").open_float, { desc = "Open parent directory" })
end

function M.config()
    require("oil").setup({
        columns = {
            "icon",
            -- "permissions",
            -- "size",
            -- "mtime",
        },
        float = {
            padding = 5,
            max_height = 120,
            max_width = 160,
        },
        view_options = {
            show_hidden = true,
        },
    })
end

return M
