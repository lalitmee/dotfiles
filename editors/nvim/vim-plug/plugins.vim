" auto-install vim-plug
if empty(glob('~/.config/nvim/autoload/plug.vim'))
  silent !curl -fLo ~/.config/nvim/autoload/plug.vim --create-dirs
        \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall
  autocmd VimEnter * PlugInstall | source $MYVIMRC
endif

call plug#begin('~/.config/nvim/autoload/plugged')

" LEARN VIM {{{

Plug 'ThePrimeagen/vim-be-good', {
        \ 'on': 'VimBeGood'
      \ }                           " vim-be-good
Plug 'tjdevries/train.nvim'         " motion training

" LEARN VIM }}}

" UI AND BEAUTIFY {{{

" colorschemes {{{

Plug 'tjdevries/colorbuddy.nvim'  " colorbuddy for Colorschemes
Plug 'tjdevries/gruvbuddy.nvim'   " gruvbuddy using colorbuddy

"}}}

" icons {{{

Plug 'kyazdani42/nvim-web-devicons'  " for file icons
Plug 'ryanoasis/vim-devicons'        " vim icons

"}}}

" general {{{

Plug 'kshenoy/vim-signature'        " toggle, display and navigate marks
Plug 'liuchengxu/vim-which-key'     " See what keys do like in emacs
Plug 'mhinz/vim-startify'           " fancy start Screen for vim
Plug 'norcalli/nvim-colorizer.lua'  " Colorizer for showing the colors

"}}}

" UI AND BEAUTIFY }}}

" ACTIONS {{{

" Search, Replace and Jump {{{

Plug 'gennaro-tedesco/nvim-peekup'  " registers in lua
Plug 'junegunn/vim-fnr'
Plug 'junegunn/vim-pseudocl'
Plug 'kevinhwang91/nvim-bqf'        " better quick-fix winodw
Plug 'kevinhwang91/nvim-hlslens'    " hlslens lens for neovim
Plug 'pechorin/any-jump.vim'        " any-jump
Plug 'phaazon/hop.nvim'             " easymotion using lua

" Search, Replace and Jump }}}

" Movements {{{

Plug 'rhysd/accelerated-jk'       " accelerated movements for j and k
Plug 'terryma/vim-smooth-scroll'  " smooth-scroll
Plug 'unblevable/quick-scope'     " Quickscope same as f, F, t, T but better

" Movements }}}

" General {{{

Plug 'AndrewRadev/splitjoin.vim'        " Switch between single-line and multiline forms of code
Plug 'antoinemadec/FixCursorHold.nvim'  " fix cursor hold
Plug 'christoomey/vim-sort-motion'      " sorting in vim
Plug 'christoomey/vim-tmux-navigator'   " Moving in vim inside Tmux
Plug 'christoomey/vim-tmux-runner'      " tmux runner for tests
Plug 'haya14busa/incsearch.vim'         " Better search highlighting
Plug 'ntpeters/vim-better-whitespace'   " Better Whitespace
Plug 'scr1pt0r/crease.vim'              " nice fold text
Plug 'szw/vim-maximizer'                " Maximizer for vim
Plug 'tommcdo/vim-exchange'             " vim-exchange for exchanging words
Plug 'wellle/targets.vim'               " targets.vim for extra motions
Plug 'wesQ3/vim-windowswap'             " Swap windows

" General }}}

" ACTIONS }}}

" TEXT {{{

" Notes {{{

" Plug 'oberblastmeister/neuron.nvim'  " note taking using lua
Plug 'michal-h21/vim-zettel'           " zettel tasks
Plug 'vimwiki/vimwiki'                 " vim wiki

" Notes }}}

" Snippets {{{

Plug 'SirVer/ultisnips'         " snippets engine
Plug 'honza/vim-snippets'       " Snippets in Vim
Plug 'hrsh7th/vim-vsnip'        " vsnip vscode snippets
Plug 'hrsh7th/vim-vsnip-integ'
Plug 'norcalli/snippets.nvim'   " snippets in lua

" Snippets }}}

" Format {{{

" Plug 'glepnir/indent-guides.nvim'  " indent guides using lua
" Plug 'mhartington/formatter.nvim'  " formatter in lua
Plug 'Yggdroot/indentLine', {
        \ 'on': 'IndentLinesEnable'
      \ }                            " Indent Lines made beautiful
Plug 'godlygeek/tabular'             " Tabularize for Vim

" Format }}}

" Undo {{{

Plug 'simnalamburt/vim-mundo', {
        \ 'on': 'MundoToggle'
      \ }                         " undo tree visualizer

" Undo }}}

" TEXT }}}

" LSP {{{

" coc.nvim {{{

Plug 'josa42/vim-lightline-coc'  " coc.nvim support for lightline
Plug 'neoclide/coc-neco'         " vim completion for coc
Plug 'neoclide/coc.nvim', {
        \ 'branch': 'release'
      \ }                        " Completion Conquerer

" coc.nvim }}}

" neovim-lsp {{{

" Plug 'alexaandru/nvim-lspupdate'
" Plug 'anott03/nvim-lspinstall'
" Plug 'euclidianAce/BetterLua.vim'
" Plug 'glepnir/lspsaga.nvim'
" Plug 'hrsh7th/nvim-compe'
" Plug 'josa42/nvim-lightline-lsp'      " nvim_lsp support for lightline
" Plug 'kizza/actionmenu.nvim'          " actions menu
Plug 'kosayoda/nvim-lightbulb'        " lightbulb like vscode
" Plug 'neovim/nvim-lspconfig'
" Plug 'nvim-lua/completion-nvim'
" Plug 'nvim-lua/lsp-status.nvim'
" Plug 'ojroques/nvim-lspfuzzy'
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

