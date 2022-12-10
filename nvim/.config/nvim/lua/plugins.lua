--------------------------------------------------------------------------------
-- NOTE: plugins setup {{{
--------------------------------------------------------------------------------
local fmt = string.format
-- cfilter plugin allows filter down an existing quickfix list
-- vim.cmd([[packadd! cfilter]])

-- function to return string for require plugins using path
local function conf(name)
    if name == "null-ls" then
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
            config = conf("packer"),
        })
        use({ "lewis6991/impatient.nvim" })
        use({
            "tweekmonster/startuptime.vim",
            cmd = "StartupTime",
            opt = true,
        })
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
        -- improve default neovim UI
        use({
            "stevearc/dressing.nvim",
            config = conf("dressing"),
        })

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
            config = conf("devicons"),
        })

        -- }}}
        ----------------------------------------------------------------------------

        ----------------------------------------------------------------------------
        -- NOTE: general {{{
        ----------------------------------------------------------------------------
        -- -- new UI paradigm
        -- use({
        --     "folke/noice.nvim",
        --     requires = {
        --         "MunifTanjim/nui.nvim",
        --     },
        --     config = conf("noice"),
        -- })

        -- TODO: I may try to remove this in the future, I don't think I get anything
        --       from this that's why I can remove this
        -- which-key
        use({
            "folke/which-key.nvim",
            config = conf("which-key"),
        })

        -- session management
        use({
            "rmagatti/session-lens",
            after = { "telescope.nvim", "auto-session" },
            cmd = { "SearchSession" },
            requires = {
                "rmagatti/auto-session",
                event = { "VimEnter" },
            },
            config = conf("sessions"),
        })

        -- Colorizer for showing the colors
        use({
            "NvChad/nvim-colorizer.lua",
            config = conf("colorizer"),
            cmd = { "ColorizerToggle" },
        })

        ----------------------------------------------------------------------
        -- NOTE: quick fix plugins {{{
        ----------------------------------------------------------------------
        -- better quick-fix winodw
        use({
            "kevinhwang91/nvim-bqf",
            config = conf("bqf"),
        })

        -- prettify quickfix windows for neovim
        use({
            "https://gitlab.com/yorickpeterse/nvim-pqf.git",
            config = conf("pqf"),
        })

        -- makes quickfix list editable
        use({
            "gabrielpoca/replacer.nvim",
            config = conf("replacer"),
            cmd = { "Replacer", "ReplacerFiles" },
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
        -- surround plugin same as tpope's but in lua
        use({
            "kylechui/nvim-surround",
            config = conf("surround"),
        })

        -- take images of the code or buffers
        use({
            "narutoxy/silicon.lua",
            config = conf("silicon"),
            cmd = { "Silicon", "SiliconCopy", "SiliconBuf" },
        })

        -- neozoom
        use({
            "nyngwang/NeoZoom.lua",
            config = conf("neozoom"),
            cmd = { "NeoZoomToggle" },
        })

        -- icon picker for neovim
        use({
            "ziontee113/icon-picker.nvim",
            config = conf("icon-picker"),
            cmd = { "PickEverything" },
        })

        -- color picker for neovim
        use({
            "nvim-colortils/colortils.nvim",
            config = conf("colortils"),
            cmd = { "Colortils" },
        })

        -- scratch files in `/tmp` folder
        use({
            "m-demare/attempt.nvim",
            config = conf("attempt"),
            cmd = { "AttemptNew", "AttemptNewExtension" },
        })

        -- cycle folds
        use({
            "jghauser/fold-cycle.nvim",
            config = conf("fold-cycle"),
        })

        -- rooter for neovim
        use({
            "ahmedkhalf/project.nvim",
            config = conf("project"),
        })

        -- wakatime for vim
        use({
            "wakatime/vim-wakatime",
            event = { "VimEnter" },
        })

        -- yank history after paste with `<C-n>` and `<C-p>`
        use({
            "gbprod/yanky.nvim",
            config = conf("yanky"),
        })

        -- undo tree
        use({
            "mbbill/undotree",
            cmd = { "UndotreeToggle" },
        })

        -- interactively swap so many things
        use({
            "mizlan/iswap.nvim",
            after = { "nvim-treesitter" },
        })

        ----------------------------------------------------------------------------
        -- NOTE: Search {{{
        ----------------------------------------------------------------------------
        -- search and replace in the whole project
        use({
            "nvim-pack/nvim-spectre",
            config = conf("spectre"),
        })

        -- display search matches
        use({ "romainl/vim-cool" })

        -- Navigations
        use({
            "ThePrimeagen/harpoon",
            config = conf("harpoon"),
        })
        -- }}}
        ----------------------------------------------------------------------------

        ------------------------------------------------------------------------
        -- NOTE: FUZZY SEARCH {{{
        ------------------------------------------------------------------------
        -- NOTE: will see if I need this later
        -- use({
        --     "ibhagwan/fzf-lua",
        --     config = conf("fzf"),
        -- })

        -- telescope.nvim
        use({
            "nvim-telescope/telescope.nvim",
            config = conf("telescope"),
            requires = {
                {
                    "nvim-telescope/telescope-frecency.nvim",
                    requires = { "kkharji/sqlite.lua" },
                    after = { "telescope.nvim" },
                    config = function()
                        require("telescope").load_extension("frecency")
                    end,
                },
                {
                    "nvim-telescope/telescope-fzf-native.nvim",
                    run = "make",
                    after = { "telescope.nvim" },
                    config = function()
                        require("telescope").load_extension("fzf")
                    end,
                },
                {
                    "nvim-telescope/telescope-ui-select.nvim",
                    after = { "telescope.nvim" },
                    config = function()
                        require("telescope").load_extension("ui-select")
                    end,
                },
                {
                    "nvim-telescope/telescope-dap.nvim",
                    after = { "nvim-dap", "telescope.nvim" },
                    config = function()
                        require("telescope").load_extension("dap")
                    end,
                },
                {
                    "zane-/howdoi.nvim",
                    after = { "telescope.nvim" },
                    config = function()
                        require("telescope").load_extension("howdoi")
                    end,
                },
                {
                    "nvim-telescope/telescope-github.nvim",
                    after = { "telescope.nvim" },
                    config = function()
                        require("telescope").load_extension("gh")
                    end,
                },
                {
                    "nvim-telescope/telescope-live-grep-args.nvim",
                    after = { "telescope.nvim" },
                    config = function()
                        require("telescope").load_extension("live_grep_args")
                    end,
                },
            },
        })

        -- }}}
        ------------------------------------------------------------------------

        ----------------------------------------------------------------------------
        -- NOTE: General {{{
        ----------------------------------------------------------------------------
        -- helping in reading
        use({
            "nullchilly/fsread.nvim",
            cmd = { "FSToggle" },
        })

        -- smooth scrolling in neovim
        use({
            "karb94/neoscroll.nvim",
            config = conf("neoscroll"),
        })

        -- delete buffers without distubing layout
        use({ "famiu/bufdelete.nvim" })

        -- auto pairs
        use({
            "windwp/nvim-autopairs",
            config = conf("autopairs"),
        })

        -- extra text objects
        use({ "wellle/targets.vim" })

        -- split and join
        use({
            "Wansmer/treesj",
            config = conf("treesj"),
            cmd = { "TSJToggle", "TSJSplit", "TSJJoin" },
            keys = { "gS", "gJ" },
        })

        -- sorting in vim
        use({ "christoomey/vim-sort-motion" })

        -- navigate and splits
        use({
            "numToStr/Navigator.nvim",
            config = conf("navigator"),
        })

        use({
            "kevinhwang91/nvim-ufo",
            requires = "kevinhwang91/promise-async",
            config = conf("ufo"),
        })

        -- nice fold text
        use({
            "anuvyklack/pretty-fold.nvim",
            config = conf("pretty-fold"),
        })

        -- commenting
        use({
            "numToStr/Comment.nvim",
            config = conf("comment"),
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
            config = conf("sniprun"),
        })

        -- overseer.nvim: task runner and job management
        use({
            "stevearc/overseer.nvim",
            config = conf("overseer"),
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
            },
        })
        -- }}}
        ------------------------------------------------------------------------

        ------------------------------------------------------------------------
        -- NOTE: Format {{{
        ------------------------------------------------------------------------
        -- formatter in lua
        use({ "mhartington/formatter.nvim" })

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
            config = conf("mason"),
        })

        use({
            "hrsh7th/nvim-cmp",
            requires = {
                { "hrsh7th/cmp-buffer", after = "nvim-cmp" },
                { "hrsh7th/cmp-nvim-lsp" },
                { "hrsh7th/cmp-nvim-lua", after = "nvim-cmp", ft = { "lua" } },
                { "hrsh7th/cmp-path", after = "nvim-cmp" },
                { "saadparwaiz1/cmp_luasnip", after = "nvim-cmp" },
                { "tzachar/cmp-tabnine", run = "./install.sh", after = "nvim-cmp" },
            },
            config = conf("cmp"),
        })

        use({
            "neovim/nvim-lspconfig",
            ft = vim.g.enable_lspconfig_ft,
            module = "lspconfig",
            config = conf("lsp"),
            requires = {
                { "onsails/lspkind.nvim" },
                { "j-hui/fidget.nvim" },
                { "folke/neodev.nvim" },
                {
                    "jose-elias-alvarez/null-ls.nvim",
                    config = conf("null-ls"),
                },
                { "folke/lsp-trouble.nvim" },
            },
        })
        -- }}}
        ------------------------------------------------------------------------

        ------------------------------------------------------------------------
        -- NOTE: Treesitter {{{
        ------------------------------------------------------------------------
        use({
            "nvim-treesitter/nvim-treesitter",
            run = ":TSUpdate",
            config = conf("treesitter"),
            event = { "VimEnter" },
            requires = {
                {
                    "nvim-treesitter/nvim-treesitter-textobjects",
                    after = "nvim-treesitter",
                },
                {
                    "nvim-treesitter/playground",
                    after = { "nvim-treesitter" },
                    cmd = { "TSPlaygroundToggle", "TSHighlightCapturesUnderCursor" },
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
            config = conf("neogen"),
            cmd = { "Neogen" },
        })
        -- }}}
        ------------------------------------------------------------------------

        ----------------------------------------------------------------------------
        -- NOTE: Languages {{{
        ----------------------------------------------------------------------------
        -- sxhkdrc syntax
        use({ "baskerville/vim-sxhkdrc" })

        -- emmet vim
        use({
            "mattn/emmet-vim",
            config = conf("emmet"),
        })

        -- golang support
        use({ "ray-x/go.nvim", ft = "go" })

        -- debug print
        use({
            "andrewferrier/debugprint.nvim",
            config = conf("debugprint"),
        })

        ----------------------------------------------------------------------------
        -- NOTE: markdown {{{
        ----------------------------------------------------------------------------
        -- preview markdown in neovim
        use({
            "ellisonleao/glow.nvim",
            ft = "markdown",
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
            config = conf("neogit"),
            cmd = { "Neogit" },
        })

        -- gitsigns in lua
        use({
            "lewis6991/gitsigns.nvim",
            config = conf("gitsigns"),
        })

        -- git lens in vim
        use({
            "sindrets/diffview.nvim",
            config = conf("diffview"),
        })

        -- for interacting with github
        use({
            "pwntester/octo.nvim",
            config = conf("octo"),
        })
        -- }}}
        ------------------------------------------------------------------------

        ------------------------------------------------------------------------
        -- NOTE: STATUS AND TAB LINES {{{
        ------------------------------------------------------------------------
        -- lualine.nvim
        use({ "nvim-lualine/lualine.nvim" })

        -- tabline
        use({
            "nanozuki/tabby.nvim",
            requires = { "tiagovla/scope.nvim" },
        })

        -- winbar component
        use({
            "SmiteshP/nvim-navic",
            config = conf("navic"),
        })

        -- }}}
        ------------------------------------------------------------------------

        ------------------------------------------------------------------------
        -- NOTE: VIM NINJAS {{{
        ------------------------------------------------------------------------
        --------------------------------------------------------------------------------
        --  NOTE: ThePrimeagen {{{
        --------------------------------------------------------------------------------
        use({ "ThePrimeagen/vim-be-good" })
        -- }}}
        --------------------------------------------------------------------------------

        ------------------------------------------------------------------------
        -- NOTE: tpope {{{
        ------------------------------------------------------------------------
        -- abbreviations
        use({ "tpope/vim-abolish" })

        -- repeat using `.`
        use({ "tpope/vim-repeat" })

        -- debug things
        use({ "tpope/vim-scriptease" })
        -- }}}
        ------------------------------------------------------------------------

        -- }}}
        ------------------------------------------------------------------------

        ------------------------------------------------------------------------
        -- NOTE: Explorers {{{
        ------------------------------------------------------------------------
        -- dirbuf
        use({
            "elihunter173/dirbuf.nvim",
            cmd = { "Dirbuf", "DirbufSync" },
            keys = { { "n", "-" } },
            config = function()
                vim.cmd([[autocmd VimEnter * autocmd! dirbuf]])
            end,
        })

        -- neo-tree
        use({
            "nvim-neo-tree/neo-tree.nvim",
            branch = "v2.x",
            requires = {
                { "MunifTanjim/nui.nvim" },
                { "s1n7ax/nvim-window-picker", tag = "v1.*" },
            },
            config = conf("neo-tree"),
        })
        -- }}}
        ------------------------------------------------------------------------

        ----------------------------------------------------------------------
        -- NOTE: browse {{{
        ----------------------------------------------------------------------
        local_use({
            "browse.nvim",
            config = conf("browse"),
        })
        -- }}}
        ----------------------------------------------------------------------

        ------------------------------------------------------------------------
        -- NOTE: TESTING {{{
        ------------------------------------------------------------------------
        -- debugger attach protocol
        use({
            "rcarriga/nvim-dap-ui",
            config = conf("dap"),
            requires = {
                { "jbyuki/one-small-step-for-vimkind" },
                { "mfussenegger/nvim-dap" },
                { "theHamsta/nvim-dap-virtual-text" },
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
            config = conf("mind"),
        })

        -- auto add list markers to the next lines
        use({
            "gaoDean/autolist.nvim",
            config = conf("autolist"),
        })

        -- }}}
        ----------------------------------------------------------------------

        ----------------------------------------------------------------------
        -- NOTE: entertainment {{{
        ----------------------------------------------------------------------
        use({
            "terror/chatgpt.nvim",
            run = "pip3 install -r requirements.txt",
        })
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
            threshold = 1,
        },
    },
})

-- }}}
--------------------------------------------------------------------------------

-- }}}
--------------------------------------------------------------------------------

-- vim:foldmethod=marker
