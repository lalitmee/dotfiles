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
        enabled = false,
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
        opts = {},
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
        "danymat/neogen",
        cmd = { "Neogen" },
        config = function()
            require("neogen").setup({ snippet_engine = "luasnip" })
        end,
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
    --  NOTE: colorschemes {{{
    ---------------------------------------------------------------------------
    {
        "catppuccin/nvim",
        event = { "ColorSchemePre" },
        name = "catppuccin",
        init = function()
            require("catppuccin").setup({
                flavour = "mocha", -- latte, frappe, macchiato, mocha
                background = { -- :h background
                    light = "latte",
                    dark = "mocha",
                },
                transparent_background = true,
                show_end_of_buffer = false, -- show the '~' characters after the end of buffers
                term_colors = true,
                dim_inactive = {
                    enabled = false,
                    shade = "dark",
                    percentage = 0.15,
                },
                no_italic = false, -- Force no italic
                no_bold = false, -- Force no bold
                styles = {
                    comments = { "italic" },
                    conditionals = { "italic" },
                    loops = {},
                    functions = {},
                    keywords = { "italic" },
                    strings = {},
                    variables = {},
                    numbers = {},
                    booleans = {},
                    properties = {},
                    types = {},
                    operators = {},
                },
                color_overrides = {},
                custom_highlights = {},
                integrations = {
                    cmp = true,
                    gitsigns = true,
                    nvimtree = true,
                    telescope = true,
                    notify = true,
                    mini = false,
                },
            })

            vim.cmd.colorscheme("catppuccin")
        end,
        -- enabled = false,
    },
    {
        dir = "~/Desktop/Github/cobalt2.nvim",
        event = { "ColorSchemePre" },
        dependencies = { "tjdevries/colorbuddy.nvim" },
        init = function()
            require("colorbuddy").colorscheme("cobalt2")
        end,
        dev = true,
        enabled = false,
    },
    {
        "Mofiqul/vscode.nvim",
        event = { "ColorSchemePre" },
        init = function()
            require("vscode").setup({
                transparent = true,
                italic_comments = true,
                disable_nvimtree_bg = true,
            })
            require("vscode").load()
        end,
        enabled = false,
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
