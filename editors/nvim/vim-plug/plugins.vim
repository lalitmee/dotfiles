" auto-install vim-plug
if empty(glob('~/.config/nvim/autoload/plug.vim'))
  silent !curl -fLo ~/.config/nvim/autoload/plug.vim --create-dirs
        \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall
  autocmd VimEnter * PlugInstall | source $MYVIMRC
endif

call plug#begin('~/.config/nvim/autoload/plugged')

" Plug 'skywind3000/asynctasks.vim'
" Plug 'skywind3000/asyncrun.vim'
Plug 'terryma/vim-smooth-scroll'
Plug 'AndrewRadev/splitjoin.vim'                    " Switch between single-line and multiline forms of code
Plug 'wellle/targets.vim'                           " targets.vim for extra motions
Plug 'unblevable/quick-scope'                       " Quickscope same as f, F, t, T but better
Plug 'mhinz/vim-startify'                           " fancy start Screen for vim
Plug 'christoomey/vim-tmux-navigator'               " Moving in vim inside Tmux
Plug 'christoomey/vim-tmux-runner'                  " tmux runner for tests
Plug 'kshenoy/vim-signature'                        " toggle, display and navigate marks
Plug 'haya14busa/incsearch.vim'                     " Better search highlighting
Plug 'itchyny/lightline.vim'                        " lightline for vim
Plug 'josa42/vim-lightline-coc'                     " coc.nvim support for lightline
" Plug 'josa42/nvim-lightline-lsp'                  " nvim_lsp support for lightline
Plug 'ryanoasis/vim-devicons'                       " vim icons
Plug 'gioele/vim-autoswap'                          " for handling swap files
Plug 'junegunn/vim-pseudocl'
Plug 'junegunn/vim-fnr'
Plug 'christianchiarulli/nvcode-color-schemes.vim'  " nvcode colors
Plug 'lifepillar/vim-gruvbox8'                      " gruvbox8 Colorscheme
Plug 'tjdevries/colorbuddy.nvim'                    " colorbuddy for Colorschemes
Plug 'tjdevries/gruvbuddy.nvim'                     " gruvbuddy using colorbuddy
Plug 'Shougo/neco-vim'
Plug 'neoclide/coc-neco'
Plug 'neoclide/coc.nvim', {
      \ 'branch': 'release'
      \ }                                           " Completion Conquerer
Plug 'chemzqm/vim-jsx-improve'                      " better jsx
Plug 'stsewd/fzf-checkout.vim'                      " fzf-checkout using fzf
Plug 'junegunn/gv.vim'                              " commits blame
Plug 'godlygeek/tabular'                            " Tabularize for Vim
Plug 'SirVer/ultisnips'                             " snippets engine
Plug 'honza/vim-snippets'                           " Snippets in Vim
Plug 'hrsh7th/vim-vsnip'                            " vsnip vscode snippets
Plug 'hrsh7th/vim-vsnip-integ'
Plug 'alvan/vim-closetag'                           " Auto Close Tag in HTML
Plug 'AndrewRadev/tagalong.vim'                     " html tags completion
Plug 'valloric/MatchTagAlways'                      " match tags always
Plug 'Yggdroot/indentLine', {
      \ 'on': 'IndentLinesEnable'
      \ }                                           " Indent Lines made beautiful
Plug 'junegunn/vim-emoji'                           " emojis in vim
Plug 'junegunn/fzf', {
      \ 'dir': '~/.fzf',
      \ 'do': './install --all'
      \ }                                           " FZF in vim
Plug 'junegunn/fzf.vim'                             " FZF in vim
Plug 'yuki-yano/fzf-preview.vim', {
      \ 'branch': 'release/remote',
      \ 'do': ':UpdateRemotePlugins'
      \ }                                           " fzf with preview
Plug 'airblade/vim-rooter'                          " change root director to root of the project
Plug 'mattn/emmet-vim'                              " Emmets in Vim
Plug 'liuchengxu/vim-which-key'                     " See what keys do like in emacs
Plug 'voldikss/vim-floaterm'                        " Float Terminal
" Plug 'tpope/vim-speeddating'                      " change dates
Plug 'tpope/vim-fugitive'                           " version control
Plug 'tpope/vim-abolish'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-eunuch'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-sleuth'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-unimpaired'
Plug 'junegunn/goyo.vim', {
      \ 'on': 'Goyo'
      \ }                                           " Zen mode
