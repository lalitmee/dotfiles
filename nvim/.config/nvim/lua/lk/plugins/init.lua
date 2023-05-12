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
        "andymass/vim-matchup",
        event = "BufReadPost",
        config = function()
            vim.g.matchup_matchparen_offscreen = { method = "status_manual" }
        end,
    },
    {
        "NvChad/nvim-colorizer.lua",
        cmd = { "ColorizerToggle" },
        config = true,
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
    --  NOTE: enhancements {{{
    ---------------------------------------------------------------------------
    {
        "NMAC427/guess-indent.nvim",
        event = { "VeryLazy" },
        opts = {},
    },
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
