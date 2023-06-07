local navigator = {
    "numToStr/Navigator.nvim",
    event = { "VeryLazy" },
    opts = {
        auto_save = "all",
    },
    init = function()
        local wk = require("which-key")
        wk.register({
            ["w"] = {
                ["h"] = { ":NavigatorLeft<CR>", "window-left" },
                ["j"] = { ":NavigatorDown<CR>", "window-down" },
                ["k"] = { ":NavigatorUp<CR>", "window-up" },
                ["l"] = { ":NavigatorRight<CR>", "window-right" },
                ["p"] = { ":NavigatorPrevious<CR>", "window-previous" },
            },
        }, { mode = "n", prefix = "<leader>" })
    end,
}

local buffer_manager = {
    "j-morano/buffer_manager.nvim",
    event = { "VeryLazy" },
    opts = {
        width = 137,
        height = 22,
    },
    init = function()
        local wk = require("which-key")
        wk.register({
            -- stylua: ignore
            ["b"] = {
                ["m"] = { function() require("buffer_manager.ui").toggle_quick_menu() end, "buffer-menu" },
                ["n"] = { function() require("buffer_manager.ui").nav_next() end, "buffer-next" },
                ["p"] = { function() require("buffer_manager.ui").nav_prev() end, "buffer-previous" },
            },
        }, { mode = "n", prefix = "<leader>" })
    end,
}

return {
    buffer_manager,
    navigator,
}
