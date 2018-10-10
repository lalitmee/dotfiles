" Configurations

" Vim-Plug Plugins {{{

call plug#begin()

" Main {{{

Plug 'junegunn/limelight.vim'
Plug 'suan/vim-instant-markdown' " Instant markdown preview from vim
Plug 'gcmt/wildfire.vim'         " For selecting closed text objects
Plug 'dyng/ctrlsf.vim'           " Ctrl + Shift + F on sublime text
Plug 'kshenoy/vim-signature'
Plug 'nathanaelkane/vim-indent-guides'
Plug 'tpope/vim-rhubarb'
Plug 'benmills/vimux'
Plug 'gilsondev/searchtasks.vim'
Plug 'tpope/vim-vinegar'
Plug 'chrisbra/NrrwRgn'
Plug 'jaxbot/github-issues.vim'
Plug 'wincent/command-t'
Plug 'ruanyl/vim-sort-imports'
Plug 'haya14busa/incsearch.vim'        " Better search highlighting
Plug 'reedes/vim-pencil'               " Better Writing
Plug 'vim-syntastic/syntastic'         " Syntax Checking
Plug 'jeetsukumaran/vim-buffergator'   " Buffer Manager
Plug 'Raimondi/delimitMate'            " Better HTML Editing
Plug 'mileszs/ack.vim'                 " SilverSearcher
Plug 'terryma/vim-multiple-cursors'    " Multiple Cursor
Plug 'airblade/vim-gitgutter'          " Vim Git Gutter
Plug 'machakann/vim-highlightedyank'   " Highlight and Yank
Plug 'vim-airline/vim-airline'         " vim airlines
Plug 'vim-airline/vim-airline-themes'  " vim airline themes
Plug 'ryanoasis/vim-devicons'          " vim icons
Plug 'junegunn/vim-journal'

" }}}

" Colors {{{

Plug 'junegunn/rainbow_parentheses.vim'
Plug 'tomasr/molokai'
Plug 'rafi/awesome-vim-colorschemes'    " Color Schemes
Plug 'altercation/vim-colors-solarized' " solarized color scheme
Plug 'ayu-theme/ayu-vim'                " ayu Color Scheme
Plug 'morhetz/gruvbox'                  " gruvbox Color Scheme
Plug 'joshdick/onedark.vim'             " onedark Color Scheme
Plug 'dracula/vim'                      " dracula Color Scheme
Plug 'gertjanreynaert/cobalt2-vim-theme'
Plug 'chriskempson/tomorrow-theme', { 'rtp': 'vim' }

" }}}

" Plugins for JavaScript & TypeScript {{{

Plug 'kristijanhusak/vim-js-file-import'
Plug 'Galooshi/vim-import-js'
Plug 'w0rp/ale'                        " Linting and fixing
Plug 'Quramy/tsuquyomi'
Plug 'pangloss/vim-javascript'
Plug 'mxw/vim-jsx'
Plug 'rhysd/npm-debug-log.vim'
Plug 'neovim/node-host',                  { 'do': 'npm install' }
Plug 'cdata/vim-tagged-template'
Plug 'romainl/ctags-patterns-for-javascript'
Plug 'janko-m/vim-test'
Plug 'HerringtonDarkholme/yats.vim'
Plug 'mhartington/nvim-typescript',       { 'do': ':UpdateRemotePlugins' }
Plug 'leshill/vim-json'

" }}}

" Functionalities {{{

Plug 'easymotion/vim-easymotion'
Plug 'tommcdo/vim-exchange'
Plug 'prettier/vim-prettier'
Plug 'godlygeek/tabular'
Plug 'tpope/vim-unimpaired'
Plug 'thaerkh/vim-workspace'
"Plug 'Valloric/YouCompleteMe'
" Vimproc to asynchronously run commands (Plug, Unite)
Plug 'Shougo/vimproc', {
      \ 'build' : {
      \     'windows' : 'make -f make_mingw32.mak',
      \     'cygwin' : 'make -f make_cygwin.mak',
      \     'mac' : 'make -f make_mac.mak',
      \     'unix' : 'make -f make_unix.mak',
      \    },
      \ }

