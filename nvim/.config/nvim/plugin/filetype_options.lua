lk.augroup("filetype_options_au", {
    {
        event = { "BufWinEnter" },
        pattern = { "*" },
        command = function()
            vim.cmd("set formatoptions-=o")
        end,
    },
})
