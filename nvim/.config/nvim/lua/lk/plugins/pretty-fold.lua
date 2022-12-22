local M = {
    "anuvyklack/pretty-fold.nvim",
}

function M.config()
    require("pretty-fold").setup({
        keep_indentation = false,
        fill_char = "━",
        sections = {
            left = {
                "━ ",
                function()
                    return string.rep("*", vim.v.foldlevel)
                end,
                " ━┫",
                "content",
                "┣",
            },
            right = {
                "┫ ",
                "number_of_folded_lines",
                ": ",
                "percentage",
                " ┣━━",
            },
        },
    })
end

return M
