" NOTE: vim-plug and plugins

" auto-install vim-plug {{{

if empty(glob('~/.config/nvim/autoload/plug.vim'))
  silent !curl -fLo ~/.config/nvim/autoload/plug.vim --create-dirs
        \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall
  autocmd VimEnter * PlugInstall | source $MYVIMRC
endif

" }}}

" Plugins {{{

call plug#begin('~/.config/nvim/autoload/plugged')

" LEARN VIM {{{

" Plug 'ThePrimeagen/vim-be-good', {
"       \ 'on': 'VimBeGood'
"       \ }                                         " vim-be-good
" Plug 'tjdevries/train.nvim', {
"       \ 'on': [
"       \ 'TrainClear',
"       \ 'TrainUpDown',
"       \ 'TrainTextObj',
"       \ 'TrainWord'
"       \ ]
"       \ }                                         " motion training

" LEARN VIM }}}

" UI AND BEAUTIFY {{{

" colorschemes {{{

Plug 'tjdevries/colorbuddy.nvim'                    " colorbuddy for Colorschemes
Plug 'tjdevries/gruvbuddy.nvim'                     " gruvbuddy using colorbuddy
" Plug 'DilanGMB/nightbuddy'                          " nightbuddy theme using colorbuddy
Plug 'marko-cerovac/material.nvim'                  " material theme using colorbuddy
Plug 'rktjmp/lush.nvim'
Plug 'npxbr/gruvbox.nvim'

"}}}

" icons {{{

Plug 'kyazdani42/nvim-web-devicons'                 " for icons in vim
Plug 'yamatsum/nvim-nonicons'                       " beautiful icons

"}}}

" General {{{

Plug 'junegunn/goyo.vim'
Plug 'kshenoy/vim-signature'                        " toggle, display and navigate marks
Plug 'liuchengxu/vim-which-key',                    " See what keys do like in emacs
Plug 'mhinz/vim-startify'                           " fancy start Screen for vim
Plug 'norcalli/nvim-colorizer.lua'                  " Colorizer for showing the colors

"}}}

" UI AND BEAUTIFY }}}

" ACTIONS {{{

" Search, Replace and Jump {{{

Plug 'thinca/vim-visualstar'
Plug 'junegunn/vim-fnr'
Plug 'junegunn/vim-pseudocl'
Plug 'kevinhwang91/nvim-bqf'                        " better quick-fix winodw
Plug 'kevinhwang91/nvim-hlslens'                    " hlslens lens for neovim
Plug 'pechorin/any-jump.vim'                        " any-jump
Plug 'phaazon/hop.nvim'                             " easymotion using lua

" Search, Replace and Jump }}}

" Movements {{{

Plug 'unblevable/quick-scope'                       " Quickscope same as f, F, t, T but better
Plug 'justinmk/vim-sneak'

" Movements }}}

" Navigations {{{

Plug 'ThePrimeagen/harpoon'

" Navigations }}}

" General {{{

Plug 'mhinz/vim-sayonara'                           " delete buffers and windows
Plug 'andymass/vim-matchup'                         " match brackets and more
Plug 'AndrewRadev/splitjoin.vim'                    " Switch between single-line and multiline forms of code
Plug 'antoinemadec/FixCursorHold.nvim'              " fix cursor hold
Plug 'christoomey/vim-sort-motion'                  " sorting in vim
Plug 'christoomey/vim-tmux-navigator'               " Moving in vim inside Tmux
Plug 'christoomey/vim-tmux-runner'                  " tmux runner for tests
Plug 'haya14busa/is.vim'                            " successor of incsearch
Plug 'haya14busa/incsearch.vim'                     " Better search highlighting
Plug 'haya14busa/incsearch-fuzzy.vim'               " fuzzy incsearch
Plug 'ntpeters/vim-better-whitespace'               " Better Whitespace
Plug 'scr1pt0r/crease.vim'                          " nice fold text
Plug 'Konfekt/FastFold'                             " fast folds in vim
Plug 'szw/vim-maximizer'                            " Maximizer for vim
Plug 'tommcdo/vim-exchange'                         " vim-exchange for exchanging words
Plug 'wellle/targets.vim'                           " targets.vim for extra motions
Plug 'wesQ3/vim-windowswap'                         " Swap windows

" General }}}

" Profiling {{{

Plug 'dstein64/vim-startuptime'

