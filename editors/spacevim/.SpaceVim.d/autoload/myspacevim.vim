function! myspacevim#before() abort
    let profile = SpaceVim#mapping#search#getprofile('rg')
    let default_opt = profile.default_opts + ['--no-ignore-vcs']
    call SpaceVim#mapping#search#profile({'rg' : {'default_opts' : default_opt}})


    " fzf colorschemes
    call SpaceVim#custom#SPC('nmap', [';'], ':CocList commands', 'coc-commands', 1)
    " fzf.vim
    " f
    call SpaceVim#custom#SPC('nmap', ['f', 'a'], ':FzfPreviewGitActions', 'git-actions', 1)
    call SpaceVim#custom#SPC('nmap', ['f', 'f'], ':FzfFiles', 'project-files', 1)
    call SpaceVim#custom#SPC('nmap', ['f', 'g'], ':FzfPreviewGitFiles', 'project-files', 1)
    call SpaceVim#custom#SPC('nmap', ['f', 'l'], ':FzfPreviewLines', 'buffer-lines', 1)
    call SpaceVim#custom#SPC('nmap', ['f', 'm'], ':FzfMessages', 'editor-logs', 1)
    " p
    call SpaceVim#custom#SPC('nmap', ['p', 'f'], ':FzfFiles', 'project-files', 1)
    call SpaceVim#custom#SPC('nmap', ['p', 'b'], ':FzfBuffers', 'list-buffers', 1)

    " coc diagnostics
    call SpaceVim#custom#SPC('nmap', ['e', 'l'], ':CocDiagnostics', 'list-errors', 1)
    call SpaceVim#custom#SPC('nmap', ['e', 'n'], '<Plug>(coc-diagnostic-next)', 'next-error', 0)
    call SpaceVim#custom#SPC('nmap', ['e', 'p'], '<Plug>(coc-diagnostic-prev)', 'prev-error', 0)

    " coc key bindings
    call SpaceVim#custom#SPC('nmap', ['m', 'r'], '<Plug>(coc-rename)', 'coc-rename', 0)
    call SpaceVim#custom#SPC('nmap', ['m', 'a'], '<Plug>(coc-codeaction-selected)', 'coc-action', 0)
    call SpaceVim#custom#SPC('xmap', ['m', 'a'], '<Plug>(coc-codeaction-selected)', 'coc-action', 0)
    call SpaceVim#custom#SPC('nmap', ['m', 'c'], '<Plug>(code-codeaction)', 'coc-actions', 0)
    call SpaceVim#custom#SPC('nmap', ['m', 'f'], '<Plug>(code-fix-current)', 'coc-fix-current', 0)

    " spacevim keybindings for config
    call SpaceVim#custom#SPCGroupName('u', '+Spacevim/Terms')
    call SpaceVim#custom#SPC('nnoremap', ['u', 'd'], ':call coc#util#install()', 'call-coc-util-install', 1)
    call SpaceVim#custom#SPC('nnoremap', ['u', 'u'], ':SPUpdate', 'update-spacevim', 1)
    call SpaceVim#custom#SPC('nnoremap', ['u', 'e'], ':e ~/.SpaceVim.d/autoload/myspacevim.vim', 'edit-spacevim-config', 1)
    call SpaceVim#custom#SPC('nnoremap', ['u', 'i'], ':SPConfig -l', 'edit-init.toml', 1)
    call SpaceVim#custom#SPC('nnoremap', ['u', 'r'], ':source ~/.SpaceVim.d/init.toml', 'source', 1)
    call SpaceVim#custom#SPC('nnoremap', ['u', 'l'], ':SPRuntimeLog ', 'log', 1)
endfunction

