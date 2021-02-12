" auto-install vim-plug
if empty(glob('~/.config/nvim/autoload/plug.vim'))
  silent !curl -fLo ~/.config/nvim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall
  autocmd VimEnter * PlugInstall | source $MYVIMRC
endif

call plug#begin('~/.config/nvim/autoload/plugged')

" " neomake
" Plug 'neomake/neomake'

" " neovim in browser
" Plug 'glacambre/firenvim', { 'do': { _ -> firenvim#install(69) } }

" " dim focus on not active windows
" Plug 'blueyed/vim-diminactive'

" Switch between single-line and multiline forms of code
Plug 'AndrewRadev/splitjoin.vim'

" reopen files at the last edit place
Plug 'farmergreg/vim-lastplace'

" " targets.vim for extra motions
" Plug 'wellle/targets.vim'

" ack search
Plug 'mileszs/ack.vim'

" flygrep
Plug 'wsdjeg/FlyGrep.vim'

" Rainbow Parentheses
Plug 'junegunn/rainbow_parentheses.vim'

" cycle through your yank history
Plug 'maxbrunsfeld/vim-yankstack'

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

" " lightline for vim
" Plug 'itchyny/lightline.vim'

" Airline for vim
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'

" vim icons
Plug 'ryanoasis/vim-devicons'

" for handling swap files
Plug 'gioele/vim-autoswap'

" for renaming the current buffer
Plug 'danro/rename.vim'

" for jumping
Plug 'easymotion/vim-easymotion'

" File Management using ranger
Plug 'francoiscabrol/ranger.vim'
Plug 'rbgrouleff/bclose.vim'

" Colors
Plug 'chriskempson/base16-vim'
Plug 'christianchiarulli/nvcode-color-schemes.vim'
Plug 'gruvbox-community/gruvbox'
Plug 'joshdick/onedark.vim'
Plug 'lifepillar/vim-gruvbox8'
Plug 'tjdevries/colorbuddy.nvim'
Plug 'tjdevries/gruvbuddy.nvim'

" Completion Conquerer
Plug 'neoclide/coc.nvim', {'branch': 'release'}

" javascript syntax
Plug 'othree/javascript-libraries-syntax.vim'

" Pairs of handy bracket mappings
Plug 'tpope/vim-unimpaired'

" easily search for, substitute, and abbreviate multiple variants of a word
Plug 'tpope/vim-abolish'

" Surround Plugin for brackets and more
Plug 'tpope/vim-surround'

" Version Control in Vim
Plug 'airblade/vim-gitgutter'
if has('nvim') || has('patch-8.0.902')
  Plug 'mhinz/vim-signify'
else
  Plug 'mhinz/vim-signify', { 'branch': 'legacy' }
endif
Plug 'stsewd/fzf-checkout.vim'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-rhubarb'
Plug 'junegunn/gv.vim'
" git messenger same as gitlens in vscode
Plug 'rhysd/git-messenger.vim'
" Magit like emacs for git workflow
Plug 'jreybert/vimagit'

" Vim sugar for the UNIX shell commands that need it the most
" Example: :Delete, :Unlink, :Move, etc
Plug 'tpope/vim-eunuch'

" comment stuff out
Plug 'tpope/vim-commentary'

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

" Easy Alignment in vim
Plug 'junegunn/vim-easy-align'

" Indent Lines made beautiful
Plug 'Yggdroot/indentLine'

" syntax highlighter for vim
Plug 'sheerun/vim-polyglot'

" The interactive scratchpad for hackers.
Plug 'metakirby5/codi.vim'

Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'
Plug 'yuki-yano/fzf-preview.vim', { 'branch': 'release/remote', 'do': ':UpdateRemotePlugins' }
Plug 'airblade/vim-rooter'

" Cyclist by Tjdevries
" For setting listchars dynamically by calling function of plugin
Plug 'tjdevries/cyclist.vim'

" Ranger
Plug 'kevinhwang91/rnvimr', {'do': 'make sync'}

" Emmets in Vim
Plug 'mattn/emmet-vim'

" See what keys do like in emacs
Plug 'liuchengxu/vim-which-key'

" Float Terminal
Plug 'voldikss/vim-floaterm'

" Find and Replace
" Plug 'brooth/far.vim'
Plug 'ChristianChiarulli/far.vim'

" Change dates fast
Plug 'tpope/vim-speeddating'

" Convert binary, hex, etc..
Plug 'glts/vim-radical'

" Repeat stuff
Plug 'tpope/vim-repeat'

" Useful for React Commenting
Plug 'suy/vim-context-commentstring'

" auto set indent settings
Plug 'tpope/vim-sleuth'

" Auto pairs for '(' '[' '{'
Plug 'jiangmiao/auto-pairs'

" Zen mode
Plug 'junegunn/goyo.vim'

" Better tabline
Plug 'mg979/vim-xtabline'
" Plug 'romgrk/barbar.nvim'

" undo time travel
Plug 'mbbill/undotree'

" Smooth scroll
Plug 'psliwka/vim-smoothie'

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

" vim and tmux = vimux
Plug 'benmills/vimux'

" vim-workspaces
Plug 'thaerkh/vim-workspace'

" vim-be-good
Plug 'ThePrimeagen/vim-be-good'

" wakatime for vim
Plug 'wakatime/vim-wakatime'

" easytags
Plug 'xolox/vim-easytags'
Plug 'xolox/vim-misc'

" Maximizer for vim
Plug 'szw/vim-maximizer'
Plug 'puremourning/vimspector'

" Useful for React Commenting
Plug 'suy/vim-context-commentstring'

" lisp in vim
Plug 'vlime/vlime'

" cheat.sh in vim
" Plug 'dbeniamine/cheat.sh-vim'

" " switch between single and multilines
" Plug 'AndrewRadev/splitjoin.vim'

""""""""""""""""""""""""""""""""""""""
"            Lua Plugins             "
""""""""""""""""""""""""""""""""""""""

" telescope fuzzy finder
Plug 'nvim-lua/popup.nvim'
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-telescope/telescope.nvim'
Plug 'nvim-telescope/telescope-github.nvim'
Plug 'nvim-telescope/telescope-symbols.nvim'

" " LSP
" Plug 'neovim/nvim-lspconfig'
" Plug 'nvim-lua/completion-nvim'

" Treesitter
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}  " We recommend updating the parsers on update
Plug 'nvim-treesitter/playground'

" formatter in lua
Plug 'mhartington/formatter.nvim'

" file explorer
Plug 'kyazdani42/nvim-web-devicons' " for file icons
Plug 'kyazdani42/nvim-tree.lua'

" Colorizer for showing the colors
Plug 'norcalli/nvim-colorizer.lua'

" " express_line from tj
" Plug 'tjdevries/express_line.nvim'

" " galaxyline for neovim
" Plug 'glepnir/galaxyline.nvim' , {'branch': 'main'}

call plug#end()
