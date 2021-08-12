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

return require('packer').startup {
  function(use)
    -- Packer can manage itself as an optional plugin
    use 'wbthomason/packer.nvim'

    -- UI AND BEAUTIFY {{{

    -- colorschemes {{{

    -- enabled
    use { 'Murtaza-Udaipurwala/gruvqueen', disable = false }
    use { 'navarasu/onedark.nvim', disable = false }
    use { 'NTBBloodbath/doom-one.nvim', disable = false }
    use { 'projekt0n/github-nvim-theme', disable = false }
    use { 'tjdevries/colorbuddy.nvim', disable = false }
    use { 'tjdevries/gruvbuddy.nvim', disable = false }
    use { 'tomasiser/vim-code-dark', disable = false }
    use { 'Mofiqul/vscode.nvim', disable = false }
    use { 'folke/tokyonight.nvim', disable = false }
    use { 'marko-cerovac/material.nvim', disable = false }
    use {
      'folke/twilight.nvim',
      config = function()
        require('twilight').setup {}
      end,
      disable = false,
    }

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

    -- fancy start Screen for vim
    use 'mhinz/vim-startify'

    -- Colorizer for showing the colors
    use 'norcalli/nvim-colorizer.lua'

    -- }}}

    -- }}}

    -- ACTIONS {{{

    -- Search, Replace and Jump {{{

    use 'windwp/nvim-spectre'
    use 'nelstrom/vim-visual-star-search'
    use 'junegunn/vim-fnr'
    use 'junegunn/vim-pseudocl'

    -- better quick-fix winodw
    use 'kevinhwang91/nvim-bqf'

    -- display search matches
    use { 'kevinhwang91/nvim-hlslens' }
    use 'henrik/vim-indexed-search'

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
        require('neoscroll').setup()
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
    use { 'AndrewRadev/splitjoin.vim', keys = { 'gJ', 'gS' } }

    -- sorting in vim
    use 'christoomey/vim-sort-motion'
    use {
      'numToStr/Navigator.nvim',
      config = function()
        require('Navigator').setup()
      end,
    }

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
      end,
    }

    -- }}}

    -- commenting {{{

    -- not using this because this doesn't support repeating of the last acion
    use { 'b3nj5m1n/kommentary', disable = true }

    -- }}}

    -- }}}

    -- TEXT {{{

    -- jump to any definition or references
    use 'pechorin/any-jump.vim'

    -- Notes {{{

    -- NOTE: not using this because it has 3 seconds loading time
    use {
      'vhyrro/neorg',
      disable = true,
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
                    undone = { enabled = true, icon = '×' },
                  },
                  quote = { enabled = true, icon = '∣' },
                  heading = {
                    enabled = true,

                    level_1 = { enabled = true, icon = '⦿' },

                    level_2 = { enabled = true, icon = '⦾' },

                    level_3 = { enabled = true, icon = '•' },

                    level_4 = { enabled = true, icon = '◦' },
                  },
                  list = { enabled = true, icon = '‑' },
                },

                conceal_cursor = '',
              },
            },
            ['core.norg.dirman'] = { -- Manage your directories with Neorg
              config = {
                workspaces = { my_workspace = '~/data/Github/Notes/neorg' },
              },
            },
          },
        }
      end,
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
            leader = 'gz',
          }
        end,
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
    -- use 'Shougo/neco-vim'
    -- use 'neoclide/coc-neco'

    -- -- Completion Conquerer
    -- use { 'neoclide/coc.nvim', branch = 'release' }

    -- }}}

    -- neovim-lsp {{{

    use {
      'neovim/nvim-lspconfig',
      requires = {
        { 'arkav/lualine-lsp-progress' },
        { 'glepnir/lspsaga.nvim' },
        { 'hrsh7th/nvim-compe' },
        {
          'tzachar/compe-tabnine',
          run = './install.sh',
          requires = 'hrsh7th/nvim-compe',
        },
        { 'kabouzeid/nvim-lspinstall' },
        { 'alexaandru/nvim-lspupdate' },
        { 'nvim-lua/lsp-status.nvim' },
        { 'tjdevries/lsp_extensions.nvim' },
        {
          'simrat39/symbols-outline.nvim',
          config = function()
            vim.g.symbols_outline = {
              highlight_hovered_item = true,
              show_guides = true,
              auto_preview = false, -- experimental
              position = 'right',
              keymaps = {
                close = '<Esc>',
                goto_location = '<Cr>',
                focus_location = 'o',
                hover_symbol = '<C-space>',
                rename_symbol = 'r',
                code_actions = 'a',
              },
              lsp_blacklist = {},
            }
          end,
        },
        { 'folke/lsp-colors.nvim' },
        {
          'folke/trouble.nvim',
          requires = 'kyazdani42/nvim-web-devicons',
          config = function()
            require('trouble').setup {}
          end,
        },
        { 'jose-elias-alvarez/nvim-lsp-ts-utils' },
        { 'jose-elias-alvarez/null-ls.nvim' },
        {
          'simrat39/symbols-outline.nvim',
          config = function()
            vim.g.symbols_outline = {
              highlight_hovered_item = true,
              show_guides = true,
              auto_preview = true,
              position = 'right',
              show_numbers = false,
              show_relative_numbers = false,
              show_symbol_details = true,
              keymaps = {
                close = '<Esc>',
                goto_location = '<Cr>',
                focus_location = 'o',
                hover_symbol = '<C-space>',
                rename_symbol = 'r',
                code_actions = 'a',
              },
              lsp_blacklist = {},
            }
          end,
        },
        { 'stevearc/aerial.nvim' },
        { 'folke/lua-dev.nvim' },
        {
          'ahmedkhalf/lsp-rooter.nvim',
          config = function()
            require('lsp-rooter').setup()
          end,
          event = 'ColorScheme',
        },
        {
          'onsails/vimway-lsp-diag.nvim',
          disable = true,
          config = function()
            require('vimway-lsp-diag').init({})
          end,
        },
      },
    }

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
        end,
      },
      { 'nvim-treesitter/nvim-treesitter-refactor' },
      { 'nvim-treesitter/nvim-treesitter-textobjects' },
      { 'RRethy/nvim-treesitter-textsubjects' },
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
        end,
      },
    }

    -- interactively swap so many things
    use 'mizlan/iswap.nvim'

    -- }}}

    -- }}}

    -- FUZZY SEARCH {{{

    use { 'camspiers/snap', rocks = { 'fzy' } }

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
        { 'fannheyward/telescope-coc.nvim' },
        { 'fhill2/telescope-ultisnips.nvim' },
        { 'gbrlsnchs/telescope-lsp-handlers.nvim' },
        { 'nvim-telescope/telescope-cheat.nvim' },
        { 'nvim-telescope/telescope-dap.nvim' },
        { 'nvim-telescope/telescope-frecency.nvim' },
        { 'nvim-telescope/telescope-fzf-native.nvim', run = 'make' },
        { 'nvim-telescope/telescope-fzf-writer.nvim' },
        { 'nvim-telescope/telescope-github.nvim' },
        { 'nvim-telescope/telescope-project.nvim' },
        { 'tamago324/telescope-openbrowser.nvim' },
        { 'tkmpypy/telescope-jumps.nvim' },
        { 'xiyaowong/telescope-emoji.nvim' },
      },
    }

    -- }}}

    -- }}}

    -- LANGUAGES {{{

    -- packages info
    use {
      'vuki656/package-info.nvim',
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

    -- auto-pairs in lua
    use 'windwp/nvim-autopairs'

    -- }}}

    -- }}}

    -- VERSION CONTROL STYSTEM {{{

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
    use { 'sindrets/diffview.nvim' }

    -- }}}

    -- STATUS AND TAB LINES {{{
    -- use {
    --   'tjdevries/express_line.nvim',
    --   requires = { 'kyazdani42/nvim-web-devicons', opt = true },
    -- }

    use {
      'shadmansaleh/lualine.nvim',
      requires = { { 'kyazdani42/nvim-web-devicons', opt = true } },
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
    use {
      'akinsho/nvim-toggleterm.lua',
      -- cmd = { 'ToggleTerm', 'ToggleTermCloseAll', 'ToggleTermOpenAll' },
      -- keys = { '<C-t>' }
    }

    -- }}}

    -- GNVIM {{{

    -- Goneovim Fuzzy search
    -- NOTE: not using this because we have neovide instead of goneovim
    use { 'akiyosi/gonvim-fuzzy', disable = true }

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
        'OpenGithubIssue',
      },
    }
    use { 'tyru/open-browser.vim' }

    -- }}}

    -- TESTING {{{

    -- debugger attach protocol
    use 'mfussenegger/nvim-dap'
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
