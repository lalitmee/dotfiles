local M = {
    "kevinhwang91/nvim-bqf",
    ft = "qf",
    dependencies = {
        url = "https://gitlab.com/yorickpeterse/nvim-pqf.git",
        ft = "qf",
        config = function()
            require("pqf").setup()
        end,
    },
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
