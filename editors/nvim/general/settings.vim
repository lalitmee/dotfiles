" NOTE: General Settings

" set Settings {{{

filetype plugin indent on
set fo-=oat2                                                      " format options
set fo+=cqrnj                                                     " format options
syntax enable                                                     " Enables syntax highlighing
set hidden                                                        " Required to keep multiple buffers open multiple buffers
set whichwrap+=<,>,[,],h,l
set encoding=utf-8                                                " The encoding displayed
set pumheight=10                                                  " Makes popup menu smaller
set fileencoding=utf-8                                            " The encoding written to file
set ruler                                                         " Show the cursor position all the time
set cmdheight=2                                                   " More space for displaying messages
set splitbelow                                                    " Horizontal splits will automatically be below
set splitright                                                    " Vertical splits will automatically be to the right
set t_Co=256                                                      " Support 256 colors
set conceallevel=0                                                " So that I can see `` in markdown files
set laststatus=2                                                  " Always display the status line
set cursorline                                                    " Enable highlighting of the current line
set background=dark                                               " tell vim what the background color looks like
set showtabline=2                                                 " Always show tabs
set noshowmode                                                    " We don't need to see things like -- INSERT -- anymore
set noshowcmd
set nobackup                                                      " This is recommended by coc
set nowritebackup                                                 " This is recommended by coc
set shortmess+=c                                                  " Don't pass messages to |ins-completion-menu|.
set completeopt=menuone,noinsert,noselect                         " Set completeopt to have a better completion experience
set signcolumn=yes                                                " Always show the signcolumn, otherwise it would shift the text each time
set updatetime=1000                                                " Faster completion
set timeoutlen=100                                                " By default timeoutlen is 1000 ms
set clipboard=unnamedplus                                         " Copy paste between vim and everything else
set relativenumber                                                " relative line numbers
set mouse=a                                                       " Copy paste in vim
set re=1                                                          " to make nvim fast
set scrolloff=10                                                  " to make scroll stay in middle of the screen
set matchpairs+=<:>                                               " HTML Editing
set magic                                                         " Set magic on, for regex
set autoread                                                      " detect when a file is changed
set number                                                        " show line numbers
set wrap                                                          " turn on line wrapping
set wrapmargin=8                                                  " wrap lines when coming within n characters from side
set linebreak                                                     " set soft wrapping
set ttyfast                                                       " faster redrawing
set diffopt+=vertical
set shell=$SHELL
set title                                                         " set terminal title
set showmatch                                                     " show matching braces
set mat=2                                                         " how many tenths of a second to blink
set history=1000                                                  " store more commands
set nolist
set noswapfile                                                    " no swapfiles
set shada=!,'1000,<50,s10,h                                       " store some data when I leave
" set noequalalways
set pumblend=17
set wildmode-=list
set wildmode+=full,longest
set wildoptions=pum

" NOTE: Searching
set ignorecase                                                    " case insensitive searching
set smartcase                                                     " case-sensitive if expresson contains a capital letter
set hlsearch                                                      " highlight search results
set incsearch                                                     " set incremental search, like modern browsers
set nolazyredraw                                                  " don't redraw while executing macros

" Indenting
set smartindent                                                   " Makes smart indent
set autoindent                                                    " Good auto indent
set breakindent

" error bells
set noerrorbells
set visualbell
set t_vb=
set tm=500

" undo dir
set undodir=~/.vim/undodir
set undofile
set undolevels=1000                                               " use many muchos levels of undo

set viminfo='1000

set sessionoptions+=globals

set colorcolumn=80
highlight ColorColumn guibg=#3B4252

" NOTE: install par first from here http://www.nicemice.net/par/
" set formatprg=par\ -w80

set inccommand=split                                              " show results of substition as they're happening

set backspace=indent,eol,start                                    " make backspace behave in a sane manner

set tags=./tags,tags;$HOME

" NOTE: Path settings for browsing files
set path+=**

