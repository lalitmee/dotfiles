--------------------------------------------------------------------------------
-- NOTE: plugins setup {{{
--------------------------------------------------------------------------------
local fmt = string.format
-- cfilter plugin allows filter down an existing quickfix list
-- vim.cmd([[packadd! cfilter]])

-- function to return string for require plugins using path
local function conf(name)
    if name == "signature" then
        return fmt("R('lk.plugins.lsp.%s')", name)
    end
    return fmt("R('lk.plugins.%s')", name)
end

--------------------------------------------------------------------------------
-- NOTE: packer startup {{{
--------------------------------------------------------------------------------
require("packer").startup({
    function(use)
        local local_use = function(opts)
            local plug_path = opts[1]

            if vim.fn.isdirectory(vim.fn.expand("~/Desktop/Github/" .. plug_path)) == 1 then
                opts[1] = "~/Desktop/Github/" .. plug_path
            end

            use(opts)
        end
        --------------------------------------------------------------------------------
        -- NOTE: Packer and speed ups {{{
        --------------------------------------------------------------------------------
        use({
            "wbthomason/packer.nvim",
        })
        use({ "lewis6991/impatient.nvim" })

        local tweek = false
        if tweek then
            -- Profile startup time
            use({
                "tweekmonster/startuptime.vim",
                cmd = "StartupTime",
                opt = true,
            })
        else
            use({
                "dstein64/vim-startuptime",
                cmd = "StartupTime",
                opt = true,
            })
        end
        -- }}}
        --------------------------------------------------------------------------------

        ----------------------------------------------------------------------
        -- NOTE: must have {{{
        ----------------------------------------------------------------------
        use({ "nvim-lua/plenary.nvim" })
        -- }}}
        ----------------------------------------------------------------------

        ----------------------------------------------------------------------------
        -- NOTE: UI and Beautify {{{
        ----------------------------------------------------------------------------
        -- beautiful screenshots of the code
        use({
            "cameronviner/carbon-now-sh.nvim",
            cmd = { "CarbonNow" },
        })

        -- improve default neovim UI
        use({
            "stevearc/dressing.nvim",
        })

        -- NOTE: I think I don't even see this sometimes
        -- -- decorated scrollbar
        -- use({
        --   "lewis6991/satellite.nvim",
        -- })

        ----------------------------------------------------------------------------
        -- NOTE: notifications {{{
        ----------------------------------------------------------------------------
        use({
            "rcarriga/nvim-notify",
            module = "vim",
        })
        -- }}}
        ----------------------------------------------------------------------------

        ----------------------------------------------------------------------------
        -- NOTE: colorschemes {{{
        ----------------------------------------------------------------------------
        local_use({
            "cobalt2.nvim",
            requires = "tjdevries/colorbuddy.nvim",
        })
        -- use({
        --     "catppuccin/nvim",
        --     as = "catppuccin",
        -- })
        -- }}}
        ----------------------------------------------------------------------------

        ----------------------------------------------------------------------------
        -- NOTE: icons {{{
        ----------------------------------------------------------------------------
        use({
            "yamatsum/nvim-nonicons",
            requires = { "kyazdani42/nvim-web-devicons" },
            event = { "BufRead" },
        })

        -- }}}
        ----------------------------------------------------------------------------

        ----------------------------------------------------------------------------
        -- NOTE: general {{{
        ----------------------------------------------------------------------------
        -- -- new UI paradigm
        -- use({
        --   "folke/noice.nvim",
        --   event = "VimEnter",
        --   requires = {
        --     "MunifTanjim/nui.nvim",
        --   },
        -- })

        -- highlighting of todo comments
        use({
            "folke/todo-comments.nvim",
            requires = { "nvim-lua/plenary.nvim" },
        })

        -- which-key
        use({
            -- "~/Desktop/Github/which-key.nvim",
            "folke/which-key.nvim",
        })

        -- Colorizer for showing the colors
        use({
            "NvChad/nvim-colorizer.lua",
            cmd = {
                "ColorizerToggle",
                "ColorizerAttachToBuffer",
            },
        })

        ----------------------------------------------------------------------
        -- NOTE: quick fix plugins {{{
        ----------------------------------------------------------------------
        -- better quick-fix winodw
        use({
            "kevinhwang91/nvim-bqf",
            ft = { "qf" },
        })

        -- prettify quickfix windows for neovim
        use({
            "https://gitlab.com/yorickpeterse/nvim-pqf.git",
        })

        -- makes quickfix list editable
        use({
            "gabrielpoca/replacer.nvim",
            cmd = {
                "ReplacerRun",
                "ReplacerRunF",
                "ReplacerRunFiles",
            },
        })
        -- }}}
        ----------------------------------------------------------------------
        -- }}}
        ----------------------------------------------------------------------------
        -- }}}
        ----------------------------------------------------------------------------

        ------------------------------------------------------------------------
        -- NOTE: ACTIONS {{{
        ------------------------------------------------------------------------
        -- matchit extended
        use({ "andymass/vim-matchup" })

        -- keep the cursor where it is
        use({
            "gbprod/stay-in-place.nvim",
        })

        -- icon picker for neovim
        use({
            "ziontee113/icon-picker.nvim",
            cmd = {
                -- normal mode
                "PickEverything",
                "PickIcons",
                "PickEmoji",
                "PickNerd",
                "PickSymbols",
                "PickAltFont",
                "PickAltFontAndSymbols",

                -- insert mode
                "PickEverythingInsert",
                "PickIconsInsert",
                "PickEmojiInsert",
                "PickNerdInsert",
                "PickSymbolsInsert",
                "PickAltFontInsert",
                "PickAltFontAndSymbolsInsert",
            },
        })

        -- color picker for neovim
        use({
            "ziontee113/color-picker.nvim",
            cmd = { "PickColor" },
        })

        -- scratch files in `/tmp` folder
        use({
            "m-demare/attempt.nvim",
            cmd = { "AttemptNew", "AttemptNewExtension" },
        })

        -- cycle folds
        use({
            "jghauser/fold-cycle.nvim",
            keys = { "n", "<CR>" },
            cmd = {
                "FoldOpen",
                "FoldClose",
                "FoldCloseAll",
                "FoldOpenAll",
                "FoldToggleAll",
            },
        })

        -- rooter for neovim
        use({
            "ahmedkhalf/project.nvim",
        })

        -- wakatime for vim
        use({
            "wakatime/vim-wakatime",
            event = { "VimEnter" },
        })

        -- yank history after paste with `<C-n>` and `<C-p>`
        use({
            "gbprod/yanky.nvim",
            requires = { "nvim-telescope/telescope.nvim" },
        })

        -- undo tree
        use({ "mbbill/undotree" })

        -- better substitute
        use({
            "gbprod/substitute.nvim",
        })

        -- interactively swap so many things
        use({
            "mizlan/iswap.nvim",
            cmd = { "ISwap", "ISwapWith" },
        })

        ----------------------------------------------------------------------------
        -- NOTE: Search {{{
        ----------------------------------------------------------------------------
        -- search and replace in the whole project
        use({
            "nvim-pack/nvim-spectre",
        })

        -- display search matches
        use({ "romainl/vim-cool" })

        -- toggle relative line numbers automatically
        use({
            "sitiom/nvim-numbertoggle",
            config = function()
                require("numbertoggle").setup()
            end,
        })

        -- quick scope for lines in lua
        use({
            "jinh0/eyeliner.nvim",
            config = conf("eyeliner"),
        })

        -- easymotion using lua
        use({
            "phaazon/hop.nvim",
        })

        -- Navigations
        use({
            "ThePrimeagen/harpoon",
            config = conf("harpoon"),
            cmd = {
                "HarpoonAddFile",
                "HarpoonGotoFile1",
                "HarpoonGotoFile2",
                "HarpoonGotoFile3",
                "HarpoonGotoFile4",
                "HarpoonGotoFile5",
                "HarpoonGotoFile6",
                "HarpoonGotoFile7",
                "HarpoonGotoFile8",
                "HarpoonGotoFile9",
                "HarpoonGotoTerm1",
                "HarpoonGotoTerm2",
                "HarpoonGotoTerm3",
                "HarpoonNextMark",
                "HarpoonPrevMark",
                "HarpoonRemoveFile",
                "ToggleHarpoonMenu",
            },
        })
        -- }}}
        ----------------------------------------------------------------------------

        ------------------------------------------------------------------------
        -- NOTE: FUZZY SEARCH {{{
        ------------------------------------------------------------------------
        -- telescope.nvim
        use({
            "nvim-telescope/telescope.nvim",
            config = conf("telescope"),
            requires = {
                {
                    "nvim-lua/plenary.nvim",
                    module = "plenary",
                    after = "telescope.nvim",
                },
                {
                    "nvim-telescope/telescope-frecency.nvim",
                    requires = { "tami5/sqlite.lua" },
                    after = "telescope.nvim",
                    config = function()
                        require("telescope").load_extension("frecency")
                    end,
                },
                {
                    "nvim-telescope/telescope-fzf-native.nvim",
                    run = "make",
                    after = "telescope.nvim",
                    module = "telescope._extensions.fzf",
                    config = function()
                        require("telescope").load_extension("fzf")
                    end,
                },
                {
                    "nvim-telescope/telescope-smart-history.nvim",
                    after = "telescope.nvim",
                    module = "telescope._extensions.smart_history",
                    config = function()
                        require("telescope").load_extension("smart_history")
                    end,
                },
                {
                    "nvim-telescope/telescope-ui-select.nvim",
                    after = "telescope.nvim",
                    config = function()
                        require("telescope").load_extension("ui-select")
                    end,
                },
                {
                    "nvim-telescope/telescope-dap.nvim",
                    after = { "nvim-dap", "telescope.nvim" },
                    module = "telescope._extensions.dap",
                    config = function()
                        require("telescope").load_extension("dap")
                    end,
                },
                {
                    "zane-/howdoi.nvim",
                    -- module = "telescope._extensions.howdoi",
                    after = "telescope.nvim",
                    config = function()
                        require("telescope").load_extension("howdoi")
                    end,
                },
                {
                    "jvgrootveld/telescope-zoxide",
                    after = "telescope.nvim",
                    config = function()
                        require("telescope").load_extension("zoxide")
                    end,
                },
            },
        })

        -- file browser using telescope
        use({
            "nvim-telescope/telescope-file-browser.nvim",
            after = "telescope.nvim",
            config = function()
                require("telescope").load_extension("file_browser")
            end,
        })
        -- }}}
        ------------------------------------------------------------------------

        ----------------------------------------------------------------------------
        -- NOTE: General {{{
        ----------------------------------------------------------------------------
        -- smooth scrolling in neovim
        use({
            "karb94/neoscroll.nvim",
            keys = {
                { "n", "<C-u>" },
                { "n", "<C-d>" },
                { "n", "<C-b>" },
                { "n", "<C-f>" },
                { "n", "<C-y>" },
                { "n", "<C-e>" },
                { "n", "zt" },
                { "n", "zz" },
                { "n", "zb" },
            },
        })

        -- delete buffers without distubing layout
        use({
            "famiu/bufdelete.nvim",
            cmd = { "Bdelete", "Bwipeout", "Bdelete!", "Bwipeout!" },
        })

        -- beautiful buffer switcher
        use({
            "toppair/reach.nvim",
        })

        -- auto pairs
        use({
            "windwp/nvim-autopairs",
            keys = {
                { "i", "(" },
                { "i", "{" },
                { "i", "[" },
                { "i", "'" },
                { "i", '"' },
                { "i", "`" },
            },
        })

        -- extra text objects
        use({ "wellle/targets.vim" })

        -- split and join
        use({
            "AndrewRadev/splitjoin.vim",
            keys = {
                { "n", "gJ" },
                { "n", "gS" },
            },
        })

        -- sorting in vim
        use({
            "christoomey/vim-sort-motion",
            keys = {
                { "v", "gs" },
                { "n", "gs" },
            },
        })

        -- navigate and splits
        use({
            "numToStr/Navigator.nvim",
            cmd = {
                "NavigateLeft",
                "NavigateRight",
                "NavigateUp",
                "NavigateDown",
                "NavigatePrevious",
            },
        })

        use({
            "kevinhwang91/nvim-ufo",
            requires = "kevinhwang91/promise-async",
        })

        -- nice fold text
        use({
            "anuvyklack/pretty-fold.nvim",
            event = { "BufEnter" },
        })

        -- commenting
        use({
            "numToStr/Comment.nvim",
            event = "BufRead",
        })
        -- }}}
        ------------------------------------------------------------------------
        -- }}}
        ------------------------------------------------------------------------

        ------------------------------------------------------------------------
        -- NOTE: TEXT {{{
        ------------------------------------------------------------------------
        -- run any code of any file type
        use({
            "michaelb/sniprun",
            run = "bash ./install.sh",
            cmd = { "SnipRun" },
        })

        -- overseer.nvim: task runner and job management
        use({
            "stevearc/overseer.nvim",
        })

        ------------------------------------------------------------------------
        -- NOTE: Snippets {{{
        ------------------------------------------------------------------------
        -- -- snippets engine
        use({
            "L3MON4D3/LuaSnip",
            requires = {
                "rafamadriz/friendly-snippets",
                "honza/vim-snippets",
                "molleweide/LuaSnip-snippets.nvim",
            },
        })
        -- }}}
        ------------------------------------------------------------------------

        ------------------------------------------------------------------------
        -- NOTE: Format {{{
        ------------------------------------------------------------------------
        -- trim whitespaces while editing
        use({
            "lewis6991/spaceless.nvim",
            config = function()
                require("spaceless").setup()
            end,
        })

        -- formatter in lua
        use({
            -- "mhartington/formatter.nvim",
            "Hrle97/formatter.nvim",
            branch = "fix/shellescape",
        })

        -- Tabularize for Vim
        use({
            "godlygeek/tabular",
            cmd = { "Tabularize" },
        })
        -- }}}
        ------------------------------------------------------------------------
        -- }}}
        ------------------------------------------------------------------------

        ------------------------------------------------------------------------
        -- NOTE: LSP {{{
        ------------------------------------------------------------------------
        use({
            "williamboman/mason-lspconfig.nvim",
            requires = { "williamboman/mason.nvim" },
        })
        use({
            "neovim/nvim-lspconfig",
            ft = vim.g.enable_lspconfig_ft,
            module = "lspconfig",
            config = conf("lsp"),
            requires = {
                {
                    "j-hui/fidget.nvim",
                    after = "nvim-lspconfig",
                },
                {
                    "onsails/lspkind.nvim",
                    after = "nvim-lspconfig",
                },
                {
                    "hrsh7th/nvim-cmp",
                    event = { "InsertEnter", "CmdlineEnter" },
                    requires = {
                        { "hrsh7th/cmp-buffer", after = "nvim-cmp" },
                        { "hrsh7th/cmp-cmdline", after = "nvim-cmp", event = { "CmdlineEnter" } },
                        { "hrsh7th/cmp-nvim-lsp", after = "nvim-cmp" },
                        { "hrsh7th/cmp-nvim-lua", after = "nvim-cmp", ft = { "lua" } },
                        { "hrsh7th/cmp-path", after = "nvim-cmp" },
                        { "saadparwaiz1/cmp_luasnip", after = "nvim-cmp" },
                        { "lukas-reineke/cmp-rg", after = "nvim-cmp" },
                        { "tzachar/cmp-tabnine", run = "./install.sh", after = "nvim-cmp" },
                    },
                },
                {
                    "ray-x/lsp_signature.nvim",
                    after = "nvim-lspconfig",
                    config = conf("signature"),
                },
                {
                    "folke/lua-dev.nvim",
                    ft = "lua",
                    after = { "nvim-lspconfig" },
                },
            },
        })
        -- }}}
        ------------------------------------------------------------------------

        ------------------------------------------------------------------------
        -- NOTE: Treesitter {{{
        ------------------------------------------------------------------------
        use({
            "nvim-treesitter/nvim-treesitter",
            -- ft = vim.g.enable_treesitter_ft,
            event = { "BufRead", "BufNewFile" },
            config = conf("treesitter"),
            run = ":TSUpdate",
            requires = {
                {
                    "nvim-treesitter/nvim-treesitter-textobjects",
                    after = "nvim-treesitter",
                },
                {
                    "nvim-treesitter/playground",
                    cmd = { "TSPlaygroundToggle" },
                    after = { "nvim-treesitter" },
                },
                {
                    "JoosepAlviste/nvim-ts-context-commentstring",
                    after = { "nvim-treesitter", "Comment.nvim" },
                },
                {
                    "p00f/nvim-ts-rainbow",
                    after = { "nvim-treesitter" },
                },
                {
                    "nvim-treesitter/nvim-treesitter-context",
                    after = { "nvim-treesitter" },
                },
            },
        })

        -- annotations using treesitter
        use({
            "danymat/neogen",
            cmd = { "Neogen" },
        })
        -- }}}
        ------------------------------------------------------------------------

        ----------------------------------------------------------------------------
        -- NOTE: Languages {{{
        ----------------------------------------------------------------------------
        -- web tools for html
        use({
            "ray-x/web-tools.nvim",
            config = function()
                require("web-tools").setup()
            end,
            cmd = {
                "BrowserOpen",
                "BrowserPreview",
                "BrowserRestart",
                "BrowserStop",
                "BrowserSync",
                "TagRename",
            },
        })

        -- golang support
        use({ "ray-x/go.nvim", ft = "go" })

        -- debug print
        use({
            "andrewferrier/debugprint.nvim",
            config = function()
                require("debugprint").setup()
            end,
        })

        ----------------------------------------------------------------------------
        -- NOTE: markdown {{{
        ----------------------------------------------------------------------------
        -- preview markdown in neovim
        use({
            "ellisonleao/glow.nvim",
            ft = "markdown",
            cmd = { "Glow" },
        })

        use({
            "iamcco/markdown-preview.nvim",
            run = function()
                vim.fn["mkdp#util#install"]()
            end,
            ft = "markdown",
        })
        -- }}}
        ----------------------------------------------------------------------------
        -- }}}
        ----------------------------------------------------------------------------

        ------------------------------------------------------------------------
        -- NOTE: VERSION CONTROL STYSTEM {{{
        ------------------------------------------------------------------------
        -- git worktree
        use({
            "ThePrimeagen/git-worktree.nvim",
            after = "telescope.nvim",
            config = function()
                require("telescope").load_extension("git_worktree")
            end,
        })

        -- magit for neovim in lua
        use({
            "TimUntersberger/neogit",
            requires = { "nvim-lua/plenary.nvim" },
            cmd = { "Neogit" },
        })

        -- gitsigns in lua
        use({
            "lewis6991/gitsigns.nvim",
            requires = { "nvim-lua/plenary.nvim" },
            event = { "BufRead" },
        })

        -- git lens in vim
        use({
            "sindrets/diffview.nvim",
            requires = { "nvim-lua/plenary.nvim" },
            cmd = { "DiffviewOpen", "DiffviewFileHistory" },
        })
        -- }}}
        ------------------------------------------------------------------------

        ------------------------------------------------------------------------
        -- NOTE: STATUS AND TAB LINES {{{
        ------------------------------------------------------------------------
        -- lualine.nvim
        use({
            "nvim-lualine/lualine.nvim",
            after = "nvim-web-devicons",
        })

        -- winbar component
        use({
            "SmiteshP/nvim-navic",
            requires = "neovim/nvim-lspconfig",
            config = function()
                require("nvim-navic").setup({
                    highlight = true,
                })
            end,
        })

        -- }}}
        ------------------------------------------------------------------------

        ------------------------------------------------------------------------
        -- NOTE: VIM NINJAS {{{
        ------------------------------------------------------------------------
        ------------------------------------------------------------------------
        -- NOTE: tpope {{{
        ------------------------------------------------------------------------
        -- abbreviations
        use({
            "tpope/vim-abolish",
        })

        -- repeat using `.`
        use({
            "tpope/vim-repeat",
            event = { "BufRead" },
        })

        use({
            "kylechui/nvim-surround",
        })

        -- debug things
        use({
            "tpope/vim-scriptease",
            ft = "help",
            cmd = { "Messages", "Verbose", "Time" },
        })
        -- }}}
        ------------------------------------------------------------------------

        ------------------------------------------------------------------------
        -- NOTE: tjdevries {{{
        ------------------------------------------------------------------------
        -- use 'tjdevries/express_line.nvim'
        -- use("tjdevries/complextras.nvim")
        -- }}}
        ------------------------------------------------------------------------

        -- }}}
        ------------------------------------------------------------------------

        ------------------------------------------------------------------------
        -- NOTE: Explorers {{{
        ------------------------------------------------------------------------
        -- neo-tree
        use({
            "nvim-neo-tree/neo-tree.nvim",
            branch = "v2.x",
            requires = {
                "MunifTanjim/nui.nvim",
            },
        })
        -- }}}
        ------------------------------------------------------------------------

        ------------------------------------------------------------------------
        -- NOTE: TERMINAL {{{
        ------------------------------------------------------------------------
        -- Float Terminal
        use({
            "akinsho/nvim-toggleterm.lua",
            cmd = {
                "ToggleTerm",
                "ToggleTerm1",
                "ToggleTerm2",
                "ToggleTerm3",
                "ToggleTerm4",
                "TermExec",
            },
            keys = { "n", [[<C-\>]] },
        })
        -- }}}
        ------------------------------------------------------------------------

        ----------------------------------------------------------------------
        -- NOTE: browse {{{
        ----------------------------------------------------------------------
        local_use({
            "browse.nvim",
            cmd = {
                "Browse",
                "BrowseBookmarks",
                "BrowseInputSearch",
                "BrowseDevdocsSearch",
                "BrowseDevdocsFiletypeSearch",
                "BrowseMdnSearch",
            },
        })
        -- }}}
        ----------------------------------------------------------------------

        ------------------------------------------------------------------------
        -- NOTE: TESTING {{{
        ------------------------------------------------------------------------
        -- debugger attach protocol
        use({
            "mfussenegger/nvim-dap",
            config = conf("dap"),
            cmd = { "DapToggleBreakpoint" },
            requires = {
                {
                    "jbyuki/one-small-step-for-vimkind",
                    after = "nvim-dap",
                },
                {
                    "rcarriga/nvim-dap-ui",
                    after = "nvim-dap",
                },
                {
                    "theHamsta/nvim-dap-virtual-text",
                    after = "nvim-dap",
                },
            },
        })
        -- }}}
        ------------------------------------------------------------------------

        ----------------------------------------------------------------------
        -- NOTE: notes {{{
        ----------------------------------------------------------------------
        -- mind
        use({
            "phaazon/mind.nvim",
            tag = "v2.2",
            config = function()
                require("mind").setup()
            end,
        })

        -- auto add list markers to the next lines
        use({
            "gaoDean/autolist.nvim",
        })

        -- similar to orgmode but with neovim in lua
        use({
            "nvim-neorg/neorg",
            ft = "norg",
            cmd = { "Neorg" },
            requires = {
                { "nvim-neorg/neorg-telescope" },
            },
        })
        -- }}}
        ----------------------------------------------------------------------

        ----------------------------------------------------------------------
        -- NOTE: entertainment {{{
        ----------------------------------------------------------------------
        -- }}}
        ----------------------------------------------------------------------

        ----------------------------------------------------------------------
        -- NOTE: reading {{{
        ----------------------------------------------------------------------
        -- }}}
        ----------------------------------------------------------------------
    end,
    config = {
        compile_path = vim.fn.stdpath("config") .. "/lua/packer_compiled.lua",
        display = {
            prompt_border = "rounded",
            open_fn = function()
                return require("packer.util").float({ border = "rounded" })
            end,
        },
        profile = {
            enable = true,
            threshold = 1, -- the amount in ms that a plugins load time must be over for it to be included in the profile
        },
    },
})

-- }}}
--------------------------------------------------------------------------------

-- }}}
--------------------------------------------------------------------------------

-- vim:foldmethod=marker
