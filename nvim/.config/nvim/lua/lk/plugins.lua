return {
    {
        "L3MON4D3/LuaSnip",
        dependencies = {
            "rafamadriz/friendly-snippets",
            "honza/vim-snippets",
        },
    },
    {
        "andrewferrier/debugprint.nvim",
        config = function()
            require("debugprint").setup()
        end,
    },
    { "NvChad/nvim-colorizer.lua", cmd = { "ColorizerToggle" } },
    {
        "SmiteshP/nvim-navic",
        config = function()
            require("nvim-navic").setup({ highlight = true })
        end,
    },
    {
        "ThePrimeagen/git-worktree.nvim",
        after = "telescope.nvim",
        config = function()
            require("telescope").load_extension("git_worktree")
        end,
    },
    { "ThePrimeagen/vim-be-good" },
    { "baskerville/vim-sxhkdrc" },
    { "christoomey/vim-sort-motion" },
    {
        "danymat/neogen",
        cmd = { "Neogen" },
        config = function()
            require("neogen").setup({ snippet_engine = "luasnip" })
        end,
    },
    { "ellisonleao/glow.nvim", ft = "markdown" },
    { "famiu/bufdelete.nvim" },
    {
        "gaoDean/autolist.nvim",
        config = function()
            require("autolist").setup({ enable = true, enabled_filetypes = { "markdown", "text", "norg" } })
        end,
    },
    { "godlygeek/tabular", cmd = { "Tabularize" } },
    {
        url = "https://gitlab.com/yorickpeterse/nvim-pqf.git",
        config = function()
            require("pqf").setup()
        end,
    },
    {
        "iamcco/markdown-preview.nvim",
        run = function()
            vim.fn["mkdp#util#install"]()
        end,
        ft = "markdown",
    },
    {
        "jackMort/ChatGPT.nvim",
        config = function()
            require("chatgpt").setup()
        end,
    },
    {
        "kylechui/nvim-surround",
        config = function()
            require("nvim-surround").setup()
        end,
    },
    { "lalitmee/cobalt2.nvim", dependencies = "tjdevries/colorbuddy.nvim" },
    { "lewis6991/impatient.nvim" },
    { "mattn/emmet-vim" },
    { "mbbill/undotree" },
    { "mhartington/formatter.nvim" },
    { "mizlan/iswap.nvim" },
    { "nullchilly/fsread.nvim", cmd = { "FSToggle" } },
    {
        "nvim-colortils/colortils.nvim",
        cmd = { "Colortils" },
        config = function()
            require("colortils").setup()
        end,
    },
    { "nvim-lua/plenary.nvim" },
    {
        "phaazon/mind.nvim",
        config = function()
            require("mind").setup({ ui = { width = 80 } })
        end,
    },
    {
        "pwntester/octo.nvim",
        config = function()
            require("octo").setup()
        end,
    },
    { "ray-x/go.nvim", ft = "go" },
    { "rcarriga/nvim-notify" },
    { "romainl/vim-cool" },
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
    { "tpope/vim-abolish" },
    { "tpope/vim-repeat" },
    { "tpope/vim-scriptease" },
    { "tweekmonster/startuptime.vim", cmd = "StartupTime" },
    { "wakatime/vim-wakatime", event = { "VimEnter" } },
    { "wellle/targets.vim" },
    {
        "ziontee113/icon-picker.nvim",
        config = function()
            require("icon-picker")
        end,
        cmd = { "PickEverything" },
    },
}

-- vim:foldmethod=marker
