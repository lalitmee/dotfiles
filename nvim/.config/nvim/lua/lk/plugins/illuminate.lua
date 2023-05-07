return {
    "RRethy/vim-illuminate",
    event = { "VeryLazy" },
    config = function()
        require("illuminate").configure({
            under_cursor = false,
        })
    end,
}
