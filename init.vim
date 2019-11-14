
" Configurations

" Vim-Plug Plugins {{{

call plug#begin()

" Main {{{

Plug 'justinmk/vim-sneak'           " Vim sneak with two words
Plug 'suan/vim-instant-markdown'    " Instant markdown preview from vim
" Plug 'dyng/ctrlsf.vim'              " Ctrl + Shift + F on sublime text
Plug 'kshenoy/vim-signature'        " toggle, display and navigate marks
Plug 'haya14busa/incsearch.vim'     " Better search highlighting
" Plug 'vim-syntastic/syntastic'      " Syntax Checking
Plug 'Raimondi/delimitMate'         " Better HTML Editing
Plug 'mileszs/ack.vim'              " SilverSearcher
Plug 'terryma/vim-multiple-cursors' " Multiple Cursor
Plug 'airblade/vim-gitgutter'       " Vim Git Gutter
Plug 'itchyny/lightline.vim'        " lightweight statusline for vim
Plug 'ryanoasis/vim-devicons'       " vim icons
Plug 'gioele/vim-autoswap'          " for handling swap files
Plug 'danro/rename.vim'             " for renaming the current buffer

" }}}

" Writing in vim {{{{

Plug 'junegunn/goyo.vim'      " remove all the things and go in the center
let g:limelight_conceal_ctermfg = 240

let g:goyo_entered = 0
function! s:goyo_enter()
	silent !tmux set status off
	let g:goyo_entered = 1
	set noshowmode
	set noshowcmd
	set scrolloff=999
	set wrap
	setlocal textwidth=0
	setlocal wrapmargin=0
	Limelight
endfunction

function! s:goyo_leave()
	silent !tmux set status on
	let g:goyo_entered = 0
	set showmode
	set showcmd
	set scrolloff=5
	set textwidth=120
	set wrapmargin=8
	Limelight!
endfunction

autocmd! User GoyoEnter nested call <SID>goyo_enter()
autocmd! User GoyoLeave nested call <SID>goyo_leave()

" }}}

" Colors {{{

Plug 'chriskempson/base16-vim'
Plug 'fenetikm/falcon'
Plug 'itchyny/landscape.vim'
Plug 'tomasr/molokai'

" }}}

" coc.nvim {{{

Plug 'neoclide/coc.nvim', {'branch': 'release'}

" }}}

" JavaScript {{{

" Plug 'isRuslan/vim-es6'
" Plug 'pangloss/vim-javascript'
" Plug 'heavenshell/vim-jsdoc' " for commenting the code
" Plug 'othree/yajs.vim', { 'for': [ 'javascript', 'javascript.jsx', 'html' ] }
" Plug 'moll/vim-node', { 'for': 'javascript' }
" Plug 'mxw/vim-jsx', { 'for': ['javascript.jsx', 'javascript'] }
" Plug 'Ivo-Donchev/vim-react-goto-definition'
" Plug 'ternjs/tern_for_vim', { 'for': ['javascript', 'javascript.jsx'], 'do': 'npm install' }
" Plug 'justinj/vim-react-snippets'

" }}}

" Golang {{{

Plug 'fatih/vim-go', {'do': ':GoInstallBinaries'}
Plug 'vim-scripts/c.vim' 
Plug 'rhysd/vim-clang-format'

let g:clang_library_path='/usr/lib/llvm-6.0/lib'
let g:clang_use_library = 1

" CLANG FORMAT
" default settings
let g:clang_format#auto_format = 1
let g:clang_format#code_style = "llvm"
let g:clang_format#style_options = {
      \ "AllowShortFunctionsOnASingleLine": "Empty",
      \ "AlwaysBreakTemplateDeclarations": "true",
      \ "BreakBeforeBraces": "Allman",
      \ "BreakConstructorInitializersBeforeComma": "true",
      \ "IndentCaseLabels": "true",
      \ "IndentWidth":     4,
      \ "MaxEmptyLinesToKeep": 2,
      \ "NamespaceIndentation": "Inner",
      \ "ObjCBlockIndentWidth": 4,
      \ "TabWidth": 4}

augroup ClangFormatSettings
    autocmd!
    " if you install vim-operator-user
    autocmd FileType c,cpp,objc,java,javascript map <buffer><Leader>c <Plug>(operator-clang-format)
    autocmd FileType vimwiki nmap <Leader>tts :TaskWikiMod +sprint<CR>
    autocmd FileType vimwiki nmap <Leader>ttS :TaskWikiMod -sprint<CR>