" Unite. The interface to rule almost everything
Plug 'Shougo/unite.vim'
Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
Plug 'SirVer/ultisnips'
Plug 'honza/vim-snippets'
Plug 'ternjs/tern_for_vim', { 'for': ['javascript', 'javascript.jsx'] }
Plug 'carlitux/deoplete-ternjs', { 'for': ['javascript', 'javascript.jsx'] }
Plug 'othree/jspc.vim', { 'for': ['javascript', 'javascript.jsx'] }
Plug 'ctrlpvim/ctrlp.vim'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-sensible'
Plug 'tpope/vim-surround'
Plug 'majutsushi/tagbar'
Plug 'scrooloose/nerdtree'
Plug 'scrooloose/nerdcommenter'
"Plug 'roxma/nvim-completion-manager'
Plug 'ervandew/supertab'
Plug 'jiangmiao/auto-pairs'
Plug 'junegunn/vim-easy-align'
Plug 'alvan/vim-closetag'
Plug 'tpope/vim-abolish'
Plug 'Yggdroot/indentLine'
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'
Plug 'sheerun/vim-polyglot'
Plug 'chrisbra/Colorizer'
Plug 'heavenshell/vim-pydocstring'
Plug 'vim-scripts/loremipsum'
Plug 'SirVer/ultisnips'
Plug 'honza/vim-snippets'
Plug 'mattn/emmet-vim'
Plug 'metakirby5/codi.vim'

" }}}

" Entertainment {{{

Plug 'adelarsq/vim-hackernews' " For hackernews in your vim
Plug 'vim-scripts/DrawIt' " For drawing easily

" }}}

call plug#end()

" }}}

" Limelight mappings {{{

nmap <Leader>l <Plug>(Limelight)
xmap <Leader>l <Plug>(Limelight)

" }}}

" Search Task mappings {{{

nnoremap <leader>st :SearchTasks .<CR>

" }}}

" Python3 VirtualEnv {{{

let g:python3_host_prog = expand('/home/lalit/.pyenv/versions/neovim3/bin/python')
let g:python_host_prog = expand('/home/lalit/.pyenv/versions/neovim2/bin/python')

" }}}

" vim-workspace Configurations for saving the session {{{

nnoremap <leader>; :ToggleWorkspace<CR>
let g:workspace_session_disable_on_args = 1

" }}}

" ctrlp settings {{{

let g:ctrlp_custom_ignore= {
      \ 'dir': '\.git$\|\.hg$\|\.svn$\|\.yardoc\|public\/images\|public\/system\|log\|node_modules\|tmp$',
      \ 'file':'\.exe$\|\.so$\|\.dat$|\moc$|\.cpp_parameters|\.o$|\.cpp.o$'
      \}

" }}}

" Use deoplete {{{

let g:deoplete#enable_at_startup = 1
let g:deoplete#omni#functions = {}
let g:deoplete#omni#functions.javascript = [
      \ 'tern#Complete',
      \ 'jspc#omni'
      \]

""" for javascript completions
set completeopt=longest,menuone,preview
let g:deoplete#sources = {}
let g:deoplete#sources['javascript.js'] = ['file', 'ultisnips', 'ternjs']
let g:tern#command = ['tern']
let g:tern#arguments = ['--persistent']

" }}}

" Commented Mappings {{{

" close the preview window when you're not using it
" or just disable the preview entirely
"set completeopt-=preview


""" javascript completions with TAB
"autocmd FileType javascript let g:SuperTabDefaultCompletionType = "<c-x><c-o>"

" }}}

" Coloring {{{

"let ayucolor="dark"
syntax on
set bg=dark
colorscheme gruvbox
highlight Pmenu guibg=LightYellow1 guifg=black
highlight Comment gui=none
highlight Normal gui=none
highlight NonText guibg=none

