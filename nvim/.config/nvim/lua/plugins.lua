--------------------------------------------------------------------------------
-- NOTE: plugins setup {{{
--------------------------------------------------------------------------------
-- cfilter plugin allows filter down an existing quickfix list
-- vim.cmd([[packadd! cfilter]])

--------------------------------------------------------------------------------
-- NOTE: packer startup {{{
--------------------------------------------------------------------------------
require("packer").startup({
  function(use)
    --------------------------------------------------------------------------------
    -- NOTE: Packer and speed ups {{{
    --------------------------------------------------------------------------------
    use({ "wbthomason/packer.nvim" })
    use({ "lewis6991/impatient.nvim" })

    -- fast filetype detection
    use({ "nathom/filetype.nvim" })

    -- Profile startup time
    use({
      "tweekmonster/startuptime.vim",
      cmd = "StartupTime",
    })

    use({
      "antoinemadec/FixCursorHold.nvim",
      run = function()
        vim.g.curshold_updatime = 1000
      end,
    })
    -- }}}
    --------------------------------------------------------------------------------

    ----------------------------------------------------------------------------
    -- NOTE: UI and Beautify {{{
    ----------------------------------------------------------------------------
    -- improve default neovim UI
    use({
      "stevearc/dressing.nvim",
      event = { "BufEnter" },
      module = "vim.ui",
      config = [[require('lk/plugins/dressing')]],
    })

    ----------------------------------------------------------------------------
    -- NOTE: notifications {{{
    ----------------------------------------------------------------------------
    use({
      "rcarriga/nvim-notify",
      module = "vim",
      config = [[require('lk/plugins/notify')]],
    })
    -- }}}
    ----------------------------------------------------------------------------

    ----------------------------------------------------------------------------
    -- NOTE: colorschemes {{{
    ----------------------------------------------------------------------------
    use({
      "/home/lalitmee/Desktop/Github/cobalt2.nvim",
      requires = "tjdevries/colorbuddy.nvim",
    })
    -- }}}
    ----------------------------------------------------------------------------

    ----------------------------------------------------------------------------
    -- NOTE: icons {{{
    ----------------------------------------------------------------------------
    use({
      "yamatsum/nvim-nonicons",
      requires = { "kyazdani42/nvim-web-devicons" },
      config = [[require('lk/plugins/devicons')]],
      event = { "BufRead" },
    })

    -- }}}
    ----------------------------------------------------------------------------

    ----------------------------------------------------------------------------
    -- NOTE: general {{{
    ----------------------------------------------------------------------------
    -- highlighting of todo comments
    use({
      "folke/todo-comments.nvim",
      config = [[require('lk/plugins/todo-comments')]],
    })

    -- which-key
    use({
      "folke/which-key.nvim",
      config = [[require('lk/plugins/which-key')]],
    })

    -- session management
    use({
      "rmagatti/session-lens",
      after = { "telescope.nvim", "auto-session" },
      cmd = { "SearchSession" },
      requires = {
        "rmagatti/auto-session",
        config = [[require('lk/plugins/auto-session')]],
      },
      config = [[require('lk/plugins/session-lens')]],
    })

    -- Colorizer for showing the colors
    use({
      "norcalli/nvim-colorizer.lua",
      config = [[require('lk/plugins/colorizer')]],
      cmd = { "ColorizerToggle", "ColorizerAttachToBuffer" },
    })

    -- better quick-fix winodw
    use({
      "kevinhwang91/nvim-bqf",
      ft = { "qf" },
      config = [[require('lk/plugins/nvim-bqf')]],
    })

    -- prettify quickfix windows for neovim
    use({
      "https://gitlab.com/yorickpeterse/nvim-pqf.git",
      config = [[require('lk/plugins/nvim-pqf')]],
    })
    -- }}}
    ----------------------------------------------------------------------------
    -- }}}
    ----------------------------------------------------------------------------

    ------------------------------------------------------------------------
    -- NOTE: ACTIONS {{{
    ------------------------------------------------------------------------
    -- makes quickfix list editable
    use({
      "gabrielpoca/replacer.nvim",
      cmd = { "ReplacerRun", "ReplacerRunFiles" },
    })

    -- projects management
    use({
      "ahmedkhalf/project.nvim",
      after = "telescope.nvim",
      config = function()
        require("telescope").load_extension("projects")
        require("project_nvim").setup({
          show_hidden = true,
        })
      end,
    })

    -- wakatime for vim
    use({
      "wakatime/vim-wakatime",
      event = { "VimEnter" },
    })

    -- better increment
    use({
      "monaqa/dial.nvim",
      keys = {
        { "n", "<C-a>" },
        { "n", "<C-x>" },
        { "v", "<C-a>" },
        { "v", "<C-x>" },
        { "v", "g<C-a>" },
        { "v", "g<C-x>" },
      },
      config = [[require('lk/plugins/dial')]],
    })

    -- yank history after paste with `<C-n>` and `<C-p>`
    use({
      "svermeulen/vim-yoink",
      config = [[require('lk/plugins/vim-yoink')]],
    })

    use({
      "gbprod/substitute.nvim",
      config = [[require('lk/plugins/substitute')]],
    })

    -- interactively swap so many things
    use({
      "mizlan/iswap.nvim",
      cmd = { "ISwap", "ISwapWith" },
    })

    -- toggle, display and navigate marks
    use({
      "chentau/marks.nvim",
      config = [[require('lk/plugins/marks')]],
    })

    -- clipboard
    use({
      "AckslD/nvim-neoclip.lua",
      after = { "telescope.nvim" },
      requires = { "tami5/sqlite.lua", module = "sqlite" },
      config = [[require('lk/plugins/neoclip')]],
    })

    ----------------------------------------------------------------------------
    -- NOTE: Search {{{
    ----------------------------------------------------------------------------
    -- Search and replace plugins
    use({
      "windwp/nvim-spectre",
      cmd = { "SpectreOpen" },
      module = "spectre",
    })

    -- search multiple thing using `*`
    use({
      "nelstrom/vim-visual-star-search",
      keys = { "v", "*" },
    })

    -- display search matches
    use({
      "kevinhwang91/nvim-hlslens",
      keys = {
        { "n", "/" },
        { "n", "?" },
        { "n", "*" },
        { "n", "g*" },
        { "n", "#" },
        { "n", "g#" },
      },
      config = [[require('lk/plugins/hlslens')]],
      requires = {
        { "haya14busa/incsearch.vim" },
        { "romainl/vim-cool" },
      },
    })

    -- search lines using numbers
    use({
      "nacro90/numb.nvim",
      keys = { "c", ":" },
      config = [[require('lk/plugins/numb')]],
    })

    -- easymotion using lua
    use({
      "phaazon/hop.nvim",
      config = [[require('lk/plugins/hop')]],
    })

    -- Quickscope same as f, F, t, T but better
    use({
      "unblevable/quick-scope",
      config = [[require('lk/plugins/quick-scope')]],
    })

    -- Navigations
    use({
      "ThePrimeagen/harpoon",
      cmd = {
        "HarpoonAddFile",
        "HarpoonGoToFile1",
        "HarpoonGoToFile2",
        "HarpoonGoToFile3",
        "HarpoonGoToFile4",
        "HarpoonGoToFile5",
        "HarpoonGoToFile6",
        "HarpoonGoToFile7",
        "HarpoonGoToFile8",
        "HarpoonGoToFile9",
        "HarpoonRemoveFile",
        "ToggleHarpoonMenu",
      },
      config = [[require('lk/plugins/harpoon')]],
    })
    -- }}}
    ----------------------------------------------------------------------------

    ------------------------------------------------------------------------
    -- NOTE: FUZZY SEARCH {{{
    ------------------------------------------------------------------------
    -- telescope.nvim
    use({ "nvim-lua/plenary.nvim" })
    use({
      "nvim-telescope/telescope.nvim",
      cmd = { "Telescope" },
      config = [[require('lk/plugins/telescope')]],
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
          "xiyaowong/telescope-emoji.nvim",
          after = "telescope.nvim",
          config = function()
            require("telescope").load_extension("emoji")
          end,
        },
        {
          "nvim-telescope/telescope-smart-history.nvim",
          after = "telescope.nvim",
          config = function()
            require("telescope").load_extension("smart_history")
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
          "nvim-telescope/telescope-media-files.nvim",
          after = "telescope.nvim",
          config = function()
            require("telescope").load_extension("media_files")
          end,
        },
        {
          "camgraff/telescope-tmux.nvim",
          requires = { "norcalli/nvim-terminal.lua" },
          after = "telescope.nvim",
          config = function()
            require("telescope").load_extension("tmux")
          end,
        },
        {
          "danielpieper/telescope-tmuxinator.nvim",
          after = "telescope.nvim",
          config = function()
            require("telescope").load_extension("tmuxinator")
          end,
        },
        {
          "nvim-telescope/telescope-hop.nvim",
          after = "telescope.nvim",
          config = function()
            require("telescope").load_extension("hop")
          end,
        },
      },
    })
    use({
      "nvim-telescope/telescope-file-browser.nvim",
      after = "telescope.nvim",
      config = function()
        require("telescope").load_extension("file_browser")
      end,
    })
    -- }}}
    ------------------------------------------------------------------------

    ----------------------------------------------------------------------------
    -- NOTE: General {{{
    ----------------------------------------------------------------------------
    -- move code up and down
    use({
      "booperlv/nvim-gomove",
      keys = {
        { "n", "<M-h>" },
        { "n", "<M-j>" },
        { "n", "<M-k>" },
        { "n", "<M-l>" },
        { "v", "<M-h>" },
        { "v", "<M-j>" },
        { "v", "<M-k>" },
        { "v", "<M-l>" },
      },
      config = [[require('lk/plugins/gomove')]],
    })

    -- smooth scrolling in neovim
    use({
      "karb94/neoscroll.nvim",
      keys = {
        { "n", "<C-u>" },
        { "n", "<C-d>" },
        { "n", "<C-b>" },
        { "n", "<C-f>" },
        { "n", "<C-y>" },
        { "n", "<C-e>" },
        { "n", "zt" },
        { "n", "zz" },
        { "n", "zb" },
      },
      config = [[require('lk/plugins/neoscroll')]],
    })

    -- delete buffers without distubing layout
    use({
      "kazhala/close-buffers.nvim",
      cmd = { "BDelete" },
      config = [[require('lk/plugins/close-buffers')]],
    })

    -- auto pairs
    use({
      "windwp/nvim-autopairs",
      keys = {
        { "i", "(" },
        { "i", "{" },
        { "i", "[" },
        { "i", "'" },
        { "i", '"' },
        { "i", "`" },
      },
      config = [[require('lk/plugins/autopairs')]],
    })

    -- match brackets and more
    use({
      "andymass/vim-matchup",
      keys = {
        { "n", "%" },
        { "v", "%" },
      },
    })

    -- extra text objects
    use({ "wellle/targets.vim" })

    -- split and join
    use({
      "AndrewRadev/splitjoin.vim",
      keys = {
        { "n", "gJ" },
        { "n", "gS" },
      },
    })

    -- sorting in vim
    use({
      "christoomey/vim-sort-motion",
      keys = {
        { "v", "gs" },
        { "n", "gs" },
      },
    })

    -- navigate and splits
    use({
      "numToStr/Navigator.nvim",
      config = [[require('lk/plugins/navigator')]],
      cmd = {
        "NavigateLeft",
        "NavigateRight",
        "NavigateUp",
        "NavigateDown",
        "NavigatePrevious",
      },
    })

    -- remove trailing whitespace and lines
    use({
      "McAuleyPenney/tidy.nvim",
      event = { "BufWritePre" },
    })

    -- nice fold text
    use({
      "anuvyklack/pretty-fold.nvim",
      event = { "BufEnter" },
      config = [[require('lk/plugins/pretty-fold')]],
    })

    -- fast folds in vim
    use({
      "Konfekt/FastFold",
      event = { "BufRead" },
      config = [[require('lk/plugins/fastfold')]],
    })

    -- commenting
    use({
      "numToStr/Comment.nvim",
      config = [[require('lk/plugins/comment')]],
      keys = {
        { "n", "gcc" },
        { "n", "gbc" },
        { "v", "gc" },
        { "v", "gb" },
      },
    })

    -- comment boxes
    use({
      "LudoPinelli/comment-box.nvim",
      cmd = {
        "CBlbox",
        "CBclbox",
        "CBcbox",
        "CBccbox",
        "CBalbox",
        "CBaclbox",
        "CBacbox",
        "CBaccbox",
      },
    })
    -- }}}
    ------------------------------------------------------------------------
    -- }}}
    ------------------------------------------------------------------------

    ------------------------------------------------------------------------
    -- NOTE: TEXT {{{
    ------------------------------------------------------------------------
    -- github copilot
    use({
      "github/copilot.vim",
      event = { "InsertEnter" },
      config = function()
        vim.g.copilot_filetypes = {
          gitcommit = false,
          NeogitCommitMessage = false,
        }
      end,
    })

    -- run any code of any file type
    use({
      "michaelb/sniprun",
      run = "bash ./install.sh",
      cmd = { "SnipRun" },
      opt = true,
    })

    ------------------------------------------------------------------------
    -- NOTE: Snippets {{{
    ------------------------------------------------------------------------
    -- -- snippets engine
    use({
      "SirVer/ultisnips",
      requires = { "honza/vim-snippets" },
      config = [[require('lk/plugins/ultisnips')]],
    })
    -- }}}
    ------------------------------------------------------------------------

    ------------------------------------------------------------------------
    -- NOTE: Format {{{
    ------------------------------------------------------------------------
    -- formatter in lua
    use({
      "mhartington/formatter.nvim",
      config = [[require('lk/plugins/formatter')]],
      cmd = { "FormatWrite" },
    })

    -- indentlines in neovim
    use({
      "lukas-reineke/indent-blankline.nvim",
      config = [[require('lk/plugins/indent-blankline')]],
      event = { "BufRead" },
    })

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

    --------------------------------------------------------------------------
    ---- NOTE: coc.nvim {{{
    --------------------------------------------------------------------------
    -- use 'neoclide/vim-jsx-improve'
    -- use 'Shougo/neco-vim'
    -- use 'neoclide/coc-neco'
    -- -- NOTE: Completion Conquerer
    -- use { 'neoclide/coc.nvim', branch = 'release', }
    -- use { 'fannheyward/go.vim', ft = 'go' }
    -- }}}
    --------------------------------------------------------------------------

    ------------------------------------------------------------------------
    -- NOTE: lspconfig {{{
    ------------------------------------------------------------------------
    use({
      "neovim/nvim-lspconfig",
      ft = vim.g.enable_lspconfig_ft,
      config = [[require('lk/plugins/lsp')]],
      requires = {
        { "onsails/lspkind-nvim" },
        {
          "hrsh7th/nvim-cmp",
          config = [[require('lk/plugins/nvim-cmp')]],
          event = { "InsertEnter", "CmdlineEnter" },
          requires = {
            {
              "hrsh7th/cmp-buffer",
              after = "nvim-cmp",
            },
            {
              "hrsh7th/cmp-cmdline",
              after = "nvim-cmp",
              event = { "CmdlineEnter" },
            },
            {
              "hrsh7th/cmp-nvim-lsp",
              after = "nvim-cmp",
            },
            {
              "hrsh7th/cmp-nvim-lua",
              after = "nvim-cmp",
              ft = { "lua" },
            },
            {
              "hrsh7th/cmp-path",
              after = "nvim-cmp",
            },
            {
              "hrsh7th/cmp-emoji",
              after = "nvim-cmp",
            },
            {
              "quangnguyen30192/cmp-nvim-ultisnips",
              after = "nvim-cmp",
            },
            {
              "tzachar/cmp-tabnine",
              run = "./install.sh",
              after = "nvim-cmp",
            },
          },
        },
        {
          "narutoxy/dim.lua",
          after = "nvim-lspconfig",
          requires = { "nvim-treesitter/nvim-treesitter", "neovim/nvim-lspconfig" },
          config = function()
            require("dim").setup({
              change_in_insert = true,
            })
          end,
        },
        {
          "ray-x/lsp_signature.nvim",
          config = function()
            require("lsp_signature").setup({
              bind = true,
              fix_pos = false,
              auto_close_after = 15, -- close after 15 seconds
              hint_enable = false,
              handler_opts = { border = "rounded" },
            })
          end,
        },
        { "onsails/diaglist.nvim" },
        { "williamboman/nvim-lsp-installer" },
        { "arkav/lualine-lsp-progress" },
        { "folke/lua-dev.nvim" },
      },
    })
    -- }}}
    ------------------------------------------------------------------------
    -- }}}
    ------------------------------------------------------------------------

    ------------------------------------------------------------------------
    -- NOTE: Treesitter {{{
    ------------------------------------------------------------------------
    use({
      "nvim-treesitter/nvim-treesitter",
      ft = vim.g.enable_treesitter_ft,
      config = [[require('lk/plugins/treesitter')]],
      run = ":TSUpdate",
      requires = {
        {
          "nvim-treesitter/nvim-treesitter-textobjects",
          after = { "nvim-treesitter" },
        },
        {
          "nvim-treesitter/playground",
          cmd = { "TSPlaygroundToggle" },
          after = { "nvim-treesitter" },
        },
        {
          "JoosepAlviste/nvim-ts-context-commentstring",
          after = { "nvim-treesitter", "Comment.nvim" },
        },
      },
    })

    -- annotations using treesitter
    use({
      "danymat/neogen",
      cmd = { "Neogen" },
      config = [[require('lk/plugins/neogen')]],
    })
    -- }}}
    ------------------------------------------------------------------------

    ----------------------------------------------------------------------------
    -- NOTE: Languages {{{
    ----------------------------------------------------------------------------
    -- refactor the code
    use({
      "ThePrimeagen/refactoring.nvim",
      after = { "nvim-treesitter" },
      config = [[require('lk/plugins/refactoring')]],
    })

    ----------------------------------------------------------------------------
    -- NOTE: markdown {{{
    ----------------------------------------------------------------------------
    -- preview markdown in neovim
    use({
      "ellisonleao/glow.nvim",
      ft = "markdown",
      cmd = { "Glow" },
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
    use({
      "rhysd/conflict-marker.vim",
      config = [[require('lk/plugins/conflict-marker')]],
    })

    -- git actions using telescope
    use({
      "pwntester/octo.nvim",
      requires = {
        "nvim-lua/plenary.nvim",
        "nvim-telescope/telescope.nvim",
        "kyazdani42/nvim-web-devicons",
      },
      config = [[require('lk/plugins/octo')]],
      after = { "telescope.nvim" },
      keys = { "n", "<leader>go" },
    })

    -- git worktree
    use({
      "ThePrimeagen/git-worktree.nvim",
      after = "telescope.nvim",
      config = function()
        require("telescope").load_extension("git_worktree")
      end,
    })

    -- magit for neovim in lua
    use({
      "TimUntersberger/neogit",
      requires = { "nvim-lua/plenary.nvim" },
      cmd = { "Neogit" },
      config = [[require('lk/plugins/neogit')]],
    })

    -- gitsigns in lua
    use({
      "lewis6991/gitsigns.nvim",
      requires = { "nvim-lua/plenary.nvim" },
      event = { "BufRead" },
      config = [[require('lk/plugins/gitsigns')]],
    })

    -- git lens in vim
    use({
      "sindrets/diffview.nvim",
      requires = { "nvim-lua/plenary.nvim" },
      config = [[require('lk/plugins/diffview')]],
      cmd = { "DiffviewOpen", "DiffviewFileHistory" },
    })
    -- }}}
    ------------------------------------------------------------------------

    ------------------------------------------------------------------------
    -- NOTE: STATUS AND TAB LINES {{{
    ------------------------------------------------------------------------
    -- use({ "tjdevries/express_line.nvim" })

    -- lualine.nvim
    use({
      "nvim-lualine/lualine.nvim",
      config = [[require('lk/plugins/lualine')]],
    })

    -- bufferline
    use({
      "akinsho/nvim-bufferline.lua",
      event = { "BufRead" },
      config = [[require('lk/plugins/bufferline')]],
    })
    -- }}}
    ------------------------------------------------------------------------

    ------------------------------------------------------------------------
    -- NOTE: VIM NINJAS {{{
    ------------------------------------------------------------------------
    ------------------------------------------------------------------------
    -- NOTE: tpope {{{
    ------------------------------------------------------------------------
    use({
      "tpope/vim-abolish",
      config = [[require('lk/plugins/abolish')]],
    })
    use({ "tpope/vim-dotenv", ft = "env" })
    use({
      "tpope/vim-repeat",
      keys = { "n", "." },
    })
    use({ "tpope/vim-sleuth" })
    use({
      "tpope/vim-surround",
      event = { "BufRead" },
    })
    use({ "tpope/vim-unimpaired" })
    use({
      "tpope/vim-scriptease",
      ft = "help",
      cmd = { "Messages", "Verbose", "Time" },
    })
    -- }}}
    ------------------------------------------------------------------------

    ------------------------------------------------------------------------
    -- NOTE: tjdevries {{{
    ------------------------------------------------------------------------
    -- use 'tjdevries/express_line.nvim'
    -- use("tjdevries/complextras.nvim")
    -- }}}
    ------------------------------------------------------------------------

    -- }}}
    ------------------------------------------------------------------------

    ------------------------------------------------------------------------
    -- NOTE: FILES {{{
    ------------------------------------------------------------------------

    ------------------------------------------------------------------------
    -- NOTE: Explorers {{{
    ------------------------------------------------------------------------
    use({
      "kyazdani42/nvim-tree.lua",
      cmd = {
        "NvimTreeToggle",
        "NvimTreeRefresh",
        "NvimTreeFindFile",
      },
      config = [[require('lk/plugins/nvim-tree')]],
    })
    -- }}}
    ------------------------------------------------------------------------
    -- }}}
    ------------------------------------------------------------------------

    ------------------------------------------------------------------------
    -- NOTE: TERMINAL {{{
    ------------------------------------------------------------------------
    -- Float Terminal
    use({
      "akinsho/nvim-toggleterm.lua",
      config = [[require('lk/plugins/toggleterm')]],
      keys = { "n", [[<C-\>]] },
    })
    -- }}}
    ------------------------------------------------------------------------

    ------------------------------------------------------------------------
    -- NOTE: TESTING {{{
    ------------------------------------------------------------------------

    -- debugger attach protocol
    -- use({
    --   "rcarriga/nvim-dap-ui",
    --   config = load_config("lk/plugins/dap"),
    --   requires = "mfussenegger/nvim-dap",
    -- })
    -- }}}
    ------------------------------------------------------------------------
  end,
  config = {
    compile_path = vim.fn.stdpath("config") .. "/lua/packer_compiled.lua",
    display = {
      prompt_border = "rounded",
      open_fn = function()
        return require("packer.util").float({ border = "single" })
      end,
    },
    profile = {
      enable = true,
      threshold = 1, -- the amount in ms that a plugins load time must be over for it to be included in the profile
    },
  },
})

-- }}}
--------------------------------------------------------------------------------
-- }}}
--------------------------------------------------------------------------------

-- vim:foldmethod=marker
