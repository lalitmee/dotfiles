"
"                       __   _(_)_ __ ___  _ __ ___
"                       \ \ / / | '_ ` _ \| '__/ __|
"                        \ V /| | | | | | | | | (__
"                       (_)_/ |_|_| |_| |_|_|  \___|
"
" Author: Xianzhe Liang <liangxianzhe@gmail.com>
" Source: https://github.com/liangxianzhe/oh-my-vim

" Setup language {{{ ==========================================================

" language en_US.UTF-8           " Solve some plugins incompatibilities

" }}}

set nocompatible             " No to the total compatibility with the ancient vi

" TODO use vimscript to check update, this will leave some blank lines after
" leaving vim
silent !sh $OH_MY_VIM/tools/check_for_upgrade.sh

" Load external configuration before anything else {{{

let s:before_vimrc = expand('~/.before.vimrc')
if filereadable(s:before_vimrc)
    exec ':so ' . s:before_vimrc
endif
" }}}
"
" NEOBUNDLE {{{ ===============================================================

" NeoBundle auto-installation and setup {{{

" Auto installing NeoBundle
let iCanHazNeoBundle=1
let neobundle_readme=expand($OH_MY_VIM."/bundle/neobundle.vim/README.md")
let neobundle_runtimepath=expand($OH_MY_VIM."/bundle/neobundle.vim/")
if !filereadable(neobundle_readme)
    echo "Installing NeoBundle.."
    echo ""
    execute "silent !mkdir -p ".$OH_MY_VIM."/bundle"
    execute "silent !git clone https://github.com/Shougo/neobundle.vim ".$OH_MY_VIM."/bundle/neobundle.vim"
    let iCanHazNeoBundle=0
endif

" Call NeoBundle
if has('vim_starting')
    let &rtp=neobundle_runtimepath.','.&rtp
endif

" Supertab for tab completion
"NeoBundle 'ervandew/supertab' 

call neobundle#begin(expand($OH_MY_VIM.'/bundle/'))

" is better if NeoBundle rules NeoBundle (needed!)
NeoBundle 'Shougo/neobundle.vim'
" }}}

" BUNDLES (plugins administrated by NeoBundle) {{{

" Shougo's way {{{

" Vimproc to asynchronously run commands (NeoBundle, Unite)
NeoBundle 'Shougo/vimproc', {
            \ 'build' : {
            \     'windows' : 'make -f make_mingw32.mak',
            \     'cygwin' : 'make -f make_cygwin.mak',
            \     'mac' : 'make -f make_mac.mak',
            \     'unix' : 'make -f make_unix.mak',
            \    },
            \ }

" Unite. The interface to rule almost everything
NeoBundle 'Shougo/unite.vim'

" Unite sources
NeoBundleLazy 'Shougo/unite-outline', {'autoload':{'unite_sources':'outline'}}
NeoBundleLazy 'tsukkee/unite-help', {'autoload':{'unite_sources':'help'}}
NeoBundleLazy 'ujihisa/unite-colorscheme', {'autoload':{'unite_sources':
            \ 'colorscheme'}}
NeoBundleLazy 'ujihisa/unite-locate', {'autoload':{'unite_sources':'locate'}}
NeoBundleLazy 'thinca/vim-unite-history', { 'autoload' : { 'unite_sources' :
            \ ['history/command', 'history/search']}}
NeoBundleLazy 'osyo-manga/unite-filetype', { 'autoload' : {'unite_sources' :
            \ 'filetype', }}
NeoBundleLazy 'osyo-manga/unite-quickfix', {'autoload':{'unite_sources':
            \ ['quickfix', 'location_list']}}
NeoBundleLazy 'osyo-manga/unite-fold', {'autoload':{'unite_sources':'fold'}}
NeoBundleLazy 'tacroe/unite-mark', {'autoload':{'unite_sources':'mark'}}
NeoBundleLazy 'tsukkee/unite-tag', {'autoload':{'unite_sources':'tag'}}
NeoBundleLazy 'Shougo/neomru.vim', {'autoload':{'unite_sources':
            \['file_mru', 'directory_mru']}}