augroup END

" }}}


" TypeScript {{{

" Plug 'leafgarland/typescript-vim', { 'for': 'typescript' }
" Plug 'Shougo/vimproc.vim', { 'do': 'make' }

" Plug 'mhartington/nvim-typescript', { 'for': 'typescript', 'do': './install.sh' }
" let g:nvim_typescript#diagnostics_enable = 0
" let g:nvim_typescript#max_completion_detail=100

" }}}


" Styles {{{

"Plug 'wavded/vim-stylus', { 'for': ['stylus', 'markdown'] }
" Plug 'groenewege/vim-less', { 'for': 'less' }
" Plug 'hail2u/vim-css3-syntax', { 'for': 'css' }
" Plug 'cakebaker/scss-syntax.vim', { 'for': 'scss' }
" Plug 'gko/vim-coloresque'
" Plug 'stephenway/postcss.vim', { 'for': 'css' }
" Plug 'csscomb/vim-csscomb'

" }}}

" markdown {{{

" Plug 'tpope/vim-markdown', { 'for': 'markdown' }

" }}}

" JSON {{{

" Plug 'elzr/vim-json', { 'for': 'json' }
" let g:vim_json_syntax_conceal = 0

" }}}

" Plugins for JavaScript & TypeScript {{{

" Plug 'rhysd/npm-debug-log.vim'
" Plug 'neovim/node-host',                  { 'do': 'npm install' }
" Plug 'cdata/vim-tagged-template'
" Plug 'romainl/ctags-patterns-for-javascript'
Plug 'HerringtonDarkholme/yats.vim'
" Use release branch

" }}}

" Functionalities {{{

" search inside files using ripgrep. This plugin provides an Ack command.
Plug 'tpope/vim-eunuch'
Plug 'tpope/vim-commentary'
Plug 'prettier/vim-prettier'
Plug 'godlygeek/tabular'
Plug 'tpope/vim-unimpaired'
" For Denite features
Plug 'Shougo/denite.nvim'
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
if (has('nvim'))
	Plug 'Shougo/defx.nvim', { 'do': ':UpdateRemotePlugins' }
	Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
else
	Plug 'Shougo/defx.nvim'
	Plug 'Shougo/deoplete.nvim'
	Plug 'roxma/nvim-yarp'
	Plug 'roxma/vim-hug-neovim-rpc'
endif

" custom implementation of devicons for defx
Plug 'kristijanhusak/defx-icons'

Plug 'SirVer/ultisnips'
Plug 'honza/vim-snippets'
Plug 'carlitux/deoplete-ternjs', { 'for': ['javascript', 'javascript.jsx'] }
Plug 'othree/jspc.vim', { 'for': ['javascript', 'javascript.jsx'] }
Plug 'ctrlpvim/ctrlp.vim'
Plug 'jreybert/vimagit' " magit for git workflow
Plug 'tpope/vim-surround'
Plug 'majutsushi/tagbar'
Plug 'jiangmiao/auto-pairs'
Plug 'vim-scripts/closetag.vim'
Plug 'junegunn/vim-easy-align'
Plug 'alvan/vim-closetag'
Plug 'tpope/vim-abolish'
Plug 'Yggdroot/indentLine'
Plug 'sheerun/vim-polyglot'
Plug 'chrisbra/Colorizer'
Plug 'heavenshell/vim-pydocstring'
Plug 'vim-scripts/loremipsum'
Plug 'metakirby5/codi.vim'

if isdirectory('/usr/local/opt/fzf')
  Plug '/usr/local/opt/fzf' | Plug 'junegunn/fzf.vim'
else
  Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --bin' }
  Plug 'junegunn/fzf.vim'
endif
let g:make = 'gmake'
if exists('make')
        let g:make = 'make'
endif

" }}}

" Entertainment {{{


" }}}


" Commented out Plugins {{{

" Plug 'reedes/vim-pencil'               " Better Writing
" Plug 'benmills/vimux'                  " better integration with tmux
" Plug 'nathanaelkane/vim-indent-guides' " indenting guides which I didn't like
" Plug 'tpope/vim-rhubarb'               " fugitive relative somehow
" Plug 'gilsondev/searchtasks.vim'       " searching tags like TODO and FIXME
" Plug 'chrisbra/NrrwRgn'                " narrow region like emacs
" Plug 'wincent/ferret'                  " I am using FZF so I disabled it
" Plug 'easymotion/vim-easymotion'       " I don't think I need this
" Plug 'tommcdo/vim-exchange'            " It does something for text operator exchange
" Plug 'thaerkh/vim-workspace'           " It's not that hard to go for files now with FZF

