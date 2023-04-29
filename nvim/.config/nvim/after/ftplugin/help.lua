lk.augroup("help_au", {
    {
        event = { "BufWinEnter" },
        buffer = 0,
        command = function()
            if not vim.bo.modifiable then
                vim.cmd([[:wincmd K | resize 40]])
            end
        end,
    },
})

-- NOTE: enable code highlighting for help
vim.treesitter.start()