" NOTE: view options
set viewoptions=cursor,folds,slash,unix

" NOTE: Tab control
" set noexpandtab                                                 " insert tabs rather than spaces for <Tab>
" set smarttab                                                    " tab respects 'tabstop', 'shiftwidth', and 'softtabstop'
" set expandtab                                                   " Converts tabs to spaces
" set tabstop=2                                                   " the visible width of tabs
" set softtabstop=2                                               " edit as if the tabs are 4 characters wide
" set shiftwidth=2                                                " number of spaces to use for indent and unindent
" set shiftround                                                  " round indent to a multiple of 'shiftwidth'

" NOTE: code folding settings
set foldmethod=marker
set foldlevel=0

" set Settings }}}

" True color support {{{

set t_ZH=[3m
set t_ZR=[23m
set t_ut=

if (has("nvim"))
  "For Neovim 0.1.3 and 0.1.4 < https://github.com/neovim/neovim/pull/2198 >
  let $NVIM_TUI_ENABLE_TRUE_COLOR=1
endif

" set true colors
if has('termguicolors')
  set t_8f=\[[38;2;%lu;%lu;%lum
  set t_8b=\[[48;2;%lu;%lu;%lum
  set termguicolors
endif

" True color support }}}

" Open help in vertical split {{{

" augroup vimrc_help
"   autocmd!
"   autocmd BufEnter *.txt if &buftype == 'help' | wincmd L | endif
" augroup END

" }}}

" Neovim :Terminal {{{

autocmd BufWinEnter,WinEnter term://* startinsert
autocmd BufLeave term://* stopinsert

" }}}

" Trim Whitespaces {{{

fun! TrimWhitespace()
  let l:save = winsaveview()
  keeppatterns %s/\s\+$//e
  call winrestview(l:save)
endfun

autocmd BufWritePre * :call TrimWhitespace()

" }}}

" additional_filetypes {{{

" " Helping nvim detect filetype
" let s:additional_filetypes = {
"       \ 'zsh': '*.zsh*',
"       \ 'sh': '.env.*, Caddyfile',
"       \ 'bnf': '*.bnf',
"       \ 'json': '*.webmanifest',
"       \ 'rest': '*.http',
"       \ 'elixir': ['*.exs', '*.ex'],
"       \ }

" augroup file_types
"   autocmd!
"   for kv in items(s:additional_filetypes)
"     if type(kv[1]) == v:t_list
"       for ext in kv[1]
"         execute 'autocmd BufNewFile,BufRead ' . ext
"               \ . ' setlocal filetype=' . kv[0]
"       endfor
"     else
"       execute 'autocmd BufNewFile,BufRead ' . kv[1]
"             \ . ' setlocal filetype=' . kv[0]
"     endif
"   endfor

"   autocmd FileType markdown setlocal conceallevel=2

"   " json 5 comment
"   autocmd FileType json
"                  \ syntax region Comment start="//" end="$" |
"                  \ syntax region Comment start="/\*" end="\*/" |
"                  \ setlocal commentstring=//\ %s
" augroup END

" additional_filetypes }}}

" background and comments {{{

" transparent background
hi! Normal ctermbg=NONE guibg=NONE
hi! NonText ctermbg=NONE guibg=NONE

" make comments italic
highlight Comment cterm=italic gui=italic

" background and comments }}}

" Faster Startup time (disable default plugins loading) {{{

let g:did_install_default_menus = 1
let g:did_install_syntax_menu = 1
set guioptions=M
let g:loaded_vimball           = 1
let g:loaded_vimballPlugin     = 1
let g:loaded_getscript         = 1
let g:loaded_getscriptPlugin   = 1
let g:loaded_netrw             = 1
let g:loaded_netrwPlugin       = 1
let g:loaded_netrwSettings     = 1
let g:loaded_netrwFileHandlers = 1
" Leave netrw to death
let g:netrw_banner=0

"}}}