" }}}

call plug#end()

" }}}

" FZF {{{

set wildmode=list:longest,list:full
set wildignore+=*.o,*.obj,.git,*.rbc,*.pyc,__pycache__
let $FZF_DEFAULT_COMMAND =  "find * -path '*/\.*' -prune -o -path 'node_modules/**' -prune -o -path 'target/**' -prune -o -path 'dist/**' -prune -o  -type f -print -o -type l -print 2> /dev/null"

" The Silver Searcher
if executable('ag')
  let $FZF_DEFAULT_COMMAND = 'ag --hidden --ignore .git -g ""'
  set grepprg=ag\ --nogroup\ --nocolor
endif

" ripgrep
if executable('rg')
  let $FZF_DEFAULT_COMMAND = 'rg --files --hidden --follow --glob "!.git/*"'
  set grepprg=rg\ --vimgrep
  command! -bang -nargs=* Find call fzf#vim#grep('rg --column --line-number --no-heading --fixed-strings --ignore-case --hidden --follow --glob "!.git/*" --color "always" '.shellescape(<q-args>).'| tr -d "\017"', 1, <bang>0)
endif

cnoremap <C-P> <C-R>=expand("%:p:h") . "/" <CR>
nnoremap <silent> <leader>b :Buffers<CR>

nnoremap <silent> <leader>ff :FZF -m<CR>
nnoremap <silent> <leader>bb :Buffers<CR>
nnoremap <silent> <leader>cc :Colors<CR>
nnoremap <silent> <leader>hh :History<CR>

"Recovery commands from history through FZF
nmap <leader>y :History:<CR>

" }}} 

" Abbreviations{{{ "

abbr funciton function
abbr teh the
abbr tempalte template
abbr fitler filter
abbr cosnt const
abbr attribtue attribute
abbr attribuet attribute

" }}} Abbreviations "

" coc.nvim settins {{{

" Prettier command for coc-prettier
command! -nargs=0 Prettier :CocCommand prettier.formatFile

let g:coc_global_extensions = [ 
				\ 'coc-pairs',
				\ 'coc-eslint',
				\ 'coc-prettier',
				\ 'coc-json',
				\ 'coc-tsserver', 
				\ 'coc-html', 
				\ 'coc-css',
				\ 'coc-yaml', 
				\ 'coc-python',
				\ 'coc-highlight',
				\ 'coc-emmet',
				\ 'coc-snippets',
				\ 'coc-lists',
				\ 'coc-angular',
				\ 'coc-tslint',
				\ 'coc-git',
				\ 'coc-yank',
				\ 'coc-svg',
				\ 'coc-vimlsp',
				\ 'coc-xml',
				\ 'coc-texlab',
				\ 'coc-smartf',
				\ 'coc-gitignore',
				\ 'coc-ultisnips',
				\ 'coc-neosnippet',
				\ 'coc-go',
				\ 'coc-gocode',
				\ 'coc-sh',
				\ 'coc-emoji',
				\ 'coc-dictionary',
				\ 'coc-syntax'
				\ ]

" Better display for messages
set cmdheight=2

" Use tab for trigger completion with characters ahead and navigate.
" Use command ':verbose imap <tab>' to make sure tab is not mapped by other plugin.
inoremap <silent><expr> <TAB>
      \ pumvisible() ? "\<C-n>" :
      \ <SID>check_back_space() ? "\<TAB>" :
      \ coc#refresh()
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

" Use <c-space> to trigger completion.
inoremap <silent><expr> <c-space> coc#refresh()

" Use <cr> to confirm completion, `<C-g>u` means break undo chain at current position.
" Coc only does snippet and additional edit on confirm.
inoremap <expr> <cr> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"
" Or use `complete_info` if your vim support it, like:
" inoremap <expr> <cr> complete_info()["selected"] != "-1" ? "\<C-y>" : "\<C-g>u\<CR>"

" Use `[g` and `]g` to navigate diagnostics
nmap <silent> [g <Plug>(coc-diagnostic-prev)
nmap <silent> ]g <Plug>(coc-diagnostic-next)

" Remap keys for gotos
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

" Use K to show documentation in preview window
nnoremap <silent> K :call <SID>show_documentation()<CR>

function! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  else
    call CocAction('doHover')
  endif
endfunction

