local M = {
    "sindrets/diffview.nvim",
    cmd = {
        "DiffviewOpen",
        "DiffviewFileHistory",
        "DiffviewLog",
    },
}

M.config = function()
    require("diffview").setup({
        enhanced_diff_hl = true,
        key_bindings = {
            file_panel = {
                q = "<Cmd>DiffviewClose<CR>",
            },
            view = {
                q = "<Cmd>DiffviewClose<CR>",
            },
        },
    })
end

return M
