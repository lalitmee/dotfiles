" auto-install vim-plug
if empty(glob('~/.config/nvim/autoload/plug.vim'))
  silent !curl -fLo ~/.config/nvim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall
  autocmd VimEnter * PlugInstall | source $MYVIMRC
endif

call plug#begin('~/.config/nvim/autoload/plugged')

" " neovim in browser
" Plug 'glacambre/firenvim', { 'do': { _ -> firenvim#install(69) } }

" Switch between single-line and multiline forms of code
Plug 'AndrewRadev/splitjoin.vim'

" targets.vim for extra motions
Plug 'wellle/targets.vim'

" Quickscope same as f, F, t, T but better
Plug 'unblevable/quick-scope'

" fancy start Screen for vim
Plug 'mhinz/vim-startify'

" Moving in vim inside Tmux
Plug 'christoomey/vim-tmux-navigator'
Plug 'christoomey/vim-tmux-runner'

" Instant markdown preview from vim
Plug 'suan/vim-instant-markdown'

" toggle, display and navigate marks
Plug 'kshenoy/vim-signature'

" Better search highlighting
Plug 'haya14busa/incsearch.vim'

" lightline for vim
" Plug 'delphinus/lightline-delphinus'
Plug 'itchyny/lightline.vim'
" Plug 'josa42/vim-lightline-coc'
Plug 'josa42/nvim-lightline-lsp'

" vim icons
Plug 'ryanoasis/vim-devicons'

" for handling swap files
Plug 'gioele/vim-autoswap'

" " for jumping
" Plug 'easymotion/vim-easymotion'

" File Management using ranger
Plug 'francoiscabrol/ranger.vim'

" Colors
Plug 'christianchiarulli/nvcode-color-schemes.vim'
Plug 'gruvbox-community/gruvbox'
Plug 'joshdick/onedark.vim'
Plug 'lifepillar/vim-gruvbox8'
Plug 'tjdevries/colorbuddy.nvim'
Plug 'tjdevries/gruvbuddy.nvim'
Plug 'Th3Whit3Wolf/onebuddy'
Plug 'Th3Whit3Wolf/spacebuddy'
Plug 'sainnhe/gruvbox-material'

" Completion Conquerer
" Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'antoinemadec/coc-fzf', {'branch': 'release'}
Plug 'chemzqm/vim-jsx-improve'

" Version Control in Vim
Plug 'stsewd/fzf-checkout.vim'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-rhubarb'
Plug 'junegunn/gv.vim'
Plug 'rhysd/git-messenger.vim'
Plug 'jreybert/vimagit'

" Tabularize for Vim
" Vim script for text filtering and alignment
Plug 'godlygeek/tabular'

" Snippets in Vim
Plug 'SirVer/ultisnips'
Plug 'honza/vim-snippets'

" Auto Close Tag in HTML
Plug 'alvan/vim-closetag'
Plug 'AndrewRadev/tagalong.vim'
Plug 'valloric/MatchTagAlways'

" Indent Lines made beautiful
Plug 'Yggdroot/indentLine'

Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'
Plug 'yuki-yano/fzf-preview.vim', { 'branch': 'release/remote', 'do': ':UpdateRemotePlugins' }
Plug 'airblade/vim-rooter'

" Ranger
Plug 'kevinhwang91/rnvimr', {'do': 'make sync'}

" Emmets in Vim
Plug 'mattn/emmet-vim'

" See what keys do like in emacs
Plug 'liuchengxu/vim-which-key'

" Float Terminal
Plug 'voldikss/vim-floaterm'

" Vim sugar for the UNIX shell commands that need it the most
" Example: :Delete, :Unlink, :Move, etc
Plug 'tpope/vim-eunuch'

" comment stuff out
Plug 'tpope/vim-commentary'

" Change dates fast
Plug 'tpope/vim-speeddating'

" Repeat stuff
Plug 'tpope/vim-repeat'

" auto set indent settings
Plug 'tpope/vim-sleuth'

" Pairs of handy bracket mappings
Plug 'tpope/vim-unimpaired'

" easily search for, substitute, and abbreviate multiple variants of a word
Plug 'tpope/vim-abolish'

" Surround Plugin for brackets and more
Plug 'tpope/vim-surround'

" " Auto pairs for '(' '[' '{'
" Plug 'jiangmiao/auto-pairs'

" Zen mode
Plug 'junegunn/goyo.vim'

" Better tabline
Plug 'mg979/vim-xtabline'
" Plug 'romgrk/barbar.nvim'

" undo time travel
Plug 'mbbill/undotree'

" Better Whitespace
Plug 'ntpeters/vim-better-whitespace'

" For deleting buffers without disturbing the layout
Plug 'moll/vim-bbye'

" live server
Plug 'turbio/bracey.vim'

" Swap windows
Plug 'wesQ3/vim-windowswap'

" Markdown Preview
Plug 'iamcco/markdown-preview.nvim', { 'do': 'cd app & npm install'  }

