return {
    {
        "nvim-lua/plenary.nvim",
        event = { "VeryLazy" },
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
    {
        "baskerville/vim-sxhkdrc",
        event = { "VeryLazy" },
    },
    {
        "christoomey/vim-sort-motion",
        event = { "VeryLazy" },
    },
    {
        "danymat/neogen",
        cmd = { "Neogen" },
        config = function()
            require("neogen").setup({ snippet_engine = "luasnip" })
        end,
    },
    {
        "ellisonleao/glow.nvim",
        ft = "markdown",
        cmd = { "Glow" },
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
        url = "https://gitlab.com/yorickpeterse/nvim-pqf.git",
        ft = "qf",
        config = function()
            require("pqf").setup()
        end,
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
        "kylechui/nvim-surround",
        event = { "VeryLazy" },
        config = function()
            require("nvim-surround").setup()
        end,
    },
    {
        "lalitmee/cobalt2.nvim",
        dependencies = "tjdevries/colorbuddy.nvim",
        event = { "VimEnter" },
        lazy = true,
    },
    {
        "mbbill/undotree",
        cmd = { "UndotreeToggle" },
    },
    {
        "mizlan/iswap.nvim",
        cmd = { "ISwapWith", "ISwap" },
    },
    {
        "nvim-colortils/colortils.nvim",
        cmd = { "Colortils" },
        config = function()
            require("colortils").setup()
        end,
    },
    {
        "pwntester/octo.nvim",
        cmd = { "Octo" },
        config = function()
            require("octo").setup()
        end,
    },
    {
        "ray-x/go.nvim",
        ft = "go",
    },
    {
        "rcarriga/nvim-notify",
        event = { "VeryLazy" },
    },
    {
        "romainl/vim-cool",
        event = { "VeryLazy" },
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
        "tweekmonster/startuptime.vim",
        cmd = "StartupTime",
    },
    {
        "wakatime/vim-wakatime",
        event = { "VimEnter" },
    },
    {
        "wellle/targets.vim",
        event = { "VeryLazy" },
    },
    {
        "ziontee113/icon-picker.nvim",
        config = function()
            require("icon-picker")
        end,
        cmd = { "PickEverything" },
    },
    {
        "andymass/vim-matchup",
        event = { "BufReadPost" },
        init = function()
            vim.g.matchup_matchparen_offscreen = {
                method = "popup",
                border = "rounded",
            }
        end,
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
        "ckolkey/ts-node-action",
        event = { "VeryLazy" },
        dependencies = { "nvim-treesitter" },
        init = function()
            lk.nnoremap("<leader>k", require("ts-node-action").node_action, { desc = "Trigger Node Action" })
        end,
    },
    {
        "LeonHeidelbach/trailblazer.nvim",
        event = { "VeryLazy" },
        config = function()
            require("trailblazer").setup()
        end,
        enabled = false,
    },
    { -- will add bang(#!) like this on running `:Bang`
        "susensio/magic-bang.nvim",
        cmd = { "Bang" },
        config = function()
            require("magic-bang").setup()
        end,
    },
}