" }}}

" Colorschemes {{{

" Dark themes
" Improved terminal version of molokai, almost identical to the GUI one
NeoBundle 'joedicastro/vim-molokai256'

NeoBundle 'tomasr/molokai'
NeoBundleLazy 'sjl/badwolf', { 'autoload' :
            \ { 'unite_sources' : 'colorscheme', }}
NeoBundleLazy 'nielsmadan/harlequin', { 'autoload' :
            \ { 'unite_sources' : 'colorscheme', }}

" NerdTree
NeoBundle 'scrooloose/nerdtree'
nmap <leader>nt :NERDTreeToggle<CR>
nmap <leader>nf :NERDTreeFind<CR>
nmap <leader>nc :NERDTreeCWD<CR>


"Create the `tags` file
command! MakeTags !ctags -R .


" CtrlP Fuzzy file finder
NeoBundle 'ctrlpvim/ctrlp.vim'
set runtimepath^=~/.vim/bundle/ctrlp.vim
let g:ctrlp_map = '<c-p>'
let g:ctrlp_cmd = 'CtrlP'


" Another fuzzy file finder 
NeoBundle 'junegunn/fzf'
nmap ff :FZF<CR>


" vim-workspace for saving the Sessions
NeoBundle 'thaerkh/vim-workspace'
nnoremap <leader>s :ToggleWorkspace<CR>
"let g:sessions_dir = '~/vim-sessions'


" git tool for vim
NeoBundle 'tpope/vim-fugitive'


" Syntax checker for vim
NeoBundle 'scrooloose/syntastic'


" Prettier for vim
NeoBundle 'prettier/vim-prettier'


" insert or delete brackets, parens, quotes in pair
NeoBundle 'jiangmiao/auto-pairs'


" Mark Multiple in vim
NeoBundle 'adinapoli/vim-markmultiple'


" easy commenting motions
NeoBundle 'tpope/vim-commentary'


" substitute, search, and abbreviate multiple variants of a word
NeoBundle 'tpope/vim-abolish'


" Replace with registers
NeoBundle 'vim-scripts/ReplaceWithRegister'


" tcomment in vim
NeoBundle 'tomtom/tcomment_vim'


" js-beautify for formatting the code
NeoBundle 'beautify-web/js-beautify'


" File Navigation easy
NeoBundle 'wincent/command-t'


" Typescript Syntax highlight
NeoBundle 'leafgarland/typescript-vim'


" ALE Linting Engine for vim
NeoBundle 'w0rp/ale'


" Easy Align 
NeoBundle 'junegunn/vim-easy-align'


" Key Bindings for Easy Align
" Start interactive EasyAlign in visual mode (e.g. vipga)
xmap ga <Plug>(EasyAlign)


" Start interactive EasyAlign for a motion/text object (e.g. gaip)
nmap ga <Plug>(EasyAlign)


" Oceanic Next Theme
NeoBundle 'mhartington/oceanic-next'
" Theme
syntax enable
" for vim 7
set t_Co=256


" for vim 8
if (has("termguicolors"))
    set termguicolors
endif


" one dark theme for vim
NeoBundle 'joshdick/onedark.vim'
colorscheme onedark


" The silver searcher for vim
NeoBundle 'rking/ag.vim'



" matching tags by matchit
NeoBundle 'tmhedberg/matchit'