" Opaque Background (Comment out to use terminal's profile)
set termguicolors

""" for planelight theme
if (has("nvim"))
  "For Neovim 0.1.3 and 0.1.4 < https://github.com/neovim/neovim/pull/2198 >
  let $NVIM_TUI_ENABLE_TRUE_COLOR=1
endif

" }}}

" Pencil auto detect for text and Markdown files {{{

augroup pencil
  autocmd!
  autocmd FileType markdown,mkd call pencil#init()
  autocmd FileType text         call pencil#init()
augroup END

" }}}

" Open help in vertical split {{{

augroup vimrc_help
  autocmd!
  autocmd BufEnter *.txt if &buftype == 'help' | wincmd L | endif
augroup END

" }}}

" Omni Completion {{{

set omnifunc=syntaxcomplete#Complete
" Enable omni completion.
autocmd FileType css setlocal omnifunc=csscomplete#CompleteCSS
autocmd FileType html,markdown setlocal omnifunc=htmlcomplete#CompleteTags
autocmd FileType javascript setlocal omnifunc=javascriptcomplete#CompleteJS
autocmd FileType python setlocal omnifunc=pythoncomplete#Complete
autocmd FileType xml setlocal omnifunc=xmlcomplete#CompleteTags

" }}}

" Syntastic Configuration {{{

set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*

let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 1
" let g:syntastic_check_on_wq = 0
" let g:syntastic_enable_elixir_checker = 1
" let g:syntastic_elixir_checkers = ["elixir"]

" }}}

" Converting Markdown to html OR HTML to Markdown {{{

if has("autocmd")
  let pandoc_pipeline  = "pandoc --from=html --to=markdown"
  let pandoc_pipeline .= " | pandoc --from=markdown --to=html"
  autocmd FileType html let &l:formatprg=pandoc_pipeline
endif

" }}}

" NERDTree {{{

let NERDTreeShowHidden=1
let g:NERDTreeDirArrowExpandable = '↠'
let g:NERDTreeDirArrowCollapsible = '↡'
let g:NERDTreeWinSize=20

" }}}

" Airline {{{

let g:airline_theme = 'badwolf'
let g:airline_powerline_fonts = 1
let g:airline_section_z = ' %{strftime("%-I:%M %p")}'
let g:airline_section_warning = ''
let g:airline#extensions#tabline#enabled = 1

" }}}

" Neovim :Terminal {{{

tmap <Esc> <C-\><C-n>
tmap <C-w> <Esc><C-w>
"tmap <C-d> <Esc>:q<CR>
autocmd BufWinEnter,WinEnter term://* startinsert
autocmd BufLeave term://* stopinsert

" }}}

" Nvim Completion Manager {{{

"inoremap <expr> <Tab> pumvisible() ? "\<C-n>" : "\<Tab>"
"let g:cm_complete_popup_delay = 0
"let g:cm_refresh_length = [[1, 2], [7, 2]]

" }}}

" Disable documentation window {{{

"set completeopt-=preview
" Close the documentation window when completion is done
"autocmd InsertLeave,CompleteDone * if pumvisible() == 0 | pclose | endif

" }}}

" Supertab {{{

let g:SuperTabClosePreviewOnPopupClose = 1
let g:SuperTabDefaultCompletionType = "<C-n>"

" }}}

" EasyAlign {{{

xmap ga <Plug>(EasyAlign)
nmap ga <Plug>(EasyAlign)

" }}}

" indentLine {{{

let g:indentLine_char = '▏'
let g:indentLine_color_gui = '#363949'

" }}}

" TagBar {{{

let g:tagbar_width = 30
let g:tagbar_iconchars = ['↠', '↡']

" }}}

" fzf-vim {{{

" FZF mapping to

" search through files in the project
nmap ff :FZF<CR>

" search by Ag for some specific words or anything
nmap fs :Ag<CR>

" locate files in the system
nmap fl :Locate<space>

" find the lines in the loaded buffers
nmap fbl :Lines<CR>

" find the lines in the current buffer
nmap fbcl :BLines<CR>

" finds all the Snippets for the current buffer Filetype
nmap fsn :Snippets<CR>

" opens files which you have opened
nmap fh :History<CR>

" commands history which you have entered in the vim
nmap fch :History:<CR>

" search history which you have entered in the vim
nmap fsh :History/<CR>

" search through all the commits of the project
nmap fc :Commits<CR>

" search through all the commits for the current file
nmap fbc :BCommits<CR>

" search through all the normal mode mappings in your config
nmap fm :Maps<CR>

" search through all the help files
nmap fht :Helptags<CR>

" change the filetype of the current file by searching for all
nmap ft :Filetypes<CR>


let g:fzf_action = {
      \ 'ctrl-t': 'tab split',
      \ 'ctrl-s': 'split',
      \ 'ctrl-v': 'vsplit' }
let g:fzf_colors =
      \ { 'fg':      ['fg', 'Normal'],
      \ 'bg':      ['bg', 'Normal'],
      \ 'hl':      ['fg', 'Comment'],
      \ 'fg+':     ['fg', 'CursorLine', 'CursorColumn', 'Normal'],
      \ 'bg+':     ['bg', 'CursorLine', 'CursorColumn'],
      \ 'hl+':     ['fg', 'Statement'],
      \ 'info':    ['fg', 'Type'],
      \ 'border':  ['fg', 'Ignore'],
      \ 'prompt':  ['fg', 'Character'],
      \ 'pointer': ['fg', 'Exception'],
      \ 'marker':  ['fg', 'Keyword'],
      \ 'spinner': ['fg', 'Label'],
      \ 'header':  ['fg', 'Comment'] }

" }}}

" Trim Whitespaces {{{

function! TrimWhitespace()
  let l:save = winsaveview()
  %s/\\\@<!\s\+$//e
  call winrestview(l:save)
endfunction

" }}}

" tabularize mappings for `=` and `:` {{{

if exists(":Tabularize")
  nmap <Leader>a= :Tabularize /=<CR>
  vmap <Leader>a= :Tabularize /=<CR>
  nmap <Leader>a: :Tabularize /:\zs<CR>
  vmap <Leader>a: :Tabularize /:\zs<CR>
endif

" }}}

" Edit command to remove the last file name of the current directory {{{

map <leader>ew :e <C-R>=expand("%:p:h") . "/" <CR>
map <leader>es :sp <C-R>=expand("%:p:h") . "/" <CR>
map <leader>ev :vsp <C-R>=expand("%:p:h") . "/" <CR>
map <leader>et :tabe <C-R>=expand("%:p:h") . "/" <CR>

" }}}

" Indent Guides mappings {{{

" Indentation Visualization Plugin Indent Guides
" Start with vim
"let g:indent_guides_enable_on_vim_startup = 1
"" Visual display indentation from the second layer
"let g:indent_guides_start_level = 2
"" Color block width
""let  g: indent_guides_guide_size = 1
"" Shortcut i on/off indentation visualization
"nmap <silent><leader>i<Plug> :IndentGuidesToggle

" }}}

" Custom Mappings {{{

set relativenumber
set wrap
let mapleader=" "
set cursorline
nmap <leader>q :NERDTreeToggle<CR>
nmap <leader>w :TagbarToggle<CR>
nmap \ <leader>q<leader>w
nmap <leader>ee :Colors<CR>
nmap <leader>ce :colorscheme<space>
nmap <leader>ea :AirlineTheme
nmap <leader>e1 :call ColorDracula()<CR>
nmap <leader>gt :colorscheme gruvbox<CR>
nmap <leader>co :colorscheme onedark<CR>
nmap <leader>tb :colorscheme Tomorrow-Night-Bright<CR>
nmap <leader>e2 :call ColorSeoul256()<CR>
nmap <leader>e3 :call ColorForgotten()<CR>
nmap <leader>e4 :call ColorZazen()<CR>
nmap <leader>r :so ~/.config/nvim/init.vim<CR>
nmap <leader>e :e ~/.config/nvim/init.vim<CR>
nmap <silent> <leader>tc :call TrimWhitespace()<CR>
xmap <leader>a gaip*
nmap <leader>a gaip*
nmap <leader>s <C-w>s<C-w>j:terminal<CR>
nmap <leader>vs <C-w>v<C-w>l:terminal<CR>
nmap <leader>d <Plug>(pydocstring)
"nmap <leader>f :Files<CR>
nmap <leader>g :Goyo<CR>
nmap <leader>h :RainbowParentheses!!<CR>
"nmap <leader>j :set filetype=journal<CR>
"nmap <leader>k :ColorToggle<CR>
"nmap <leader>l :Limelight!!<CR>
"xmap <leader>l :Limelight!!<CR>
autocmd FileType python nmap <leader>x :0,$!~/.config/nvim/env/bin/python -m yapf<CR>
map <leader>n <C-w>v<C-w>l:HackerNews best<CR>J
nmap <silent> <leader><leader> :noh<CR>
nmap <Tab> :bnext<CR>
nmap <S-Tab> :bprevious<CR>

" Taking word under the cursor and put in CtrlSF Plugin
noremap <leader>fw :CtrlSF <C-R><C-W><CR>



" To show marks, Toggle command from signature plugin
noremap <leader>m :SignatureToggle<CR>

" save
noremap <leader>, :w<CR>

" Paste with middle mouse click
vmap <LeftRelease> "*ygv

" clear highlighted search
"noremap r :set hlsearch! hlsearch?<cr>

" Paste with <Shift> + <Insert>
imap <S-Insert> <C-R>*

" Paste from system clipboard
set clipboard=unnamedplus

" Copy paste in vim
set mouse=a

"HTML Editing
set matchpairs+=<:>

" to not produce commented next line
autocmd FileType * setlocal formatoptions-=c formatoptions-=r formatoptions-=o
inoremap <expr> <enter> getline('.') =~ '^\s*//' ? '<enter><esc>S' : '<enter>'
""" for o and O behaviour
nnoremap <expr> O getline('.') =~ '^\s*//' ? 'O<esc>S' : 'O'
nnoremap <expr> o getline('.') =~ '^\s*//' ? 'o<esc>S' : 'o'

