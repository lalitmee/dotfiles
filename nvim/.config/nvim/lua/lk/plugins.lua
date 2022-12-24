return {
    { "nvim-lua/plenary.nvim" },
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
        "SmiteshP/nvim-navic",
        enabled = false,
        config = function()
            require("nvim-navic").setup({
                highlight = true,
            })
        end,
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
    { "ThePrimeagen/vim-be-good" },
    { "baskerville/vim-sxhkdrc" },
    {
        "christoomey/vim-sort-motion",
        keys = { "gs" },
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
        "gaoDean/autolist.nvim",
        ft = { "markdown", "text", "norg" },
        config = function()
            require("autolist").setup({
                enable = true,
                enabled_filetypes = { "markdown", "text", "norg" },
            })
        end,
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
        "jackMort/ChatGPT.nvim",
        cmd = {
            "ChatGPT",
            "ChatGPTActAs",
            "ChatGPTEditWithInstructions",
        },
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
    {
        "lalitmee/cobalt2.nvim",
        dependencies = "tjdevries/colorbuddy.nvim",
    },
    { "mattn/emmet-vim" },
    {
        "mbbill/undotree",
        cmd = { "UndotreeToggle" },
    },
    {
        "mhartington/formatter.nvim",
        cmd = { "FormatWrite" },
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
        "phaazon/mind.nvim",
        cmd = {
            "MindOpenMain",
            "MindOpenProject",
            "MindOpenSmartProject",
        },
        config = function()
            require("mind").setup({
                ui = { width = 80 },
            })
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
    { "rcarriga/nvim-notify" },
    { "romainl/vim-cool" },
    {
        "sindrets/diffview.nvim",
        cmd = {
            "DiffviewOpen",
            "DiffviewFileHistory",
            "DiffviewLog",
        },
        config = function()
            require("diffview").setup({
                enhanced_diff_hl = true,
                key_bindings = {
                    file_panel = {
                        q = "<Cmd>DiffviewClose<CR>",
                    },
                    view = {
                        q = "<Cmd>DiffviewClose<CR>",
                    },
                },
            })
        end,
    },
    { "tpope/vim-abolish" },
    { "tpope/vim-repeat" },
    {
        "tpope/vim-scriptease",
        cmd = { "Message", "Verbose" },
    },
    {
        "tweekmonster/startuptime.vim",
        cmd = "StartupTime",
    },
    {
        "wakatime/vim-wakatime",
        event = { "VimEnter" },
    },
    { "wellle/targets.vim" },
    {
        "ziontee113/icon-picker.nvim",
        config = function()
            require("icon-picker")
        end,
        cmd = { "PickEverything" },
    },
    {
        "andymass/vim-matchup",
        event = "BufReadPost",
        config = function()
            vim.g.matchup_matchparen_offscreen = { method = "status_manual" }
        end,
    },
}

-- vim:foldmethod=marker
