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
        float = {
            padding = 5,
            max_height = 100,
            max_width = 150,
        },
        view_options = {
            show_hidden = true,
        },
    })
end

return M
