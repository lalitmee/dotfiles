local M = {
    "ggandor/leap.nvim",
}

-- M.enabled = false

M.init = function()
    require("leap").add_default_mappings()
end

return M
