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

" Better HTML Editing
Plug 'Raimondi/delimitMate'

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

" Completion Conquerer
Plug 'neoclide/coc.nvim', {'branch': 'release'}

" Pairs of handy bracket mappings
Plug 'tpope/vim-unimpaired'

" easily search for, substitute, and abbreviate multiple variants of a word
Plug 'tpope/vim-abolish'

" Surround Plugin for brackets and more
Plug 'tpope/vim-surround'

" Version Control in Vim
Plug 'stsewd/fzf-checkout.vim'
Plug 'mhinz/vim-signify'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-rhubarb'
Plug 'junegunn/gv.vim'
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
" Plug 'SirVer/ultisnips'
Plug 'honza/vim-snippets'

" Auto Close Tag in HTML
Plug 'vim-scripts/closetag.vim'
Plug 'alvan/vim-closetag'

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
Plug 'airblade/vim-rooter'

" Cyclist by Tjdevries
" For setting listchars dynamically by calling function of plugin
Plug 'tjdevries/cyclist.vim'

" Ranger
Plug 'kevinhwang91/rnvimr', {'do': 'make sync'}

call plug#end()
