local ok, neo_zoom = lk.require("neo-zoom")
if not ok then
    return
end

neo_zoom.setup({
    width_ratio = 0.9,
    height_ratio = 1,
    border = "rounded",
})
