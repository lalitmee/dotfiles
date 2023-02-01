return {
    --------------------------------------------------------------------------------
    --  NOTE: must {{{
    --------------------------------------------------------------------------------
    {
        "nvim-lua/plenary.nvim",
        event = { "VeryLazy" },
    },
    -- }}}
    --------------------------------------------------------------------------------

    --------------------------------------------------------------------------------
    --  NOTE: UI {{{
    --------------------------------------------------------------------------------
    {
        "rcarriga/nvim-notify",
        event = { "VeryLazy" },
    },
    {
        -- "xiyaowong/virtcolumn.nvim",
        "lukas-reineke/virt-column.nvim",
        event = { "VimEnter" },
        config = function()
            require("virt-column").setup()
        end,
    },
    {
        url = "https://gitlab.com/yorickpeterse/nvim-pqf.git",
        ft = "qf",
        config = function()
            require("pqf").setup()
        end,
    },
    -- }}}
    --------------------------------------------------------------------------------

    --------------------------------------------------------------------------------
    --  NOTE: actions {{{
    --------------------------------------------------------------------------------
    {
        "jghauser/fold-cycle.nvim",
        config = function()
            require("fold-cycle").setup()
            lk.nnoremap("<CR>", function()
                require("fold-cycle").open()
            end)
        end,
    },
    {
        "andymass/vim-matchup",
        event = "BufReadPost",
        config = function()
            vim.g.matchup_matchparen_offscreen = { method = "status_manual" }
        end,
    },
    {
        "ckolkey/ts-node-action",
        event = { "VeryLazy" },
        dependencies = { "nvim-treesitter" },
    },
    { -- will add bang(#!) like this on running `:Bang`
        "susensio/magic-bang.nvim",
        cmd = { "Bang" },
        config = function()
            require("magic-bang").setup()
        end,
    },
    {
        "andrewferrier/debugprint.nvim",
        keys = { "g?" },
        config = function()
            require("debugprint").setup()
        end,
    },
    {
        "NvChad/nvim-colorizer.lua",
        cmd = { "ColorizerToggle" },
    },
    {
        "christoomey/vim-sort-motion",
        event = { "VeryLazy" },
    },
    {
        "famiu/bufdelete.nvim",
        cmd = { "Bdelete" },
    },
    {
        "godlygeek/tabular",
        cmd = { "Tabularize" },
    },
    {
        "danymat/neogen",
        cmd = { "Neogen" },
        config = function()
            require("neogen").setup({ snippet_engine = "luasnip" })
        end,
    },
    {
        "kylechui/nvim-surround",
        event = { "VeryLazy" },
        config = function()
            require("nvim-surround").setup()
        end,
    },
    {
        "mbbill/undotree",
        cmd = { "UndotreeToggle" },
    },
    {
        "mizlan/iswap.nvim",
        cmd = { "ISwapWith", "ISwap" },
    },
    -- }}}
    --------------------------------------------------------------------------------

    --------------------------------------------------------------------------------
    --  NOTE: motions {{{
    --------------------------------------------------------------------------------
    {
        "wellle/targets.vim",
        event = { "VeryLazy" },
    },
    -- }}}
    --------------------------------------------------------------------------------

    --------------------------------------------------------------------------------
    --  NOTE: languages {{{
    --------------------------------------------------------------------------------
    {
        "baskerville/vim-sxhkdrc",
        event = { "VeryLazy" },
    },
    {
        "antonk52/markdowny.nvim",
        ft = { "markdown", "text" },
        keys = { "<C-b>", "<C-k>", "<C-i>" },
        config = function()
            require("markdowny").setup()
        end,
    },
    {
        "ellisonleao/glow.nvim",
        ft = "markdown",
        cmd = { "Glow" },
    },
    {
        "iamcco/markdown-preview.nvim",
        build = function()
            vim.fn["mkdp#util#install"]()
        end,
        ft = "markdown",
        cmd = { "MarkdownPreviewToggle" },
    },
    {
        "dhruvasagar/vim-table-mode",
        -- ft = { "markdown", "txt" },
        cmd = { "TableModeToggle" },
    },
    {
        "ray-x/go.nvim",
        ft = "go",
    },
    -- }}}
    --------------------------------------------------------------------------------

    --------------------------------------------------------------------------------
    --  NOTE: colorschemes {{{
    --------------------------------------------------------------------------------
    {
        "lalitmee/cobalt2.nvim",
        dependencies = "tjdevries/colorbuddy.nvim",
        event = { "VimEnter" },
        lazy = true,
        dev = true,
    },
    -- }}}
    --------------------------------------------------------------------------------

    --------------------------------------------------------------------------------
    --  NOTE: enhancements {{{
    --------------------------------------------------------------------------------
    {
        "nvim-colortils/colortils.nvim",
        cmd = { "Colortils" },
        config = function()
            require("colortils").setup()
        end,
    },
    {
        "tweekmonster/startuptime.vim",
        cmd = "StartupTime",
    },
    {
        "wakatime/vim-wakatime",
        event = { "VimEnter" },
    },
    {
        "ziontee113/icon-picker.nvim",
        config = function()
            require("icon-picker")
        end,
        cmd = { "PickEverything" },
    },
    {
        "pwntester/octo.nvim",
        cmd = { "Octo" },
        config = function()
            require("octo").setup()
        end,
    },
    {
        "romainl/vim-cool",
        event = { "VeryLazy" },
    },
    -- }}}
    --------------------------------------------------------------------------------

    --------------------------------------------------------------------------------
    --  NOTE: tpope {{{
    --------------------------------------------------------------------------------
    {
        "tpope/vim-dispatch",
        cmd = { "Dispatch", "Focus", "Make", "Start" },
    },
    {
        "tpope/vim-eunuch",
        cmd = {
            "Cfind",
            "Chmod",
            "Clocate",
            "Copy",
            "Delete",
            "Duplicate",
            "Lfind",
            "Llocate",
            "Mkdir",
            "Move",
            "Remove",
            "Rename",
            "SudoEdit",
            "SudoWrite",
            "Wall",
        },
    },
    {
        "tpope/vim-abolish",
        event = { "VeryLazy" },
    },
    {
        "tpope/vim-repeat",
        event = { "VeryLazy" },
    },
    {
        "tpope/vim-scriptease",
        cmd = { "Messages", "Verbose" },
    },
    {
        "tpope/vim-unimpaired",
        event = { "VeryLazy" },
    },
    -- }}}
    --------------------------------------------------------------------------------

    --------------------------------------------------------------------------------
    --  NOTE: ThePrimeagen {{{
    --------------------------------------------------------------------------------
    {
        "ThePrimeagen/git-worktree.nvim",
        keys = {
            {
                "<leader>ga",
                "<cmd>Telescope git_worktree create_git_worktree<cr>",
                desc = "create-git-worktree",
            },
            {
                "<leader>gl",
                "<cmd>Telescope git_worktree git_worktrees<cr>",
                desc = "list-worktrees",
            },
        },
        config = function()
            require("telescope").load_extension("git_worktree")
        end,
    },
    {
        "ThePrimeagen/vim-be-good",
        cmd = { "VimBeGood" },
    },
    { -- treat terminal windows as buffers so that :bd! can work
        "boltlessengineer/bufterm.nvim",
        event = { "VeryLazy" },
        config = function()
            require("bufterm").setup()
        end,
    },
    -- }}}
    --------------------------------------------------------------------------------

    --------------------------------------------------------------------------------
    --  NOTE: disabled {{{
    --------------------------------------------------------------------------------
    {
        "LeonHeidelbach/trailblazer.nvim",
        event = { "VeryLazy" },
        config = function()
            require("trailblazer").setup()
        end,
        enabled = false,
    },
    -- }}}
    --------------------------------------------------------------------------------
}

-- vim:fdm=marker
