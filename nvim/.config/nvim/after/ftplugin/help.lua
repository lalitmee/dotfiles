lk.augroup("help_au", {
    {
        event = { "BufWinEnter" },
        buffer = 0,
        command = [[ :wincmd K | resize 40]],
    },
})
