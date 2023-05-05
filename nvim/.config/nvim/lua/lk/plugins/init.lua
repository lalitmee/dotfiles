return {
    ---------------------------------------------------------------------------
    --  NOTE: must {{{
    ---------------------------------------------------------------------------
    {
        "nvim-lua/plenary.nvim",
        event = { "VeryLazy" },
    },
    -- }}}
    ---------------------------------------------------------------------------

    ---------------------------------------------------------------------------
    --  NOTE: UI {{{
    ---------------------------------------------------------------------------
    {
        "m4xshen/smartcolumn.nvim",
        event = { "BufReadPost" },
        config = function()
            require("smartcolumn").setup({
                disabled_filetypes = {
                    "toggleterm",
                    "lazy",
                    "mason",
                    "help",
                },
            })
        end,
    },
    -- }}}
    ---------------------------------------------------------------------------

    ---------------------------------------------------------------------------
    --  NOTE: actions {{{
    ---------------------------------------------------------------------------
    {
        "jghauser/fold-cycle.nvim",
        keys = { "<CR>" },
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
        "andrewferrier/debugprint.nvim",
        keys = {
            "g?",
            { "g?", mode = "v" },
        },
        cmd = { "DeleteDebugPrints" },
        opts = {},
    },
    {
        "NvChad/nvim-colorizer.lua",
        cmd = { "ColorizerToggle" },
    },
    {
        "christoomey/vim-sort-motion",
        keys = {
            "gs",
            { "gs", mode = "v" },
        },
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
        "kylechui/nvim-surround",
        keys = { "ds", "ys" },
        opts = {},
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
    ---------------------------------------------------------------------------

    ---------------------------------------------------------------------------
    --  NOTE: motions {{{
    ---------------------------------------------------------------------------
    {
        "wellle/targets.vim",
        event = { "VeryLazy" },
    },
    -- }}}
    ---------------------------------------------------------------------------

    ---------------------------------------------------------------------------
    --  NOTE: languages {{{
    ---------------------------------------------------------------------------
    {
        "NMAC427/guess-indent.nvim",
        event = { "VeryLazy" },
        opts = {},
    },
    {
        "Vimjas/vim-python-pep8-indent",
        ft = "python",
    },
    {
        "baskerville/vim-sxhkdrc",
        ft = { "sxhkdrc" },
    },
    {
        "antonk52/markdowny.nvim",
        ft = { "markdown" },
        keys = {
            { "<C-b>", mode = "v" },
            { "<C-k>", mode = "v" },
            { "<C-i>", mode = "v" },
        },
        opts = {},
    },
    {
        "iamcco/markdown-preview.nvim",
        build = function()
            vim.fn["mkdp#util#install"]()
        end,
        ft = "markdown",
        cmd = { "MarkdownPreview" },
    },
    {
        "ray-x/go.nvim",
        ft = "go",
    },
    -- }}}
    ---------------------------------------------------------------------------

    ---------------------------------------------------------------------------
    --  NOTE: enhancements {{{
    ---------------------------------------------------------------------------
    {
        "nvim-colortils/colortils.nvim",
        cmd = { "Colortils" },
        opts = {},
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
        opts = {},
    },
    {
        "romainl/vim-cool",
        event = { "VeryLazy" },
    },
    -- }}}
    ---------------------------------------------------------------------------

    ---------------------------------------------------------------------------
    --  NOTE: ThePrimeagen {{{
    ---------------------------------------------------------------------------
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
    -- }}}
    ---------------------------------------------------------------------------

    --------------------------------------------------------------------------------
    --  NOTE: notes {{{
    --------------------------------------------------------------------------------
    {
        "JellyApple102/flote.nvim",
        cmd = { "Flote" },
        opts = {},
        enabled = false,
    },
    -- }}}
    --------------------------------------------------------------------------------

    ---------------------------------------------------------------------------
    --  NOTE: disabled {{{
    ---------------------------------------------------------------------------
    -- }}}
    ---------------------------------------------------------------------------
}
