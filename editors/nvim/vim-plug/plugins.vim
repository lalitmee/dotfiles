" auto-install vim-plug
if empty(glob('~/.config/nvim/autoload/plug.vim'))
  silent !curl -fLo ~/.config/nvim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall
  autocmd VimEnter * PlugInstall | source $MYVIMRC
endif

call plug#begin('~/.config/nvim/autoload/plugged')

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

" toggle, display and navigate marks
Plug 'kshenoy/vim-signature'

" Better search highlighting
Plug 'haya14busa/incsearch.vim'

" lightline for vim
" Plug 'delphinus/lightline-delphinus'
Plug 'itchyny/lightline.vim'
Plug 'josa42/vim-lightline-coc'
Plug 'josa42/nvim-lightline-lsp'

" vim icons
Plug 'ryanoasis/vim-devicons'

" for handling swap files
Plug 'gioele/vim-autoswap'

" File Management using ranger
Plug 'francoiscabrol/ranger.vim'

" Colors
Plug 'christianchiarulli/nvcode-color-schemes.vim'
Plug 'lifepillar/vim-gruvbox8'
Plug 'tjdevries/colorbuddy.nvim'
Plug 'tjdevries/gruvbuddy.nvim'

" Completion Conquerer
" Plug 'neoclide/coc.nvim', {'branch': 'release'}
" Plug 'antoinemadec/coc-fzf', {'branch': 'release'}
Plug 'chemzqm/vim-jsx-improve'

" Version Control in Vim
Plug 'stsewd/fzf-checkout.vim'
Plug 'tpope/vim-fugitive'
Plug 'junegunn/gv.vim'

" Tabularize for Vim
Plug 'godlygeek/tabular'

" Snippets in Vim
Plug 'SirVer/ultisnips'
Plug 'honza/vim-snippets'

" vsnip vscode snippets
Plug 'hrsh7th/vim-vsnip'
Plug 'hrsh7th/vim-vsnip-integ'

" Auto Close Tag in HTML
Plug 'alvan/vim-closetag'
Plug 'AndrewRadev/tagalong.vim'
Plug 'valloric/MatchTagAlways'

" " Indent Lines made beautiful
" Plug 'Yggdroot/indentLine'

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

" tpope plugins
" Plug 'tpope/vim-speeddating'
Plug 'tpope/vim-abolish'
" Plug 'tpope/vim-commentary'
Plug 'tpope/vim-eunuch'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-sleuth'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-unimpaired'

" Zen mode
Plug 'junegunn/goyo.vim'

" Better tabline
" Plug 'mg979/vim-xtabline'
Plug 'romgrk/barbar.nvim'

" " undo time travel
" Plug 'mbbill/undotree'

" Better Whitespace
Plug 'ntpeters/vim-better-whitespace'

" Swap windows
Plug 'wesQ3/vim-windowswap'

" " Goneovim Fuzzy search
" Plug 'akiyosi/gonvim-fuzzy'

" Viewer & Finder for LSP symbols and tags
Plug 'liuchengxu/vista.vim'

" bookmarks
Plug 'MattesGroeger/vim-bookmarks'

" " vim-be-good
" Plug 'ThePrimeagen/vim-be-good'

" wakatime for vim
Plug 'wakatime/vim-wakatime'

" Maximizer for vim
Plug 'szw/vim-maximizer'
" Plug 'puremourning/vimspector'

" " lisp in vim
" Plug 'vlime/vlime'

" cheat.sh in vim
Plug 'dbeniamine/cheat.sh-vim'

" " vim and tmux = vimux
" " Testing in vim with tmux
" Plug 'benmills/vimux'

" open browser from vim
Plug 'tyru/open-browser.vim'
Plug 'tyru/open-browser-github.vim'
Plug 'dhruvasagar/vim-open-url'

" sorting in vim
Plug 'christoomey/vim-sort-motion'

