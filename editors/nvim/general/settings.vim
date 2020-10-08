set iskeyword+=-                      	" treat dash separated words as a word text object"
set formatoptions-=cro                  " Stop newline continution of comments

syntax enable                           " Enables syntax highlighing
set hidden                              " Required to keep multiple buffers open multiple buffers
set nowrap                              " Display long lines as just one line
set whichwrap+=<,>,[,],h,l
set encoding=utf-8                      " The encoding displayed
set pumheight=10                        " Makes popup menu smaller
set fileencoding=utf-8                  " The encoding written to file
set ruler              			            " Show the cursor position all the time
set cmdheight=2                         " More space for displaying messages
set splitbelow                          " Horizontal splits will automatically be below
set splitright                          " Vertical splits will automatically be to the right
set t_Co=256                            " Support 256 colors
set conceallevel=0                      " So that I can see `` in markdown files
set laststatus=2                        " Always display the status line
set cursorline                          " Enable highlighting of the current line
set background=dark                     " tell vim what the background color looks like
set showtabline=2                       " Always show tabs
set noshowmode                          " We don't need to see things like -- INSERT -- anymore
set nobackup                            " This is recommended by coc
set nowritebackup                       " This is recommended by coc
set shortmess+=c                        " Don't pass messages to |ins-completion-menu|.
set signcolumn=yes                      " Always show the signcolumn, otherwise it would shift the text each time
set updatetime=300                      " Faster completion
set timeoutlen=100                      " By default timeoutlen is 1000 ms
set clipboard=unnamedplus               " Copy paste between vim and everything else
set relativenumber                      " relative line numbers
set mouse=a                             " Copy paste in vim
set re=1                                " to make nvim fast
set scrolloff=999                       " to make scroll stay in middle of the screen
set matchpairs+=<:>                     " HTML Editing
set magic                               " Set magic on, for regex
set autoread                            " detect when a file is changed
set number                              " show line numbers
set wrap                                " turn on line wrapping
set wrapmargin=8                        " wrap lines when coming within n characters from side
set linebreak                           " set soft wrapping
set ttyfast                             " faster redrawing
set diffopt+=vertical
set so=7                                " set 7 lines to the cursors - when moving vertical
set shell=$SHELL
set title                               " set terminal title
set showmatch                           " show matching braces
set mat=2                               " how many tenths of a second to blink
set history=1000                        " store more commands

" Searching
set ignorecase                          " case insensitive searching
set smartcase                           " case-sensitive if expresson contains a capital letter
set hlsearch                            " highlight search results
set incsearch                           " set incremental search, like modern browsers
set nolazyredraw                        " don't redraw while executing macros

" Indenting
set smartindent                         " Makes smart indent
set autoindent                          " Good auto indent
set breakindent

" error bells
set noerrorbells
set visualbell
set t_vb=
set tm=500

" Tab control
set noexpandtab                         " insert tabs rather than spaces for <Tab>
set smarttab                            " tab respects 'tabstop', 'shiftwidth', and 'softtabstop'
set expandtab                           " Converts tabs to spaces
set tabstop=2                           " the visible width of tabs
set softtabstop=2                       " edit as if the tabs are 4 characters wide
set shiftwidth=2                        " number of spaces to use for indent and unindent
set shiftround                          " round indent to a multiple of 'shiftwidth'

" code folding settings
set foldmethod=syntax                   " fold based on indent
set foldlevelstart=99
set foldnestmax=10                      " deepest fold is 10 levels
set nofoldenable                        " don't fold by default
set foldlevel=1
" set undodir=~/.vim/undodir
" set undofile

set colorcolumn=80

set fillchars+=vert:\
set formatprg=par\ -w72

filetype plugin indent on

if (has('nvim'))
	" show results of substition as they're happening
	" but don't open a split
	set inccommand=split
endif

set backspace=indent,eol,start " make backspace behave in a sane manner

set guicursor=n-v-c:block,i-ci-ve:ver25,r-cr:hor20,o:hor50
			\,a:blinkwait700-blinkoff400-blinkon250-Cursor/lCursor
			\,sm:block-blinkwait175-blinkoff150-blinkon175

" highlight conflicts
match ErrorMsg '^\(<\|=\|>\)\{7\}\([^=].\+\)\?$'

" make comments and HTML attributes italic
highlight Comment cterm=italic term=italic gui=italic
highlight htmlArg cterm=italic term=italic gui=italic
highlight xmlAttrib cterm=italic term=italic gui=italic

" command for making ctags in a project
command! MakeTags !ctags -R .

set tags=./tags,tags;$HOME

""" Path settings for browsing files
set path+=**

""" undolevels
set undolevels=1000      " use many muchos levels of undo

if (has("nvim"))
	"For Neovim 0.1.3 and 0.1.4 < https://github.com/neovim/neovim/pull/2198 >
	let $NVIM_TUI_ENABLE_TRUE_COLOR=1
endif

" Opaque Background (Comment out to use terminal's profile)
set termguicolors

highlight Pmenu guibg=LightYellow1 guifg=black
" highlight Normal gui=none
" highlight NonText guibg=none guifg=grey
" highlight Whitespace guibg=none guifg=grey


" Open help in vertical split {{{

augroup vimrc_help
	autocmd!
	autocmd BufEnter *.txt if &buftype == 'help' | wincmd L | endif
augroup END

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

" au! BufWritePost $MYVIMRC source %      " auto source when writing to init.vm alternatively you can run :source $MYVIMRC
autocmd FileType * setlocal formatoptions-=c formatoptions-=r formatoptions-=o