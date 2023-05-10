return {
    "nyngwang/NeoZoom.lua",
    cmd = { "NeoZoomToggle" },
    config = function()
        require("neo-zoom").setup({
            winopts = {
                border = "rounded",
                offset = {
                    height = 0.9,
                    width = 220,
                },
            },
        })
    end,
}
