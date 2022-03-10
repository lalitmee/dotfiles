--------------------------------------------------------------------------------
-- NOTE: plugins setup {{{
--------------------------------------------------------------------------------
local utils = require("lk/utils/plugins")

----------------------------------------------------------------------
-- NOTE: bootstrap packer {{{
----------------------------------------------------------------------
utils.bootstrap_packer()
-- }}}
----------------------------------------------------------------------

-- cfilter plugin allows filter down an existing quickfix list
vim.cmd("packadd! cfilter")

-- load config
local function load_config(path)
  require(path)
end

--------------------------------------------------------------------------------
-- NOTE: packer startup {{{
--------------------------------------------------------------------------------
require("packer").startup({
  function(use)
    --------------------------------------------------------------------------------
    -- NOTE: Packer and speed ups {{{
    --------------------------------------------------------------------------------
    use({ "wbthomason/packer.nvim", opt = true })
    use("lewis6991/impatient.nvim")

    -- fast filetype detection
    use({ "nathom/filetype.nvim" })

    -- Profile startup time
    use({
      "tweekmonster/startuptime.vim",
      cmd = "StartupTime",
    })
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
        if vim.g.packer_compiled_loaded then
          return
        end
        require("notify").setup({
          stages = "static",
          timeout = 2000,
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
    use({
      "/home/lalitmee/Desktop/Github/cobalt2.nvim",
      requires = "tjdevries/colorbuddy.nvim",
    })
    use({
      "themercorp/themer.lua",
      config = function()
        require("themer").setup({
          styles = {
            comment = { style = "italic" },
          },
        })
      end,
    })
    -- }}}
    ----------------------------------------------------------------------------

    ----------------------------------------------------------------------------
    -- NOTE: icons {{{
    ----------------------------------------------------------------------------
    use({
      "yamatsum/nvim-nonicons",
      config = load_config("lk/plugins/devicons"),
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
        if vim.g.packer_compiled_loaded then
          return
        end
        require("todo-comments").setup({})
      end,
    })

    -- which-key
    use({
      "folke/which-key.nvim",
      config = load_config("lk/plugins/which-key"),
    })

    -- home screen
    use({
      "mhinz/vim-startify",
      config = load_config("lk/plugins/startify"),
    })

    -- learn something new about vim by typing `:Random`
    use({ "mhinz/vim-randomtag" })

    -- Colorizer for showing the colors
    use({
      "norcalli/nvim-colorizer.lua",
      config = load_config("lk/plugins/colorizer"),
    })

    -- better quick-fix winodw
    use({
      "kevinhwang91/nvim-bqf",
      config = load_config("lk/plugins/nvim-bqf"),
    })
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
    --regex explainer
    use({
      "bennypowers/nvim-regexplainer",
      config = function()
        require("regexplainer").setup()
      end,
      requires = {
        "MunifTanjim/nui.nvim",
      },
    })

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

    -- better increment
    use({ "monaqa/dial.nvim" })

    -- yank history after paste with `<C-n>` and `<C-p>`
    use({
      "svermeulen/vim-yoink",
      config = load_config("lk/plugins/vim-yoink"),
    })

    -- interactively swap so many things
    use("mizlan/iswap.nvim")

    -- scratch buffer in neovim like emacs
    use({
      "shift-d/scratch.nvim",
      config = function()
        require("telescope").load_extension("scratch")
      end,
    })

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
    -- makes quickfix list editable
    use({ "gabrielpoca/replacer.nvim" })

    -- Search and replace plugins
    use("windwp/nvim-spectre")
    use("nelstrom/vim-visual-star-search")
    use("junegunn/vim-fnr")
    use("junegunn/vim-pseudocl")

    -- display search matches
    use({
      "kevinhwang91/nvim-hlslens",
      config = load_config("lk/plugins/hlslens"),
    })
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
    use({
      "phaazon/hop.nvim",
      config = load_config("lk/plugins/hop"),
    })

    -- Quickscope same as f, F, t, T but better
    use({
      "unblevable/quick-scope",
      config = load_config("lk/plugins/quick-scope"),
    })

    -- Navigations
    use({
      "ThePrimeagen/harpoon",
      config = load_config("lk/plugins/harpoon"),
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
      config = load_config("lk/plugins/telescope"),
      requires = {
        {
          "brandoncc/telescope-harpoon.nvim",
          after = "telescope.nvim",
          config = function()
            require("telescope").load_extension("harpoon")
          end,
        },
        {
          "nvim-telescope/telescope-dap.nvim",
          after = "telescope.nvim",
          config = function()
            require("telescope").load_extension("dap")
          end,
        },
        {
          "nvim-telescope/telescope-frecency.nvim",
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
          "nvim-telescope/telescope-project.nvim",
          after = "telescope.nvim",
          config = function()
            require("telescope").load_extension("project")
          end,
        },
        {
          "tamago324/telescope-openbrowser.nvim",
          after = "telescope.nvim",
          config = function()
            require("telescope").load_extension("openbrowser")
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
        }, -- tmux support
        {
          "jgvw/telescope-arglist.nvim",
          after = "telescope.nvim",
          config = function()
            require("telescope").load_extension("arglist")
          end,
        }, -- arglist in telescope
        {
          "wesleimp/telescope-windowizer.nvim",
          after = "telescope.nvim",
          config = function()
            require("telescope").load_extension("windowizer")
          end,
        },
        {
          "danielpieper/telescope-tmuxinator.nvim",
          after = "telescope.nvim",
          config = function()
            require("telescope").load_extension("tmuxinator")
          end,
        }, -- tmuxinator support
        {
          "nvim-telescope/telescope-hop.nvim",
          after = "telescope.nvim",
          config = function()
            require("telescope").load_extension("hop")
          end,
        },
        {
          "cljoly/telescope-repo.nvim",
          after = "telescope.nvim",
          config = function()
            require("telescope").load_extension("repo")
          end,
        },
        {
          "nvim-telescope/telescope-live-grep-raw.nvim",
          after = "telescope.nvim",
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
    -- access recent buffers
    use({ "gaborvecsei/memento.nvim" })

    -- move code up and down
    use({
      "booperlv/nvim-gomove",
      config = function()
        require("gomove").setup()
      end,
    })

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
    use({
      "scr1pt0r/crease.vim",
      config = load_config("lk/plugins/crease"),
    })

    -- fast folds in vim
    use({
      "Konfekt/FastFold",
      config = load_config("lk/plugins/fastfold"),
    })

    -- Maximizer for vim
    use("szw/vim-maximizer")

    -- vim-exchange for exchanging words
    use("tommcdo/vim-exchange")

    -- targets.vim for extra motions
    use("wellle/targets.vim")

    -- Swap windows
    use({
      "wesQ3/vim-windowswap",
      config = function()
        vim.g.windowswap_map_keys = 0
      end,
    })

    -- commenting
    use({
      "numToStr/Comment.nvim",
      config = load_config("lk/plugins/comment"),
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
      config = load_config("lk/plugins/orgmode"),
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
      config = load_config("lk/plugins/ultisnip"),
      requires = { "honza/vim-snippets" },
    })
    -- }}}
    ------------------------------------------------------------------------

    ------------------------------------------------------------------------
    -- NOTE: Format {{{
    ------------------------------------------------------------------------
    -- formatter in lua
    use({
      "mhartington/formatter.nvim",
      config = load_config("lk/plugins/formatter"),
    })
    use({
      "lukas-reineke/indent-blankline.nvim",
      config = load_config("lk/plugins/indent-blankline"),
    })

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
        {
          "tami5/lspsaga.nvim",
          config = load_config("lk/plugins/lspsaga"),
        },
        {
          "hrsh7th/nvim-cmp",
          config = load_config("lk/plugins/nvim-cmp"),
          requires = {
            { "f3fora/cmp-spell", after = "nvim-cmp" },
            { "hrsh7th/cmp-buffer", after = "nvim-cmp" },
            { "hrsh7th/cmp-cmdline", after = "nvim-cmp" },
            { "hrsh7th/cmp-emoji", after = "nvim-cmp" },
            { "hrsh7th/cmp-nvim-lsp", after = "nvim-cmp" },
            { "hrsh7th/cmp-nvim-lua", after = "nvim-cmp" },
            { "hrsh7th/cmp-path", after = "nvim-cmp" },
            { "quangnguyen30192/cmp-nvim-ultisnips", after = "nvim-cmp" },
            { "tzachar/cmp-tabnine", run = "./install.sh", after = "nvim-cmp" },
          },
        },
        {
          "narutoxy/dim.lua",
          after = "nvim-lspconfig",
          config = function()
            require("dim").setup()
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
        { "nvim-lua/lsp-status.nvim" },
        { "tjdevries/lsp_extensions.nvim" },
        { "folke/lsp-colors.nvim" },
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
      run = ":TSUpdate",
      config = load_config("lk/plugins/treesitter"),
      requires = {
        { "nvim-treesitter/nvim-treesitter-textobjects", after = "nvim-treesitter" },
        { "nvim-treesitter/playground", cmd = "TSPlaygroundToggle", after = "nvim-treesitter" },
        { "p00f/nvim-ts-rainbow", after = "nvim-treesitter" },
        { "JoosepAlviste/nvim-ts-context-commentstring", after = "nvim-treesitter" },
      },
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
    -- refactor the code
    use({
      "ThePrimeagen/refactoring.nvim",
      config = load_config("lk/plugins/refactoring"),
    })

    ----------------------------------------------------------------------------
    -- NOTE: markdown {{{
    ----------------------------------------------------------------------------
    -- preview markdown in neovim
    use({ "ellisonleao/glow.nvim", ft = "markdown" })

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
    -- cheat.sh in neovim
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
    use({
      "ThePrimeagen/git-worktree.nvim",
      config = function()
        require("telescope").load_extension("git_worktree")
      end,
    })

    -- magit for neovim in lua
    use({
      "TimUntersberger/neogit",
      config = load_config("lk/plugins/neogit"),
    })

    -- gitsigns in lua
    use({
      "lewis6991/gitsigns.nvim",
      config = load_config("lk/plugins/gitsigns"),
    })

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
    -- github notifications in neovim
    use({
      "rlch/github-notifications.nvim",
      cond = function()
        return lk.executable("gh")
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
      config = load_config("lk/plugins/lualine"),
    })

    -- bufferline
    use({
      "akinsho/nvim-bufferline.lua",
      config = load_config("lk/plugins/bufferline"),
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
      config = load_config("lk/plugins/abolish"),
    })
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
    use({ "elihunter173/dirbuf.nvim" })
    use({
      "kyazdani42/nvim-tree.lua",
      config = load_config("lk/plugins/nvim-tree"),
    })
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
    use({
      "akinsho/nvim-toggleterm.lua",
      config = load_config("lk/plugins/toggleterm"),
    })
    -- }}}
    ------------------------------------------------------------------------

    ------------------------------------------------------------------------
    -- NOTE: BROWSER {{{
    ------------------------------------------------------------------------
    -- sql nvim database for frecency
    use("tami5/sqlite.lua")
    use("tami5/sql.nvim")
    use({
      "tyru/open-browser.vim",
      config = load_config("lk/plugins/open-browser"),
    })
    -- }}}
    ------------------------------------------------------------------------

    ------------------------------------------------------------------------
    -- NOTE: TESTING {{{
    ------------------------------------------------------------------------

    -- debugger attach protocol
    use({
      "rcarriga/nvim-dap-ui",
      config = load_config("lk/plugins/dap"),
      requires = "mfussenegger/nvim-dap",
    })
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