""" vim-pasta makes pasting easier
""NeoBundle 'sickill/vim-pasta'
""nnoremap <leader>ps p`[v`]=
""let g:pasta_enabled_filetypes = ['ruby', 'javascript', 'css', 'sh']


au BufNewFile,BufRead *.md setlocal nospell noet ts=4 sw=4
" let g:gfm_syntax_enable_filetypes = ['markdown.gfm']
autocmd BufRead,BufNewFile {*.markdown,*.mdown,*.mkdn,*.md,*.mkd,*.mdwn,*.mdtxt,*.mdtext,*.text} set filetype=markdown
autocmd FileType markdown setlocal nospell


set encoding=utf8


NeoBundle 'yuttie/comfortable-motion.vim'
let g:comfortable_motion_scroll_down_key = "j"
let g:comfortable_motion_scroll_up_key = "k"


NeoBundleLazy 'jelera/vim-javascript-syntax', {'autoload':{'filetypes':['javascript']}}


set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*


let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0


" creates table of the text if I want.
NeoBundle 'godlygeek/tabular'


" makdown highlighting
NeoBundle "plasticboy/vim-markdown" 
set conceallevel=2
let g:vim_markdown_conceal = 0
let g:vim_markdown_folding_disabled = 1
let g:vim_markdown_folding_style_pythonic = 1
let g:vim_markdown_override_foldtext = 0
let g:vim_markdown_folding_level = 6
let g:vim_markdown_no_default_key_mappings = 1
let g:vim_markdown_toc_autofit = 1


" cursor in vim terminal
if has("autocmd")
    au VimEnter,InsertLeave * silent execute '!echo -ne "\e[1 q"' | redraw!
    au InsertEnter,InsertChange *
                \ if v:insertmode == 'i' | 
                \   silent execute '!echo -ne "\e[5 q"' | redraw! |
                \ elseif v:insertmode == 'r' |
                \   silent execute '!echo -ne "\e[3 q"' | redraw! |
                \ endif
    au VimLeave * silent execute '!echo -ne "\e[ q"' | redraw!
endif


""" Derek wyatt cursor theme
""set guicursor=n-v-c:block-Cursor-blinkon0,ve:ver35-Cursor,o:hor50-Cursor,i-ci:ver25-Cursor,r-cr:hor20-Cursor,sm:block-Cursor-blinkwait175-blinkoff150-blinkon175

