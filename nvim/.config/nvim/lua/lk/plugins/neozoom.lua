local M = {
    "nyngwang/NeoZoom.lua",
    cmd = { "NeoZoomToggle" },
}

function M.config()
    local ok, zoom = lk.require("neo-zoom")
    if not ok then
        return
    end

    zoom.setup({
        width_ratio = 0.9,
        height_ratio = 1,
        border = "rounded",
    })
end

return M
