" auto-install vim-plug
if empty(glob('~/.config/nvim/autoload/plug.vim'))
  silent !curl -fLo ~/.config/nvim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall
  autocmd VimEnter * PlugInstall | source $MYVIMRC
endif

call plug#begin('~/.config/nvim/autoload/plugged')

" Colorizer for showing the colors
Plug 'norcalli/nvim-colorizer.lua'

" Rainbow Parentheses
Plug 'junegunn/rainbow_parentheses.vim'

" Quickscope same as f, F, t, T but better
Plug 'unblevable/quick-scope'

" fancy start Screen for vim
Plug 'mhinz/vim-startify'

" Moving in vim inside Tmux
Plug 'christoomey/vim-tmux-navigator'

" Instant markdown preview from vim
Plug 'suan/vim-instant-markdown'

" toggle, display and navigate marks
Plug 'kshenoy/vim-signature'

" Better search highlighting
Plug 'haya14busa/incsearch.vim'

" SilverSearcher
Plug 'mileszs/ack.vim'

" lightweight statusline for vim
Plug 'itchyny/lightline.vim'

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
Plug 'joshdick/onedark.vim'
Plug 'gruvbox-community/gruvbox'
Plug 'tjdevries/colorbuddy.vim'
Plug 'tjdevries/gruvbuddy.nvim'
Plug 'arcticicestudio/nord-vim'
Plug 'rakr/vim-one'
Plug 'mhartington/oceanic-next'
Plug 'hzchirs/vim-material'
Plug 'patstockwell/vim-monokai-tasty'
Plug 'nanotech/jellybeans.vim'
Plug 'tomasiser/vim-code-dark'
Plug 'drewtempelmeyer/palenight.vim'


" Completion Conquerer
Plug 'neoclide/coc.nvim', {'branch': 'release'}

" Pairs of handy bracket mappings
Plug 'tpope/vim-unimpaired'

" easily search for, substitute, and abbreviate multiple variants of a word
Plug 'tpope/vim-abolish'

" Surround Plugin for brackets and more
Plug 'tpope/vim-surround'

" Version Control in Vim
Plug 'airblade/vim-gitgutter'
Plug 'stsewd/fzf-checkout.vim'
" Plug 'mhinz/vim-signify'
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

" Easy Alignment in vim
Plug 'junegunn/vim-easy-align'

" Indent Lines made beautiful
Plug 'Yggdroot/indentLine'

"
Plug 'sheerun/vim-polyglot'

" The interactive scratchpad for hackers.
Plug 'metakirby5/codi.vim'

Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'
Plug 'yuki-ycino/fzf-preview.vim', { 'branch': 'release', 'do': ':UpdateRemotePlugins' }
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

" for supporting syntax highlighting for color schemes monkai
Plug 'HerringtonDarkholme/yats.vim'
Plug 'pangloss/vim-javascript'
Plug 'MaxMEllon/vim-jsx-pretty'
Plug 'styled-components/vim-styled-components'
Plug 'elzr/vim-json'
Plug 'jparise/vim-graphql'

" Viewer & Finder for LSP symbols and tags
Plug 'liuchengxu/vista.vim'

" bookmarks
Plug 'MattesGroeger/vim-bookmarks'

" vim and tmux = vimux
Plug 'benmills/vimux'

" Random color scheme on startup
Plug 'Sammyalhashe/random_colorscheme.vim'

" telescope fuzzy finder
Plug 'nvim-lua/popup.nvim'
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-lua/telescope.nvim'

call plug#end()
