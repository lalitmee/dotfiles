local M = {
    "folke/trouble.nvim",
    cmd = { "TroubleToggle", "Trouble" },
}

 M.config = function()
    require("trouble").setup({
        padding = false,
        auto_close = true,
        use_diagnostic_signs = true,
    })
end

return M