" Plug 'mg979/vim-xtabline'                         " tabline
Plug 'romgrk/barbar.nvim'                           " tabline
" Plug 'mbbill/undotree'                            " undo time travel
Plug 'ntpeters/vim-better-whitespace'               " Better Whitespace
Plug 'wesQ3/vim-windowswap'                         " Swap windows
" Plug 'akiyosi/gonvim-fuzzy'                       " Goneovim Fuzzy search
Plug 'liuchengxu/vista.vim'                         " Viewer & Finder for LSP symbols and tags
Plug 'ThePrimeagen/vim-be-good'                     " vim-be-good
Plug 'wakatime/vim-wakatime'                        " wakatime for vim
Plug 'szw/vim-maximizer'                            " Maximizer for vim
Plug 'puremourning/vimspector'                      " debugger in vim
Plug 'vlime/vlime'                                  " lisp in vim
Plug 'dbeniamine/cheat.sh-vim'                      " cheat.sh in vim
Plug 'benmills/vimux'                               " Testing in vim with tmux
Plug 'tyru/open-browser.vim'
Plug 'tyru/open-browser-github.vim'
Plug 'dhruvasagar/vim-open-url'
Plug 'christoomey/vim-sort-motion'                  " sorting in vim
Plug 'tommcdo/vim-exchange'                         " vim-exchange for exchanging words
Plug 'pechorin/any-jump.vim'                        " any-jump
Plug 'tami5/sql.nvim'                               " sql nvim database for frecency
Plug 'norcalli/snippets.nvim'                       " snippets in lua
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
Plug 'oberblastmeister/neuron.nvim'                 " note taking using lua
" Plug 'anott03/nvim-lspinstall'
" Plug 'alexaandru/nvim-lspupdate'
Plug 'euclidianAce/BetterLua.vim'
" Plug 'glepnir/lspsaga.nvim'
" Plug 'hrsh7th/nvim-compe'
" Plug 'neovim/nvim-lspconfig'
" Plug 'nvim-lua/completion-nvim'
" Plug 'nvim-lua/lsp-status.nvim'
" Plug 'ojroques/nvim-lspfuzzy'
" Plug 'onsails/lspkind-nvim'
" Plug 'tjdevries/complextras.nvim'
" Plug 'tjdevries/lsp_extensions.nvim'
Plug 'tjdevries/manillua.nvim'
Plug 'tjdevries/nlua.nvim'
Plug 'nvim-treesitter/nvim-treesitter', {
      \ 'do': ':TSUpdate'
      \ }
Plug 'nvim-treesitter/playground'
Plug 'p00f/nvim-ts-rainbow'
Plug 'nvim-treesitter/nvim-treesitter-textobjects'
Plug 'nvim-treesitter/nvim-treesitter-refactor'
Plug 'mhartington/formatter.nvim'                   " formatter in lua
Plug 'kyazdani42/nvim-web-devicons'                 " for file icons
Plug 'kyazdani42/nvim-tree.lua', {
      \ 'on': 'NvimTreeToggle'}                     " file explorer
Plug 'norcalli/nvim-colorizer.lua'                  " Colorizer for showing the colors
Plug 'npxbr/glow.nvim'                              " markdown preview
Plug 'kevinhwang91/nvim-bqf'                        " better quick-fix winodw
Plug 'mfussenegger/nvim-dap'                        " debugger attach protocol
Plug 'windwp/nvim-autopairs'                        " auto-pairs in lua
Plug 'kizza/actionmenu.nvim'                        " actions menu
Plug 'phaazon/hop.nvim'                             " easymotion using lua
Plug 'lewis6991/gitsigns.nvim'                      " gitsigns in lua
Plug 'kosayoda/nvim-lightbulb'                      " lightbulb like vscode
Plug 'akinsho/nvim-toggleterm.lua'                  " neovim terminal managment in lua
Plug 'gennaro-tedesco/nvim-peekup'                  " registers in lua
Plug 'TimUntersberger/neogit'                       " magit for neovim in lua
Plug 'tjdevries/train.nvim'                         " motion training
Plug 'kevinhwang91/nvim-hlslens'                    " hlslens lens for neovim
" Plug 'glepnir/indent-guides.nvim'                 " indent guides using lua
" Plug 'TimUntersberger/neofs'                      " file manager in lua
" Plug 'f-person/git-blame.nvim'                    " git blame like gitlens in vscode
" Plug 'b3nj5m1n/kommentary'                        " commenting in lua
" Plug 'rmagatti/auto-session'                      " auto session save
" Plug 'akinsho/nvim-bufferline.lua'                " buffer line
" Plug 'tjdevries/express_line.nvim'
" Plug 'hoob3rt/lualine.nvim'
" Plug 'glepnir/galaxyline.nvim' , {
" \ 'branch': 'main'
" \ }

call plug#end()
