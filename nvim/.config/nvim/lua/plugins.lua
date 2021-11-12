local execute = vim.api.nvim_command
local fn = vim.fn

local install_path = fn.stdpath('data') .. '/site/pack/packer/start/packer.nvim'

if fn.empty(fn.glob(install_path)) > 0 then
  execute('!git clone https://github.com/wbthomason/packer.nvim ' ..
              install_path)
end

return require('packer').startup {
  function(use)
    -- Packer can manage itself as an optional plugin
    use 'wbthomason/packer.nvim'
    use 'lewis6991/impatient.nvim'

    -- NOTE: VIM

    -- NOTE: man pages in vim
    use 'vim-utils/vim-man'

    -- UI AND BEAUTIFY {{{

    -- NOTE: disturbing Telescope UI
    -- -- auto focus and resizing
    -- use {
    --   'beauwilliams/focus.nvim',
    --   config = function()
    --     require('focus').setup()
    --   end,
    -- }

    -- stabilize windows
    use {
      'luukvbaal/stabilize.nvim',
      config = function()
        require('stabilize').setup()
      end,
    }

    -- notifications
    use {
      'rcarriga/nvim-notify',
      config = function()
        require('notify').setup({
          -- Animation style (see below for details)
          stages = 'fade',

          -- Default timeout for notifications
          timeout = 1000,

          -- For stages that change opacity this is treated as the highlight behind the window
          background_colour = 'BufferCurrent',

          -- Icons for the different levels
          icons = {
            ERROR = '',
            WARN = '',
            INFO = '',
            DEBUG = '',
            TRACE = '✎',
          },
        })
      end,
    }

    -- colorschemes {{{

    -- enabled
    use {
      'folke/twilight.nvim',
      config = function()
        require('twilight').setup {}
      end,
    }
    use { 'rmehri01/onenord.nvim' }
    use { 'Mofiqul/vscode.nvim' }
    use { 'Murtaza-Udaipurwala/gruvqueen' }
    use { 'folke/tokyonight.nvim' }
    use { 'shaunsingh/nord.nvim' }
    use { 'lalitmee/cobalt2.nvim' }
    use { 'marko-cerovac/material.nvim' }
    -- use { 'navarasu/onedark.nvim' }
    use { 'olimorris/onedark.nvim' }
    use { 'tjdevries/colorbuddy.nvim' }
    use { 'tjdevries/gruvbuddy.nvim' }

    -- }}}

    -- icons {{{

    -- beautiful icons
    use {
      'yamatsum/nvim-nonicons',
      requires = { 'kyazdani42/nvim-web-devicons' },
    }

    -- }}}

    -- General {{{

    -- toggle, display and navigate marks
    use 'kshenoy/vim-signature'

    -- See what keys do like in emacs
    use 'folke/which-key.nvim'

    use 'mhinz/vim-startify'

    -- Colorizer for showing the colors
    use 'norcalli/nvim-colorizer.lua'

    -- }}}

    -- }}}

    -- ACTIONS {{{

    -- clipboard
    use {
      'AckslD/nvim-neoclip.lua',
      config = function()
        require('neoclip').setup()
      end,
    }

    -- post contents online like pastebin
    use {
      'rktjmp/paperplanes.nvim',
      config = function()
        require('paperplanes').setup({ register = '+', provider = 'dpaste.org' })
      end,
    }

    -- Search, Replace and Jump {{{

    use 'windwp/nvim-spectre'
    use 'nelstrom/vim-visual-star-search'
    use 'junegunn/vim-fnr'
    use 'junegunn/vim-pseudocl'

    -- better quick-fix winodw
    use 'kevinhwang91/nvim-bqf'

    -- display search matches
    use { 'kevinhwang91/nvim-hlslens' }
    use { 'haya14busa/incsearch.vim' }
    use {
      'romainl/vim-cool',
      config = function()
        vim.g.CoolTotalMatches = 1
      end,
    }

    -- easymotion using lua
    use 'phaazon/hop.nvim'

    -- Quickscope same as f, F, t, T but better
    use 'unblevable/quick-scope'

    -- }}}

    -- Navigations {{{

    use 'ThePrimeagen/harpoon'

    -- }}}

    -- General {{{

    -- move code up and down
    use 'matze/vim-move'

    use {
      'folke/todo-comments.nvim',
      config = function()
        require('todo-comments').setup {}
      end,
    }

    -- smooth scrolling in neovim
    use {
      'karb94/neoscroll.nvim',
      config = function()
        require('neoscroll').setup({ use_local_scrolloff = true })
      end,
    }

    -- delete buffers without distubing layout
    use {
      'kazhala/close-buffers.nvim',
      config = function()
        require('close_buffers').setup({
          preserve_window_layout = { 'this', 'nameless' },
          next_buffer_cmd = function(windows)
            require('bufferline').cycle(1)
            local bufnr = vim.api.nvim_get_current_buf()

            for _, window in ipairs(windows) do
              vim.api.nvim_win_set_buf(window, bufnr)
            end
          end,
        })
      end,
    }

    -- match brackets and more
    use 'andymass/vim-matchup'

    -- Switch between single-line and multiline forms of code
    use 'AndrewRadev/splitjoin.vim'

    -- sorting in vim
    use 'christoomey/vim-sort-motion'
    use {
      'numToStr/Navigator.nvim',
      config = function()
        require('Navigator').setup()
      end,
    }

    -- remove trailing whitespace and lines
    use 'McAuleyPenney/tidy.nvim'

    -- nice fold text
    use 'scr1pt0r/crease.vim'

    -- fast folds in vim
    use 'Konfekt/FastFold'

    -- Maximizer for vim
    use 'szw/vim-maximizer'

    -- vim-exchange for exchanging words
    use 'tommcdo/vim-exchange'

    -- targets.vim for extra motions
    use 'wellle/targets.vim'

    -- Swap windows
    use 'wesQ3/vim-windowswap'
    use {
      'nacro90/numb.nvim',
      config = function()
        require('numb').setup()
      end,
    }

    -- }}}

    -- commenting {{{

    -- not using this because this doesn't support repeating of the last acion
    -- use 'tpope/vim-commentary'
    use {
      'numToStr/Comment.nvim',
      config = function()
        require('Comment').setup()
      end,
    }

    -- }}}

    -- }}}

    -- TEXT {{{

    -- inline text edit
    use 'AndrewRadev/inline_edit.vim'

    -- cycle similar words
    use 'zef/vim-cycle'

    -- brackets done right way
    use 'itmammoth/doorboy.vim'

    -- github copilot
    use 'github/copilot.vim'

    -- Notes {{{

    -- use 'michal-h21/vim-zettel' -- zettel tasks
    -- use 'vimwiki/vimwiki' -- vim wiki

    use {
      'kristijanhusak/orgmode.nvim',
      requires = {
        {
          'akinsho/org-bullets.nvim',
          config = function()
            require('org-bullets').setup {
              symbols = { '◉', '○', '✸', '✿' },
            }
          end,
        },
        {
          'lukas-reineke/headlines.nvim',
          config = function()
            require('headlines').setup()
          end,
        },
        { 'michaelb/sniprun', run = 'bash ./install.sh' },
        { 'dhruvasagar/vim-table-mode' },
      },
      config = function()
        require('orgmode').setup {}
      end,
      disable = true,
    }

    -- }}}

    -- Snippets {{{

    -- snippets engine
    use 'SirVer/ultisnips'

    -- Snippets in Vim
    use 'honza/vim-snippets'

    -- snippets in lua
    use 'norcalli/snippets.nvim'

    -- }}}

    -- Format {{{

    -- use 'lukas-reineke/format.nvim'

    -- formatter in lua
    use 'mhartington/formatter.nvim'
    use 'lukas-reineke/indent-blankline.nvim'

    -- Tabularize for Vim
    use 'godlygeek/tabular'

    -- }}}

    -- Undo {{{

    use 'simnalamburt/vim-mundo'

    -- }}}

    -- }}}

    -- LSP {{{

    -- coc.nvim {{{

    use 'neoclide/vim-jsx-improve'

    -- vim completion for coc
    use 'Shougo/neco-vim'
    use 'neoclide/coc-neco'

    -- Completion Conquerer
    use { 'neoclide/coc.nvim', branch = 'release' }

    use { 'fannheyward/go.vim', ft = 'go' }

    -- }}}

    -- neovim-lsp {{{

    -- use {
    --   'neovim/nvim-lspconfig',
    --   requires = {
    --     {
    --       'onsails/lspkind-nvim',
    --       config = function()
    --         require('lspkind').init({
    --           preset = 'codicons',
    --           symbol_map = {
    --             Class = '   ',
    --             Color = '   ',
    --             Constant = '   ',
    --             Constructor = '   ',
    --             Default = '   ',
    --             Enum = ' 了 ',
    --             EnumMember = '   ',
    --             Event = '   ',
    --             Field = '   ',
    --             File = '   ',
    --             Folder = '   ',
    --             Function = '   ',
    --             Interface = ' ﰮ  ',
    --             Keyword = '   ',
    --             Method = ' ƒ  ',
    --             Module = '   ',
    --             Operator = ' ○  ',
    --             Property = '   ',
    --             Reference = '   ',
    --             Snippet = ' ﬌  ',
    --             Struct = '   ',
    --             Text = '   ',
    --             TypeParameter = ' ⅀  ',
    --             Unit = '   ',
    --             Value = '   ',
    --             Variable = '   ',
    --           },
    --         })
    --       end,
    --     },
    --     { 'tami5/lspsaga.nvim' },
    --     -- nvim-cmp plugins
    --     {
    --       'hrsh7th/nvim-cmp',
    --       requires = {
    --         { 'hrsh7th/cmp-buffer' },
    --         { 'hrsh7th/cmp-nvim-lsp' },
    --         { 'hrsh7th/cmp-nvim-lua' },
    --         { 'hrsh7th/cmp-path' },
    --         { 'petertriho/cmp-git', requires = 'nvim-lua/plenary.nvim' },
    --         {
    --           'tzachar/cmp-tabnine',
    --           run = './install.sh',
    --           requires = 'hrsh7th/nvim-cmp',
    --         },
    --         { 'quangnguyen30192/cmp-nvim-ultisnips' },
    --         { 'f3fora/cmp-spell' },
    --         { 'ray-x/cmp-treesitter' },
    --         { 'hrsh7th/cmp-emoji' },
    --       },
    --     },
    --     { 'williamboman/nvim-lsp-installer' },
    --     { 'alexaandru/nvim-lspupdate', tag = 'v0.9.0' },
    --     { 'nvim-lua/lsp-status.nvim' },
    --     { 'tjdevries/lsp_extensions.nvim' },
    --     { 'folke/lsp-colors.nvim' },
    --     {
    --       'folke/trouble.nvim',
    --       requires = 'kyazdani42/nvim-web-devicons',
    --       config = function()
    --         require('trouble').setup {}
    --       end,
    --     },
    --     { 'folke/lua-dev.nvim' },
    --     {
    --       'onsails/vimway-lsp-diag.nvim',
    --       disable = true,
    --       config = function()
    --         require('vimway-lsp-diag').init({})
    --       end,
    --     },
    --   },
    -- }

    -- }}}

    -- Treesitter {{{

    use {
      'nvim-treesitter/nvim-treesitter',
      run = ':TSUpdate',
      requires = {
        { 'nvim-treesitter/nvim-treesitter-refactor' },
        { 'nvim-treesitter/nvim-treesitter-textobjects' },
        { 'RRethy/nvim-treesitter-textsubjects' },
        { 'nvim-treesitter/playground', cmd = 'TSPlaygroundToggle' },
        { 'p00f/nvim-ts-rainbow' },
        { 'JoosepAlviste/nvim-ts-context-commentstring' },
        {
          'mfussenegger/nvim-ts-hint-textobject',
          config = function()
            require('tsht').config.hint_keys = {
              'h',
              'j',
              'f',
              'd',
              'n',
              'v',
              's',
              'l',
              'a',
            }
            -- keybindings
            lk_utils.omap('m', [[:<C-U>lua require('tsht').nodes()<CR>]])
            lk_utils.vnoremap('m', [[:lua require('tsht').nodes()<CR>]])
          end,
        },
      },
    }

    -- interactively swap so many things
    use 'mizlan/iswap.nvim'

    -- }}}

    -- }}}

    -- FUZZY SEARCH {{{

    -- telescope.nvim {{{
    use { 'nvim-lua/plenary.nvim' }
    use { 'nvim-lua/popup.nvim' }

    use {
      'nvim-telescope/telescope.nvim',
      requires = {
        { 'brandoncc/telescope-harpoon.nvim' },
        { 'fannheyward/telescope-coc.nvim' },
        { 'fhill2/telescope-ultisnips.nvim' },
        { 'jvgrootveld/telescope-zoxide' },
        {
          'nvim-telescope/telescope-arecibo.nvim',
          rocks = { 'openssl', 'lua-http-parser' },
        },
        { 'nvim-telescope/telescope-cheat.nvim' },
        { 'nvim-telescope/telescope-dap.nvim' },
        { 'nvim-telescope/telescope-frecency.nvim' },
        { 'nvim-telescope/telescope-fzf-native.nvim', run = 'make' },
        { 'nvim-telescope/telescope-project.nvim' },
        { 'tamago324/telescope-openbrowser.nvim' },
        { 'xiyaowong/telescope-emoji.nvim' },
        { 'nvim-telescope/telescope-packer.nvim' },
        { 'nvim-telescope/telescope-smart-history.nvim' },
      },
    }

    -- }}}

    -- }}}

    -- LANGUAGES {{{

    -- packages info
    use {
      'vuki656/package-info.nvim',
      requires = 'MunifTanjim/nui.nvim',
      config = function()
        require('package-info').setup()
      end,
    }

    -- refactor the code {{{
    use {
      'ThePrimeagen/refactoring.nvim',
      requires = {
        { 'nvim-lua/plenary.nvim' },
        { 'nvim-treesitter/nvim-treesitter' },
      },
    }
    -- }}}

    -- HTML {{{

    -- emmets in vim
    use 'mattn/emmet-vim'

    -- html tags completion
    use 'AndrewRadev/tagalong.vim'

    -- wakatime for vim
    use 'wakatime/vim-wakatime'
    -- use 'sheerun/vim-polyglot'

    -- }}}

    -- markdown {{{

    use {
      'iamcco/markdown-preview.nvim',
      ft = 'markdown',
      run = 'cd app && yarn install',
    }

    -- markdown preview
    use { 'npxbr/glow.nvim', cmd = { 'Glow' } }

    -- }}}

    -- tags {{{

    -- Viewer & Finder for LSP symbols and tags
    use { 'liuchengxu/vista.vim', cmd = { 'Vista' } }

    -- }}}

    -- General {{{

    use {
      'RishabhRD/nvim-cheat.sh',
      requires = { 'RishabhRD/popfix' },
      cmd = {
        'Cheat',
        'CheatWithouComments',
        'CheatList',
        'CheatListWithoutComments',
      },
    }

    -- }}}

    -- }}}

    -- VERSION CONTROL STYSTEM {{{

    use { 'tpope/vim-fugitive' }
    use { 'ruifm/gitlinker.nvim', requires = 'nvim-lua/plenary.nvim' }
    use {
      'rhysd/conflict-marker.vim',
      config = function()
        -- disable the default highlight group
        vim.g.conflict_marker_highlight_group = ''
        -- Include text after begin and end markers
        vim.g.conflict_marker_begin = '^<<<<<<< .*$'
        vim.g.conflict_marker_end = '^>>>>>>> .*$'
      end,
    }

    use {
      'pwntester/octo.nvim',
      config = function()
        require'octo'.setup()
      end,
    }

    -- git worktree
    use 'ThePrimeagen/git-worktree.nvim'

    -- magit for neovim in lua
    use { 'TimUntersberger/neogit' }

    -- gitsigns in lua
    use 'lewis6991/gitsigns.nvim'

    -- git lens in vim
    use {
      'sindrets/diffview.nvim',
      config = function()
        require('diffview').setup {
          key_bindings = {
            file_panel = { q = '<Cmd>DiffviewClose<CR>' },
            view = { q = '<Cmd>DiffviewClose<CR>' },
          },
        }
      end,
    }

    -- }}}

    -- STATUS AND TAB LINES {{{
    -- use {
    --   'tjdevries/express_line.nvim',
    --   requires = { 'kyazdani42/nvim-web-devicons', opt = true },
    -- }

    use {
      'nvim-lualine/lualine.nvim',
      requires = { 'kyazdani42/nvim-web-devicons', opt = true },
    }
    use 'akinsho/nvim-bufferline.lua'

    -- }}}

    -- VIM NINJAS {{{

    -- tpope {{{

    use 'tpope/vim-abolish'
    use {
      'tpope/vim-dispatch',
      opt = true,
      cmd = { 'Dispatch', 'Make', 'Focus', 'Start' },
    }
    use 'tpope/vim-dotenv'
    use 'tpope/vim-eunuch'
    use 'tpope/vim-repeat'
    use 'tpope/vim-sleuth'
    use 'tpope/vim-surround'
    use 'tpope/vim-unimpaired'
    use 'tpope/vim-characterize'
    use {
      'tpope/vim-scriptease',
      cmd = {
        'Messages', -- view messages in quickfix list
        'Verbose', -- view verbose output in preview window.
        'Time', -- measure how long it takes to run some stuff.
      },
    }

    -- }}}

    -- tjdevries  {{{

    -- use 'tjdevries/express_line.nvim'
    use 'tjdevries/nlua.nvim'

    -- motion training
    use {
      'tjdevries/train.nvim',
      cmd = { 'TrainUpDown', 'TrainWord', 'TrainTextObj' },
    }
    use 'tjdevries/complextras.nvim'

    -- Make comments appear IN YO FACE
    use { 'tjdevries/vim-inyoface', keys = { '<Plug>(InYoFace_Toggle)' } }

    -- }}}

    --  }}}

    -- FILES {{{

    use {
      'airblade/vim-rooter',
      config = function()
        vim.g.rooter_silent_chdir = 1
        vim.g.rooter_resolve_links = 1
      end,
    }

    -- Explorer {{{

    use {
      'tamago324/lir.nvim',
      requires = {
        { 'tamago324/lir-git-status.nvim' },
        { 'nvim-lua/plenary.nvim' },
        { 'kyazdani42/nvim-web-devicons' },
      },
    }
    -- ranger for neovim
    use {
      'kevinhwang91/rnvimr',
      disable = true,
      config = function()
        -- Make Ranger replace Netrw and be the file explorer
        vim.g.rnvimr_enable_ex = 1

        -- Make Ranger to be hidden after picking a file
        vim.g.rnvimr_enable_picker = 1

        -- -- Disable a border for floating window
        -- vim.g.rnvimr_draw_border = 0

        -- Hide the files included in gitignore
        vim.g.rnvimr_hide_gitignore = 1

        -- Make Neovim wipe the buffers corresponding to the files deleted by Ranger
        vim.g.rnvimr_enable_bw = 1

        -- Add a shadow window, value is equal to 100 will disable shadow
        vim.g.rnvimr_shadow_winblend = 70
      end,
    }

    use { 'kyazdani42/nvim-tree.lua' }

    -- }}}

    -- General {{{

    -- for handling swap files
    use {
      'gioele/vim-autoswap',
      config = function()
        vim.g.autoswap_detect_tmux = 1
      end,
    }

    -- }}}

    -- }}}

    -- TERMINAL {{{

    -- Float Terminal
    use { 'akinsho/nvim-toggleterm.lua' }
    use {
      's1n7ax/nvim-terminal',
      config = function()
        ---@diagnostic disable-next-line: different-requires
        require('nvim-terminal').setup()
      end,
    }
    -- for using telescope-tmux
    use { 'norcalli/nvim-terminal.lua' }

    -- }}}

    -- GNVIM {{{

    -- Goneovim Fuzzy search
    -- NOTE: not using this because we have neovide instead of goneovim
    use { 'akiyosi/gonvim-fuzzy', disable = false }

    -- }}}

    -- BROWSER {{{

    -- sql nvim database for frecency
    use 'tami5/sqlite.lua'
    use 'tami5/sql.nvim'
    use 'tyru/open-browser.vim'

    -- }}}

    -- TESTING {{{

    -- debugger attach protocol
    use { 'rcarriga/nvim-dap-ui', requires = { 'mfussenegger/nvim-dap' } }

    -- }}}
  end,
  config = {
    display = {
      prompt_border = 'rounded',
      open_fn = function()
        return require('packer.util').float({ border = 'single' })
      end,
    },
    profile = {
      enable = true,
      threshold = 1, -- the amount in ms that a plugins load time must be over for it to be included in the profile
    },
  },
}