" Goneovim Fuzzy search
Plug 'akiyosi/gonvim-fuzzy'

" Viewer & Finder for LSP symbols and tags
Plug 'liuchengxu/vista.vim'

" bookmarks
Plug 'MattesGroeger/vim-bookmarks'

" " vim and tmux = vimux
" Plug 'benmills/vimux'

" vim-be-good
Plug 'ThePrimeagen/vim-be-good'

" wakatime for vim
Plug 'wakatime/vim-wakatime'

" Maximizer for vim
Plug 'szw/vim-maximizer'
" Plug 'puremourning/vimspector'

" Useful for React Commenting
Plug 'suy/vim-context-commentstring'

" lisp in vim
Plug 'vlime/vlime'

" cheat.sh in vim
Plug 'dbeniamine/cheat.sh-vim'

" " tmuxline
" Plug 'edkolev/tmuxline.vim'

" open browser from vim
Plug 'tyru/open-browser.vim'
Plug 'tyru/open-browser-github.vim'

" sorting in vim
Plug 'christoomey/vim-sort-motion'

" context for filetypes
Plug 'Shougo/context_filetype.vim'

" vim-exchange for exchanging words
Plug 'tommcdo/vim-exchange'

" visual search using * from drew neil
Plug 'nelstrom/vim-visual-star-search'

" grep easily
Plug 'mhinz/vim-grepper'

" any-jump
Plug 'pechorin/any-jump.vim'

""""""""""""""""""""""""""""""""""""""
"            Lua Plugins             "
""""""""""""""""""""""""""""""""""""""

" sql nvim database for frecency
Plug 'tami5/sql.nvim'

" snippets in lua
Plug 'norcalli/snippets.nvim'


" telescope fuzzy finder
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-lua/popup.nvim'
Plug 'nvim-telescope/telescope.nvim'
Plug 'fhill2/telescope-ultisnips.nvim'
Plug 'nvim-telescope/telescope-dap.nvim'
Plug 'nvim-telescope/telescope-frecency.nvim'
Plug 'nvim-telescope/telescope-fzf-writer.nvim'
Plug 'nvim-telescope/telescope-fzy-native.nvim'
Plug 'nvim-telescope/telescope-github.nvim'
Plug 'nvim-telescope/telescope-media-files.nvim'
Plug 'nvim-telescope/telescope-node-modules.nvim'
Plug 'nvim-telescope/telescope-project.nvim'
Plug 'nvim-telescope/telescope-symbols.nvim'
Plug 'nvim-telescope/telescope-z.nvim'
Plug 'tamago324/telescope-openbrowser.nvim'
Plug 'the-codingguy/telescope-checkout'
Plug 'tkmpypy/telescope-jumps.nvim'
Plug 'nvim-telescope/telescope-snippets.nvim'

" " LSP
Plug 'euclidianAce/BetterLua.vim'
Plug 'glepnir/lspsaga.nvim'
Plug 'hrsh7th/nvim-compe'
Plug 'neovim/nvim-lspconfig'
Plug 'nvim-lua/completion-nvim'
Plug 'nvim-lua/lsp-status.nvim'
Plug 'onsails/lspkind-nvim'
Plug 'tjdevries/lsp_extensions.nvim'
Plug 'tjdevries/manillua.nvim'
Plug 'tjdevries/nlua.nvim'

" Treesitter
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}  " We recommend updating the parsers on update
Plug 'nvim-treesitter/playground'
Plug 'p00f/nvim-ts-rainbow'
Plug 'nvim-treesitter/nvim-treesitter-textobjects'
Plug 'nvim-treesitter/nvim-treesitter-refactor'

" formatter in lua
Plug 'mhartington/formatter.nvim'
Plug 'andrejlevkovitch/vim-lua-format'

" file explorer
Plug 'kyazdani42/nvim-web-devicons' " for file icons
Plug 'kyazdani42/nvim-tree.lua'

" Colorizer for showing the colors
Plug 'norcalli/nvim-colorizer.lua'

" " better quick-fix winodw
" Plug 'kevinhwang91/nvim-bqf'

" debugger attach protocol
Plug 'mfussenegger/nvim-dap'

" easymotion using lua
Plug 'phaazon/hop.nvim'

" auto-pairs in lua
Plug 'windwp/nvim-autopairs'

" gitsigns in lua
Plug 'lewis6991/gitsigns.nvim'

" actions menu
Plug 'kizza/actionmenu.nvim'

" " lightbulb like vscode
" Plug 'kosayoda/nvim-lightbulb'

" " colorshceme template
" Plug 'Iron-E/nvim-highlite'

" express_line from tj
Plug 'tjdevries/express_line.nvim'

" " lualine
" Plug 'hoob3rt/lualine.nvim'

" " galaxyline for neovim
" Plug 'glepnir/galaxyline.nvim' , {'branch': 'main'}

call plug#end()
