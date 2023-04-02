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
        "LintaoAmons/scratch.nvim",
        cmd = {
            "ScratchCheckConfig",
            "ScratchEditConfig",
            "Scratch",
            "ScratchOpen",
            "ScratchWithName",
            "ScratchOpenFzf",
        },
    },
    {
        "axieax/urlview.nvim",
        cmd = { "UrlView" },
        opts = {},
    },
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
    { -- will add bang(#!) like this on running `:Bang`
        "susensio/magic-bang.nvim",
        cmd = { "Bang" },
        config = function()
            require("magic-bang").setup()
        end,
    },
    {
        "andrewferrier/debugprint.nvim",
        keys = {
            "g?",
            { "g?", mode = "v" },
        },
        cmd = { "DeleteDebugPrints" },
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
        "danymat/neogen",
        cmd = { "Neogen" },
        config = function()
            require("neogen").setup({ snippet_engine = "luasnip" })
        end,
    },
    {
        "kylechui/nvim-surround",
        keys = { "ds", "ys" },
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
        ft = { "markdown", "text" },
        keys = {
            { "<C-b>", mode = "v" },
            { "<C-k>", mode = "v" },
            { "<C-i>", mode = "v" },
        },
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
        cmd = { "MarkdownPreview" },
    },
    {
        "dhruvasagar/vim-table-mode",
        cmd = { "TableModeToggle" },
    },
    {
        "ray-x/go.nvim",
        ft = "go",
    },
    -- }}}
    ---------------------------------------------------------------------------

    ---------------------------------------------------------------------------
    --  NOTE: colorschemes {{{
    ---------------------------------------------------------------------------
    {
        "lalitmee/cobalt2.nvim",
        event = { "ColorSchemePre" },
        dependencies = { "tjdevries/colorbuddy.nvim" },
        init = function()
            require("colorbuddy").colorscheme("cobalt2")
            local links = {
                ["@lsp.type.namespace"] = "@namespace",
                ["@lsp.type.type"] = "@type",
                ["@lsp.type.class"] = "@type",
                ["@lsp.type.enum"] = "@type",
                ["@lsp.type.interface"] = "@type",
                ["@lsp.type.struct"] = "@structure",
                ["@lsp.type.parameter"] = "@parameter",
                ["@lsp.type.variable"] = "@variable",
                ["@lsp.type.property"] = "@property",
                ["@lsp.type.enumMember"] = "@constant",
                ["@lsp.type.function"] = "@function",
                ["@lsp.type.method"] = "@method",
                ["@lsp.type.macro"] = "@macro",
                ["@lsp.type.decorator"] = "@function",
            }
            for newgroup, oldgroup in pairs(links) do
                vim.api.nvim_set_hl(0, newgroup, {
                    link = oldgroup,
                    default = true,
                })
            end

            -- -- disable semantic highlighting
            -- for _, group in ipairs(
            -- vim.fn.getcompletion("@lsp", "highlight")) do
            --     vim.api.nvim_set_hl(0, group, {})
            -- end
        end,
        dev = true,
    },
    -- }}}
    ---------------------------------------------------------------------------

    ---------------------------------------------------------------------------
    --  NOTE: enhancements {{{
    ---------------------------------------------------------------------------
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
    ---------------------------------------------------------------------------

    ---------------------------------------------------------------------------
    --  NOTE: tpope {{{
    ---------------------------------------------------------------------------
    {
        "tpope/vim-abolish",
        event = { "VeryLazy" },
    },
    {
        "tpope/vim-repeat",
        keys = { "." },
    },
    {
        "tpope/vim-scriptease",
        cmd = { "Messages", "Verbose" },
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

-- vim:fdm=marker