" Profiling }}}

" ACTIONS }}}

" TEXT {{{

" Notes {{{

" Plug 'oberblastmeister/neuron.nvim'               " note taking using lua
" Plug 'michal-h21/vim-zettel'                      " zettel tasks
" Plug 'vimwiki/vimwiki'                            " vim wiki

" Notes }}}

" Snippets {{{

Plug 'SirVer/ultisnips'                             " snippets engine
Plug 'honza/vim-snippets'                           " Snippets in Vim
Plug 'hrsh7th/vim-vsnip'                            " vsnip vscode snippets
Plug 'hrsh7th/vim-vsnip-integ'
Plug 'norcalli/snippets.nvim'                       " snippets in lua

" Snippets }}}

" Format {{{

Plug 'lukas-reineke/format.nvim'
" Plug 'mhartington/formatter.nvim'                   " formatter in lua
" Plug 'Yggdroot/indentLine',                         " Indent Lines made beautiful
Plug 'lukas-reineke/indent-blankline.nvim', {
      \ 'branch': 'lua'
      \ }
Plug 'godlygeek/tabular'                            " Tabularize for Vim

" Format }}}

" Undo {{{

" Plug 'simnalamburt/vim-mundo', {
"       \ 'on': 'MundoToggle'
"       \ }                                         " undo tree visualizer

" Undo }}}

" Highlight Yank {{{

Plug 'machakann/vim-highlightedyank'

" Highlight Yank }}}

" General {{{

Plug 'vim-scripts/restore_view.vim'

" General }}}

" TEXT }}}

" LSP {{{

" coc.nvim {{{

Plug 'neoclide/coc-neco'                            " vim completion for coc
Plug 'neoclide/coc.nvim', {
        \ 'branch': 'release'
      \ }                                           " Completion Conquerer

" coc.nvim }}}

" neovim-lsp {{{

Plug 'bfredl/nvim-luadev'
" Plug 'glacambre/nvim-lsp'
" Plug 'alexaandru/nvim-lspupdate'
" Plug 'anott03/nvim-lspinstall'
Plug 'euclidianAce/BetterLua.vim', {
      \ 'for': 'lua'
      \ }                                           " better lua syntax highlighting
" Plug 'glepnir/lspsaga.nvim'
" Plug 'hrsh7th/nvim-compe'
" Plug 'kosayoda/nvim-lightbulb'                    " lightbulb like vscode
" Plug 'neovim/nvim-lspconfig'
" Plug 'nvim-lua/lsp-status.nvim'
" Plug 'onsails/lspkind-nvim'
" Plug 'tjdevries/complextras.nvim'
" Plug 'tjdevries/lsp_extensions.nvim'
Plug 'tjdevries/nlua.nvim'

" neovim-lsp }}}

" Treesitter {{{

Plug 'nvim-treesitter/nvim-treesitter', {
      \ 'do': ':TSUpdate'
      \ }
Plug 'nvim-treesitter/nvim-treesitter-refactor'
Plug 'nvim-treesitter/nvim-treesitter-textobjects'
Plug 'nvim-treesitter/playground'
Plug 'p00f/nvim-ts-rainbow'
Plug 'windwp/nvim-ts-autotag'

" Treesitter }}}

" General {{{

Plug 'Shougo/neco-vim'
Plug 'chemzqm/vim-jsx-improve'                      " better jsx

" General }}}

" LSP }}}

" FUZZY SEARCH {{{

" fzf.vim {{{

Plug 'junegunn/fzf', {
      \ 'dir': '~/.fzf',
      \ 'do': './install --all'
      \ }                                           " FZF in vim
Plug 'junegunn/fzf.vim'                             " FZF in vim
Plug 'benwainwright/fzf-project'                    " switch projects using fzf

" fzf.vim }}}

" telescope.nvim {{{

" Plug 'nvim-telescope/telescope-dap.nvim'
Plug 'fhill2/telescope-ultisnips.nvim'
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-lua/popup.nvim'
Plug 'nvim-telescope/telescope-cheat.nvim'
Plug 'nvim-telescope/telescope-frecency.nvim'
Plug 'nvim-telescope/telescope-fzf-writer.nvim'
Plug 'nvim-telescope/telescope-fzy-native.nvim'
Plug 'nvim-telescope/telescope-project.nvim'
Plug 'nvim-telescope/telescope-snippets.nvim'
Plug 'nvim-telescope/telescope-symbols.nvim'
Plug 'nvim-telescope/telescope.nvim'
Plug 'tamago324/telescope-openbrowser.nvim'
Plug 'tkmpypy/telescope-jumps.nvim'
Plug 'brandoncc/telescope-harpoon.nvim'

