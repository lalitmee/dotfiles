local M = {
    "ggandor/leap.nvim",
}

M.enabled = false

function M.config()
    require("leap").add_default_mappings()
end

return M