" command for making ctags in a project
command! MakeTags !ctags -R .

""" mapping : to ; for easy
nnoremap ; :

""" Path settings for browsing files
set path+=**

""" repeat `n.` after editing the searched word
nnoremap Q @='n.'<CR>

" Copy to clipboard
set clipboard^=unnamed,unnamedplus

" yank all lines of a file
nnoremap <leader>yl :%y<CR>

""" undolevels
set undolevels=1000      " use many muchos levels of undo


""" mapping of 0 and $ to easy map
nmap <Leader>en $
nmap <Leader>aa 0

""" HTML editing on pressing enter make an empty line
function! Expander()
  let line   = getline(".")
  let col    = col(".")
  let first  = line[col-2]
  let second = line[col-1]
  let third  = line[col]

  if first ==# ">"
    if second ==# "<" && third ==# "/"
      return "\<CR>\<C-o>==\<C-o>O"

    else
      return "\<CR>"

    endif

  else
    return "\<CR>"

  endif

endfunction

inoremap <expr> <CR> Expander()


""" tpope mapping method for the Character we want to align with
inoremap <silent> <Bar>   <Bar><Esc>:call <SID>align()<CR>a

function! s:align()
  let p = '^\s*|\s.*\s|\s*$'
  if exists(':Tabularize') && getline('.') =~# '^\s*|' && (getline(line('.')-1) =~# p || getline(line('.')+1) =~# p)
    let column = strlen(substitute(getline('.')[0:col('.')],'[^|]','','g'))
    let position = strlen(matchstr(getline('.')[0:col('.')],'.*|\s*\zs.*'))
    Tabularize/|/l1
    normal! 0
    call search(repeat('[^|]*|',column).'\s\{-\}'.repeat('.',position),'ce',line('.'))
  endif
endfunction


" resize panes
nnoremap <silent> <Right> :vertical resize +5<cr>
nnoremap <silent> <Left> :vertical resize -5<cr>
nnoremap <silent> <Up> :resize +5<cr>
nnoremap <silent> <Down> :resize -5<cr>


""" move line up and down using topope vim-unimpaired
" Bubble single lines
nmap <C-Up> [e
nmap <C-Down> ]e
" Bubble multiple lines
vmap <C-Up> [egv
vmap <C-Down> ]egv

