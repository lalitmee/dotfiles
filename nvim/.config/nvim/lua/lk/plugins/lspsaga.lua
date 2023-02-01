local M = {
    "glepnir/lspsaga.nvim",
    event = "BufRead",
}

M.config = function()
    require("lspsaga").setup({})
end

return M
