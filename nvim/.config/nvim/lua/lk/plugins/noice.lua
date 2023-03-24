local M = {
    "folke/noice.nvim",
    event = { "VeryLazy" },
}

M.enabled = false

M.config = function()
    require("noice").setup()
end

return M
