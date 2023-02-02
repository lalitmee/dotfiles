local M = {
    "kevinhwang91/nvim-bqf",
    ft = "qf",
}

 M.config = function()
    require("bqf").setup({
        auto_enable = true,
        preview = { auto_previw = true, win_height = 25, win_vheight = 25 },
        filter = {
            fzf = {
                extra_opts = {
                    "--bind",
                    "ctrl-s:select-all,ctrl-d:deselect-all",
                    "--prompt",
                    "Filter > ",
                },
            },
        },
    })
end

return M
