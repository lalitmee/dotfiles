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
        use({ "wbthomason/packer.nvim" })
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
        use({ "gorbit99/codewindow.nvim" })

        -- highlights of unused functions, variables, parameters, and more
        use({ "zbirenbaum/neodim" })

        -- improve default neovim UI
        use({ "stevearc/dressing.nvim" })

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
            branch = "feat/lua",
            requires = { "kyazdani42/nvim-web-devicons" },
        })

        -- }}}
        ----------------------------------------------------------------------------

        ----------------------------------------------------------------------------
        -- NOTE: general {{{
        ----------------------------------------------------------------------------
        use({ "ofirgall/open.nvim" })

        -- -- new UI paradigm
        -- use({
        --     "folke/noice.nvim",
        --     requires = {
        --         "MunifTanjim/nui.nvim",
        --     },
        -- })

        -- TODO: I may try to remove this in the future, I don't think I get anything
        --       from this that's why I can remove this
        -- which-key
        use({ "folke/which-key.nvim" })

        -- Colorizer for showing the colors
        use({ "NvChad/nvim-colorizer.lua" })

        ----------------------------------------------------------------------
        -- NOTE: quick fix plugins {{{
        ----------------------------------------------------------------------
        -- better quick-fix winodw
        use({ "kevinhwang91/nvim-bqf" })

        -- prettify quickfix windows for neovim
        use({ "https://gitlab.com/yorickpeterse/nvim-pqf.git" })

        -- makes quickfix list editable
        use({ "gabrielpoca/replacer.nvim" })
        -- }}}
        ----------------------------------------------------------------------
        -- }}}
        ----------------------------------------------------------------------------
        -- }}}
        ----------------------------------------------------------------------------

        ------------------------------------------------------------------------
        -- NOTE: ACTIONS {{{
        ------------------------------------------------------------------------
        -- neozoom
        use({ "nyngwang/NeoZoom.lua" })

        -- matchit extended
        use({ "andymass/vim-matchup" })

        -- keep the cursor where it is
        use({ "gbprod/stay-in-place.nvim" })

        -- icon picker for neovim
        use({ "ziontee113/icon-picker.nvim" })

        -- color picker for neovim
        use({ "ziontee113/color-picker.nvim" })

        -- scratch files in `/tmp` folder
        use({ "m-demare/attempt.nvim" })

        -- cycle folds
        use({ "jghauser/fold-cycle.nvim" })

        -- rooter for neovim
        use({ "ahmedkhalf/project.nvim" })

        -- wakatime for vim
        use({
            "wakatime/vim-wakatime",
            event = { "VimEnter" },
        })

        -- yank history after paste with `<C-n>` and `<C-p>`
        use({ "gbprod/yanky.nvim" })

        -- undo tree
        use({ "mbbill/undotree" })

        -- interactively swap so many things
        use({ "mizlan/iswap.nvim" })

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
        use({ "sitiom/nvim-numbertoggle" })

        -- easymotion using lua
        use({ "ggandor/leap.nvim" })

        -- Navigations
        use({ "ThePrimeagen/harpoon" })
        -- }}}
        ----------------------------------------------------------------------------

        ------------------------------------------------------------------------
        -- NOTE: FUZZY SEARCH {{{
        ------------------------------------------------------------------------
        use({ "ibhagwan/fzf-lua" })

        -- telescope.nvim
        use({
            "nvim-telescope/telescope.nvim",
            config = conf("telescope"),
            requires = {
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
                    config = function()
                        require("telescope").load_extension("fzf")
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
                    config = function()
                        require("telescope").load_extension("dap")
                    end,
                },
                {
                    "zane-/howdoi.nvim",
                    after = "telescope.nvim",
                    config = function()
                        require("telescope").load_extension("howdoi")
                    end,
                },
                {
                    "nvim-telescope/telescope-github.nvim",
                    after = "telescope.nvim",
                    config = function()
                        require("telescope").load_extension("gh")
                    end,
                },
                {
                    "nvim-telescope/telescope-live-grep-args.nvim",
                    after = "telescope.nvim",
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
        -- restor last editing cursor position
        use({ "farmergreg/vim-lastplace" })

        -- smooth scrolling in neovim
        use({ "karb94/neoscroll.nvim" })

        -- delete buffers without distubing layout
        use({ "famiu/bufdelete.nvim" })

        -- beautiful buffer switcher
        use({ "toppair/reach.nvim" })

        -- auto pairs
        use({ "windwp/nvim-autopairs" })

        -- extra text objects
        use({ "wellle/targets.vim" })

        -- split and join
        use({ "AndrewRadev/splitjoin.vim" })

        -- sorting in vim
        use({ "christoomey/vim-sort-motion" })

        -- navigate and splits
        use({ "numToStr/Navigator.nvim" })

        use({
            "kevinhwang91/nvim-ufo",
            requires = "kevinhwang91/promise-async",
        })

        -- nice fold text
        use({ "anuvyklack/pretty-fold.nvim" })

        -- commenting
        use({ "numToStr/Comment.nvim" })
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
        })

        -- overseer.nvim: task runner and job management
        use({ "stevearc/overseer.nvim" })

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
        })

        use({
            "hrsh7th/nvim-cmp",
            requires = {
                { "hrsh7th/cmp-buffer", after = "nvim-cmp" },
                { "hrsh7th/cmp-cmdline", after = "nvim-cmp", event = { "CmdlineEnter" } },
                { "hrsh7th/cmp-nvim-lsp" },
                { "hrsh7th/cmp-nvim-lua", after = "nvim-cmp", ft = { "lua" } },
                { "hrsh7th/cmp-path", after = "nvim-cmp" },
                { "saadparwaiz1/cmp_luasnip", after = "nvim-cmp" },
                { "tzachar/cmp-tabnine", run = "./install.sh", after = "nvim-cmp" },
            },
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
            requires = {
                {
                    "nvim-treesitter/nvim-treesitter-textobjects",
                    after = "nvim-treesitter",
                },
                {
                    "nvim-treesitter/playground",
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
        use({ "danymat/neogen" })
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
        })

        -- golang support
        use({ "ray-x/go.nvim", ft = "go" })

        -- debug print
        use({ "andrewferrier/debugprint.nvim" })

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
        use({ "TimUntersberger/neogit" })

        -- gitsigns in lua
        use({ "lewis6991/gitsigns.nvim" })

        -- git lens in vim
        use({ "sindrets/diffview.nvim" })
        -- }}}
        ------------------------------------------------------------------------

        ------------------------------------------------------------------------
        -- NOTE: STATUS AND TAB LINES {{{
        ------------------------------------------------------------------------
        -- tabline
        use({ "nanozuki/tabby.nvim" })

        -- lualine.nvim
        use({ "nvim-lualine/lualine.nvim" })

        -- winbar component
        use({ "SmiteshP/nvim-navic" })

        -- }}}
        ------------------------------------------------------------------------

        ------------------------------------------------------------------------
        -- NOTE: VIM NINJAS {{{
        ------------------------------------------------------------------------
        ------------------------------------------------------------------------
        -- NOTE: tpope {{{
        ------------------------------------------------------------------------
        -- abbreviations
        use({ "tpope/vim-abolish" })

        -- repeat using `.`
        use({ "tpope/vim-repeat" })

        use({ "kylechui/nvim-surround" })

        -- debug things
        use({ "tpope/vim-scriptease" })
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

        ----------------------------------------------------------------------
        -- NOTE: browse {{{
        ----------------------------------------------------------------------
        local_use({ "browse.nvim" })
        -- }}}
        ----------------------------------------------------------------------

        ------------------------------------------------------------------------
        -- NOTE: TESTING {{{
        ------------------------------------------------------------------------
        -- debugger attach protocol
        use({
            "mfussenegger/nvim-dap",
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
        })

        -- auto add list markers to the next lines
        use({ "gaoDean/autolist.nvim" })

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
            threshold = 1,
        },
    },
})

-- }}}
--------------------------------------------------------------------------------

-- }}}
--------------------------------------------------------------------------------

-- vim:foldmethod=marker
