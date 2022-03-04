--------------------------------------------------------------------------------
-- NOTE: plugins setup {{{
--------------------------------------------------------------------------------

local execute = vim.api.nvim_command
local fn = vim.fn

local PACKER_COMPILED_PATH = fn.stdpath("cache") .. "/packer/packer_compiled.lua"

local install_path = fn.stdpath("data") .. "/site/pack/packer/start/packer.nvim"

if fn.empty(fn.glob(install_path)) > 0 then
  execute("!git clone https://github.com/wbthomason/packer.nvim " .. install_path)
end

-- cfilter plugin allows filter down an existing quickfix list
vim.cmd("packadd! cfilter")

--------------------------------------------------------------------------------
-- NOTE: packer startup {{{
--------------------------------------------------------------------------------
require("packer").startup({
  function(use)
    --------------------------------------------------------------------------------
    -- NOTE: Packer {{{
    --------------------------------------------------------------------------------
    use("wbthomason/packer.nvim")
    use("lewis6991/impatient.nvim")
    -- }}}
    --------------------------------------------------------------------------------

    ----------------------------------------------------------------------------
    -- NOTE: UI and Beautify {{{
    ----------------------------------------------------------------------------
    --- ui and beatification related plugins
    ----------------------------------------------------------------------------
    -- NOTE: notifications {{{
    ----------------------------------------------------------------------------
    use({
      "rcarriga/nvim-notify",
      config = function()
        require("notify").setup({
          stages = "fade",
          timeout = 2000,
          background_colour = "BufferCurrent",
          icons = {
            ERROR = lk.style.icons.error,
            WARN = lk.style.icons.warn,
            INFO = lk.style.icons.info,
            DEBUG = lk.style.icons.debug,
            TRACE = lk.style.icons.trace,
          },
        })
      end,
    })
    -- }}}
    ----------------------------------------------------------------------------

    ----------------------------------------------------------------------------
    -- NOTE: colorschemes {{{
    ----------------------------------------------------------------------------
    use({ "/home/lalitmee/Desktop/Github/cobalt2.nvim", requires = { "tjdevries/colorbuddy.nvim" } })
    -- use({ "EdenEast/nightfox.nvim" })
    -- use({ "Mofiqul/vscode.nvim" })
    -- use({ "catppuccin/nvim", as = "catppuccin" })
    -- use({ "folke/tokyonight.nvim" })
    -- use({ "kyazdani42/nvim-palenight.lua" })
    -- use({ "luisiacc/gruvbox-baby" })
    -- use({ "marko-cerovac/material.nvim" })
    -- use({ "rebelot/kanagawa.nvim" })
    -- use({ "rmehri01/onenord.nvim" })
    -- use({ "tjdevries/gruvbuddy.nvim", requires = { "tjdevries/colorbuddy.nvim" } })
    -- }}}
    ----------------------------------------------------------------------------

    ----------------------------------------------------------------------------
    -- NOTE: icons {{{
    ----------------------------------------------------------------------------
    use({
      "yamatsum/nvim-nonicons",
      requires = { "kyazdani42/nvim-web-devicons" },
    })
    -- }}}
    ----------------------------------------------------------------------------

    ----------------------------------------------------------------------------
    -- NOTE: general {{{
    ----------------------------------------------------------------------------
    -- highlighting of todo comments
    use({
      "folke/todo-comments.nvim",
      config = function()
        require("todo-comments").setup({})
      end,
    })
    -- which-key
    use("folke/which-key.nvim")

    -- home screen
    use("mhinz/vim-startify")

    -- Colorizer for showing the colors
    use("norcalli/nvim-colorizer.lua")

    -- better quick-fix winodw
    use("kevinhwang91/nvim-bqf")
    -- prettify quickfix windows for neovim
    use({
      "https://gitlab.com/yorickpeterse/nvim-pqf.git",
      config = function()
        require("pqf").setup()
      end,
    })
    -- }}}
    ----------------------------------------------------------------------------
    -- }}}
    ----------------------------------------------------------------------------

    ------------------------------------------------------------------------
    -- NOTE: ACTIONS {{{
    ------------------------------------------------------------------------
    -- beautiful code snippets from neovim
    use({
      "kristijanhusak/vim-carbon-now-sh",
      cmd = "CarbonNowSh",
      config = function()
        vim.g.carbon_now_sh_options = { fm = "MonoLisa" }
      end,
    })

    -- packages info
    use({
      "vuki656/package-info.nvim",
      requires = "MunifTanjim/nui.nvim",
      config = function()
        require("package-info").setup()
      end,
    })

    -- wakatime for vim
    use("wakatime/vim-wakatime")

    -- prevent select and visual mode from overwriting the clipboard
    use({
      "kevinhwang91/nvim-hclipboard",
      event = "InsertCharPre",
      config = function()
        require("hclipboard").start()
      end,
    })

    -- yank history after paste with `<C-n>` and `<C-p>`
    use({
      "svermeulen/vim-yoink",
      config = function()
        local map = lk.map
        local map_opts = {}
        map("n", "<C-n>", "<Plug>(YoinkPostPasteSwapBack)", map_opts)
        map("n", "<C-p>", "<Plug>(YoinkPostPasteSwapForward)", map_opts)
        map("n", "p", "<Plug>(YoinkPaste_p)", map_opts)
        map("n", "P", "<Plug>(YoinkPaste_P)", map_opts)
        map("n", "gp", "<Plug>(YoinkPaste_gp)", map_opts)
        map("n", "gP", "<Plug>(YoinkPaste_gP)", map_opts)
        map("n", "[y", "<Plug>(YoinkRotateBack)", map_opts)
        map("n", "]y", "<Plug>(YoinkRotateForward)", map_opts)
        map("n", "y", "<Plug>(YoinkYankPreserveCursorPosition)", map_opts)
        map("x", "y", "<Plug>(YoinkYankPreserveCursorPosition)", map_opts)
        map("n", "[y", "<Plug>(YoinkRotateBack)", map_opts)
      end,
    })

    -- interactively swap so many things
    use("mizlan/iswap.nvim")

    -- scratch buffer in neovim like emacs
    use({ "shift-d/scratch.nvim" })

    -- registers
    use({ "tversteeg/registers.nvim" })

    -- toggle, display and navigate marks
    use({
      "chentau/marks.nvim",
      config = function()
        require("marks").setup({
          mappings = { set_next = "m," },
        })
      end,
    })

    -- clipboard
    use({
      "AckslD/nvim-neoclip.lua",
      requires = { "tami5/sqlite.lua", module = "sqlite" },
      config = function()
        require("neoclip").setup({
          enable_persistent_history = true,
          keys = {
            telescope = {
              i = { select = "<c-p>", paste = "<CR>", paste_behind = "<c-k>" },
              n = { select = "p", paste = "<CR>", paste_behind = "P" },
            },
          },
        })
      end,
    })

    -- post contents online like pastebin
    use({
      "rktjmp/paperplanes.nvim",
      config = function()
        require("paperplanes").setup({ register = "+", provider = "dpaste.org" })
      end,
    })

    ----------------------------------------------------------------------------
    -- NOTE: Search {{{
    ----------------------------------------------------------------------------
    -- Search and replace plugins
    use("windwp/nvim-spectre")
    use("nelstrom/vim-visual-star-search")
    use("junegunn/vim-fnr")
    use("junegunn/vim-pseudocl")

    -- display search matches
    use({ "kevinhwang91/nvim-hlslens" })
    use({ "haya14busa/incsearch.vim" })
    use({
      "romainl/vim-cool",
      config = function()
        vim.g.CoolTotalMatches = 1
      end,
    })

    -- search lines using numbers
    use({
      "nacro90/numb.nvim",
      config = function()
        require("numb").setup()
      end,
    })

    -- easymotion using lua
    use("phaazon/hop.nvim")

    -- Quickscope same as f, F, t, T but better
    use("unblevable/quick-scope")

    -- Navigations
    use("ThePrimeagen/harpoon")
    -- }}}
    ----------------------------------------------------------------------------

    ------------------------------------------------------------------------
    -- NOTE: FUZZY SEARCH {{{
    ------------------------------------------------------------------------
    -- telescope.nvim
    use({ "nvim-lua/plenary.nvim" })
    use({ "nvim-lua/popup.nvim" })
    use({
      "nvim-telescope/telescope.nvim",
      requires = {
        { "brandoncc/telescope-harpoon.nvim" },
        { "nvim-telescope/telescope-dap.nvim" },
        { "nvim-telescope/telescope-frecency.nvim" },
        { "nvim-telescope/telescope-fzf-native.nvim", run = "make" },
        { "nvim-telescope/telescope-project.nvim" },
        { "tamago324/telescope-openbrowser.nvim" },
        { "xiyaowong/telescope-emoji.nvim" },
        { "nvim-telescope/telescope-packer.nvim" },
        { "nvim-telescope/telescope-smart-history.nvim" },
        { "nvim-telescope/telescope-ui-select.nvim" },
      },
    })
    use({ "nvim-telescope/telescope-file-browser.nvim" })
    -- }}}
    ------------------------------------------------------------------------

    ----------------------------------------------------------------------------
    -- NOTE: General {{{
    ----------------------------------------------------------------------------
    -- move code up and down
    use("matze/vim-move")

    -- smooth scrolling in neovim
    use({
      "karb94/neoscroll.nvim",
      config = function()
        require("neoscroll").setup({ use_local_scrolloff = true })
      end,
    })

    -- delete buffers without distubing layout
    use({
      "kazhala/close-buffers.nvim",
      config = function()
        require("close_buffers").setup({
          preserve_window_layout = { "this", "nameless" },
          next_buffer_cmd = function(windows)
            local bufnr = vim.api.nvim_get_current_buf()
            for _, window in ipairs(windows) do
              vim.api.nvim_win_set_buf(window, bufnr)
            end
          end,
        })
      end,
    })

    -- auto pairs
    use({
      "windwp/nvim-autopairs",
      config = function()
        require("nvim-autopairs").setup({
          disable_filetype = { "TelescopePrompt", "vim" },
        })
      end,
    })

    -- match brackets and more
    use("andymass/vim-matchup")

    -- Switch between single-line and multiline forms of code
    use("AndrewRadev/splitjoin.vim")

    -- sorting in vim
    use("christoomey/vim-sort-motion")

    -- navigate and splits
    use({
      "numToStr/Navigator.nvim",
      config = function()
        require("Navigator").setup()
      end,
    })

    -- remove trailing whitespace and lines
    use("McAuleyPenney/tidy.nvim")

    -- nice fold text
    use("scr1pt0r/crease.vim")

    -- fast folds in vim
    use("Konfekt/FastFold")

    -- Maximizer for vim
    use("szw/vim-maximizer")

    -- vim-exchange for exchanging words
    use("tommcdo/vim-exchange")

    -- targets.vim for extra motions
    use("wellle/targets.vim")

    -- Swap windows
    use("wesQ3/vim-windowswap")

    -- commenting
    use({
      "numToStr/Comment.nvim",
      config = function()
        require("Comment").setup()
      end,
    })
    -- comment boxes
    use("LudoPinelli/comment-box.nvim")
    -- }}}
    ------------------------------------------------------------------------
    -- }}}
    ------------------------------------------------------------------------

    ------------------------------------------------------------------------
    -- NOTE: TEXT {{{
    ------------------------------------------------------------------------

    -- inline text edit
    use("AndrewRadev/inline_edit.vim")

    -- cycle similar words
    use("zef/vim-cycle")

    -- brackets done right way
    use("itmammoth/doorboy.vim")

    -- github copilot
    use("github/copilot.vim")

    -- run any code of any file type
    use({ "michaelb/sniprun", run = "bash ./install.sh" })

    ------------------------------------------------------------------------
    -- NOTE: Notes {{{
    ------------------------------------------------------------------------
    -- table like in org mode in emacs
    use({ "dhruvasagar/vim-table-mode" })

    -- norg for notes and tasks
    use({
      "nvim-neorg/neorg",
      config = function()
        require("neorg").setup({
          ["core.norg.dirman"] = {
            config = {
              workspaces = {
                work = "~/Desktop/Github/Notes/neorg",
              },
            },
          },
        })
      end,
    })

    use({
      "nvim-orgmode/orgmode.nvim",
      requires = {
        {
          "akinsho/org-bullets.nvim",
          config = function()
            require("org-bullets").setup({
              symbols = { "◉", "○", "✸", "✿" },
            })
          end,
        },
        {
          "lukas-reineke/headlines.nvim",
          config = function()
            require("headlines").setup()
          end,
        },
      },
    })
    -- }}}
    ------------------------------------------------------------------------

    ------------------------------------------------------------------------
    -- NOTE: Snippets {{{
    ------------------------------------------------------------------------
    -- -- snippets engine
    use({
      "SirVer/ultisnips",
      config = function()
        vim.g.UltiSnipsRemoveSelectModeMappings = 0
      end,
    })
    -- }}}
    ------------------------------------------------------------------------

    ------------------------------------------------------------------------
    -- NOTE: Format {{{
    ------------------------------------------------------------------------
    -- formatter in lua
    use("mhartington/formatter.nvim")
    use("lukas-reineke/indent-blankline.nvim")

    -- Tabularize for Vim
    use({ "godlygeek/tabular", cmd = "Tabularize" })

    -- Undo
    use({ "mbbill/undotree", cmd = "UndotreeToggle" })
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
    -- use { 'neoclide/coc.nvim', branch = 'release' }
    -- use { 'fannheyward/go.vim', ft = 'go' }
    -- }}}
    --------------------------------------------------------------------------

    ------------------------------------------------------------------------
    -- NOTE: lspconfig {{{
    ------------------------------------------------------------------------
    use({
      "neovim/nvim-lspconfig",
      requires = {
        { "onsails/lspkind-nvim" },
        { "tami5/lspsaga.nvim" },
        {
          "hrsh7th/nvim-cmp",
          requires = {
            { "David-Kunz/cmp-npm", after = "nvim-cmp" },
            { "andersevenrud/cmp-tmux", after = "nvim-cmp" },
            { "f3fora/cmp-spell", after = "nvim-cmp" },
            { "hrsh7th/cmp-buffer", after = "nvim-cmp" },
            { "hrsh7th/cmp-calc", after = "nvim-cmp" },
            { "hrsh7th/cmp-cmdline", after = "nvim-cmp" },
            { "hrsh7th/cmp-emoji", after = "nvim-cmp" },
            { "hrsh7th/cmp-nvim-lsp", after = "nvim-cmp" },
            { "hrsh7th/cmp-nvim-lsp-document-symbol", after = "nvim-cmp" },
            { "hrsh7th/cmp-nvim-lua", after = "nvim-cmp" },
            { "hrsh7th/cmp-path", after = "nvim-cmp" },
            { "hrsh7th/cmp-copilot", after = "nvim-cmp" },
            { "quangnguyen30192/cmp-nvim-ultisnips", after = "nvim-cmp" },
            { "ray-x/cmp-treesitter", after = "nvim-cmp" },
            { "tzachar/cmp-tabnine", run = "./install.sh", after = "nvim-cmp" },
            {
              "simrat39/symbols-outline.nvim",
              cmd = { "SymbolsOutline", "SymbolsOutlineClose", "SymbolsOutlineOpen" },
            },
            {
              "petertriho/cmp-git",
              after = "nvim-cmp",
              config = function()
                require("cmp_git").setup({
                  filetypes = { "gitcommit", "NeogitCommitMessage" },
                })
              end,
            },
          },
        },
        {
          "ray-x/lsp_signature.nvim",
          config = function()
            require("lsp_signature").setup()
          end,
        },
        { "onsails/diaglist.nvim" },
        { "williamboman/nvim-lsp-installer" },
        { "nvim-lua/lsp-status.nvim" },
        { "tjdevries/lsp_extensions.nvim" },
        { "folke/lsp-colors.nvim" },
        {
          "folke/trouble.nvim",
          config = function()
            require("trouble").setup({})
          end,
        },
        { "folke/lua-dev.nvim" },
        {
          "j-hui/fidget.nvim",
          config = function()
            require("fidget").setup({
              text = {
                spinner = "bouncing_bar",
              },
              align = {
                bottom = true,
              },
              window = {
                relative = "editor",
              },
            })
          end,
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
      run = ":TSUpdate",
      requires = {
        { "nvim-treesitter/nvim-treesitter-refactor", after = "nvim-treesitter" },
        { "nvim-treesitter/nvim-treesitter-textobjects", after = "nvim-treesitter" },
        { "RRethy/nvim-treesitter-textsubjects", after = "nvim-treesitter" },
        { "nvim-treesitter/playground", cmd = "TSPlaygroundToggle", after = "nvim-treesitter" },
        { "p00f/nvim-ts-rainbow", after = "nvim-treesitter" },
        { "JoosepAlviste/nvim-ts-context-commentstring", after = "nvim-treesitter" },
        { "mfussenegger/nvim-ts-hint-textobject" },
      },
    })

    -- spell checker using treesitter
    use({
      "lewis6991/spellsitter.nvim",
      config = function()
        require("spellsitter").setup()
      end,
    })

    -- annotations using treesitter
    use({
      "danymat/neogen",
      config = function()
        require("neogen").setup({})
      end,
      -- Uncomment next line if you want to follow only stable versions
      -- tag = "*"
    })
    -- }}}
    ------------------------------------------------------------------------

    ----------------------------------------------------------------------------
    -- NOTE: Languages {{{
    ----------------------------------------------------------------------------
    -- vim log highlighting
    use({ "MTDL9/vim-log-highlighting" })

    -- refactor the code
    use({ "ThePrimeagen/refactoring.nvim" })

    ----------------------------------------------------------------------------
    -- NOTE: markdown {{{
    ----------------------------------------------------------------------------
    use({
      "iamcco/markdown-preview.nvim",
      ft = "markdown",
      run = "cd app && yarn install",
    })
    -- }}}
    ----------------------------------------------------------------------------

    ----------------------------------------------------------------------------
    -- NOTE: General {{{
    ----------------------------------------------------------------------------

    use({
      "RishabhRD/nvim-cheat.sh",
      requires = { "RishabhRD/popfix" },
      cmd = {
        "Cheat",
        "CheatWithouComments",
        "CheatList",
        "CheatListWithoutComments",
      },
    })
    -- }}}
    ----------------------------------------------------------------------------
    -- }}}
    ----------------------------------------------------------------------------

    ------------------------------------------------------------------------
    -- NOTE: VERSION CONTROL STYSTEM {{{
    ------------------------------------------------------------------------
    use({ "ruifm/gitlinker.nvim" })
    use({
      "rhysd/conflict-marker.vim",
      config = function()
        -- disable the default highlight group
        vim.g.conflict_marker_highlight_group = ""
        -- Include text after begin and end markers
        vim.g.conflict_marker_begin = "^<<<<<<< .*$"
        vim.g.conflict_marker_end = "^>>>>>>> .*$"
      end,
    })

    -- git actions using telescope
    use({
      "pwntester/octo.nvim",
      config = function()
        require("octo").setup()
      end,
    })

    -- git worktree
    use("ThePrimeagen/git-worktree.nvim")

    -- magit for neovim in lua
    use({ "TimUntersberger/neogit" })

    -- gitsigns in lua
    use("lewis6991/gitsigns.nvim")

    -- git lens in vim
    use({
      "sindrets/diffview.nvim",
      config = function()
        require("diffview").setup({
          key_bindings = {
            file_panel = { q = "<Cmd>DiffviewClose<CR>" },
            view = { q = "<Cmd>DiffviewClose<CR>" },
          },
        })
      end,
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
      requires = { "kyazdani42/nvim-web-devicons", opt = true },
    })

    -- bufferline
    use("akinsho/nvim-bufferline.lua")
    -- }}}
    ------------------------------------------------------------------------

    ------------------------------------------------------------------------
    -- NOTE: VIM NINJAS {{{
    ------------------------------------------------------------------------
    ------------------------------------------------------------------------
    -- NOTE: tpope {{{
    ------------------------------------------------------------------------
    use("tpope/vim-abolish")
    use({
      "tpope/vim-dispatch",
      opt = true,
      cmd = { "Dispatch", "Make", "Focus", "Start" },
    })
    use("tpope/vim-dotenv")
    use("tpope/vim-eunuch")
    use("tpope/vim-repeat")
    use("tpope/vim-sleuth")
    use("tpope/vim-surround")
    use("tpope/vim-unimpaired")
    use("tpope/vim-characterize")
    use({
      "tpope/vim-scriptease",
      cmd = {
        "Messages", -- view messages in quickfix list
        "Verbose", -- view verbose output in preview window.
        "Time", -- measure how long it takes to run some stuff.
      },
    })
    -- }}}
    ------------------------------------------------------------------------

    ------------------------------------------------------------------------
    -- NOTE: tjdevries {{{
    ------------------------------------------------------------------------
    -- use 'tjdevries/express_line.nvim'
    use("tjdevries/complextras.nvim")
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
      "elihunter173/dirbuf.nvim", -- config = function()
      --   require('dirbuf').setup()
      -- end,
    })
    use({ "kyazdani42/nvim-tree.lua" })
    -- }}}
    ------------------------------------------------------------------------

    ------------------------------------------------------------------------
    -- NOTE: General {{{
    ------------------------------------------------------------------------
    -- for handling swap files
    use({
      "gioele/vim-autoswap",
      config = function()
        vim.g.autoswap_detect_tmux = 1
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
    use({ "akinsho/nvim-toggleterm.lua" })
    -- }}}
    ------------------------------------------------------------------------

    ------------------------------------------------------------------------
    -- NOTE: BROWSER {{{
    ------------------------------------------------------------------------
    -- sql nvim database for frecency
    use("tami5/sqlite.lua")
    use("tami5/sql.nvim")
    use("tyru/open-browser.vim")
    -- }}}
    ------------------------------------------------------------------------

    ------------------------------------------------------------------------
    -- NOTE: TESTING {{{
    ------------------------------------------------------------------------

    -- debugger attach protocol
    use({ "rcarriga/nvim-dap-ui", requires = { "mfussenegger/nvim-dap" } })
    -- }}}
    ------------------------------------------------------------------------

    ----------------------------------------------------------------------------
    -- NOTE: NOT USING {{{
    ----------------------------------------------------------------------------
    -- -- NOTE: disturbing Telescope UI
    -- -- auto focus and resizing
    -- use {
    --   'beauwilliams/focus.nvim',
    --   config = function()
    --     require('focus').setup()
    --   end,
    -- }
    --
    -- -- stabilize windows
    -- use {
    --   'luukvbaal/stabilize.nvim',
    --   config = function()
    --     require('stabilize').setup()
    --   end,
    -- }
    --
    --
    -- -- Search, Replace and Jump
    -- use {
    --   'ray-x/sad.nvim',
    --   requires = { 'ray-x/guihua.lua' },
    --   config = function()
    --     require('sad').setup({
    --       diff = 'delta', -- you can use `diff`, `diff-so-fancy`
    --       ls_file = 'fd', -- also git ls_file
    --       exact = false, -- exact match
    --     })
    --   end,
    -- }
    -- }}}
    ----------------------------------------------------------------------------
  end,
  config = {
    display = {
      compile_path = PACKER_COMPILED_PATH,
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
