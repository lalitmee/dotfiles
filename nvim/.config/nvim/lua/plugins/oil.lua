return {
    "stevearc/oil.nvim",
    keys = { "-" },
    cmd = { "Oil" },
    config = function()
        require("oil").setup({
            columns = { "icon" },
            float = {
                win_options = {
                    winblend = 0,
                },
                padding = 5,
                max_height = 120,
                max_width = 160,
            },
            view_options = {
                show_hidden = true,
            },
            skip_confirm_for_simple_edits = true,
        })
    end,
    init = function()
        local wk = require("which-key")
        wk.register({
            ["a"] = {
                ["e"] = { ":Oil<CR>", "file-browser" },
                ["o"] = { ":Oil --float<CR>", "file-browser" },
            },
        }, { mode = "n", prefix = "<leader>" })
    end,
}