" Treesitter }}}

" General {{{

Plug 'Shougo/neco-vim'
Plug 'chemzqm/vim-jsx-improve'  " better jsx

" General }}}

" LSP }}}

" SEARCH {{{

" fzf.vim {{{

Plug 'junegunn/fzf', {
      \ 'dir': '~/.fzf',
      \ 'do': './install --all'
      \ }                            " FZF in vim
Plug 'junegunn/fzf.vim'              " FZF in vim
Plug 'yuki-yano/fzf-preview.vim', {
      \ 'branch': 'release/remote',
      \ 'do': ':UpdateRemotePlugs'
      \ }                            " fzf with preview

" fzf.vim }}}

" telescope.nvim {{{

Plug 'fhill2/telescope-ultisnips.nvim'
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-lua/popup.nvim'
Plug 'nvim-telescope/telescope-dap.nvim'
Plug 'nvim-telescope/telescope-frecency.nvim'
Plug 'nvim-telescope/telescope-fzf-writer.nvim'
Plug 'nvim-telescope/telescope-fzy-native.nvim'
Plug 'nvim-telescope/telescope-media-files.nvim'
Plug 'nvim-telescope/telescope-node-modules.nvim'
Plug 'nvim-telescope/telescope-project.nvim'
Plug 'nvim-telescope/telescope-snippets.nvim'
Plug 'nvim-telescope/telescope-symbols.nvim'
Plug 'nvim-telescope/telescope.nvim'
Plug 'tamago324/telescope-openbrowser.nvim'
Plug 'tkmpypy/telescope-jumps.nvim'

" telescope.nvim }}}

" SEARCH }}}

" LANGUAGES {{{

" HTML {{{
Plug 'alvan/vim-closetag', {
      \ 'for': [
        \ 'html',
        \ 'javascriptreact'
        \ ]
      \ }                           " Auto Close Tag in HTML
Plug 'AndrewRadev/tagalong.vim', {
      \ 'for': [
        \ 'html',
        \ 'javascriptreact'
        \ ]
      \ }                           " html tags completion
Plug 'wakatime/vim-wakatime'        " wakatime for vim

" HTML }}}

" markdown {{{

Plug 'npxbr/glow.nvim', {
        \ 'on': 'Glow'
      \ }                  " markdown preview

" markdown }}}

" tags {{{

" Plug 'liuchengxu/vista.vim'  " Viewer & Finder for LSP symbols and tags

" tags }}}

" General {{{

" Plug 'b3nj5m1n/kommentary'  " commenting in lua
Plug 'windwp/nvim-autopairs'  " auto-pairs in lua

" General }}}

" LANGUAGES }}}

" VERSION CONTROL STYSTEM {{{

" Plug 'f-person/git-blame.nvim'  " git blame like gitlens in vscode
Plug 'TimUntersberger/neogit'     " magit for neovim in lua
Plug 'lewis6991/gitsigns.nvim'    " gitsigns in lua
Plug 'tpope/vim-fugitive'         " version control

" VERSION CONTROL STYSTEM }}}

" STATUS AND TAB LINES {{{

" Plug 'akinsho/nvim-bufferline.lua'  " buffer line
" Plug 'glepnir/galaxyline.nvim' , {
" \ 'branch': 'main'
" \ }
" Plug 'hoob3rt/lualine.nvim'
" Plug 'romgrk/barbar.nvim'           " tabline
" Plug 'tjdevries/express_line.nvim'
Plug 'itchyny/lightline.vim'          " lightline for vim
Plug 'mg979/vim-xtabline'             " tabline

" STATUS AND TAB LINES }}}

" VIM NINJAS {{{

" tpope {{{

Plug 'tpope/vim-abolish'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-dotenv'
Plug 'tpope/vim-eunuch'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-sleuth'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-unimpaired'

" tpope }}}

" junegunn {{{

Plug 'junegunn/goyo.vim', {
      \ 'on': 'Goyo'
      \ }                    " Zen mode
" junegunn }}}

" VIM NINJAS }}}

" FILES {{{

" Explorer {{{

Plug 'kyazdani42/nvim-tree.lua', {
      \ 'on': 'NvimTreeToggle'
      \ }                           " file explorer
" Plug 'TimUntersberger/neofs'      " file manager in lua

" Explorer }}}

" General {{{

Plug 'gioele/vim-autoswap'  " for handling swap files

" General }}}

" FILES }}}

" TERMINAL {{{

" Plug 'akinsho/nvim-toggleterm.lua'  " neovim terminal managment in lua
Plug 'voldikss/vim-floaterm', {
      \ 'on': [
          \ 'FloatermNew',
          \ 'FloatermToggle'
        \ ]
      \ }                             " Float Terminal

" TERMINAL }}}

" GNVIM {{{

" Plug 'akiyosi/gonvim-fuzzy'  " Goneovim Fuzzy search

" GNVIM }}}

" BROWSER {{{

Plug 'dbeniamine/cheat.sh-vim'       " cheat.sh in vim
Plug 'dhruvasagar/vim-open-url'
Plug 'tami5/sql.nvim'                " sql nvim database for frecency
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

" PROJECT MANAGEMENT {{{

" Plug 'rmagatti/auto-session'                      " auto session save
Plug 'airblade/vim-rooter'                          " change root director to root of the project

" PROJECT MANAGEMENT }}}

call plug#end()
