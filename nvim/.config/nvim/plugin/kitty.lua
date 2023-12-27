lk.augroup("kitty_au", {
    {
        event = { "BufWritePost" },
        pattern = { "kitty.conf" },
        command = function()
            vim.cmd([[:silent !kill -SIGUSR1 $(pgrep kitty)]])
        end,
    },
})
