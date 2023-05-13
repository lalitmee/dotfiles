lk.augroup("telescope_au", {
    {
        event = { "Filetype" },
        pattern = { "TelescopeResults" },
        command = function()
            vim.cmd([[setlocal notfoldenable]])
        end,
    },
    {
        event = { "User" },
        pattern = { "TelescopePreviewerLoaded" },
        command = function()
            vim.cmd([[setlocal wrap]])
        end,
    },
})