""" Dont update the display while executing the macros
""set lazyredraw

" Smart Commenting in Vim: its awesome.
NeoBundle 'scrooloose/nerdcommenter'
" Sessions in Vim
"NeoBundle 'xolox/vim-session'

"NeoBundle 'xolox/vim-misc'

" vim-autformat
"NeoBundle 'Chiel92/vim-autoformat'

" Light themes
NeoBundleLazy 'vim-scripts/summerfruit256.vim', { 'autoload' :
            \ { 'unite_sources' : 'colorscheme', }}
NeoBundleLazy 'joedicastro/vim-github256', { 'autoload' :
            \ { 'unite_sources' : 'colorscheme', }}

" Make terminal themes from GUI themes
NeoBundleLazy 'godlygeek/csapprox', { 'autoload' :
            \ { 'commands' : ['CSApprox', 'CSApproxSnapshot']}}

" }}}

" GUI {{{

" A better looking status line
NeoBundle 'vim-airline/vim-airline'
NeoBundle 'vim-airline/vim-airline-themes'


"NerdTree Icons and File icons
NeoBundle 'ryanoasis/vim-devicons'

NeoBundle 'vwxyutarooo/vim-nerdtree-syntax-highlight'

autocmd FileType nerdtree setlocal nolist
let g:WebDevIconsNerdTreeAfterGlyphPadding = '  '

nmap <leader>up :NeoBundleUpdate<CR>
" }}}

call neobundle#end()
" END BUNDLES }}}

" <Leader> & <LocalLeader> mapping {{{

let mapleader=' '
let maplocalleader= ';'

" }}}

" menus {{{

let g:unite_source_menu_menus = {}

" menu prefix key (for all Unite menus) {{{
nnoremap [menu] <Nop>
nmap <LocalLeader> [menu]
" }}}

" menus menu
nnoremap <silent>[menu]u :Unite -silent -winheight=20 menu<CR>

" }}}

" Local vimrc configuration {{{

let s:local_vimrc = expand('~/.local.vimrc')
if filereadable(s:local_vimrc)
    exec ':so ' . s:local_vimrc
endif

" }}}


" END NEOBUNDLE }}}


" IMPORT PACKAGES {{{

exec ':so ' $OH_MY_VIM."/autoload/helperfuncs.vim"
for package in g:oh_my_vim_packages
    let package_path = $OH_MY_VIM . "/packages/" . package . ".vimrc"
    if filereadable(package_path)
        exec ':so ' package_path
    endif
endfor

" Indent and plugins by filetype. Need to turn it on after importing packages.
filetype plugin indent on

" END IMPORT PACKAGES }}}

" Auto install the plugins {{{

" First-time plugins installation
if iCanHazNeoBundle == 0
    echo "Installing Bundles, please ignore key map error messages"
    echo ""
    set nomore
    NeoBundleInstall
endif
set more

" Check if all of the plugins are already installed, in other case ask if we
" want to install them (useful to add plugins in the .vimrc)
NeoBundleCheck

" }}}

" PLUGINS Setup {{{

" Airline {{{

set noshowmode

let g:airline_theme='onedark'
let g:airline_powerline_fonts=1
let g:airline#extensions#branch#enabled=1
let g:airline#extensions#whitespace#enabled = 1
let g:airline#extensions#hunks#non_zero_only = 1

let g:airline#extensions#tabline#enabled = 2
" let g:airline#extensions#tabline#fnamemod = ':t'
" let g:airline#extensions#tabline#buffer_min_count = 1
let g:airline#extensions#tabline#formatter = 'default'

" }}}

" Font {{{

set guifont=Monaco\ Regular\ 13 
" " }}}}

" Colorschemes
"syntax enable
"set background=dark
"colorscheme solarized

" Neomru {{{

let g:neomru#file_mru_path = $OH_MY_VIM.'/tmp/neomru/file'
let g:neomru#directory_mru_path = $OH_MY_VIM.'/tmp/neomru/directory'

" }}}

" Unite {{{

" files
nnoremap <silent><Leader>o :Unite -silent -start-insert file<CR>
nnoremap <silent><Leader>O :Unite -silent -start-insert file_rec/async<CR>
nnoremap <silent><Leader>m :Unite -silent file_mru<CR>
" buffers
nnoremap <silent><Leader>b :Unite -silent buffer<CR>
" tabs
nnoremap <silent><Leader>B :Unite -silent tab<CR>
" buffer search
nnoremap <silent><Leader>f :Unite -silent -no-split -start-insert -auto-preview
            \ line<CR>
nnoremap <silent>[menu]8 :UniteWithCursorWord -silent -no-split -auto-preview
            \ line<CR>
" yankring
nnoremap <silent><Leader>i :Unite -silent history/yank<CR>
" help
nnoremap <silent> g<C-h> :UniteWithCursorWord -silent help<CR>
" tasks
nnoremap <silent><Leader>; :Unite -silent -toggle
            \ grep:%::FIXME\|TODO\|NOTE\|XXX\|COMBAK\|@todo<CR>
" outlines (also ctags)
nnoremap <silent><Leader>t :Unite -silent -vertical -winwidth=40
            \ -direction=topleft -toggle outline<CR>

" }}}

call unite#filters#matcher_default#use(['matcher_fuzzy'])
call unite#filters#sorter_default#use(['sorter_rank'])
call unite#custom#source('file_mru,file_rec,file_rec/async,grep,locate',
            \ 'ignore_pattern', join(['\.git/', 'tmp/', 'bundle/'], '\|'))

let g:unite_source_history_yank_enable = 1
let g:unite_enable_start_insert = 0
let g:unite_enable_short_source_mes = 0
let g:unite_force_overwrite_statusline = 0
let g:unite_prompt = '>>> '
let g:unite_marked_icon = '✓'
" let g:unite_candidate_icon = '∘'
let g:unite_winheight = 15
let g:unite_update_time = 200
let g:unite_split_rule = 'botright'
let g:unite_data_directory = $OH_MY_VIM.'/tmp/unite'
let g:unite_source_buffer_time_format = '(%d-%m-%Y %H:%M:%S) '
let g:unite_source_file_mru_time_format = '(%d-%m-%Y %H:%M:%S) '
let g:unite_source_directory_mru_time_format = '(%d-%m-%Y %H:%M:%S) '

" }}}


" END PLUGINS SETUP }}}

" Additional Configuration {{{

let s:after_vimrc = expand('~/.after.vimrc')
if filereadable(s:after_vimrc)
    exec ':so ' . s:after_vimrc
endif

" }}}

" {{{
" GVim Configurations

" Shortcut to save
nmap <leader>, :w<cr>

" make backspace behave in a sane manner
set backspace=indent,eol,start

syntax on

""" Buffers Navigation
""map <S-Tab> :bprevious<CR>
""map <Tab> :bnext<CR>

