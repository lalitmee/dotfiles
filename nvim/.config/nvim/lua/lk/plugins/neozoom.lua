local M = {
    "nyngwang/NeoZoom.lua",
    cmd = { "NeoZoomToggle" },
}

function M.config()
    require("neo-zoom").setup({
        width_ratio = 0.9,
        height_ratio = 1,
        border = "rounded",
    })
end

return M