" Visually select the text that was last edited/pasted
nmap gV `[v`]

" Transparent Background (For i3 and compton)
"highlight Normal guibg=NONE ctermbg=NONE
"highlight LineNr guibg=NONE ctermbg=NONE

" }}}

" Emmet settings for UltiSnips {{{

" Trigger configuration. Do not use <tab> if you use https://github.com/Valloric/YouCompleteMe.
inoremap <expr><TAB>  pumvisible() ? "\<C-n>" : "\<TAB>"
let g:UltiSnipsExpandTrigger="<C-j>"
let g:UltiSnipsJumpForwardTrigger="<C-f>"
let g:UltiSnipsJumpBackwardTrigger="<C-b>"

" emmet expand for emmet.vim
imap <expr> <tab> emmet#expandAbbrIntelligent("\<tab>")

" }}}

" Git verticall splitting handling {{{

set diffopt+=vertical
nmap <leader>gs :Gstatus<CR>
nmap <leader>d :Gdiff<CR>

" }}}

" Buffers Mappings {{{

""" Buffers moving around maping
nmap <leader>b :Buffers<CR>


""" Tabs Navigation
nnoremap tl :tabnext<CR>
nnoremap th :tabprev<CR>
nnoremap tn :tabnew<CR>
nnoremap tc :tabclose<CR>

