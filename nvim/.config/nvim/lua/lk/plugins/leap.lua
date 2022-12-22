local M = {
    "ggandor/leap.nvim",
}

M.enabled = false

function M.config()
    local ok, leap = lk.require("leap")
    if not ok then
        return
    end

    leap.add_default_mappings()
end

return M