" open help vertically
command! -nargs=* -complete=help Help vertical belowright help <args>
autocmd FileType help wincmd L




" ----------------------------------------- "
" File Type settings                        "
" ----------------------------------------- "

au BufNewFile,BufRead *.vim setlocal noet ts=4 sw=4 sts=4
au BufNewFile,BufRead *.txt setlocal noet ts=4 sw=4
au BufNewFile,BufRead *.md setlocal spell noet ts=4 sw=4
au BufNewFile,BufRead *.yml,*.yaml setlocal expandtab ts=2 sw=2
au BufNewFile,BufRead *.cpp setlocal expandtab ts=2 sw=2
au BufNewFile,BufRead *.hpp setlocal expandtab ts=2 sw=2
au BufNewFile,BufRead *.json setlocal expandtab ts=2 sw=2
au BufNewFile,BufRead *.jade setlocal expandtab ts=2 sw=2

" python indent
autocmd BufNewFile,BufRead *.py setlocal tabstop=4 softtabstop=4 shiftwidth=4 textwidth=80 smarttab expandtab


"au FocusLost * :wa              " Set vim to save the file on focus out.

" Searching
set ignorecase " case insensitive searching
set smartcase " case-sensitive if expresson contains a capital letter
set hlsearch " highlight search results
set incsearch " set incremental search, like modern browsers

" Appearence
set wrap " turn on line wrapping
set wrapmargin=8 " wrap lines when coming within n characters from side
set linebreak " set soft wrapping
set autoindent " automatically set indent of new line
set ttyfast " faster redrawing
set so=7 " set 7 lines to the cursors - when moving vertical
set wildmenu " enhanced command line completion


" Tab Control
set smarttab " tab respects 'tabstop', 'shiftwidth', and 'softtabstop'

" Tab navigation like Firefox.
" nnoremap <C-S-tab> :tabprevious<CR>
" noremap <C-tab>   :tabnext<CR>
" noremap <C-t>     :tabnew<CR>
" noremap <C-S-tab> <Esc>:tabprevious<CR>i
" noremap <C-tab>   <Esc>:tabnext<CR>i
" noremap <C-t>     <Esc>:tabnew<CR>

" Vim Tabs Navigation
nnoremap tl :tabnext<CR>
nnoremap th :tabprev<CR>
nnoremap tn :tabnew<CR>
nnoremap tc :tabclose<CR>

" switch between current and last buffer
nmap <leader>. <c-^>

" yank all lines of a file
nnoremap <leader>yl :%y<CR>


" enable . command in visual mode
vnoremap . :normal .<cr>


