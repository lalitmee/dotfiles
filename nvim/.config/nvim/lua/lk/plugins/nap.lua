local M = {
    "liangxianzhe/nap.nvim",
    keys = { ",", ";" },
}

M.config = function()
    require("nap").setup({
        next_prefix = "]",
        prev_prefix = "[",
        next_repeat = "]",
        prev_repeat = "[",
    })
end

return M
