-- vim.cmd [[packadd packer.nvim]]
local execute = vim.api.nvim_command
local fn = vim.fn

local install_path = fn.stdpath('data') .. '/site/pack/packer/start/packer.nvim'

if fn.empty(fn.glob(install_path)) > 0 then
  execute('!git clone https://github.com/wbthomason/packer.nvim ' .. install_path)
  execute 'packadd packer.nvim'
end

-- vim.cmd 'autocmd BufWritePost plugins.lua PackerCompile'

-- require('packer').init({ display = { auto_clean = false } })

return require('packer').startup {
  function(use)
    -- Packer can manage itself as an optional plugin
    use 'wbthomason/packer.nvim'

    -- LEARN VIM {{{

    use 'ThePrimeagen/vim-be-good' -- vim-be-good

    -- }}}

    -- UI AND BEAUTIFY {{{

    -- colorschemes {{{

    use 'christianchiarulli/nvcode-color-schemes.vim' -- nvcode colors

    -- }}}

    -- icons {{{

    use 'kyazdani42/nvim-web-devicons' -- for icons in vim
    use 'yamatsum/nvim-nonicons' -- beautiful icons

    -- }}}

    -- General {{{

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

    use 'thinca/vim-visualstar'
    use 'junegunn/vim-fnr'
    use 'junegunn/vim-pseudocl'
    use 'kevinhwang91/nvim-bqf' -- better quick-fix winodw
    use 'kevinhwang91/nvim-hlslens' -- hlslens lens for neovim
    use 'phaazon/hop.nvim' -- easymotion using lua
    use 'unblevable/quick-scope' -- Quickscope same as f, F, t, T but better

    -- }}}

    -- Navigations {{{

    use 'ThePrimeagen/harpoon'

    -- }}}

    -- General {{{

    use 'karb94/neoscroll.nvim'
    use 'mhinz/vim-sayonara' -- delete buffers and windows
    use 'andymass/vim-matchup' -- match brackets and more
    use 'AndrewRadev/splitjoin.vim' -- Switch between single-line and multiline forms of code
    use 'antoinemadec/FixCursorHold.nvim' -- fix cursor hold
    use 'christoomey/vim-sort-motion' -- sorting in vim
    use 'christoomey/vim-tmux-navigator' -- Moving in vim inside Tmux
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
    use 'hrsh7th/vim-vsnip' -- vsnip vscode snippets
    use 'hrsh7th/vim-vsnip-integ'
    use 'norcalli/snippets.nvim' -- snippets in lua

    -- }}}

    -- Format {{{

    -- use 'lukas-reineke/format.nvim'
    use 'mhartington/formatter.nvim' -- formatter in lua
    use {
      'lukas-reineke/indent-blankline.nvim',
      branch = 'lua'
    }
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

    use 'neoclide/coc-neco' -- vim completion for coc
    use {
      'neoclide/coc.nvim',
      branch = 'release'
    } -- Completion Conquerer
    use {
      'antoinemadec/coc-fzf',
      branch = 'release'
    }

    -- }}}

    -- neovim-lsp {{{

    -- use 'glepnir/lspsaga.nvim'
    -- use 'hrsh7th/nvim-compe'
    -- use 'kabouzeid/nvim-lspinstall'
    -- use 'neovim/nvim-lspconfig'
    -- use 'nvim-lua/lsp-status.nvim'
    -- use 'tjdevries/complextras.nvim'
    -- use 'tjdevries/lsp_extensions.nvim'
    use 'bfredl/nvim-luadev'
    use 'euclidianAce/BetterLua.vim' -- better lua syntax highlighting

    -- }}}

    -- Treesitter {{{

    use {
      'nvim-treesitter/nvim-treesitter',
      run = ':TSUpdate'
    }
    use 'nvim-treesitter/nvim-treesitter-refactor'
    use 'nvim-treesitter/nvim-treesitter-textobjects'
    use 'nvim-treesitter/playground'
    use 'p00f/nvim-ts-rainbow'
    use 'windwp/nvim-ts-autotag'
    use 'JoosepAlviste/nvim-ts-context-commentstring'

    -- }}}

    -- General {{{

    use 'Shougo/neco-vim'
    use 'chemzqm/vim-jsx-improve' -- better jsx

    -- }}}

    -- }}}

    -- FUZZY SEARCH {{{

    -- fzf.vim {{{

    use {
      'junegunn/fzf',
      run = './install --all'
    } -- FZF in vim
    use 'junegunn/fzf.vim' -- FZF in vim

    -- }}}

    -- telescope.nvim {{{

    use 'brandoncc/telescope-harpoon.nvim'
    use 'fhill2/telescope-ultisnips.nvim'
    use 'nvim-lua/plenary.nvim'
    use 'nvim-lua/popup.nvim'
    use 'nvim-telescope/telescope-cheat.nvim'
    use 'nvim-telescope/telescope-dap.nvim'
    use 'nvim-telescope/telescope-frecency.nvim'
    use 'nvim-telescope/telescope-fzf-writer.nvim'
    use 'nvim-telescope/telescope-fzy-native.nvim'
    use 'nvim-telescope/telescope-media-files.nvim'
    use 'nvim-telescope/telescope-project.nvim'
    use 'nvim-telescope/telescope-snippets.nvim'
    use 'nvim-telescope/telescope-symbols.nvim'
    use 'nvim-telescope/telescope.nvim'
    use 'tamago324/telescope-openbrowser.nvim'
    use 'tkmpypy/telescope-jumps.nvim'

    -- }}}

    -- }}}

    -- LANGUAGES {{{

    -- HTML {{{

    use 'mattn/emmet-vim' -- emmets in vim
    use 'alvan/vim-closetag' -- Auto Close Tag in HTML
    use 'AndrewRadev/tagalong.vim' -- html tags completion
    use 'wakatime/vim-wakatime' -- wakatime for vim

    -- }}}

    -- markdown {{{

    use 'npxbr/glow.nvim' -- markdown preview

    -- }}}

    -- tags {{{

    use 'liuchengxu/vista.vim' -- Viewer & Finder for LSP symbols and tags

    -- }}}

    -- General {{{

    use 'RishabhRD/popfix'
    use 'RishabhRD/nvim-cheat.sh'
    use 'windwp/nvim-autopairs' -- auto-pairs in lua
    use 'AndrewRadev/sideways.vim'

    -- }}}

    -- }}}

    -- VERSION CONTROL STYSTEM {{{

    -- use 'ackyshake/vim-fist'
    -- use 'mattn/webapi-vim'
    -- use 'mattn/vim-gist'
    use 'f-person/git-blame.nvim' -- git blame in vim
    use 'rhysd/git-messenger.vim' -- git lens in vim
    use 'TimUntersberger/neogit' -- magit for neovim in lua
    use 'lewis6991/gitsigns.nvim' -- gitsigns in lua
    use 'tpope/vim-fugitive' -- version control
    use 'kdheepak/lazygit.nvim' -- lazygit from neovim

    -- }}}

    -- STATUS AND TAB LINES {{{

    -- use { 'glepnir/galaxyline.nvim', branch = 'main' }
    use 'hoob3rt/lualine.nvim'
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
    use 'tjdevries/colorbuddy.nvim' -- colorbuddy for Colorschemes
    use 'tjdevries/gruvbuddy.nvim' -- gruvbuddy using colorbuddy
    use 'tjdevries/standard.vim'
    use 'tjdevries/conf.vim'
    use 'tjdevries/fold_search.vim'

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
  config = {
    display = {
      open_cmd = 'topleft 65vnew [packer]'
    }
  }
}
