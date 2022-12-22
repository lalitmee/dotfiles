--------------------------------------------------------------------------------
-- NOTE: plugins setup {{{
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
-- NOTE: packer startup {{{
--------------------------------------------------------------------------------
return {
    { "lewis6991/impatient.nvim" },
    {
        "tweekmonster/startuptime.vim",
        cmd = "StartupTime",
    },
    { "nvim-lua/plenary.nvim" },
    {
        "rcarriga/nvim-notify",
    },
    {
        "lalitmee/cobalt2.nvim",
        dependencies = "tjdevries/colorbuddy.nvim",
    },
    {
        "NvChad/nvim-colorizer.lua",
        cmd = { "ColorizerToggle" },
    },
    {
        "https://gitlab.com/yorickpeterse/nvim-pqf.git",
        enabled = false,
        config = function()
            require("pqf").setup()
        end,
    },
    {
        "kylechui/nvim-surround",
        config = function()
            require("nvim-surround").setup()
        end,
    },
    {
        "ziontee113/icon-picker.nvim",
        config = function()
            require("icon-picker")
        end,
        cmd = { "PickEverything" },
    },
    {
        "nvim-colortils/colortils.nvim",
        cmd = { "Colortils" },
        config = function()
            require("colortils").setup()
        end,
    },
    {
        "wakatime/vim-wakatime",
        event = { "VimEnter" },
    },
    { "mbbill/undotree" },
    {
        "mizlan/iswap.nvim",
    },
    { "romainl/vim-cool" },
    {
        "nullchilly/fsread.nvim",
        cmd = { "FSToggle" },
    },
    { "famiu/bufdelete.nvim" },
    { "wellle/targets.vim" },
    { "christoomey/vim-sort-motion" },
    {
        "L3MON4D3/LuaSnip",
        dependencies = {
            "rafamadriz/friendly-snippets",
            "honza/vim-snippets",
        },
    },
    { "mhartington/formatter.nvim" },
    {
        "godlygeek/tabular",
        cmd = { "Tabularize" },
    },
    {
        "danymat/neogen",
        cmd = { "Neogen" },
        config = function()
            require("neogen").setup({
                snippet_engine = "luasnip",
            })
        end,
    },
    { "baskerville/vim-sxhkdrc" },
    { "mattn/emmet-vim" },
    { "ray-x/go.nvim", ft = "go" },
    {
        "andrewferrier/debugprint.nvim",
        config = function()
            require("debugprint").setup()
        end,
    },
    {
        "ellisonleao/glow.nvim",
        ft = "markdown",
    },
    {
        "iamcco/markdown-preview.nvim",
        run = function()
            vim.fn["mkdp#util#install"]()
        end,
        ft = "markdown",
    },
    {
        "ThePrimeagen/git-worktree.nvim",
        after = "telescope.nvim",
        config = function()
            require("telescope").load_extension("git_worktree")
        end,
    },
    {
        "sindrets/diffview.nvim",
        config = function()
            require("diffview").setup({
                enhanced_diff_hl = true,
                key_bindings = {
                    file_panel = { q = "<Cmd>DiffviewClose<CR>" },
                    view = { q = "<Cmd>DiffviewClose<CR>" },
                },
            })
        end,
    },
    {
        "pwntester/octo.nvim",
        config = function()
            require("octo").setup()
        end,
    },
    {
        "SmiteshP/nvim-navic",
        config = function()
            require("nvim-navic").setup({
                highlight = true,
            })
        end,
    },
    { "ThePrimeagen/vim-be-good" },
    { "tpope/vim-abolish" },
    { "tpope/vim-repeat" },
    { "tpope/vim-scriptease" },
    {
        "elihunter173/dirbuf.nvim",
        cmd = { "Dirbuf", "DirbufSync" },
        keys = { { "n", "-" } },
        config = function()
            vim.cmd([[autocmd VimEnter * autocmd! dirbuf]])
        end,
    },
    {
        "phaazon/mind.nvim",
        config = function()
            require("mind").setup({
                ui = { width = 80 },
            })
        end,
    },
    {
        "gaoDean/autolist.nvim",
        config = function()
            require("autolist").setup({
                enable = true,
                enabled_filetypes = { "markdown", "text", "norg" },
            })
        end,
    },
    {
        "jackMort/ChatGPT.nvim",
        config = function()
            require("chatgpt").setup()
        end,
    },
    -- }}}
    ----------------------------------------------------------------------

    ----------------------------------------------------------------------
    -- NOTE: reading {{{
    ----------------------------------------------------------------------
    -- }}}
    ----------------------------------------------------------------------
}

-- }}}
--------------------------------------------------------------------------------

-- }}}
--------------------------------------------------------------------------------

-- vim:foldmethod=marker
