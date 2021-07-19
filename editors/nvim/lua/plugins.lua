local execute = vim.api.nvim_command
local fn = vim.fn

local install_path = fn.stdpath('data') .. '/site/pack/packer/start/packer.nvim'

if fn.empty(fn.glob(install_path)) > 0 then
  execute('!git clone https://github.com/wbthomason/packer.nvim ' ..
              install_path)
end

local function hunspell_install_if_needed()
  if vim.fn.executable('hunspell') == 0 then
    if vim.fn.has('mac') > 0 then
      -- on mac os need to download GB dictionary
      -- and place in ~/Library/Spelling
      -- these are available
      -- https://wiki.openoffice.org/wiki/Dictionaries
      vim.fn.system('brew install hunspell')
    else
      vim.fn.system('apt install hunspell hunspell_en_gb')
    end
  end
end

vim.api.nvim_exec([[
  augroup Packer
    autocmd!
    autocmd BufWritePost plugins.lua PackerCompile
  augroup end
]], false)

require('packer').init({ display = { auto_clean = false } })

return require('packer').startup {
  function(use)
    -- Packer can manage itself as an optional plugin
    use 'wbthomason/packer.nvim'

    -- LEARN VIM {{{

    -- vim-be-good
    -- use 'ThePrimeagen/vim-be-good'

    -- }}}

    -- UI AND BEAUTIFY {{{

    -- colorschemes {{{

    -- colorbuddy for Colorschemes
    use 'tjdevries/colorbuddy.nvim'

    -- vscode dark color colorshceme
    use 'Mofiqul/vscode.nvim'

    -- tokyonight colorscheme
    use 'folke/tokyonight.nvim'

    -- gruvbox colorscheme
    use 'gruvbox-community/gruvbox'

    -- material colorscheme
    use 'marko-cerovac/material.nvim'

    -- gruvbuddy using colorbuddy
    use 'tjdevries/gruvbuddy.nvim'

    -- }}}

    -- icons {{{

    -- for icons in vim
    use 'kyazdani42/nvim-web-devicons'

    -- beautiful icons
    use 'yamatsum/nvim-nonicons'

    -- }}}

    -- General {{{

    use {
      'Pocco81/TrueZen.nvim',
      cmd = {
        'TZAtaraxis',
        'TZAtaraxisOn',
        'TZFocus',
        'TZFocusOn',
        'TZMinimalist',
        'TZMinimalistOn'
      }
    }

    -- toggle, display and navigate marks
    use 'kshenoy/vim-signature'

    -- See what keys do like in emacs
    use 'liuchengxu/vim-which-key'
    use 'AckslD/nvim-whichkey-setup.lua'

    -- fancy start Screen for vim
    use 'mhinz/vim-startify'

    -- Colorizer for showing the colors
    use { 'norcalli/nvim-colorizer.lua' }
    -- use {
    --   'norcalli/nvim-terminal.lua',
    --   config = function()
    --     require('terminal').setup()
    --   end
    -- }

    -- }}}

    -- }}}

    -- ACTIONS {{{

    -- Search, Replace and Jump {{{

    -- use 'mileszs/ack.vim'
    use 'windwp/nvim-spectre'
    use 'nelstrom/vim-visual-star-search'
    use 'junegunn/vim-fnr'
    use 'junegunn/vim-pseudocl'

    -- better quick-fix winodw
    use 'kevinhwang91/nvim-bqf'

    -- hlslens lens for neovim
    use 'kevinhwang91/nvim-hlslens'

    -- easymotion using lua
    use 'phaazon/hop.nvim'

    -- Quickscope same as f, F, t, T but better
    use 'unblevable/quick-scope'
    -- use {
    --   'ggandor/lightspeed.nvim',
    --   config = function()
    --     require('lightspeed').setup {
    --       jump_to_first_match = true,
    --       jump_on_partial_input_safety_timeout = 400,
    --       highlight_unique_chars = false,
    --       grey_out_search_area = true,
    --       match_only_the_start_of_same_char_seqs = true,
    --       limit_ft_matches = 5,
    --       full_inclusive_prefix_key = '<c-x>'
    --     }
    --   end
    -- }
    -- use { 'ripxorip/aerojump.nvim', run = ':UpdateRemotePlugins' }
    -- use {
    --   'edluffy/specs.nvim',
    --   config = function()
    --     require('specs').setup {
    --       show_jumps = true,
    --       min_jump = 30,
    --       popup = {
    --         delay_ms = 0, -- delay before popup displays
    --         inc_ms = 10, -- time increments used for fade/resize effects
    --         blend = 10, -- starting blend, between 0-100 (fully transparent), see :h winblend
    --         width = 10,
    --         winhl = 'PMenu',
    --         fader = require('specs').linear_fader,
    --         resizer = require('specs').shrink_resizer
    --       },
    --       ignore_filetypes = {},
    --       ignore_buftypes = { nofile = true }
    --     }
    --   end
    -- }

    -- }}}

    -- Navigations {{{

    use 'ThePrimeagen/harpoon'

    -- }}}

    -- General {{{

    -- show preview for :substitute and :normal
    use 'markonm/traces.vim'

    -- move code up and down
    use 'matze/vim-move'

    -- For narrowing regions of text to look at them alone
    use { 'chrisbra/NrrwRgn', cmd = { 'NarrowRegion', 'NarrowWindow' } }
    use {
      'folke/todo-comments.nvim',
      config = function()
        require('todo-comments').setup {}
      end
    }
    use 'suy/vim-context-commentstring'
    use { 'famiu/nvim-reload' }
    use {
      'karb94/neoscroll.nvim',
      config = function()
        require('neoscroll').setup()
      end
    }
    use {
      'jghauser/mkdir.nvim',
      config = function()
        require('mkdir')
      end
    }

    -- minimal and beautiful buffer switcher
    use 'matbme/JABS.nvim'

    -- delete buffers and windows
    use 'mhinz/vim-sayonara'

    -- match brackets and more
    use 'andymass/vim-matchup'

    -- Switch between single-line and multiline forms of code
    use { 'AndrewRadev/splitjoin.vim', keys = { 'gJ', 'gS' } }

    -- use 'yamatsum/nvim-cursorline'
    use {
      'antoinemadec/FixCursorHold.nvim',
      run = function()
        vim.g.curshold_updatime = 1000
      end
    }

    -- sorting in vim
    use 'christoomey/vim-sort-motion'
    use {
      'numToStr/Navigator.nvim',
      config = function()
        require('Navigator').setup()
      end
    }

    -- tmux runner for tests
    use 'christoomey/vim-tmux-runner'

    -- successor of incsearch
    use 'haya14busa/is.vim'

    -- Better search highlighting
    use 'haya14busa/incsearch.vim'

    -- Better Whitespace
    use 'ntpeters/vim-better-whitespace'

    -- nice fold text
    use 'scr1pt0r/crease.vim'

    -- fast folds in vim
    use { 'Konfekt/FastFold' }

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
      end
    }

    -- }}}

    -- Profiling {{{

    -- Better profiling output for startup.
    use { 'dstein64/vim-startuptime', cmd = 'StartupTime' }

    -- }}}

    -- commenting {{{

    -- not using this because this doesn't support repeating of the last acion
    use { 'b3nj5m1n/kommentary', disable = true }

    -- }}}

    -- }}}

    -- TEXT {{{

    -- Notes {{{

    use {
      'vhyrro/neorg',
      config = function()
        require('neorg').setup {
          -- Tell Neorg what modules to load
          load = {
            ['core.defaults'] = {}, -- Load all the default modules
            ['core.norg.concealer'] = { -- Allows the use of icons
              config = {
                icons = { -- Set our own icons here
                  todo = {
                    enabled = true,

                    done = { enabled = true, icon = '' },
                    pending = { enabled = true, icon = '' },
                    undone = { enabled = true, icon = '×' }
                  },
                  quote = { enabled = true, icon = '∣' },
                  heading = {
                    enabled = true,

                    level_1 = { enabled = true, icon = '⦿' },

                    level_2 = { enabled = true, icon = '⦾' },

                    level_3 = { enabled = true, icon = '•' },

                    level_4 = { enabled = true, icon = '◦' }
                  },
                  list = { enabled = true, icon = '‑' }
                },

                conceal_cursor = ''
              }
            },
            ['core.norg.dirman'] = { -- Manage your directories with Neorg
              config = {
                workspaces = { my_workspace = '~/data/Github/Notes/neorg' }
              }
            }
          }
        }
      end
    }

    if false and vim.fn.executable 'neuron' == 1 then
      use {
        'oberblastmeister/neuron.nvim',
        branch = 'unstable',
        config = function()
          -- these are all the default values
          require('neuron').setup {
            virtual_titles = true,
            mappings = true,
            run = nil,
            neuron_dir = '~/data/Github/Notes/neuron',
            leader = 'gz'
          }
        end
      }
    end
    -- use 'michal-h21/vim-zettel'                      " zettel tasks
    -- use 'vimwiki/vimwiki'                            " vim wiki

    -- }}}

    -- Snippets {{{

    -- snippets engine
    use 'SirVer/ultisnips'

    -- Snippets in Vim
    use 'honza/vim-snippets'

    -- vsnip vscode snippets
    -- use 'hrsh7th/vim-vsnip'
    -- use 'hrsh7th/vim-vsnip-integ'

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

    use { 'sjl/gundo.vim' }

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

    -- }}}

    -- neovim-lsp {{{

    -- use {
    --   'neovim/nvim-lspconfig',
    --   requires = {
    --     { 'glepnir/lspsaga.nvim' },
    --     { 'hrsh7th/nvim-compe' },
    --     {
    --       'tzachar/compe-tabnine',
    --       run = './install.sh',
    --       requires = 'hrsh7th/nvim-compe'
    --     },
    --     { 'kabouzeid/nvim-lspinstall' },
    --     { 'nvim-lua/lsp-status.nvim' },
    --     { 'tjdevries/lsp_extensions.nvim' },
    --     {
    --       'simrat39/symbols-outline.nvim',
    --       config = function()
    --         vim.g.symbols_outline = {
    --           highlight_hovered_item = true,
    --           show_guides = true,
    --           auto_preview = false, -- experimental
    --           position = 'right',
    --           keymaps = {
    --             close = '<Esc>',
    --             goto_location = '<Cr>',
    --             focus_location = 'o',
    --             hover_symbol = '<C-space>',
    --             rename_symbol = 'r',
    --             code_actions = 'a'
    --           },
    --           lsp_blacklist = {}
    --         }
    --       end
    --     },
    --     { 'folke/lsp-colors.nvim' },
    --     {
    --       'folke/trouble.nvim',
    --       requires = 'kyazdani42/nvim-web-devicons',
    --       config = function()
    --         require('trouble').setup {}
    --       end
    --     },
    --     { 'jose-elias-alvarez/nvim-lsp-ts-utils' },
    --     { 'jose-elias-alvarez/null-ls.nvim' },
    --     {
    --       'simrat39/symbols-outline.nvim',
    --       config = function()
    --         vim.g.symbols_outline = {
    --           highlight_hovered_item = true,
    --           show_guides = true,
    --           auto_preview = true,
    --           position = 'right',
    --           show_numbers = false,
    --           show_relative_numbers = false,
    --           show_symbol_details = true,
    --           keymaps = {
    --             close = '<Esc>',
    --             goto_location = '<Cr>',
    --             focus_location = 'o',
    --             hover_symbol = '<C-space>',
    --             rename_symbol = 'r',
    --             code_actions = 'a'
    --           },
    --           lsp_blacklist = {}
    --         }
    --       end
    --     },
    --     { 'stevearc/aerial.nvim' },
    --     { 'folke/lua-dev.nvim' },
    --     {
    --       'ahmedkhalf/lsp-rooter.nvim',
    --       config = function()
    --         require('lsp-rooter').setup()
    --       end,
    --       event = 'ColorScheme'
    --     }
    --   }
    -- }
    use 'bfredl/nvim-luadev'

    -- better lua syntax highlighting
    use 'euclidianAce/BetterLua.vim'

    -- }}}

    -- Treesitter {{{

    use {
      'nvim-treesitter/nvim-treesitter',
      run = ':TSUpdate',
      requires = {
        'lewis6991/spellsitter.nvim',
        cond = 'false',
        run = hunspell_install_if_needed,
        config = function()
          require('spellsitter').setup { captures = { 'comment' } }
        end
      },
      { 'nvim-treesitter/nvim-treesitter-refactor' },
      { 'nvim-treesitter/nvim-treesitter-textobjects' },
      { 'nvim-treesitter/playground', cmd = 'TSPlaygroundToggle' },
      { 'p00f/nvim-ts-rainbow' },
      { 'JoosepAlviste/nvim-ts-context-commentstring' },
      {
        'mfussenegger/nvim-ts-hint-textobject',
        config = function()
          require('tsht').config.hint_keys =
              { 'h', 'j', 'f', 'd', 'n', 'v', 's', 'l', 'a' }
          -- keybindings
          lk.omap('m', [[:<C-U>lua require('tsht').nodes()<CR>]])
          lk.vnoremap('m', [[:lua require('tsht').nodes()<CR>]])
        end
      }
    }

    -- interactively swap so many things
    use 'mizlan/iswap.nvim'

    -- }}}

    -- }}}

    -- FUZZY SEARCH {{{

    -- fzf.vim {{{

    use { 'junegunn/fzf', run = './install --all' } -- FZF in vim

    -- FZF in vim
    use 'junegunn/fzf.vim'

    -- }}}

    -- telescope.nvim {{{
    use { 'nvim-lua/plenary.nvim' }
    use { 'nvim-lua/popup.nvim' }

    use {
      'nvim-telescope/telescope.nvim',
      requires = {
        { 'brandoncc/telescope-harpoon.nvim' },
        { 'dhruvmanila/telescope-bookmarks.nvim' },
        { 'fannheyward/telescope-coc.nvim' },
        { 'fhill2/telescope-ultisnips.nvim' },
        { 'gbrlsnchs/telescope-lsp-handlers.nvim' },
        { 'jvgrootveld/telescope-zoxide' },
        { 'nvim-telescope/telescope-cheat.nvim' },
        { 'nvim-telescope/telescope-dap.nvim' },
        { 'nvim-telescope/telescope-frecency.nvim' },
        { 'nvim-telescope/telescope-fzf-native.nvim', run = 'make' },
        { 'nvim-telescope/telescope-fzf-writer.nvim' },
        { 'nvim-telescope/telescope-fzy-native.nvim' },
        { 'nvim-telescope/telescope-github.nvim' },
        { 'nvim-telescope/telescope-project.nvim' },
        { 'nvim-telescope/telescope-snippets.nvim' },
        { 'nvim-telescope/telescope-symbols.nvim' },
        { 'tamago324/telescope-openbrowser.nvim' },
        { 'tkmpypy/telescope-jumps.nvim' },
        { 'xiyaowong/telescope-emoji.nvim' }
        -- { 'nvim-telescope/telescope-github.nvim' },
        -- {
        --   'nvim-telescope/telescope-arecibo.nvim',
        --   rocks = { 'openssl', 'lua-http-parser' }
        -- },
      }
    }

    -- }}}

    -- }}}

    -- LANGUAGES {{{

    -- {{{

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

    use 'davidgranstrom/nvim-markdown-preview'

    use {
      'iamcco/markdown-preview.nvim',
      ft = 'markdown',
      run = 'cd app && yarn install'
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
        'CheatListWithoutComments'
      }
    }

    -- auto-pairs in lua
    use 'windwp/nvim-autopairs'
    -- use {
    --   'sudormrfbin/cheatsheet.nvim',
    --   requires = {
    --     { 'nvim-telescope/telescope.nvim' },
    --     { 'nvim-lua/popup.nvim' },
    --     { 'nvim-lua/plenary.nvim' }
    --   },
    --   cmd = { 'CheatSheet', 'CheatSheedEdit' }
    -- }

    -- }}}

    -- }}}

    -- VERSION CONTROL STYSTEM {{{

    use {
      'rhysd/conflict-marker.vim',
      config = function()
        -- disable the default highlight group
        vim.g.conflict_marker_highlight_group = ''
        -- Include text after begin and end markers
        vim.g.conflict_marker_begin = '^<<<<<<< .*$'
        vim.g.conflict_marker_end = '^>>>>>>> .*$'
      end
    }

    use {
      'pwntester/octo.nvim',
      config = function()
        require'octo'.setup()
      end
    }

    -- git worktree
    use 'ThePrimeagen/git-worktree.nvim'

    -- magit for neovim in lua
    use { 'TimUntersberger/neogit' }

    -- lazygit from neovim
    use {
      'kdheepak/lazygit.nvim',
      cmd = { 'LazyGit', 'LazyGitConfig', 'LazyGitFilter' }
    }

    -- gitsigns in lua
    use 'lewis6991/gitsigns.nvim'

    -- git lens in vim
    use {
      'rhysd/git-messenger.vim',
      cmd = { 'GitMessenger' },
      keys = { '<Plug>(git-messenger)' }
    }
    use {
      'sindrets/diffview.nvim'
      -- cmd = { 'DiffViewOpen' }
    }

    -- version control
    use 'tpope/vim-fugitive'

    -- }}}

    -- STATUS AND TAB LINES {{{

    -- use { 'glepnir/galaxyline.nvim', branch = 'main' }
    use {
      'hoob3rt/lualine.nvim',
      requires = { 'kyazdani42/nvim-web-devicons', opt = true }
    }
    use 'akinsho/nvim-bufferline.lua'

    -- }}}

    -- VIM NINJAS {{{

    -- tpope {{{

    use 'tpope/vim-abolish'
    use 'tpope/vim-commentary'
    use {
      'tpope/vim-dispatch',
      opt = true,
      cmd = { 'Dispatch', 'Make', 'Focus', 'Start' }
    }
    use 'tpope/vim-dotenv'
    use 'tpope/vim-eunuch'
    use 'tpope/vim-repeat'
    use 'tpope/vim-sleuth'
    use 'tpope/vim-surround'
    use 'tpope/vim-unimpaired'
    use {
      'tpope/vim-scriptease',
      cmd = {
        'Messages', -- view messages in quickfix list
        'Verbose', -- view verbose output in preview window.
        'Time' -- measure how long it takes to run some stuff.
      }
    }

    -- }}}

    -- tjdevries  {{{

    -- use 'tjdevries/express_line.nvim'
    use 'tjdevries/nlua.nvim'

    -- motion training
    use {
      'tjdevries/train.nvim',
      cmd = { 'TrainUpDown', 'TrainWord', 'TrainTextObj' }
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
      end
    }

    -- Explorer {{{

    -- file explorer
    use {
      'kyazdani42/nvim-tree.lua'
      -- cmd = {
      --   'NvimTreeToggle',
      --   'NvimTreeOpen',
      --   'NvimTreeClose',
      --   'NvimTreeRefresh',
      --   'NvimTreeFindFile',
      --   'NvimTreeFindResize',
      --   'NvimTreeClipboard'
      -- }
    }

    -- }}}

    -- General {{{

    -- for handling swap files
    use 'gioele/vim-autoswap'

    -- }}}

    -- }}}

    -- TERMINAL {{{

    -- Float Terminal
    use {
      'akinsho/nvim-toggleterm.lua'
      -- cmd = { 'ToggleTerm', 'ToggleTermCloseAll', 'ToggleTermOpenAll' },
      -- keys = { '<C-t>' }
    }

    -- }}}

    -- GNVIM {{{

    -- Goneovim Fuzzy search
    use 'akiyosi/gonvim-fuzzy'

    -- }}}

    -- BROWSER {{{

    -- sql nvim database for frecency
    use 'tami5/sql.nvim'
    use {
      'tyru/open-browser-github.vim',
      cmd = {
        'OpenGithubFile',
        'OpenGithubProject',
        'OpenGithubPullReq',
        'OpenGithubCommit',
        'OpenGithubIssue'
      }
    }
    use { 'tyru/open-browser.vim' }

    -- }}}

    -- TESTING {{{

    -- debugger attach protocol
    use 'mfussenegger/nvim-dap'
    use { 'rcarriga/nvim-dap-ui', requires = { 'mfussenegger/nvim-dap' } }

    -- }}}
  end,
  config = { display = { open_cmd = 'topleft 65vnew [packer]' } }
}
