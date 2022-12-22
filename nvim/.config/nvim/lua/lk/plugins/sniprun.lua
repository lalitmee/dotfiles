local M = {
    "michaelb/sniprun",
    build = "bash ./install.sh",
}

function M.config()
    require("sniprun").setup({
        display = { "Terminal" },
        display_options = {
            terminal_width = 100,
        },
    })
end

return M