" Highlight symbol under cursor on CursorHold
autocmd CursorHold * silent call CocActionAsync('highlight')

" Remap for rename current word
nmap <silent> <F2> <Plug>(coc-rename)

" Remap for format selected region
xmap <Leader>f  <Plug>(coc-format-selected)
nmap <Leader>f  <Plug>(coc-format-selected)

augroup mygroup
  autocmd!
  " Setup formatexpr specified filetype(s).
  autocmd FileType typescript,json setl formatexpr=CocAction('formatSelected')
  " Update signature help on jump placeholder
  autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')
augroup end

" Remap for do codeAction of selected region, ex: `<Leader>aap` for current paragraph
xmap <Leader>a  <Plug>(coc-codeaction-selected)
nmap <Leader>a  <Plug>(coc-codeaction-selected)

" Remap for do codeAction of current line
nmap <Leader>ac  <Plug>(coc-codeaction)
" Fix autofix problem of current line
nmap <Leader>qf  <Plug>(coc-fix-current)

" Create mappings for function text object, requires document symbols feature of languageserver.
xmap if <Plug>(coc-funcobj-i)
xmap af <Plug>(coc-funcobj-a)
omap if <Plug>(coc-funcobj-i)
omap af <Plug>(coc-funcobj-a)

" Use <C-d> for select selections ranges, needs server support, like: coc-tsserver, coc-python
nmap <silent> <C-d> <Plug>(coc-range-select)
xmap <silent> <C-d> <Plug>(coc-range-select)

" Use `:Format` to format current buffer
command! -nargs=0 Format :call CocAction('format')

" Use `:Fold` to fold current buffer
command! -nargs=? Fold :call     CocAction('fold', <f-args>)

" use `:OR` for organize import of current buffer
command! -nargs=0 OR   :call     CocAction('runCommand', 'editor.action.organizeImport')

