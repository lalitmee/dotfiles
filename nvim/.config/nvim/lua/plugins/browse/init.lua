local bookmarks = require("plugins.browse.bookmarks")

local browse = {
    dir = "~/Desktop/Github/browse.nvim",
    dev = true,
    keys = {
        "<localleader>bb",
        "<localleader>bd",
        "<localleader>bD",
        "<localleader>bi",
        "<localleader>bl",
        "<localleader>bm",
    },
    opts = {
        provider = "duckduckgo", -- google or bing
        bookmarks = bookmarks,
    },
    init = function()
        local wk = require("which-key")
        wk.register({
            -- stylua: ignore
            ["b"] = {
                ["name"] = "+browse",
                ["b"] = { function() require("browse").browse() end, "browse" },
                ["d"] = { function() require("browse").devdocs.search() end, "devdocs-search" },
                ["f"] = { function() require("browse").devdocs.search_with_filetype() end, "devdocs-filetype-search" },
                ["i"] = { function() require("browse").input_search() end, "input-search" },
                ["l"] = { function() require("browse").open_bookmarks() end, "bookmarks" },
                ["m"] = { function() require("browse").mdn.search() end, "mdn-search" },
            },
        }, { mode = "n", prefix = "<localleader>" })
    end,
}

return { browse }
