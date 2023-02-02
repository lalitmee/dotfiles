local M = {
    dir = "~/Desktop/Github/browse.nvim",
    dev = true,
    cmd = {
        "Browse",
        "BrowseBookmarks",
        "BrowseInputSearch",
        "BrowseDevdocsSearch",
        "BrowseDevdocsFiletypeSearch",
        "BrowseMdnSearch",
    },
}

function M.config()
    local bookmarks = {
        ["work"] = {
            ["name"] = "work related",
            ["github_pulls"] = "https://github.com/pulls",
            ["mui"] = "https://mui.com/",
            ["mui-icons"] = "https://mui.com/components/material-icons/#material-icons",
            ["v4-mui"] = "https://v4.mui.com/",
        },

        -- personal
        ["lalitmee"] = {
            ["name"] = "personal repositories",
            ["browse.nvim"] = "https://github.com/lalitmee/browse.nvim",
            ["cobalt2.nvim"] = "https://github.com/lalitmee/cobalt2.nvim",
            ["dNotes"] = "https://github.com/lalitmee/dNotes",
            ["dotfiles"] = "https://github.com/lalitmee/dotfiles",
        },

        -- neovim related
        ["neovim"] = {
            ["name"] = "most visited repositories for neovim",
            ["awesome-neovim"] = "https://github.com/rockerBOO/awesome-neovim",
            ["lualine"] = "https://github.com/nvim-lualine/lualine.nvim",
            ["neovim"] = "https://github.com/neovim/neovim",
            ["nvim-treesitter"] = "https://github.com/nvim-treesitter/nvim-treesitter",
            ["telescope"] = "https://github.com/nvim-telescope/telescope.nvim",
        },

        -- configs
        ["configs"] = {
            ["name"] = "dotfiles repositories of my favourites",
            ["ThePrimeagen"] = "https://github.com/ThePrimeagen/.dotfiles",
            ["akinsho"] = "https://github.com/akinsho/dotfiles",
            ["tjdevries"] = "https://github.com/tjdevries/config_manager",
            ["whatsthatsmell"] = "https://github.com/whatsthatsmell/dots",
        },

        -- aliases
        ["github"] = {
            ["name"] = "search github from neovim",
            ["code_search"] = "https://github.com/search?q=%s&type=code",
            ["repo_search"] = "https://github.com/search?q=%s&type=repositories",
            ["issues_search"] = "https://github.com/search?q=%s&type=issues",
            ["pulls_search"] = "https://github.com/search?q=%s&type=pullrequests",
        },
    }

    local ok, browse = lk.require("browse")
    if not ok then
        return
    end

    browse.setup({
        provider = "duckduckgo", -- google or bing
        bookmarks = bookmarks,
    })

    ----------------------------------------------------------------------
    -- NOTE: commands {{{
    ----------------------------------------------------------------------
    local command = lk.command

    command("Browse", function()
        browse.browse()
    end, {})

    command("BrowseBookmarks", function()
        browse.open_bookmarks()
    end, {})

    command("BrowseInputSearch", function()
        browse.input_search()
    end, {})

    command("BrowseDevdocsSearch", function()
        browse.devdocs.search()
    end, {})

    command("BrowseDevdocsFiletypeSearch", function()
        browse.devdocs.search_with_filetype()
    end, {})

    command("BrowseMdnSearch", function()
        browse.mdn.search()
    end, {})
    -- }}}
    ----------------------------------------------------------------------
end

return M