" Add status line support, for integration with other plugin, checkout `:h coc-status`
set statusline^=%{coc#status()}%{get(b:,'coc_current_function','')}

" Using CocList
" Show all diagnostics
nnoremap <silent> <space>a  :<C-u>CocList diagnostics<cr>
" Manage extensions
nnoremap <silent> <space>e  :<C-u>CocList extensions<cr>
" Show commands
nnoremap <silent> <space>c  :<C-u>CocList commands<cr>
" Find symbol of current document
nnoremap <silent> <space>o  :<C-u>CocList outline<cr>
" Search workspace symbols
nnoremap <silent> <space>s  :<C-u>CocList -I symbols<cr>
" Do default action for next item.
nnoremap <silent> <space>j  :<C-u>CocNext<CR>
" Do default action for previous item.
nnoremap <silent> <space>k  :<C-u>CocPrev<CR>
" Resume latest coc list
nnoremap <silent> <space>p  :<C-u>CocListResume<CR>

" }}}

" Limelight mappings {{{

nmap <Leader>l <Plug>(Limelight)
xmap <Leader>l <Plug>(Limelight)

" }}}

" Search Task mappings {{{

nnoremap <Leader>st :SearchTasks .<CR>

" }}}

" Python3 VirtualEnv {{{

let g:python3_host_prog = '/home/lalit/.pyenv/versions/neovim3/bin/python'
let g:python_host_prog = '/home/lalit/.pyenv/versions/neovim2/bin/python'

" }}}

" vim-workspace Configurations for saving the session {{{

nnoremap <Leader>; :ToggleWorkspace<CR>
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
let g:deoplete#sources['typescript.ts'] = ['file', 'ultisnips', 'ternjs']
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
set swapfile
set dir=~/vim-autoswap
colorscheme base16-monokai
" colorscheme landscape
" colorscheme darkblue
let $NVIM_TUI_ENABLE_TRUE_COLOR=1
highlight Pmenu guibg=LightYellow1 guifg=black
highlight Comment cterm=italic
"highlight Comment gui=none
"highlight Normal gui=none
"highlight NonText guibg=none

" Some GUI stuff
let g:lightTheme = 'molokai'
let g:darkTheme = 'xoria256'
command! Light :execute ':colorscheme ' . g:lightTheme . ' | set background=light'
command! Dark  :execute ':colorscheme ' . g:darkTheme . ' | set background=dark'

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

" Syntastic Configuration {{{

" set statusline+=%#warningmsg#
" set statusline+=%{SyntasticStatuslineFlag()}
" set statusline+=%*

" let g:syntastic_always_populate_loc_list = 0
" let g:syntastic_auto_loc_list = 0
" let g:syntastic_check_on_open = 1
" let g:syntastic_check_on_wq = 0

" " for react
" " goto plugin mapping for React
" noremap <Leader>gt :call ReactGotoDef()<CR>
" let g:syntastic_javascript_checkers = ['eslint']
" let g:syntastic_javascript_eslint_exe='$(npm bin)/eslint'
" let g:jsx_ext_required = 0

" }}}

" Converting Markdown to html OR HTML to Markdown {{{

if has("autocmd")
	let pandoc_pipeline  = "pandoc --from=html --to=markdown"
	let pandoc_pipeline .= " | pandoc --from=markdown --to=html"
	autocmd FileType html let &l:formatprg=pandoc_pipeline
endif

" }}}

" Neovim :Terminal {{{

tmap <Esc> <C-\><C-n>
tmap <C-w> <Esc><C-w>
"tmap <C-d> <Esc>:q<CR>
autocmd BufWinEnter,WinEnter term://* startinsert
autocmd BufLeave term://* stopinsert

" }}}

" Supertab {{{

let g:SuperTabClosePreviewOnPopupClose = 1
let g:SuperTabDefaultCompletionType = "<C-n>"

" }}}

" EasyAlign {{{

" xmap ga <Plug>(EasyAlign)
" nmap ga <Plug>(EasyAlign)

" }}}

" indentLine {{{

let g:indentLine_char = '▏'
let g:indentLine_color_gui = '#363949'

" }}}

" TagBar {{{

let g:tagbar_width = 30
let g:tagbar_iconchars = ['↠', '↡']

" }}}

" Trim Whitespaces {{{

nnoremap <silent> <space><space> :call <SID>StripTrailingWhitespaces()<CR>

if has("autocmd")
	autocmd BufWritePre *.py,*.js,*.ts,*.css,*.scss :call <SID>StripTrailingWhitespaces()
endif

function! <SID>StripTrailingWhitespaces()
	" Preparation: save last search, and cursor position.
	let _s=@/
	let l = line(".")
	let c = col(".")
	" Do the business:
	%s/\s\+$//e
	" Clean up: restore previous search history, and cursor position
	let @/=_s
	call cursor(l, c)
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

map <Leader>ew :e <C-R>=expand("%:p:h") . "/" <CR>
map <Leader>es :sp <C-R>=expand("%:p:h") . "/" <CR>
map <Leader>ev :vsp <C-R>=expand("%:p:h") . "/" <CR>
map <Leader>et :tabe <C-R>=expand("%:p:h") . "/" <CR>

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
"nmap <silent><Leader>i<Plug> :IndentGuidesToggle

" }}}

" Custom Mappings {{{

let mapleader=" "
cnoremap <C-p> <Up>
cnoremap <C-n> <Down>
nmap <Leader>* *<c-o>:%s///gn<cr>
nmap <Leader>u :PlugUpdate<CR>
nmap <Leader>qn :NERDTreeToggle<CR>
nmap <Leader>w :TagbarToggle<CR>
nmap \ <Leader>q<Leader>w
nmap <Leader>ee :Colors<CR>
nmap <Leader>ce :colorscheme<space>
nmap <Leader>r :so ~/.config/nvim/init.vim<CR>
nmap <Leader>e :e ~/.config/nvim/init.vim<CR>

" select whole file text in visual mode
map <C-c> <esc>ggVG<CR>

" count the current matched number
nnoremap <silent> <Leader>n :%s///gn<CR>

" scroll the viewport faster
nnoremap <C-e> 3<C-e>
nnoremap <C-y> 3<C-y>

" xmap <Leader>a gaip*
" nmap <Leader>a gaip*
nmap <Leader>hs <C-w>s<C-w>j:terminal<CR>
nmap <Leader>vs <C-w>v<C-w>l:terminal<CR>
"nmap <Leader>d <Plug>(pydocstring)
"nmap <Leader>f :Files<CR>
nmap <Leader>z :Goyo<CR>
nmap <Leader>h :RainbowParentheses!!<CR>
"nmap <Leader>j :set filetype=journal<CR>
"nmap <Leader>k :ColorToggle<CR>
nmap <Leader>l :Limelight!!<CR>
xmap <Leader>l :Limelight!!<CR>
autocmd FileType python nmap <Leader>x :0,$!~/.config/nvim/env/bin/python -m yapf<CR>
map <Leader>hn <C-w>v<C-w>l:HackerNews best<CR>J

" Taking word under the cursor and put in CtrlSF Plugin
noremap <Leader>fw :CtrlSF <C-R><C-W><CR>

" To show marks, Toggle command from signature plugin
"noremap <Leader>m :SignatureToggle<CR>

" save
noremap <silent> <Leader>, :w<CR>

" Paste with middle mouse click
vmap <LeftRelease> "*ygv

" clear highlighted search
noremap <silent> <Leader>h :set hlsearch! hlsearch?<cr>
nnoremap <CR> :noh<CR><CR>

" exit with leader
noremap <silent> <Leader>x :q<cr>

" Paste with <Shift> + <Insert>
imap <S-Insert> <C-R>*

" For putting the file name on the current position of cursor from Derek Wyatt
imap <Leader>fn <c-r>=expand('%:t:r')<cr>

" Paste from system clipboard
set clipboard=unnamedplus

" Copy paste in vim
set mouse=a

" to make nvim fast
set re=1

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

set tags+=tags,./.git/tags

""" mapping : to ; for easy
" nnoremap ; :

""" Path settings for browsing files
set path+=**

""" repeat `n.` after editing the searched word
nnoremap Q @='n.'<CR>

" Copy to clipboard
set clipboard^=unnamed,unnamedplus

" yank all lines of a file
nnoremap <Leader>yl :%y<CR>

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

" }}}

" Emmet settings for UltiSnips {{{

" better key bindings for UltiSnipsExpandTrigger
let g:UltiSnipsExpandTrigger = "<tab>"
let g:UltiSnipsJumpForwardTrigger = "<tab>"
let g:UltiSnipsJumpBackwardTrigger = "<s-tab>"

" emmet expand for emmet.vim
imap <expr> <tab> emmet#expandAbbrIntelligent("\<tab>")
let g:user_emmet_leader_key='<Tab>'
let g:user_emmet_settings = {
  \  'javascript.jsx' : {
    \      'extends' : 'jsx',
    \  },
  \}

" }}}

" Git verticall splitting handling {{{

set diffopt+=vertical
" fugitive git bindings
nnoremap <Leader>ga :Git add %:p<CR><CR>
nnoremap <Leader>gs :Gstatus<CR>
nnoremap <Leader>gc :Gcommit -v -q<CR>
nnoremap <Leader>gt :Gcommit -v -q %:p<CR>
nnoremap <Leader>gd :Gdiff<CR>
nnoremap <Leader>ge :Gedit<CR>
nnoremap <Leader>gr :Gread<CR>
nnoremap <Leader>gw :Gwrite<CR><CR>
nnoremap <Leader>gl :silent! Glog<CR>:bot copen<CR>
nnoremap <Leader>gp :Ggrep<Space>
nnoremap <Leader>gm :Gmove<Space>
nnoremap <Leader>gb :Git branch<Space>
nnoremap <Leader>go :Git checkout<Space>
nnoremap <Leader>gps :Dispatch! git push<CR>
nnoremap <Leader>gpl :Dispatch! git pull<CR>

" }}}

" Buffers Mappings {{{

""" Buffers moving around maping
nmap <Leader>db :bd!<CR>


""" Tabs Navigation
nnoremap tl :tabnext<CR>
nnoremap th :tabprev<CR>
nnoremap tn :tabnew<CR>
nnoremap tc :tabclose<CR>

""" Open new file in new tab
nnoremap <Leader>tn :tabnew<space>


""" show buffers
nnoremap <Leader>bls :ls<cr>:b<space>

""" show old
nnoremap <Leader>bo :browse old<CR>

" delete all buffers
nnoremap <Leader>bdd :%bdelete<CR>

" }}}

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

" Window mappings {{{

" window splits
nnoremap <Leader>v <C-w>v
nnoremap <Leader>H <C-w>S
nnoremap <Leader>c <C-w>q

" window chnages from current position
"nnoremap <Leader>h <C-w>H
"nnoremap <Leader>j <C-w>J
"nnoremap <Leader>k <C-w>K
"nnoremap <Leader>l <C-w>L

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
" autocmd BufWritePre <buffer> call Indent()

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

" Magit mappings {{{

nnoremap <Leader>m :Magit<CR>

" }}}

" Easymotion mappings {{{

" <Leader>f{char} to move to {char}
"map  <Leader>fes <Plug>(easymotion-bd-f)
"nmap <Leader>fes <Plug>(easymotion-overwin-f)

"" s{char}{char} to move to {char}{char}
"nmap s <Plug>(easymotion-overwin-f2)
"nmap t <Plug>(easymotion-t2)

"" Move to line
"map <Leader>ll <Plug>(easymotion-bd-jk)
"nmap <Leader>ll <Plug>(easymotion-overwin-line)

"" Move to word
"map  <Leader>w <Plug>(easymotion-bd-w)
"nmap <Leader>w <Plug>(easymotion-overwin-w)

" }}}

" Linting configurations for ale {{{

let g:ale_set_highlights = 0
let g:ale_change_sign_column_color = 0
let g:ale_sign_column_always = 1
let g:ale_sign_error = '✖'
let g:ale_sign_warning = '⚠'
let g:ale_echo_msg_error_str = '✖'
let g:ale_echo_msg_warning_str = '⚠'
let g:ale_echo_msg_format = '%severity% %s% [%linter%% code%]'

let g:ale_linters = {
			\   'javascript': ['eslint', 'tsserver'],
			\   'typescript': ['tsserver', 'tslint'],
			\   'html': []
			\}
let g:ale_fixers = {}
let g:ale_fixers['javascript'] = ['prettier']
let g:ale_fixers['typescript'] = ['prettier', 'tslint']
let g:ale_fixers['json'] = ['prettier']
let g:ale_fixers['css'] = ['prettier']
let g:ale_fixers['scss'] = ['prettier']
let g:ale_javascript_prettier_use_local_config = 1
let g:ale_fix_on_save = 1

" }}}

" SilverSearcher for ack {{{

let g:ackprg = 'ag --nogroup --nocolor --column'
if executable('ag')
	let g:ackprg = 'ag --vimgrep'
endif

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

set relativenumber                                           " relative line numbers
set cursorline                                               " highlight the current line
set tags=./tags;/

filetype plugin indent on

if (has('nvim'))
	" show results of substition as they're happening
	" but don't open a split
	set inccommand=nosplit
endif

set backspace=indent,eol,start                               " make backspace behave in a sane manner

if has('mouse')
	set mouse=a
endif

set magic                                                    " Set magic on, for regex
set autoread                                                 " detect when a file is changed
set number                                                   " show line numbers
set wrap                                                     " turn on line wrapping
set wrapmargin=8                                             " wrap lines when coming within n characters from side
set linebreak                                                " set soft wrapping
set showbreak=…                                              " show ellipsis at breaking
set autoindent                                               " automatically set indent of new line
set ttyfast                                                  " faster redrawing
set diffopt+=vertical
set laststatus=2                                             " show the satus line all the time
set so=7                                                     " set 7 lines to the cursors - when moving vertical
set hidden                                                   " current buffer can be put into background
set noshowmode                                               " don't show which mode disabled for PowerLine
set scrolloff=3                                              " lines of text around cursor
set shell=$SHELL
set title                                                    " set terminal title
set showmatch                                                " show matching braces
set mat=2                                                    " how many tenths of a second to blink
set history=1000 " store more commands

" Searching
set ignorecase                                               " case insensitive searching
set smartcase                                                " case-sensitive if expresson contains a capital letter
set hlsearch                                                 " highlight search results
set incsearch                                                " set incremental search, like modern browsers
set nolazyredraw                                             " don't redraw while executing macros

" error bells
set noerrorbells
set visualbell
set t_vb=
set tm=500

" Tab control
set noexpandtab                                              " insert tabs rather than spaces for <Tab>
set smarttab                                                 " tab respects 'tabstop', 'shiftwidth', and 'softtabstop'
set tabstop=2                                                " the visible width of tabs
set softtabstop=2                                            " edit as if the tabs are 4 characters wide
set shiftwidth=2                                             " number of spaces to use for indent and unindent
set shiftround                                               " round indent to a multiple of 'shiftwidth'

" code folding settings
set foldmethod=syntax                                        " fold based on indent
set foldlevelstart=99
set foldnestmax=10                                           " deepest fold is 10 levels
set nofoldenable                                             " don't fold by default
set foldlevel=1

" Some servers have issues with backup files, see #649
set nobackup
set nowritebackup

" You will have bad experience for diagnostic messages when it's default 4000.
set updatetime=300

" don't give |ins-completion-menu| messages.
set shortmess+=c

" always show signcolumns
set signcolumn=yes

" toggle invisible characters
" set list
" set listchars=tab:→\ ,eol:¬,trail:⋅,extends:❯,precedes:❮
" set showbreak=↪

set colorcolumn=80

set ruler laststatus=2 showcmd showmode
set list listchars=trail:»,tab:»-
set fillchars+=vert:\
set breakindent
set formatprg=par\ -w72
set encoding=utf-8

set guicursor=n-v-c:block,i-ci-ve:ver25,r-cr:hor20,o:hor50
			\,a:blinkwait700-blinkoff400-blinkon250-Cursor/lCursor
			\,sm:block-blinkwait175-blinkoff150-blinkon175

" highlight conflicts
match ErrorMsg '^\(<\|=\|>\)\{7\}\([^=].\+\)\?$'

" make the highlighting of tabs and other non-text less annoying
highlight SpecialKey ctermfg=19 guifg=#333333
highlight NonText ctermfg=19 guifg=#333333

" make comments and HTML attributes italic
highlight Comment cterm=italic term=italic gui=italic
highlight htmlArg cterm=italic term=italic gui=italic
highlight xmlAttrib cterm=italic term=italic gui=italic

" vim-javascript settings
let g:javascript_plugin_flow = 1
let g:javascript_plugin_jsdoc = 1
let g:javascript_plugin_ngdoc = 1
augroup javascript_folding
    au!
    au FileType javascript setlocal foldmethod=syntax
augroup END

set conceallevel=1

let g:javascript_conceal_function             = "ƒ"
let g:javascript_conceal_null                 = "ø"
let g:javascript_conceal_this                 = "@"
let g:javascript_conceal_return               = "⇚"
let g:javascript_conceal_undefined            = "¿"
let g:javascript_conceal_NaN                  = "ℕ"
let g:javascript_conceal_prototype            = "¶"
let g:javascript_conceal_static               = "•"
let g:javascript_conceal_super                = "Ω"
let g:javascript_conceal_arrow_function       = "⇒"
let g:javascript_conceal_noarg_arrow_function = "🞅"
let g:javascript_conceal_underscore_arrow_function = "🞅"

augroup filetype javascript syntax=javascript

" }}}

" Prettier Configurations {{{

" Automatically comb your CSS on save
autocmd BufWritePre,FileWritePre *.css,*.less,*.scss,*.sass silent! :CSScomb

nmap <Leader>p <Plug>(Prettier)

let g:prettier#autoformat = 0
autocmd BufWritePre *.js,*.jsx,*.mjs,*.ts,*.tsx,*.css,*.less,*.scss,*.json,*.graphql,*.md,*.vue,*.yaml,*.html,*.yml Prettier

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
let g:prettier#config#jsx_bracket_same_line = 'false'

" avoid|always
" Prettier default: avoid
let g:prettier#config#arrow_parens = 'avoid'

" html whitespace sensitivity
let g:prettier#config#html_whitespace_sensitivity = 'ignore'

" none|es5|all
" Prettier default: none
let g:prettier#config#trailing_comma = 'all'

" flow|babylon|typescript|css|less|scss|json|graphql|markdown
" Prettier default: babylon
let g:prettier#config#parser = 'babel'

" cli-override|file-override|prefer-file
let g:prettier#config#config_precedence = 'cli-override'

" always|never|preserve
let g:prettier#config#prose_wrap = 'preserve'

" }}}

" Filetype Specific Configurations {{{

""" HTML, XML, Jinja

" vim-closetag plugin settings
let g:closetag_filenames = '*.html,*.xhtml,*.phtml'
let g:closetag_filetypes = 'html,xhtml,phtml'
let g:closetag_xhtml_filetypes = 'xhtml,jsx'

autocmd FileType html setlocal shiftwidth=2 tabstop=2 softtabstop=2
autocmd FileType xml setlocal shiftwidth=2 tabstop=2 softtabstop=2
autocmd FileType htmldjango setlocal shiftwidth=2 tabstop=2 softtabstop=2
autocmd FileType htmldjango inoremap {{ {{  }}<left><left><left>
autocmd FileType htmldjango inoremap {% {%  %}<left><left><left>
autocmd FileType htmldjango inoremap {# {#  #}<left><left><left>

""" Markdown and Journal
autocmd FileType markdown setlocal shiftwidth=2 tabstop=2 softtabstop=2
autocmd FileType journal setlocal shiftwidth=2 tabstop=2 softtabstop=2

""" Yaml files
au! BufNewFile,BufReadPost *.{yaml,yml} set filetype=yaml foldmethod=indent
autocmd FileType yaml setlocal ts=2 sts=2 sw=2 expandtab

" }}}