" Indenting
map <C-j> mzgg=G`z


" Vim Autoformat
"au BufWrite * :Autoformat
"noremap <C-p> :Autoformat<CR>

"show buffers
nnoremap <leader>bls :ls<cr>:b<space>

" show old
nnoremap <leader>bo :browse old<CR>

" delete all buffers
nnoremap <leader>bdd :%bdelete<CR>

" save buffers to session, write / quit too
nnoremap <silent> <leader>ss :set sessionoptions=buffers<CR>:mksession!<CR>:echo('Saved buffers to Session.vim')<Esc>
nnoremap <silent> <leader>ssw :set sessionoptions=buffers<CR>:mksession!<CR>:wa<CR>:echo('Saved all open buffers to disc')<CR>
nnoremap <silent> <leader>ssq :set sessionoptions=buffers<CR>:mksession!<CR>:q<CR>
nnoremap <silent> <leader>sswq :set sessionoptions=buffers<CR>:mksession!<CR>:wa<CR>:q<CR>

" restore buffers
let sessionmsg = "session restored from Session.vim" + "!!"
" let sessionmsg = "session restored from Session.vim" + emoji#for('sheep')
nnoremap <silent> <leader>rs :source Session.vim<CR>:echo("Session restored from Session.vim ")<Esc>

" window size of Gvim
set lines=64
set columns=120

" font face and font size
" set gfn=Ubuntu\ Mono\ 14

" Make shift-insert work like in Xterm
map <S-Insert> <MiddleMouse>
map! <S-Insert> <MiddleMouse>
" Paste in insert mode
imap <C-v> <ESC>"+pa

" enabling tabline
let g:airline#extensions#tabline#enabled = 1

" disabling folding in markdown
"let g:vim_markdown_folding_disabled = 1
"
"" markdown syntax highlighting
"set syntax=markdown
"let g:gfm_syntax_enable_always = 0
"let g:gfm_syntax_enable_filetypes = ['markdown.gfm']
"autocmd BufRead,BufNew,BufNewFile README.md setlocal ft=markdown.gfm

"colorscheme cobalt

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

" Copy to clipboard
set clipboard^=unnamed,unnamedplus

" Re-indent the whole buffer.
function! Indent()
    call Preserve('normal gg=G')
endfunction

" Indent on save hook
autocmd BufWritePre <buffer> call Indent()

set colorcolumn=120


" Remove selected Highlight
nnoremap <C-b> :noh<CR>

" clear highlighted search
noremap r :set hlsearch! hlsearch?<cr>


" Pretteir configurations
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

" window only mode
nnoremap <Leader>on :on<CR>

" window splits
nnoremap <Leader>v <C-w>v
nnoremap <Leader>H <C-w>S
nnoremap <Leader>c <C-w>q

" window chnages from current position
nnoremap <Leader>h <C-w>H
nnoremap <Leader>j <C-w>J
nnoremap <Leader>k <C-w>K
nnoremap <Leader>l <C-w>L

" Better split switching
map <C-j> <C-W>j
map <C-k> <C-W>k
map <C-h> <C-W>h
map <C-l> <C-W>l

" mapping : to ;
" nnoremap ; :


" Edit the gvimrc files
nmap <leader>eg :e $MYGVIMRC<CR>
nmap <leader>sg :so $MYGVIMRC<CR>
nmap <leader>ev :e ~/.oh-my-vim/vimrc<CR>
nmap <leader>sv :so $MYVIMRC<CR>

" ZoomVim
map <leader>e :ZoomWin<CR>
" Zoom / Restore window.
function! s:ZoomToggle() abort
    if exists('t:zoomed') && t:zoomed
        execute t:zoom_winrestcmd
        let t:zoomed = 0
    else
        let t:zoom_winrestcmd = winrestcmd()
        resize
        vertical resize
        let t:zoomed = 1
    endif
endfunction
command! ZoomToggle call s:ZoomToggle()
nnoremap <leader>r :ZoomToggle<CR>
" }}}
