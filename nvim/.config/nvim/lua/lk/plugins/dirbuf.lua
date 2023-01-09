local M = {
    "elihunter173/dirbuf.nvim",
    cmd = { "Dirbuf" },
    keys = {
        "-",
        "<cmd>Dirbuf<cr>",
        desc = "open dirbuf",
    },
    enabled = false,
}

function M.config()
    vim.cmd([[autocmd VimEnter * autocmd! dirbuf]])
end

return M