""" Open new file in new tab
nnoremap <leader>tn :tabnew<space>


""" show buffers
nnoremap <leader>bls :ls<cr>:b<space>

""" show old
nnoremap <leader>bo :browse old<CR>

" delete all buffers
nnoremap <leader>bdd :%bdelete<CR>

" }}}

" Ale settings {{{

"let g:ale_fixers = {
"\ ‘javascript’: [‘eslint’]
"\ }

" ale fix current file
nmap <leader>d <Plug>(ale_fix)

"}}}

" Saved Macros {{{

""" For creating folds inside {}
let @f = 'va}zffq'

" }}}

" incsearch settings {{{

" :h g:incsearch#auto_nohlsearch
let g:incsearch#auto_nohlsearch = 1
map n  <Plug>(incsearch-nohl-n)
map N  <Plug>(incsearch-nohl-N)
map *  <Plug>(incsearch-nohl-*)
map #  <Plug>(incsearch-nohl-#)
map g* <Plug>(incsearch-nohl-g*)
map g# <Plug>(incsearch-nohl-g#)

" }}}

" Unite Mappings {{{

" files
"nnoremap <silent><Leader>o :Unite -silent -start-insert file<CR>
"nnoremap <silent><Leader>O :Unite -silent -start-insert file_rec/async<CR>
"nnoremap <silent><Leader>m :Unite -silent file_mru<CR>
"" buffers
"nnoremap <silent><Leader>b :Unite -silent buffer<CR>
"" tabs
"nnoremap <silent><Leader>B :Unite -silent tab<CR>
"" buffer search
"nnoremap <silent><Leader>f :Unite -silent -no-split -start-insert -auto-preview
"\ line<CR>
"nnoremap <silent>[menu]8 :UniteWithCursorWord -silent -no-split -auto-preview
"\ line<CR>
"" yankring
""nnoremap <silent><Leader>i :Unite -silent history/yank<CR>
"" help
"nnoremap <silent> g<C-h> :UniteWithCursorWord -silent help<CR>
"" tasks
""nnoremap <silent><Leader>; :Unite -silent -toggle
""\ grep:%::FIXME\|TODO\|NOTE\|XXX\|COMBAK\|@todo<CR>
"" outlines (also ctags)
"nnoremap <silent><Leader>tl :Unite -silent -vertical -winwidth=40
"\ -direction=topleft -toggle outline<CR>

