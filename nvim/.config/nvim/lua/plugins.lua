--------------------------------------------------------------------------------
-- NOTE: plugins setup {{{
--------------------------------------------------------------------------------
-- cfilter plugin allows filter down an existing quickfix list
-- vim.cmd([[packadd! cfilter]])

-- function to return string for require plugins using path
local function conf(name)
  if name == "signature" then
    return string.format("require('lk/plugins/lsp/%s')", name)
  end
  return string.format("require('lk/plugins/%s')", name)
end

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
    use({ "nathom/filetype.nvim", config = conf("filetypes") })

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
      module = "vim.ui",
      config = conf("dressing"),
    })

    ----------------------------------------------------------------------------
    -- NOTE: notifications {{{
    ----------------------------------------------------------------------------
    use({
      "rcarriga/nvim-notify",
      module = "vim",
      config = conf("notify"),
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
      config = conf("devicons"),
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
      config = conf("todo-comments"),
      requires = { "nvim-lua/plenary.nvim" },
    })

    -- which-key
    use({
      "folke/which-key.nvim",
      config = conf("which-key"),
    })

    -- session management
    use({
      "rmagatti/session-lens",
      after = { "telescope.nvim", "auto-session" },
      cmd = { "SearchSession" },
      requires = {
        "rmagatti/auto-session",
        event = { "VimEnter" },
        config = conf("auto-session"),
      },
      config = conf("session-lens"),
    })

    -- Colorizer for showing the colors
    use({
      "norcalli/nvim-colorizer.lua",
      config = conf("colorizer"),
      cmd = { "ColorizerToggle", "ColorizerAttachToBuffer" },
    })

    ----------------------------------------------------------------------
    -- NOTE: quick fix plugins {{{
    ----------------------------------------------------------------------
    -- better quick-fix winodw
    use({
      "kevinhwang91/nvim-bqf",
      ft = { "qf" },
      config = conf("nvim-bqf"),
    })

    -- prettify quickfix windows for neovim
    use({
      "https://gitlab.com/yorickpeterse/nvim-pqf.git",
      ft = { "qf" },
      config = conf("nvim-pqf"),
    })
    -- }}}
    ----------------------------------------------------------------------
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

    -- workspaces in neovim
    use({
      "natecraddock/workspaces.nvim",
      requires = { "nvim-telescope/telescope.nvim" },
      after = { "telescope.nvim" },
      cmd = {
        "WorkspacesAdd",
        "WorkspacesRemove",
        "WorkspacesList",
        "WorkspacesOpen",
      },
      config = conf("workspaces"),
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
      config = conf("dial"),
    })

    -- yank history after paste with `<C-n>` and `<C-p>`
    use({
      "svermeulen/vim-yoink",
      config = conf("vim-yoink"),
    })

    use({
      "gbprod/substitute.nvim",
      config = conf("substitute"),
    })

    -- interactively swap so many things
    use({
      "mizlan/iswap.nvim",
      cmd = { "ISwap", "ISwapWith" },
    })

    ----------------------------------------------------------------------------
    -- NOTE: Search {{{
    ----------------------------------------------------------------------------
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
      config = conf("hlslens"),
      requires = {
        { "haya14busa/incsearch.vim" },
        { "romainl/vim-cool" },
      },
    })

    -- search multiple thing using `*`
    use({
      "nelstrom/vim-visual-star-search",
      keys = { "v", "*" },
    })

    -- search lines using numbers
    use({
      "nacro90/numb.nvim",
      keys = { "c", ":" },
      config = conf("numb"),
    })

    -- easymotion using lua
    use({
      "phaazon/hop.nvim",
      config = conf("hop"),
    })

    use({
      "unblevable/quick-scope",
      config = conf("quick-scope"),
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
      config = conf("harpoon"),
    })
    -- }}}
    ----------------------------------------------------------------------------

    ------------------------------------------------------------------------
    -- NOTE: FUZZY SEARCH {{{
    ------------------------------------------------------------------------
    -- telescope.nvim
    use({
      "nvim-telescope/telescope.nvim",
      cmd = { "Telescope" },
      config = conf("telescope"),
      requires = {
        { "nvim-lua/plenary.nvim", after = "telescope.nvim" },
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
      config = conf("gomove"),
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
      config = conf("neoscroll"),
    })

    -- delete buffers without distubing layout
    use({
      "kazhala/close-buffers.nvim",
      cmd = { "BDelete" },
      config = conf("close-buffers"),
    })

    -- buffer, marks and tabpages switcher
    use({
      "toppair/reach.nvim",
      config = conf("reach"),
      cmd = { "ReachOpen" },
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
      config = conf("autopairs"),
    })

    -- match brackets and more
    use({
      "andymass/vim-matchup",
      -- keys = {
      --   { "n", "%" },
      --   { "v", "%" },
      -- },
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
      config = conf("navigator"),
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
      config = conf("pretty-fold"),
    })

    -- fast folds in vim
    use({
      "Konfekt/FastFold",
      event = { "BufRead" },
      config = conf("fastfold"),
    })

    -- commenting
    use({
      "numToStr/Comment.nvim",
      config = conf("comment"),
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
      "L3MON4D3/LuaSnip",
      after = { "nvim-cmp" },
      requires = {
        "rafamadriz/friendly-snippets",
        "honza/vim-snippets",
        "molleweide/LuaSnip-snippets.nvim",
      },
      config = conf("luasnip"),
    })
    -- }}}
    ------------------------------------------------------------------------

    ------------------------------------------------------------------------
    -- NOTE: Format {{{
    ------------------------------------------------------------------------
    -- formatter in lua
    use({
      "mhartington/formatter.nvim",
      config = conf("formatter"),
      cmd = { "FormatWrite" },
    })

    -- indentlines in neovim
    use({
      "lukas-reineke/indent-blankline.nvim",
      config = conf("indent-blankline"),
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
      config = conf("lsp"),
      requires = {
        {
          "onsails/lspkind-nvim",
          after = "nvim-lspconfig",
        },
        {
          "hrsh7th/nvim-cmp",
          config = conf("nvim-cmp"),
          event = { "InsertEnter", "CmdlineEnter" },
          requires = {
            { "saadparwaiz1/cmp_luasnip", after = "nvim-cmp" },
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
              keys = { "i", ":" },
            },
            {
              "tzachar/cmp-tabnine",
              run = "./install.sh",
              after = "nvim-cmp",
            },
          },
        },
        {
          "ray-x/lsp_signature.nvim",
          config = conf("signature"),
          after = "nvim-lspconfig",
        },
        {
          "onsails/diaglist.nvim",
          after = "nvim-lspconfig",
          cmd = { "DiagList", "DiagListAll" },
        },
        { "williamboman/nvim-lsp-installer" },
        {
          "arkav/lualine-lsp-progress",
          after = { "nvim-lspconfig", "lualine.nvim" },
        },
        {
          "folke/lua-dev.nvim",
          ft = "lua",
          after = { "nvim-lspconfig" },
        },
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
      config = conf("treesitter"),
      run = ":TSUpdate",
      requires = {
        {
          "nvim-treesitter/nvim-treesitter-textobjects",
          after = "nvim-treesitter",
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
      after = { "nvim-treesitter" },
      requires = { "nvim-treesitter/nvim-treesitter" },
      config = conf("neogen"),
    })
    -- }}}
    ------------------------------------------------------------------------

    ----------------------------------------------------------------------------
    -- NOTE: Languages {{{
    ----------------------------------------------------------------------------
    -- refactor the code
    use({
      "ThePrimeagen/refactoring.nvim",
      after = { "nvim-treesitter", "telescope.nvim" },
      cmd = {
        "ExtractSelectedFunc",
        "RefactorDebugPath",
        "RefactorDebugPrintVarAbove",
        "RefactorDebugPrintVarBelow",
        "RefactorDebugPrintfAbove",
        "RefactorDebugPrintfBelow",
        "RefactorExtractFunc",
        "RefactorExtractVar",
        "RefactorInlineVar",
        "Refactors",
        "RefactorsList",
      },
      config = conf("refactoring"),
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
    -- git actions using telescope
    use({
      "pwntester/octo.nvim",
      requires = {
        "nvim-lua/plenary.nvim",
        "nvim-telescope/telescope.nvim",
        "kyazdani42/nvim-web-devicons",
      },
      config = conf("octo"),
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
      config = conf("neogit"),
    })

    -- gitsigns in lua
    use({
      "lewis6991/gitsigns.nvim",
      requires = { "nvim-lua/plenary.nvim" },
      event = { "BufRead" },
      config = conf("gitsigns"),
    })

    -- git lens in vim
    use({
      "sindrets/diffview.nvim",
      requires = { "nvim-lua/plenary.nvim" },
      config = conf("diffview"),
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
      config = conf("lualine"),
    })

    -- bufferline
    use({
      "akinsho/nvim-bufferline.lua",
      event = { "BufRead" },
      config = conf("bufferline"),
    })
    -- }}}
    ------------------------------------------------------------------------

    ------------------------------------------------------------------------
    -- NOTE: VIM NINJAS {{{
    ------------------------------------------------------------------------
    ------------------------------------------------------------------------
    -- NOTE: tpope {{{
    ------------------------------------------------------------------------
    -- repeat using `.`
    use({
      "tpope/vim-repeat",
      keys = { "n", "." },
    })

    -- surrounding in vim
    use({
      "tpope/vim-surround",
      event = { "BufRead" },
    })

    -- debug things
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
    -- nvim-tree explorer
    use({
      "kyazdani42/nvim-tree.lua",
      cmd = {
        "NvimTreeToggle",
        "NvimTreeRefresh",
        "NvimTreeFindFile",
      },
      config = conf("nvim-tree"),
    })

    -- dirbuf
    use({
      "elihunter173/dirbuf.nvim",
      cmd = { "Dirbuf", "DirbufSync" },
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
      config = conf("toggleterm"),
      keys = { "n", [[<C-\>]] },
    })
    -- }}}
    ------------------------------------------------------------------------

    ----------------------------------------------------------------------
    -- NOTE: browse {{{
    ----------------------------------------------------------------------
    use({
      "~/Desktop/Github/browse.nvim",
      requires = { "nvim-telescope/telescope.nvim" },
      config = conf("browse"),
    })
    -- }}}
    ----------------------------------------------------------------------

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
