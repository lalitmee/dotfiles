local M = {
    "lewis6991/gitsigns.nvim",
    event = "BufReadPre",
}

function M.config()
    require("gitsigns").setup({
        signs = {
            add = {
                hl = "GitSignsAdd",
                text = "│",
                numhl = "GitSignsAddNr",
                linehl = "GitSignsAddLn",
            },
            change = {
                hl = "GitSignsChange",
                text = "│",
                numhl = "GitSignsChangeNr",
                linehl = "GitSignsChangeLn",
            },
            delete = {
                hl = "GitSignsDelete",
                text = "_",
                numhl = "GitSignsDeleteNr",
                linehl = "GitSignsDeleteLn",
            },
            topdelete = {
                hl = "GitSignsDelete",
                text = "‾",
                numhl = "GitSignsDeleteNr",
                linehl = "GitSignsDeleteLn",
            },
            changedelete = {
                hl = "GitSignsChange",
                text = "~",
                numhl = "GitSignsChangeNr",
                linehl = "GitSignsChangeLn",
            },
        },
        numhl = false,
        linehl = false,
        watch_gitdir = { interval = 1000 },
        sign_priority = 6,
        update_debounce = 200,
        status_formatter = nil,
        current_line_blame = false,
        current_line_blame_opts = {
            virt_text = true,
            virt_text_pos = "eol",
            delay = 500,
        },
        preview_config = {
            border = "rounded",
        },
        current_line_blame_formatter = "   <author>, <author_time:%R> - <summary>",
    })
end

return M
