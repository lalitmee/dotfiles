--------------------------------------------------------------------------------
-- NOTE: plugins setup {{{
--------------------------------------------------------------------------------
local fmt = string.format
-- cfilter plugin allows filter down an existing quickfix list
-- vim.cmd([[packadd! cfilter]])

-- function to return string for require plugins using path
local function conf(name)
  if name == "signature" then
    return fmt("R('lk/plugins/lsp/%s')", name)
  end
  return fmt("R('lk/plugins/%s')", name)
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
    -- use({
    --   "catppuccin/nvim",
    --   as = "catppuccin",
    -- })
    -- use({ "marko-cerovac/material.nvim" })
    -- use({ "Mofiqul/vscode.nvim" })
    -- use({ "folke/tokyonight.nvim" })
    -- }}}
    ----------------------------------------------------------------------------

    ----------------------------------------------------------------------------
    -- NOTE: icons {{{
    ----------------------------------------------------------------------------
    use({
      "yamatsum/nvim-nonicons",
      requires = { "kyazdani42/nvim-web-devicons" },
      event = { "BufRead" },
      config = conf("devicons"),
    })

    -- }}}
    ----------------------------------------------------------------------------

    ----------------------------------------------------------------------------
    -- NOTE: general {{{
    ----------------------------------------------------------------------------
    -- highlighting of todo comments
    use({
      "B4mbus/todo-comments.nvim",
      config = conf("todo-comments"),
      requires = { "nvim-lua/plenary.nvim" },
    })

    -- which-key
    use({
      "folke/which-key.nvim",
      config = conf("which-key"),
    })

    -- use({
    --   "anuvyklack/hydra.nvim",
    --   requires = "anuvyklack/keymap-layer.nvim",
    -- })

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
      "NvChad/nvim-colorizer.lua",
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
    -- }}}
    ----------------------------------------------------------------------
    -- }}}
    ----------------------------------------------------------------------------
    -- }}}
    ----------------------------------------------------------------------------

    ------------------------------------------------------------------------
    -- NOTE: ACTIONS {{{
    ------------------------------------------------------------------------
    -- keep the cursor where it is
    use({
      "gbprod/stay-in-place.nvim",
      config = conf("stay-in-place"),
    })

    -- icon picker for neovim
    use({
      "ziontee113/icon-picker.nvim",
      config = conf("icon-picker"),
      cmd = {
        -- normal mode
        "PickEverything",
        "PickIcons",
        "PickEmoji",
        "PickNerd",
        "PickSymbols",
        "PickAltFont",
        "PickAltFontAndSymbols",

        -- insert mode
        "PickEverythingInsert",
        "PickIconsInsert",
        "PickEmojiInsert",
        "PickNerdInsert",
        "PickSymbolsInsert",
        "PickAltFontInsert",
        "PickAltFontAndSymbolsInsert",
      },
    })

    -- color picker for neovim
    use({
      "ziontee113/color-picker.nvim",
      config = conf("color-picker"),
      cmd = { "PickColor" },
    })

    -- scratch files in `/tmp` folder
    use({
      "m-demare/attempt.nvim",
      config = conf("attempt"),
      cmd = { "AttemptNew", "AttemptNewExtension" },
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

    -- wakatime for vim
    use({
      "wakatime/vim-wakatime",
      event = { "VimEnter" },
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
    -- display search matches
    use({ "romainl/vim-cool" })

    -- search multiple thing using `*`
    use({
      "nelstrom/vim-visual-star-search",
      keys = { "v", "*" },
    })

    -- toggle relative line numbers automatically
    use({
      "sitiom/nvim-numbertoggle",
      config = function()
        require("numbertoggle").setup()
      end,
    })

    -- quick scope for lines in lua
    use({
      "jinh0/eyeliner.nvim",
      config = conf("eyeliner"),
    })

    -- easymotion using lua
    use({
      "phaazon/hop.nvim",
      config = conf("hop"),
    })

    -- Navigations
    use({
      "ThePrimeagen/harpoon",
      config = conf("harpoon"),
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
    })
    -- }}}
    ----------------------------------------------------------------------------

    ------------------------------------------------------------------------
    -- NOTE: FUZZY SEARCH {{{
    ------------------------------------------------------------------------
    -- telescope.nvim
    use({
      "nvim-telescope/telescope.nvim",
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
          "nvim-telescope/telescope-dap.nvim",
          after = { "nvim-dap", "telescope.nvim" },
          module = "telescope._extensions.dap",
          config = function()
            require("telescope").load_extension("dap")
          end,
        },
        {
          "zane-/howdoi.nvim",
          -- module = "telescope._extensions.howdoi",
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

    -- marks in neovim
    use({
      "chentoast/marks.nvim",
      config = conf("marks"),
    })

    -- zen-mode and more
    use({
      "Pocco81/true-zen.nvim",
      config = conf("true-zen"),
      cmd = {
        "TZAtaraxis",
        "TZFocus",
        "TZMinimalist",
        "TZNarrow",
      },
    })

    -- pomodoro timer
    use({
      "dbinagi/nomodoro",
      config = conf("nomodoro"),
    })

    -- delete buffers without distubing layout
    use({
      "kazhala/close-buffers.nvim",
      cmd = { "BDelete", "BWipeout" },
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

    use({
      "kevinhwang91/nvim-ufo",
      requires = "kevinhwang91/promise-async",
      config = conf("ufo"),
    })

    -- nice fold text
    use({
      "anuvyklack/pretty-fold.nvim",
      event = { "BufEnter" },
      config = conf("pretty-fold"),
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
    -- run any code of any file type
    use({
      "michaelb/sniprun",
      run = "bash ./install.sh",
      cmd = { "SnipRun" },
      config = conf("sniprun"),
    })

    -- run any code
    use({
      "CRAG666/code_runner.nvim",
      requires = "nvim-lua/plenary.nvim",
      config = conf("code_runner"),
      cmd = { "RunCode", "RunFile", "RunProject" },
    })

    -- overseer.nvim: task runner and job management
    use({
      "stevearc/overseer.nvim",
      config = conf("overseer"),
    })

    ------------------------------------------------------------------------
    -- NOTE: Snippets {{{
    ------------------------------------------------------------------------
    -- -- snippets engine
    use({
      "L3MON4D3/LuaSnip",
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
      -- "mhartington/formatter.nvim",
      "Hrle97/formatter.nvim",
      branch = "fix/shellescape",
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
      "williamboman/mason-lspconfig.nvim",
      requires = { "williamboman/mason.nvim" },
      config = conf("mason"),
    })
    use({
      "neovim/nvim-lspconfig",
      ft = vim.g.enable_lspconfig_ft,
      module = "lspconfig",
      config = conf("lsp"),
      requires = {
        {
          "j-hui/fidget.nvim",
          after = "nvim-lspconfig",
          config = conf("fidget"),
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
            { "hrsh7th/cmp-nvim-lsp", after = "nvim-cmp" },
            { "hrsh7th/cmp-nvim-lua", after = "nvim-cmp", ft = { "lua" } },
            { "hrsh7th/cmp-path", after = "nvim-cmp" },
            { "saadparwaiz1/cmp_luasnip", after = "nvim-cmp" },
            { "tzachar/cmp-tabnine", run = "./install.sh", after = "nvim-cmp" },
          },
        },
        {
          "ray-x/lsp_signature.nvim",
          after = "nvim-lspconfig",
          config = conf("signature"),
        },
        {
          "folke/lua-dev.nvim",
          ft = "lua",
          after = { "nvim-lspconfig" },
        },
        {
          "simrat39/symbols-outline.nvim",
          config = conf("symbols-outline"),
          cmd = {
            "SymbolsOutline",
            "SymbolsOutlineOpen",
            "SymbolsOutlineClose",
          },
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
        {
          "p00f/nvim-ts-rainbow",
          after = { "nvim-treesitter" },
        },
      },
    })

    -- annotations using treesitter
    use({
      "danymat/neogen",
      config = conf("neogen"),
      cmd = { "Neogen" },
    })
    -- }}}
    ------------------------------------------------------------------------

    ----------------------------------------------------------------------------
    -- NOTE: Languages {{{
    ----------------------------------------------------------------------------
    -- golang support
    use({ "ray-x/go.nvim", ft = "go" })

    -- debug print
    use({
      "andrewferrier/debugprint.nvim",
      config = function()
        require("debugprint").setup()
      end,
    })

    -- refactor the code
    -- use({
    --   "ThePrimeagen/refactoring.nvim",
    --   after = { "nvim-treesitter", "telescope.nvim" },
    --   cmd = {
    --     "ExtractSelectedFunc",
    --     "RefactorDebugPath",
    --     "RefactorDebugPrintVarAbove",
    --     "RefactorDebugPrintVarBelow",
    --     "RefactorDebugPrintfAbove",
    --     "RefactorDebugPrintfBelow",
    --     "RefactorExtractFunc",
    --     "RefactorExtractVar",
    --     "RefactorInlineVar",
    --     "Refactors",
    --     "RefactorsList",
    --   },
    --   config = conf("refactoring"),
    -- })

    ----------------------------------------------------------------------
    -- NOTE: html and jsx {{{
    ----------------------------------------------------------------------
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
    -- merge conflicts resolution
    use({
      "akinsho/git-conflict.nvim",
      tag = "*",
      config = conf("git-conflict"),
      cmd = {
        "GitConflictChooseOurs",
        "GitConflictChooseTheirs",
        "GitConflictChooseBoth",
        "GitConflictChooseNone",
        "GitConflictNextConflict",
        "GitConflictPrevConflict",
        "GitConflictListQf",
      },
    })

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

    use({
      "kylechui/nvim-surround",
      config = conf("nvim-surround"),
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
      keys = { { "n", "-" } },
      config = function()
        vim.cmd([[autocmd VimEnter * autocmd! dirbuf]])
      end,
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
      cmd = {
        "ToggleTerm",
        "ToggleTerm1",
        "ToggleTerm2",
        "ToggleTerm3",
        "ToggleTerm4",
        "TermExec",
      },
      keys = { "n", [[<C-\>]] },
    })
    -- }}}
    ------------------------------------------------------------------------

    ----------------------------------------------------------------------
    -- NOTE: browse {{{
    ----------------------------------------------------------------------
    use({
      "~/Desktop/Github/browse.nvim",
      config = conf("browse"),
      cmd = {
        "Browse",
        "BrowseBookmarks",
        "BrowseInputSearch",
        "BrowseDevdocsSearch",
        "BrowseDevdocsFiletypeSearch",
        "BrowseMdnSearch",
      },
    })

    -- -- editor in browser
    -- use({
    --   "glacambre/firenvim",
    --   run = function()
    --     vim.fn["firenvim#install"](0)
    --   end,
    --   config = conf("firenvim"),
    -- })
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
        {
          "jbyuki/one-small-step-for-vimkind",
          after = "nvim-dap",
        },
        {
          "rcarriga/nvim-dap-ui",
          after = "nvim-dap",
        },
        {
          "theHamsta/nvim-dap-virtual-text",
          after = "nvim-dap",
        },
      },
    })
    -- }}}
    ------------------------------------------------------------------------

    ----------------------------------------------------------------------
    -- NOTE: notes {{{
    ----------------------------------------------------------------------
    -- mind
    use({
      "phaazon/mind.nvim",
      config = function()
        require("mind").setup()
      end,
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
    -- }}}
    ----------------------------------------------------------------------

    ----------------------------------------------------------------------
    -- NOTE: reading {{{
    ----------------------------------------------------------------------
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
