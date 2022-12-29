local M = {
    "lalitmee/browse.nvim",
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
        -- work
        "https://github.com/koinearth/B2BOrdersWorkflowServer",
        "https://github.com/koinearth/marketsn-api-service",
        "https://github.com/koinearth/marketsn-pdf-service",
        "https://github.com/koinearth/marketsn-pwa-service",
        "https://github.com/koinearth/marketsn-webapp-service-nextjs",
        "https://github.com/koinearth/wf-pwa-service",
        "https://github.com/koinearth/wf-webapp-service",
        "https://github.com/pulls",
        "https://mui.com/components/material-icons/#material-icons",
        "https://v4.mui.com/",
        "https://mui.com/",

        -- mine
        "https://github.com/lalitmee/browse.nvim",
        "https://github.com/lalitmee/cobalt2.nvim",
        "https://github.com/lalitmee/dNotes",
        "https://github.com/lalitmee/dotfiles",

        -- neovim related
        "https://github.com/elihunter173/dirbuf.nvim",
        "https://github.com/kyazdani42/nvim-tree.lua",
        "https://github.com/neovim/neovim",
        "https://github.com/nvim-lualine/lualine.nvim",
        "https://github.com/nvim-telescope/telescope.nvim",
        "https://github.com/nvim-treesitter/nvim-treesitter",
        "https://github.com/phaazon/hop.nvim",
        "https://github.com/rockerBOO/awesome-neovim",
        "https://github.com/tamago324/lir.nvim",
        "https://neovim.discourse.group/",

        -- configs
        "https://github.com/ThePrimeagen/.dotfiles",
        "https://github.com/akinsho/dotfiles",
        "https://github.com/tjdevries/config_manager",
        "https://github.com/whatsthatsmell/dots",
    }

    local ok, browse = lk.require("browse")
    if not ok then
        return
    end

    browse.setup({
        -- provider = "brave",
        provider = "duckduckgo",
        -- provider = "google",
    })

    ----------------------------------------------------------------------
    -- NOTE: commands {{{
    ----------------------------------------------------------------------
    local command = lk.command

    command("Browse", function()
        browse.browse({ bookmarks = bookmarks })
    end, {})

    command("BrowseBookmarks", function()
        browse.open_bookmarks({ bookmarks = bookmarks })
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