function! myspacevim#after() abort
  set iskeyword+=-                      	" treat dash separated words as a word text object"
  set formatoptions-=cro                  " Stop newline continution of comments

  syntax on                           " Enables syntax highlighing
  set hidden                              " Required to keep multiple buffers open multiple buffers
  set nowrap                              " Display long lines as just one line
  set whichwrap+=<,>,[,],h,l
  set encoding=utf-8                      " The encoding displayed
  set pumheight=10                        " Makes popup menu smaller
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
  set foldenable                        " don't fold by default
  set foldlevel=1
  " set undodir=~/.vim/undodir
  " set undofile

  set colorcolumn=80

  " set fillchars+=vert:│
  set fillchars=eob:~
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

  " highlight Pmenu guibg=LightYellow1 guifg=black

  set guifont=Operator\ Mono\ Book:h12
  " set guifont=OperatorMono\ Book:h12
  " set guifont=OperatorMono\ Nerd\ Font:h12

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

  " Enable Italics
  let &t_ZH = "\e[3m"
  let &t_ZR = "\e[23m"

  " Enable Truecolors
  let g:TermSettings = {}
  function! g:TermSettings.EnableTrueColors() "{{{
    if ! has('termguicolors')
      return
    endif
    if ! empty($TMUX)
      let l:tmuxver = system("tmux -V | cut -d' ' -f2")
      let l:tmuxver = substitute(l:tmuxver, '\n\+$', '', '')
      let l:tmuxver_flt = str2float(l:tmuxver)
      if l:tmuxver_flt < 2.2 " version must be > 2.2
        return
      endif
    endif
    set termguicolors
    let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
    let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"
  endfunction "}}}

  call g:TermSettings.EnableTrueColors()

  " fzf.vim settings
  let g:fzf_layout = {'up':'~90%', 'window': { 'width': 0.8, 'height': 0.8,'yoffset':0.5,'xoffset': 0.5, 'highlight': 'Todo', 'border': 'sharp' } }
  let g:fzf_preview_window = 'right:60%'

  set wildmenu
  set wildmode=longest:full,full
  set wildignore+=*.o,*.obj,.git,*.rbc,*.pyc,__pycache__
  let $FZF_DEFAULT_OPTS = '--layout=reverse --inline-info'
  let $FZF_DEFAULT_COMMAND =  "find * -path '*/\.*' -prune -o -path 'node_modules/**' -prune -o -path 'target/**' -prune -o -path 'dist/**' -prune -o  -type f -print -o -type l -print 2> /dev/null"

  let g:fzf_tags_command = 'ctags -R'

  "Get Files
  command! -bang -nargs=? -complete=dir Files
      \ call fzf#vim#files(<q-args>, fzf#vim#with_preview({'options': ['--layout=reverse', '--inline-info']}), <bang>0)

  " Make Ripgrep ONLY search file contents and not filenames
  command! -bang -nargs=* Rg
    \ call fzf#vim#grep(
    \   'rg --column --line-number --hidden --smart-case --no-heading --color=always '.shellescape(<q-args>), 1,
    \   <bang>0 ? fzf#vim#with_preview({'options': '--delimiter : --nth 4..'}, 'up:60%')
    \           : fzf#vim#with_preview({'options': '--delimiter : --nth 4.. -e'}, 'right:50%', '?'),
    \   <bang>0)

  " Ripgrep advanced
  function! RipgrepFzf(query, fullscreen)
    let command_fmt = 'rg --column --line-number --no-heading --color=always --smart-case %s || true'
    let initial_command = printf(command_fmt, shellescape(a:query))
    let reload_command = printf(command_fmt, '{q}')
    let spec = {'options': ['--phony', '--query', a:query, '--bind', 'change:reload:'.reload_command]}
    call fzf#vim#grep(initial_command, 1, fzf#vim#with_preview(spec), a:fullscreen)
  endfunction

  command! -nargs=* -bang RG call RipgrepFzf(<q-args>, <bang>0)

  " Git grep
  command! -bang -nargs=* GGrep
    \ call fzf#vim#grep(
    \   'git grep --line-number '.shellescape(<q-args>), 0,
    \   fzf#vim#with_preview({'dir': systemlist('git rev-parse --show-toplevel')[0]}), <bang>0)

  " ripgrep
  if executable('rg')
    let $FZF_DEFAULT_COMMAND = 'rg --files --hidden --follow --glob "!.git/*"'
    set grepprg=rg\ --vimgrep
    command! -bang -nargs=* Find call fzf#vim#grep('rg --column --line-number --no-heading --fixed-strings --ignore-case --hidden --follow --glob "!.git/*" --color "always" '.shellescape(<q-args>).'| tr -d "\017"', 1, <bang>0)
  endif

  let g:fzf_command_prefix='Fzf'
  let g:coc_config_home = '~/.SpaceVim.d/'

  " Customize fzf colors to match your color scheme
  let g:fzf_colors =
  \ { 'fg':      ['fg', 'Normal'],
    \ 'bg':      ['bg', 'Normal'],
    \ 'hl':      ['fg', 'Comment'],
    \ 'fg+':     ['fg', 'CursorLine', 'CursorColumn', 'Normal'],
    \ 'bg+':     ['bg', 'CursorLine', 'CursorColumn'],
    \ 'hl+':     ['fg', 'Statement'],
    \ 'info':    ['fg', 'PreProc'],
    \ 'border':  ['fg', 'Ignore'],
    \ 'prompt':  ['fg', 'Conditional'],
    \ 'pointer': ['fg', 'Exception'],
    \ 'marker':  ['fg', 'Keyword'],
    \ 'spinner': ['fg', 'Label'],
    \ 'header':  ['fg', 'Comment'] }

endfunction
