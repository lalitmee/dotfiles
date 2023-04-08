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

M.config = function()
    local bookmarks = {
        ["docs"] = {
            ["name"] = "docs for everything",
            ["mdn"] = "https://developer.mozilla.org/search?q=%s",
            ["devdocs.io"] = "https://devdocs.io/search?q=%s",
            ["learnxinyminutes"] = "https://learnxinyminutes.com/docs/%s",
        },
        ["work"] = {
            ["name"] = "work related",
            ["github_pulls"] = "https://github.com/pulls",
            ["mui"] = "https://mui.com/",
            ["mui-icons"] = "https://mui.com/components/material-icons/#material-icons",
            ["v4-mui"] = "https://v4.mui.com/",
            ["npm_search"] = "https://npmjs.com/search?q=%s",
        },
        ["lalitmee"] = {
            ["name"] = "personal repositories",
            ["browse.nvim"] = "https://github.com/lalitmee/browse.nvim",
            ["cobalt2.nvim"] = "https://github.com/lalitmee/cobalt2.nvim",
            ["dNotes"] = "https://github.com/lalitmee/dNotes",
            ["dotfiles"] = "https://github.com/lalitmee/dotfiles",
        },
        ["neovim"] = {
            ["name"] = "most visited repositories for neovim",
            ["awesome-neovim"] = "https://github.com/rockerBOO/awesome-neovim",
            ["lualine"] = "https://github.com/nvim-lualine/lualine.nvim",
            ["neovim"] = "https://github.com/neovim/neovim",
            ["nvim-treesitter"] = "https://github.com/nvim-treesitter/nvim-treesitter",
            ["telescope"] = "https://github.com/nvim-telescope/telescope.nvim",
        },
        ["configs"] = {
            ["name"] = "dotfiles repositories of my favourites",
            ["ThePrimeagen"] = "https://github.com/ThePrimeagen/.dotfiles",
            ["akinsho"] = "https://github.com/akinsho/dotfiles",
            ["tjdevries"] = "https://github.com/tjdevries/config_manager",
            ["whatsthatsmell"] = "https://github.com/whatsthatsmell/dots",
        },
        ["github"] = {
            ["name"] = "search github from neovim",
            ["code_search"] = "https://github.com/search?q=%s&type=code",
            ["repo_search"] = "https://github.com/search?q=%s&type=repositories",
            ["issues_search"] = "https://github.com/search?q=%s&type=issues",
            ["pulls_search"] = "https://github.com/search?q=%s&type=pullrequests",
        },
        ["reddit"] = {
            ["name"] = "reddit search",
            ["query"] = "https://www.reddit.com/search?q=%s",
            ["sr_query"] = "https://www.reddit.com/search?q=%s&type=sr",
            ["neovim"] = "https://www.reddit.com/r/neovim",
            ["workspaces"] = "https://www.reddit.com/r/workspaces",
            ["vim_porn"] = "https://www.reddit.com/r/vimporn",
        },
    }

    local browse = require("browse")

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
