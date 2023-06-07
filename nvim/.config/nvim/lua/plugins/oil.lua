return {
    "stevearc/oil.nvim",
    keys = { "-" },
    cmd = { "Oil" },
    init = function()
        lk.command("OilFloat", require("oil").open_float, {})
        vim.keymap.set("n", "-", require("oil").open_float, { desc = "Open parent directory" })
    end,
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
}
