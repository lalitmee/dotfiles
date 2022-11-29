vim.g.user_emmet_install_global = 0

lk.augroup("emmet_au", {
    {
        event = { "FileType" },
        pattern = { "html", "css", "javascript", "typescript", "javascriptreact", "typescriptreact" },
        description = "Install emmet only for some filetypes",
        command = function()
            vim.cmd([[EmmetInstall]])
        end,
    },
})
