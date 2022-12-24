local M = {
    "folke/trouble.nvim",
    cmd = { "TroubleToggle", "Trouble" },
}

function M.config()
    local ok, trouble = lk.require("trouble")
    if not ok then
        return
    end

    trouble.setup({
        padding = false,
        auto_close = true,
        use_diagnostic_signs = true,
    })
end

return M