" }}}

" Window mappings {{{

" window splits
nnoremap <Leader>v <C-w>v
nnoremap <Leader>H <C-w>S
nnoremap <Leader>c <C-w>q

" window chnages from current position
nnoremap <Leader>h <C-w>H
nnoremap <Leader>j <C-w>J
nnoremap <Leader>k <C-w>K
nnoremap <Leader>l <C-w>L

" Quicker window movement
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-h> <C-w>h
nnoremap <C-l> <C-w>l

" }}}

" Restoring positions {{{

" Restore cursor position, window position, and last search after running a
" command.
function! Preserve(command)
  " Save the last search.
  let search = @/

  " Save the current cursor position.
  let cursor_position = getpos('.')

  " Save the current window position.
  normal! H
  let window_position = getpos('.')
  call setpos('.', cursor_position)

  " Execute the command.
  execute a:command

  " Restore the last search.
  let @/ = search

  " Restore the previous window position.
  call setpos('.', window_position)
  normal! zt

  " Restore the previous cursor position.
  call setpos('.', cursor_position)
endfunction

""" Syntax and some cursor position settings
augroup vimrcEx
  autocmd!

  " When editing a file, always jump to the last known cursor position.
  " Don't do it for commit messages, when the position is invalid, or when
  " inside an event handler (happens when dropping a file on gvim).
  autocmd BufReadPost *
        \ if &ft != 'gitcommit' && line("'\"") > 0 && line("'\"") <= line("$") |
        \   exe "normal g`\"" |
        \ endif

  " Set syntax highlighting for specific file types
  autocmd BufRead,BufNewFile *.md set filetype=markdown

  " autocmd BufRead *.jsx set ft=jsx.html
  " autocmd BufNewFile *.jsx set ft=jsx.html

  " Enable spellchecking for Markdown
  autocmd FileType markdown setlocal spell

  " Automatically wrap at 100 characters for Markdown
  autocmd BufRead,BufNewFile *.md setlocal textwidth=100

  " Automatically wrap at 100 characters and spell check git commit messages
  autocmd FileType gitcommit setlocal textwidth=100
  autocmd FileType gitcommit setlocal spell

  " Allow stylesheets to autocomplete hyphenated words
  autocmd FileType css,scss,sass,less setlocal iskeyword+=-
augroup END

" }}}

" Indenting {{{

" Re-indent the whole buffer.
function! Indent()
  call Preserve('normal gg=G')
endfunction

" Indent on save hook
autocmd BufWritePre <buffer> call Indent()

" }}}

" Highligh under cursor {{{

" Highlight all instances of word under cursor, when idle.
" Useful when studying strange source code.
" Type z/ to toggle highlighting on/off.
nnoremap z/ :if AutoHighlightToggle()<Bar>set hls<Bar>endif<CR>
function! AutoHighlightToggle()
  let @/ = ''
  if exists('#auto_highlight')
    au! auto_highlight
    augroup! auto_highlight
    setl updatetime=4000
    echo 'Highlight current word: off'
    return 0
  else
    augroup auto_highlight
      au!
      au CursorHold * let @/ = '\V\<'.escape(expand('<cword>'), '\').'\>'
    augroup end
    setl updatetime=500
    echo 'Highlight current word: ON'
    return 1
  endif
endfunction

" }}}

" Easymotion mappings {{{

" <Leader>f{char} to move to {char}
map  <Leader>fes <Plug>(easymotion-bd-f)
nmap <Leader>fes <Plug>(easymotion-overwin-f)

" s{char}{char} to move to {char}{char}
nmap s <Plug>(easymotion-overwin-f2)
nmap t <Plug>(easymotion-t2)

" Move to line
map <Leader>ll <Plug>(easymotion-bd-jk)
nmap <Leader>ll <Plug>(easymotion-overwin-line)

" Move to word
map  <Leader>w <Plug>(easymotion-bd-w)
nmap <Leader>w <Plug>(easymotion-overwin-w)

" }}}

" Linting configurations for ale {{{

let g:ale_sign_error = '>>'
let g:ale_sign_warning = '--'

" }}}

" SilverSearcher for ack {{{

let g:ackprg = 'ag --nogroup --nocolor --column'

" }}}

" Folding settings {{{

augroup ft_vim
  au!
  au FileType vim setlocal foldmethod=marker foldmarker={{{,}}}
augroup END

augroup ft_js
  au!
  au FileType javascript setlocal foldmethod=marker foldmarker={,}
augroup END

" }}}

" Other Configurations {{{

filetype plugin indent on
set tabstop=2 softtabstop=2 shiftwidth=2 expandtab smarttab autoindent
set incsearch ignorecase smartcase hlsearch
set ruler laststatus=2 showcmd showmode
set list listchars=trail:»,tab:»-
set fillchars+=vert:\
set wrap breakindent
set formatprg=par\ -w72
set encoding=utf-8
set number
set title

" vim-javascript settings
let g:javascript_plugin_flow = 1

" bind K to grep word under cursor
nnoremap K :grep! "\b<C-R><C-W>\b"<CR>:cw<CR>

" }}}

" Prettier Configurations {{{

nmap <Leader>p <Plug>(Prettier)

let g:prettier#autoformat = 0

autocmd BufWritePre *.css *.js,*.jsx,*.mjs,*.ts,*.tsx,*.css,*.less,*.scss,*.json,*.graphql,*.md, *.vue Prettier

let g:prettier#exec_cmd_path = "/home/lalit/.npm-global/bin/prettier"

let g:prettier#quickfix_enabled = 0
" max line length that prettier will wrap on
" Prettier default: 80
let g:prettier#config#print_width = 80

" number of spaces per indentation level
" Prettier default: 2
let g:prettier#config#tab_width = 2

" use tabs over spaces
" Prettier default: false
let g:prettier#config#use_tabs = 'false'

" print semicolons
" Prettier default: true
let g:prettier#config#semi = 'true'

" single quotes over double quotes
" Prettier default: false
let g:prettier#config#single_quote = 'true'

" print spaces between brackets
" Prettier default: true
let g:prettier#config#bracket_spacing = 'true'

" put > on the last line instead of new line
" Prettier default: false
let g:prettier#config#jsx_bracket_same_line = 'true'

" avoid|always
" Prettier default: avoid
let g:prettier#config#arrow_parens = 'always'

" none|es5|all
" Prettier default: none
let g:prettier#config#trailing_comma = 'all'

" flow|babylon|typescript|css|less|scss|json|graphql|markdown
" Prettier default: babylon
let g:prettier#config#parser = 'flow'

" cli-override|file-override|prefer-file
let g:prettier#config#config_precedence = 'prefer-file'

" always|never|preserve
let g:prettier#config#prose_wrap = 'preserve'

" }}}

" Filetype Specific Configurations {{{

""" HTML, XML, Jinja
autocmd FileType html setlocal shiftwidth=2 tabstop=2 softtabstop=2
autocmd FileType xml setlocal shiftwidth=2 tabstop=2 softtabstop=2
autocmd FileType htmldjango setlocal shiftwidth=2 tabstop=2 softtabstop=2
autocmd FileType htmldjango inoremap {{ {{  }}<left><left><left>
autocmd FileType htmldjango inoremap {% {%  %}<left><left><left>
autocmd FileType htmldjango inoremap {# {#  #}<left><left><left>

""" Markdown and Journal
autocmd FileType markdown setlocal shiftwidth=2 tabstop=2 softtabstop=2
autocmd FileType journal setlocal shiftwidth=2 tabstop=2 softtabstop=2

" }}}
