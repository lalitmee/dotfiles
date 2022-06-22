--------------------------------------------------------------------------------
-- NOTE: plugins setup {{{
--------------------------------------------------------------------------------
-- cfilter plugin allows filter down an existing quickfix list
-- vim.cmd([[packadd! cfilter]])

-- function to return string for require plugins using path
local function conf(name)
  if name == "signature" then
    return string.format("R('lk/plugins/lsp/%s')", name)
  end
  return string.format("R('lk/plugins/%s')", name)
end

--------------------------------------------------------------------------------
-- NOTE: packer startup {{{
--------------------------------------------------------------------------------
require("packer").startup({
  function(use)
    --------------------------------------------------------------------------------
    -- NOTE: Packer and speed ups {{{
    --------------------------------------------------------------------------------
    use({
      "wbthomason/packer.nvim",
      config = conf("packer"),
    })
    use({ "lewis6991/impatient.nvim" })

    -- Profile startup time
    use({
      "tweekmonster/startuptime.vim",
      cmd = "StartupTime",
      opt = true,
    })

    use({
      "antoinemadec/FixCursorHold.nvim",
      config = function()
        vim.g.curshold_updatime = 1000
      end,
    })
    -- }}}
    --------------------------------------------------------------------------------

    ----------------------------------------------------------------------
    -- NOTE: must have {{{
    ----------------------------------------------------------------------
    use({ "nvim-lua/plenary.nvim" })
    -- }}}
    ----------------------------------------------------------------------

    ----------------------------------------------------------------------------
    -- NOTE: UI and Beautify {{{
    ----------------------------------------------------------------------------
    -- improve default neovim UI
    use({
      "stevearc/dressing.nvim",
      config = conf("dressing"),
    })

    -- decorated scrollbar
    use({
      "lewis6991/satellite.nvim",
      config = conf("satellite"),
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

    use({
      "folke/zen-mode.nvim",
      requires = {
        "folke/twilight.nvim",
        after = { "zen-mode.nvim" },
      },
      config = conf("zen-mode"),
      cmd = { "ZenMode" },
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
      cmd = {
        "ColorizerToggle",
        "ColorizerAttachToBuffer",
      },
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

    -- scratch files in `/tmp` folder
    use({
      "m-demare/attempt.nvim",
      config = conf("attempt"),
    })

    -- cycle folds
    use({
      "jghauser/fold-cycle.nvim",
      config = conf("fold-cycle"),
      keys = { "n", "<CR>" },
      cmd = {
        "FoldOpen",
        "FoldClose",
        "FoldCloseAll",
        "FoldOpenAll",
        "FoldToggleAll",
      },
    })

    -- rooter for neovim
    use({
      "ahmedkhalf/project.nvim",
      config = conf("project"),
    })

    -- makes quickfix list editable
    use({
      "gabrielpoca/replacer.nvim",
      config = conf("replacer"),
      cmd = {
        "ReplacerRun",
        "ReplacerRunF",
        "ReplacerRunFiles",
      },
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
      "gbprod/yanky.nvim",
      config = conf("yanky"),
      requires = { "nvim-telescope/telescope.nvim" },
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
    use({
      "kevinhwang91/nvim-hlslens",
      config = conf("hlslens"),
    })

    -- display search matches
    use({ "romainl/vim-cool" })

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

    -- quick scope for lines
    use({
      "unblevable/quick-scope",
      config = conf("quick-scope"),
    })

    -- easymotion using lua
    use({
      "phaazon/hop.nvim",
      config = conf("hop"),
    })

    -- Navigations
    use({
      "ThePrimeagen/harpoon",
      cmd = {
        "HarpoonAddFile",
        "HarpoonGotoFile1",
        "HarpoonGotoFile2",
        "HarpoonGotoFile3",
        "HarpoonGotoFile4",
        "HarpoonGotoFile5",
        "HarpoonGotoFile6",
        "HarpoonGotoFile7",
        "HarpoonGotoFile8",
        "HarpoonGotoFile9",
        "HarpoonGotoTerm1",
        "HarpoonGotoTerm2",
        "HarpoonGotoTerm3",
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
        {
          "nvim-lua/plenary.nvim",
          module = "plenary",
          after = "telescope.nvim",
        },
        {
          "nvim-telescope/telescope-frecency.nvim",
          requires = { "tami5/sqlite.lua" },
          after = "telescope.nvim",
          module = "telescope._extensions.frecency",
          config = function()
            require("telescope").load_extension("frecency")
          end,
        },
        {
          "nvim-telescope/telescope-fzf-native.nvim",
          run = "make",
          after = "telescope.nvim",
          module = "telescope._extensions.fzf",
          config = function()
            require("telescope").load_extension("fzf")
          end,
        },
        {
          "xiyaowong/telescope-emoji.nvim",
          after = "telescope.nvim",
          module = "telescope._extensions.emoji",
          config = function()
            require("telescope").load_extension("emoji")
          end,
        },
        {
          "nvim-telescope/telescope-smart-history.nvim",
          after = "telescope.nvim",
          module = "telescope._extensions.smart_history",
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
          module = "telescope._extensions.media_files",
          config = function()
            require("telescope").load_extension("media_files")
          end,
        },
        {
          "nvim-telescope/telescope-dap.nvim",
          after = { "nvim-dap", "telescope.nvim" },
          module = "telescope._extensions.dap",
          config = function()
            require("telescope").load_extension("dap")
          end,
        },
        {
          "olacin/telescope-gitmoji.nvim",
          after = "telescope.nvim",
          module = "telescope._extensions.gitmoji",
          config = function()
            require("telescope").load_extension("gitmoji")
          end,
        },
        {
          "benfowler/telescope-luasnip.nvim",
          module = "telescope._extensions.luasnip",
          after = "telescope.nvim",
          config = function()
            require("telescope").load_extension("luasnip")
          end,
        },
        {
          "zane-/howdoi.nvim",
          module = "telescope._extensions.howdoi",
          after = "telescope.nvim",
          config = function()
            require("telescope").load_extension("howdoi")
          end,
        },
      },
    })

    -- file browser using telescope
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

    use({
      "chentoast/marks.nvim",
      config = conf("marks"),
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

    use({
      "kevinhwang91/nvim-ufo",
      requires = "kevinhwang91/promise-async",
      config = function()
        require("ufo").setup()
      end,
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
        { "n", "gbA" },
        { "n", "gbO" },
        { "n", "gbc" },
        { "n", "gcc" },
        { "n", "gco" },
        { "v", "gb" },
        { "v", "gc" },
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
          DressingInput = false,
          TelescopePrompt = false,
        }
      end,
      disable = true,
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
    -- use("neoclide/vim-jsx-improve")
    -- -- NOTE: Completion Conquerer
    -- use({
    --   "neoclide/coc.nvim",
    --   branch = "release",
    --   config = conf('coc'),
    --   event = { "BufRead", "BufEnter" },
    -- })
    -- use({
    --   "fannheyward/telescope-coc.nvim",
    --   after = { "coc.nvim", "telescope.nvim" },
    --   config = function()
    --     require("telescope").load_extension("coc")
    --   end,
    -- })
    -- }}}
    --------------------------------------------------------------------------

    ------------------------------------------------------------------------
    -- NOTE: lspconfig {{{
    ------------------------------------------------------------------------
    use({
      "williamboman/nvim-lsp-installer",
      config = function()
        require("nvim-lsp-installer").setup()
      end,
    })
    use({
      "neovim/nvim-lspconfig",
      module = "lspconfig",
      after = { "nvim-lsp-installer" },
      ft = vim.g.enable_lspconfig_ft,
      config = conf("lsp"),
      requires = {
        { "jose-elias-alvarez/nvim-lsp-ts-utils" },
        {
          "JASONews/glow-hover",
          config = function()
            require("glow-hover").setup({
              border = "rounded",
            })
          end,
        },
        {
          "j-hui/fidget.nvim",
          config = conf("fidget"),
          after = "nvim-lspconfig",
        },
        {
          "onsails/lspkind.nvim",
          after = "nvim-lspconfig",
        },
        {
          "hrsh7th/nvim-cmp",
          config = conf("nvim-cmp"),
          event = { "InsertEnter", "CmdlineEnter" },
          requires = {
            { "hrsh7th/cmp-buffer", after = "nvim-cmp" },
            { "hrsh7th/cmp-cmdline", after = "nvim-cmp", event = { "CmdlineEnter" } },
            { "hrsh7th/cmp-emoji", after = "nvim-cmp", keys = { "i", ":" } },
            { "hrsh7th/cmp-nvim-lsp", after = "nvim-cmp" },
            { "hrsh7th/cmp-nvim-lua", after = "nvim-cmp", ft = { "lua" } },
            { "hrsh7th/cmp-path", after = "nvim-cmp" },
            { "saadparwaiz1/cmp_luasnip", after = "nvim-cmp" },
            { "tzachar/cmp-tabnine", run = "./install.sh", after = "nvim-cmp" },
            {
              "KadoBOT/cmp-plugins",
              after = "nvim-cmp",
              config = function()
                require("cmp-plugins").setup({
                  files = { "plugins.lua" },
                })
              end,
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
      ft = vim.g.enable_treesitter_ft,
      event = { "BufRead", "BufNewFile" },
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
        -- {
        --   "nvim-treesitter/nvim-treesitter-context",
        --   after = { "nvim-treesitter" },
        -- },
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

    ----------------------------------------------------------------------
    -- NOTE: html and jsx {{{
    ----------------------------------------------------------------------
    use({
      "mattn/emmet-vim",
      config = conf("emmet"),
    })
    -- }}}
    ----------------------------------------------------------------------

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
    -- lualine.nvim
    use({
      "nvim-lualine/lualine.nvim",
      after = "nvim-web-devicons",
      config = conf("lualine"),
    })

    -- location component
    use({
      "SmiteshP/nvim-gps",
      requires = "nvim-treesitter/nvim-treesitter",
    })

    -- winbar component
    use({
      "SmiteshP/nvim-navic",
      requires = "neovim/nvim-lspconfig",
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
    -- abbreviations
    use({
      "tpope/vim-abolish",
      config = conf("abolish"),
    })

    -- repeat using `.`
    use({
      "tpope/vim-repeat",
      event = { "BufRead" },
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
    -- better `gf` command
    use({
      "moevis/smartjump.nvim",
      requires = "nvim-telescope/telescope.nvim",
    })

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
      config = conf("nvim-tree"),
    })

    -- lir explorer
    use({
      "tamago324/lir.nvim",
      requires = { "tamago324/lir-git-status.nvim" },
      config = conf("lir"),
      keys = { "n", "-" },
      cmd = { "LirFloatToggle", "LirFloatInit" },
      disable = false,
    })

    -- dirbuf
    use({
      "elihunter173/dirbuf.nvim",
      cmd = { "Dirbuf", "DirbufSync" },
      config = function()
        vim.cmd([[autocmd VimEnter * autocmd! dirbuf]])
      end,
      disable = false,
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
      cmd = {
        "ToggleTerm",
        "ToggleTerm1",
        "ToggleTerm2",
        "ToggleTerm3",
        "ToggleTerm4",
      },
    })
    -- }}}
    ------------------------------------------------------------------------

    ----------------------------------------------------------------------
    -- NOTE: browse {{{
    ----------------------------------------------------------------------
    use({
      "~/Desktop/Github/browse.nvim",
      requires = { "nvim-telescope/telescope.nvim" },
      keys = {
        { "n", "gx" },
        { "n", "gl" },
      },
      config = conf("browse"),
    })
    -- }}}
    ----------------------------------------------------------------------

    ------------------------------------------------------------------------
    -- NOTE: TESTING {{{
    ------------------------------------------------------------------------

    -- debugger attach protocol
    use({
      "mfussenegger/nvim-dap",
      config = conf("dap"),
      cmd = { "DapToggleBreakpoint" },
      requires = {
        { "jbyuki/one-small-step-for-vimkind", after = "nvim-dap" },
        { "rcarriga/nvim-dap-ui", after = "nvim-dap" },
        { "theHamsta/nvim-dap-virtual-text", after = "nvim-dap" },
      },
    })
    -- }}}
    ------------------------------------------------------------------------

    ----------------------------------------------------------------------
    -- NOTE: notes {{{
    ----------------------------------------------------------------------
    -- org mode in neovim
    use({
      "nvim-orgmode/orgmode",
      config = conf("orgmode"),
      requires = {
        { "akinsho/org-bullets.nvim", ft = "org" },
        { "TravonteD/org-capture-filetype", after = "orgmode" },
        { "ranjithshegde/orgWiki.nvim", after = "orgmode" },
        { "dhruvasagar/vim-table-mode", after = "orgmode" },
        { "lukas-reineke/headlines.nvim", after = "orgmode" },
      },
      -- disable = true,
    })

    -- similar to orgmode but with neovim in lua
    use({
      "nvim-neorg/neorg",
      ft = "norg",
      cmd = { "Neorg" },
      config = conf("neorg"),
      requires = {
        { "nvim-neorg/neorg-telescope" },
      },
    })
    -- }}}
    ----------------------------------------------------------------------

    ----------------------------------------------------------------------
    -- NOTE: entertainment {{{
    ----------------------------------------------------------------------
    use({
      "KadoBOT/nvim-spotify",
      requires = "nvim-telescope/telescope.nvim",
      config = conf("spotify"),
      run = "make",
      -- disable = true,
    })
    -- }}}
    ----------------------------------------------------------------------
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