" telescope.nvim }}}

" FUZZY SEARCH }}}

" LANGUAGES {{{

" HTML {{{

Plug 'mattn/emmet-vim'                              " emmets in vim
Plug 'alvan/vim-closetag',                          " Auto Close Tag in HTML
Plug 'AndrewRadev/tagalong.vim',                    " html tags completion
Plug 'wakatime/vim-wakatime'                        " wakatime for vim

" HTML }}}

" markdown {{{

Plug 'npxbr/glow.nvim', {
      \ 'on': 'Glow'
      \ }                                           " markdown preview

" markdown }}}

" tags {{{

" Plug 'liuchengxu/vista.vim'                       " Viewer & Finder for LSP symbols and tags

" tags }}}

" General {{{

Plug 'RishabhRD/popfix'
Plug 'RishabhRD/nvim-cheat.sh'
Plug 'windwp/nvim-autopairs'                        " auto-pairs in lua

" General }}}

" LANGUAGES }}}

" VERSION CONTROL STYSTEM {{{

" Plug 'ackyshake/vim-fist'
" Plug 'mattn/webapi-vim'
" Plug 'mattn/vim-gist'
Plug 'f-person/git-blame.nvim'                      " git blame in vim
Plug 'rhysd/git-messenger.vim'                      " git lens in vim
Plug 'TimUntersberger/neogit'                       " magit for neovim in lua
Plug 'lewis6991/gitsigns.nvim'                      " gitsigns in lua
Plug 'tpope/vim-fugitive'                           " version control
Plug 'kdheepak/lazygit.nvim', {
      \ 'on': [
      \ 'LazyGit'
      \ ]
      \ }                                           " lazygit from neovim

" VERSION CONTROL STYSTEM }}}

" STATUS AND TAB LINES {{{

" Plug 'glepnir/galaxyline.nvim' , {
"       \ 'branch': 'main'
"       \ }
Plug 'hoob3rt/lualine.nvim'
Plug 'akinsho/nvim-bufferline.lua'
" Plug 'tjdevries/express_line.nvim'

" STATUS AND TAB LINES }}}

" VIM NINJAS {{{

" tpope {{{

Plug 'tpope/vim-abolish'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-dispatch'
Plug 'tpope/vim-dotenv'
Plug 'tpope/vim-eunuch'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-sleuth'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-unimpaired'

" tpope }}}

" junegunn {{{

" Plug 'junegunn/goyo.vim', {
"       \ 'on': 'Goyo'
"       \ }                                         " Zen mode

" junegunn }}}

" VIM NINJAS }}}

" FILES {{{

" Explorer {{{

Plug 'justinmk/vim-dirvish'
Plug 'kyazdani42/nvim-tree.lua', {
      \ 'on': 'NvimTreeToggle'
      \ }                                           " file explorer

" Explorer }}}

" General {{{

Plug 'gioele/vim-autoswap'                          " for handling swap files

" General }}}

" FILES }}}

" TERMINAL {{{

Plug 'voldikss/vim-floaterm', {
      \ 'on': [
      \ 'FloatermNew',
      \ 'FloatermToggle'
      \ ]
      \ }                                           " Float Terminal

" TERMINAL }}}

" GNVIM {{{

if exists('g:goneovim')
  Plug 'akiyosi/gonvim-fuzzy'                       " Goneovim Fuzzy search
endif

" GNVIM }}}

" BROWSER {{{

Plug 'tami5/sql.nvim'                               " sql nvim database for frecency
Plug 'tyru/open-browser-github.vim'
Plug 'tyru/open-browser.vim'

" BROWSER }}}

" TESTING {{{

" Plug 'benmills/vimux'                             " Testing in vim with tmux
" Plug 'mfussenegger/nvim-dap'                      " debugger attach protocol
" Plug 'puremourning/vimspector'                    " debugger in vim
" Plug 'skywind3000/asyncrun.vim'
" Plug 'skywind3000/asynctasks.vim'

" TESTING }}}

call plug#end()

" Plugins }}}
