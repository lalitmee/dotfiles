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

    use 'ThePrimeagen/vim-be-good' -- vim-be-good

    -- }}}

    -- UI AND BEAUTIFY {{{

    -- colorschemes {{{

    use 'tjdevries/colorbuddy.nvim' -- colorbuddy for Colorschemes
    use 'tjdevries/gruvbuddy.nvim' -- gruvbuddy using colorbuddy
    use 'Th3Whit3Wolf/onebuddy'
    use 'Th3Whit3Wolf/spacebuddy'
    use 'marko-cerovac/material.nvim'
    use 'folke/tokyonight.nvim'
    use 'shaunsingh/nord.nvim'
    use 'shaunsingh/moonlight.nvim'

    -- }}}

    -- icons {{{

    use 'kyazdani42/nvim-web-devicons' -- for icons in vim
    use 'yamatsum/nvim-nonicons' -- beautiful icons

    -- }}}

    -- General {{{

    use 'Pocco81/TrueZen.nvim'
    use 'junegunn/goyo.vim'
    use 'kshenoy/vim-signature' -- toggle, display and navigate marks
    use 'liuchengxu/vim-which-key' -- See what keys do like in emacs
    use 'AckslD/nvim-whichkey-setup.lua'
    use 'mhinz/vim-startify' -- fancy start Screen for vim
    use 'norcalli/nvim-colorizer.lua' -- Colorizer for showing the colors

    -- }}}

    -- }}}

    -- ACTIONS {{{

    -- Search, Replace and Jump {{{

    use 'windwp/nvim-spectre'
    use 'thinca/vim-visualstar'
    use 'junegunn/vim-fnr'
    use 'junegunn/vim-pseudocl'
    use 'kevinhwang91/nvim-bqf' -- better quick-fix winodw
    use 'kevinhwang91/nvim-hlslens' -- hlslens lens for neovim
    use 'phaazon/hop.nvim' -- easymotion using lua
    use 'unblevable/quick-scope' -- Quickscope same as f, F, t, T but better
    use { 'ripxorip/aerojump.nvim', run = ':UpdateRemotePlugins' }
    use {
      'edluffy/specs.nvim',
      config = function()
        require('specs').setup {
          show_jumps = true,
          min_jump = 30,
          popup = {
            delay_ms = 0, -- delay before popup displays
            inc_ms = 10, -- time increments used for fade/resize effects
            blend = 10, -- starting blend, between 0-100 (fully transparent), see :h winblend
            width = 10,
            winhl = 'PMenu',
            fader = require('specs').linear_fader,
            resizer = require('specs').shrink_resizer
          },
          ignore_filetypes = {},
          ignore_buftypes = { nofile = true }
        }
      end
    }

    -- }}}

    -- Navigations {{{

    use 'ThePrimeagen/harpoon'

    -- }}}

    -- General {{{

    use 'famiu/nvim-reload'
    use 'karb94/neoscroll.nvim'
    use 'mhinz/vim-sayonara' -- delete buffers and windows
    use 'andymass/vim-matchup' -- match brackets and more
    use 'AndrewRadev/splitjoin.vim' -- Switch between single-line and multiline forms of code
    use 'antoinemadec/FixCursorHold.nvim' -- fix cursor hold
    use 'christoomey/vim-sort-motion' -- sorting in vim
    use {
      'numToStr/Navigator.nvim',
      config = function()
        require('Navigator').setup()
      end
    }
    use 'christoomey/vim-tmux-runner' -- tmux runner for tests
    use 'haya14busa/is.vim' -- successor of incsearch
    use 'haya14busa/incsearch.vim' -- Better search highlighting
    use 'ntpeters/vim-better-whitespace' -- Better Whitespace
    use 'scr1pt0r/crease.vim' -- nice fold text
    use 'Konfekt/FastFold' -- fast folds in vim
    use 'szw/vim-maximizer' -- Maximizer for vim
    use 'tommcdo/vim-exchange' -- vim-exchange for exchanging words
    use 'wellle/targets.vim' -- targets.vim for extra motions
    use 'wesQ3/vim-windowswap' -- Swap windows

    -- }}}

    -- Profiling {{{

    use 'dstein64/vim-startuptime'

    -- }}}

    -- }}}

    -- TEXT {{{

    -- Notes {{{

    -- use 'oberblastmeister/neuron.nvim'               " note taking using lua
    -- use 'michal-h21/vim-zettel'                      " zettel tasks
    -- use 'vimwiki/vimwiki'                            " vim wiki

    -- }}}

    -- Snippets {{{

    use 'SirVer/ultisnips' -- snippets engine
    use 'honza/vim-snippets' -- Snippets in Vim
    -- use 'hrsh7th/vim-vsnip' -- vsnip vscode snippets
    -- use 'hrsh7th/vim-vsnip-integ'
    use 'norcalli/snippets.nvim' -- snippets in lua

    -- }}}

    -- Format {{{

    -- use 'lukas-reineke/format.nvim'
    use 'mhartington/formatter.nvim' -- formatter in lua
    use { 'lukas-reineke/indent-blankline.nvim', branch = 'lua' }
    use 'godlygeek/tabular' -- Tabularize for Vim

    -- }}}

    -- Undo {{{

    -- use 'simnalamburt/vim-mundo', {
    --       \ 'on': 'MundoToggle'
    --       \ }                                         " undo tree visualizer

    -- }}}

    -- Highlight Yank {{{

    use 'machakann/vim-highlightedyank'

    -- }}}

    -- General {{{

    use 'vim-scripts/restore_view.vim'

    -- }}}

    -- }}}

    -- LSP {{{

    -- coc.nvim {{{

    use 'Shougo/neco-vim'
    use 'neoclide/vim-jsx-improve'
    use 'neoclide/coc-neco' -- vim completion for coc
    use { 'neoclide/coc.nvim', branch = 'release' } -- Completion Conquerer

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
    --     -- { 'andersevenrud/compe-tmux', requires = 'hrsh7th/nvim-compe' },
    --     { 'kabouzeid/nvim-lspinstall' },
    --     { 'nvim-lua/lsp-status.nvim' }
    --   }
    -- }
    -- use 'folke/lsp-colors.nvim'
    -- use {
    --   'folke/trouble.nvim',
    --   requires = 'kyazdani42/nvim-web-devicons',
    --   config = function()
    --     require('trouble').setup {
    --       -- your configuration comes here
    --       -- or leave it empty to use the default settings
    --       -- refer to the configuration section below
    --     }
    --   end
    -- }
    use 'bfredl/nvim-luadev'
    use 'euclidianAce/BetterLua.vim' -- better lua syntax highlighting

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
      { 'nvim-treesitter/nvim-treesitter-refactor', after = 'nvim-treesitter' },
      { 'nvim-treesitter/nvim-treesitter-textobjects', after = 'nvim-treesitter' },
      {
        'nvim-treesitter/playground',
        after = 'nvim-treesitter',
        cmd = 'TSPlaygroundToggle'
      },
      { 'p00f/nvim-ts-rainbow', after = 'nvim-treesitter' },
      { 'windwp/nvim-ts-autotag', after = 'nvim-treesitter' },
      { 'JoosepAlviste/nvim-ts-context-commentstring', after = 'nvim-treesitter' }
    }

    -- }}}

    -- }}}

    -- FUZZY SEARCH {{{

    -- fzf.vim {{{

    use { 'junegunn/fzf', run = './install --all' } -- FZF in vim
    use 'junegunn/fzf.vim' -- FZF in vim
    use 'gfanto/fzf-lsp.nvim'

    -- }}}

    -- telescope.nvim {{{

    use {
      'nvim-telescope/telescope.nvim',
      requires = {
        { 'brandoncc/telescope-harpoon.nvim' },
        { 'fhill2/telescope-ultisnips.nvim' },
        { 'nvim-lua/plenary.nvim' },
        { 'nvim-lua/popup.nvim' },
        { 'nvim-telescope/telescope-cheat.nvim' },
        { 'nvim-telescope/telescope-dap.nvim' },
        { 'nvim-telescope/telescope-frecency.nvim' },
        { 'nvim-telescope/telescope-fzf-writer.nvim' },
        { 'nvim-telescope/telescope-fzy-native.nvim' },
        { 'nvim-telescope/telescope-media-files.nvim' },
        { 'nvim-telescope/telescope-project.nvim' },
        { 'nvim-telescope/telescope-snippets.nvim' },
        { 'nvim-telescope/telescope-symbols.nvim' },
        { 'tamago324/telescope-openbrowser.nvim' },
        { 'tkmpypy/telescope-jumps.nvim' },
        {
          'nvim-telescope/telescope-arecibo.nvim',
          rocks = { 'openssl', 'lua-http-parser' }
        },
        { 'TC72/telescope-tele-tabby.nvim' },
        { 'gbrlsnchs/telescope-lsp-handlers.nvim' },
        { 'nvim-telescope/telescope-packer.nvim' },
        { 'dhruvmanila/telescope-bookmarks.nvim' },
        { 'fannheyward/telescope-coc.nvim' }
        -- { 'nvim-telescope/telescope-fzf-native.nvim', run = 'make' }
      }
    }

    -- }}}

    -- }}}

    -- LANGUAGES {{{

    -- HTML {{{

    use 'mattn/emmet-vim' -- emmets in vim
    use 'alvan/vim-closetag' -- Auto Close Tag in HTML
    use 'AndrewRadev/tagalong.vim' -- html tags completion
    use 'wakatime/vim-wakatime' -- wakatime for vim
    -- use 'sheerun/vim-polyglot'

    -- }}}

    -- markdown {{{

    use 'npxbr/glow.nvim' -- markdown preview

    -- }}}

    -- tags {{{

    use 'liuchengxu/vista.vim' -- Viewer & Finder for LSP symbols and tags

    -- }}}

    -- General {{{

    use { 'RishabhRD/nvim-cheat.sh', requires = { 'RishabhRD/popfix' } }
    use 'windwp/nvim-autopairs' -- auto-pairs in lua
    use 'AndrewRadev/sideways.vim'

    -- }}}

    -- }}}

    -- VERSION CONTROL STYSTEM {{{

    use 'mattn/webapi-vim'
    -- use {
    --   'mattn/vim-gist',
    --   config = function()
    --     vim.g.gist_clip_command = 'xclip -selection clipboard'
    --     vim.g.gist_detect_filetype = 1
    --     vim.g.open_browser_after_post = 1
    --     vim.g.gist_show_privates = 1
    --     vim.g.gist_post_private = 1
    --     vim.g.gist_post_anonymous = 1
    --     vim.g.gist_get_multiplefile = 1
    --   end
    -- }
    use 'f-person/git-blame.nvim' -- git blame in vim
    use 'rhysd/git-messenger.vim' -- git lens in vim
    use 'TimUntersberger/neogit' -- magit for neovim in lua
    use 'lewis6991/gitsigns.nvim' -- gitsigns in lua
    use 'tpope/vim-fugitive' -- version control
    use 'kdheepak/lazygit.nvim' -- lazygit from neovim
    use 'ThePrimeagen/git-worktree.nvim' -- git worktree
    use 'sindrets/diffview.nvim'

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
    use 'tpope/vim-dispatch'
    use 'tpope/vim-dotenv'
    use 'tpope/vim-eunuch'
    use 'tpope/vim-repeat'
    use 'tpope/vim-sleuth'
    use 'tpope/vim-surround'
    use 'tpope/vim-unimpaired'
    use 'tpope/vim-scriptease'

    -- }}}

    -- tjdevries  {{{

    -- use 'tjdevries/express_line.nvim'
    use 'tjdevries/manillua.nvim'
    use 'tjdevries/nlua.nvim'
    use 'tjdevries/train.nvim' -- motion training
    use 'tjdevries/complextras.nvim'
    use 'tjdevries/lsp_extensions.nvim'

    -- }}}

    --  }}}

    -- FILES {{{

    -- Explorer {{{

    use 'justinmk/vim-dirvish'
    use 'kyazdani42/nvim-tree.lua' -- file explorer

    -- }}}

    -- General {{{

    use 'gioele/vim-autoswap' -- for handling swap files

    -- }}}

    -- }}}

    -- TERMINAL {{{

    use 'voldikss/vim-floaterm' -- Float Terminal
    use 'akinsho/nvim-toggleterm.lua'

    -- }}}

    -- GNVIM {{{

    use 'akiyosi/gonvim-fuzzy' -- Goneovim Fuzzy search

    -- }}}

    -- BROWSER {{{

    use 'tami5/sql.nvim' -- sql nvim database for frecency
    use 'tyru/open-browser-github.vim'
    use 'tyru/open-browser.vim'

    -- }}}

    -- TESTING {{{

    -- use 'benmills/vimux'                             " Testing in vim with tmux
    -- use 'puremourning/vimspector'                    " debugger in vim
    -- use 'skywind3000/asyncrun.vim'
    -- use 'skywind3000/asynctasks.vim'
    use 'mfussenegger/nvim-dap' -- debugger attach protocol

    -- }}}
  end,
  config = { display = { open_cmd = 'topleft 65vnew [packer]' } }
}