" vim-exchange for exchanging words
Plug 'tommcdo/vim-exchange'

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
Plug 'nvim-telescope/telescope-dap.nvim'
Plug 'nvim-telescope/telescope-frecency.nvim'
Plug 'nvim-telescope/telescope-fzf-writer.nvim'
Plug 'nvim-telescope/telescope-fzy-native.nvim'
Plug 'nvim-telescope/telescope-media-files.nvim'
Plug 'nvim-telescope/telescope-node-modules.nvim'
Plug 'nvim-telescope/telescope-project.nvim'
Plug 'nvim-telescope/telescope-snippets.nvim'
Plug 'nvim-telescope/telescope-symbols.nvim'
Plug 'fhill2/telescope-ultisnips.nvim'
Plug 'tamago324/telescope-openbrowser.nvim'
Plug 'the-codingguy/telescope-checkout'
Plug 'tkmpypy/telescope-jumps.nvim'

" " note taking using lua
" Plug 'oberblastmeister/neuron.nvim'

" " LSP
Plug 'anott03/nvim-lspinstall'
Plug 'euclidianAce/BetterLua.vim'
Plug 'glepnir/lspsaga.nvim'
Plug 'hrsh7th/nvim-compe'
Plug 'neovim/nvim-lspconfig'
Plug 'nvim-lua/completion-nvim'
Plug 'nvim-lua/lsp-status.nvim'
Plug 'ojroques/nvim-lspfuzzy'
Plug 'onsails/lspkind-nvim'
Plug 'tjdevries/complextras.nvim'
Plug 'tjdevries/lsp_extensions.nvim'
Plug 'tjdevries/manillua.nvim'
Plug 'tjdevries/nlua.nvim'

" Treesitter
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
Plug 'nvim-treesitter/playground'
Plug 'p00f/nvim-ts-rainbow'
Plug 'nvim-treesitter/nvim-treesitter-textobjects'
Plug 'nvim-treesitter/nvim-treesitter-refactor'

" formatter in lua
Plug 'mhartington/formatter.nvim'

" file explorer
Plug 'kyazdani42/nvim-web-devicons' " for file icons
Plug 'kyazdani42/nvim-tree.lua'

" Colorizer for showing the colors
Plug 'norcalli/nvim-colorizer.lua'

" markdown preview
Plug 'npxbr/glow.nvim'

" better quick-fix winodw
Plug 'kevinhwang91/nvim-bqf'

" debugger attach protocol
Plug 'mfussenegger/nvim-dap'

" auto-pairs in lua
Plug 'windwp/nvim-autopairs'

" actions menu
Plug 'kizza/actionmenu.nvim'

" easymotion using lua
Plug 'phaazon/hop.nvim'

" gitsigns in lua
Plug 'lewis6991/gitsigns.nvim'

" lightbulb like vscode
Plug 'kosayoda/nvim-lightbulb'

" neovim terminal managment in lua
Plug 'akinsho/nvim-toggleterm.lua'

" registers in lua
Plug 'gennaro-tedesco/nvim-peekup'

" indent guides using lua
Plug 'glepnir/indent-guides.nvim'

" magit for neovim in lua
Plug 'TimUntersberger/neogit'

" file manager in lua
Plug 'TimUntersberger/neofs'

" motion training
Plug 'tjdevries/train.nvim'

" hlslens lens for neovim
Plug 'kevinhwang91/nvim-hlslens'
Plug 'haya14busa/vim-asterisk'

" minimap like vscode
Plug 'wfxr/minimap.vim', {'do': ':!cargo install --locked code-minimap'}

" " git blame like gitlens in vscode
" Plug 'f-person/git-blame.nvim'

" commenting in lua
Plug 'b3nj5m1n/kommentary'

" " auto session save
" Plug 'rmagatti/auto-session'

" " buffer line
" Plug 'akinsho/nvim-bufferline.lua'


" status lines
" Plug 'tjdevries/express_line.nvim'
" Plug 'hoob3rt/lualine.nvim'
" Plug 'glepnir/galaxyline.nvim' , {'branch': 'main'}

call plug#end()
