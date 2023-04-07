local M = {
    "sbdchd/neoformat",
    cmd = { "Neoformat" },
    enabled = false,
}

M.init = function()
    lk.augroup("neoformat_au", {
        {
            event = { "BufWritePre" },
            pattern = { "*" },
            command = function()
                vim.cmd([[Neoformat]])
            end,
        },
    })
end

return M
