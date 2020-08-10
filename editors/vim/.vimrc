" Configurations

" Vim-Plug Plugins {{{

" source ~/.config/nvim/init.vim

call plug#begin()

" Plugins {{{

" Colorizer for showing the colors
Plug 'norcalli/nvim-colorizer.lua'

" fancy start Screen for vim
Plug 'mhinz/vim-startify'

" Moving in vim inside Tmux
Plug 'christoomey/vim-tmux-navigator'

" Instant markdown preview from vim
Plug 'suan/vim-instant-markdown'

" toggle, display and navigate marks
Plug 'kshenoy/vim-signature'

" Better search highlighting
Plug 'haya14busa/incsearch.vim'

" Better HTML Editing
Plug 'Raimondi/delimitMate'

" SilverSearcher
Plug 'mileszs/ack.vim'

" lightweight statusline for vim
Plug 'itchyny/lightline.vim'

" vim icons
Plug 'ryanoasis/vim-devicons'

" for handling swap files
Plug 'gioele/vim-autoswap'

" for renaming the current buffer
Plug 'danro/rename.vim'

" for jumping
Plug 'easymotion/vim-easymotion'

" File Management using ranger
Plug 'francoiscabrol/ranger.vim'
Plug 'rbgrouleff/bclose.vim'

" Colors
Plug 'gruvbox-community/gruvbox'

" Completion Conquerer
Plug 'neoclide/coc.nvim', {'branch': 'release'}

" Pairs of handy bracket mappings
Plug 'tpope/vim-unimpaired'

" easily search for, substitute, and abbreviate multiple variants of a word
Plug 'tpope/vim-abolish'

" Surround Plugin for brackets and more
Plug 'tpope/vim-surround'

" Version Control in Vim
Plug 'tpope/vim-fugitive'

" Vim sugar for the UNIX shell commands that need it the most
" Example: :Delete, :Unlink, :Move, etc
Plug 'tpope/vim-eunuch'

" comment stuff out
Plug 'tpope/vim-commentary'

" Tabularize for Vim
" Vim script for text filtering and alignment
Plug 'godlygeek/tabular'

" Snippets in Vim
Plug 'SirVer/ultisnips'
Plug 'honza/vim-snippets'

" Magit like emacs for git workflow
Plug 'jreybert/vimagit'

" Show tags bar
Plug 'majutsushi/tagbar'

" Auto paris of brackets
Plug 'jiangmiao/auto-pairs'

" Auto Close Tag in HTML
Plug 'vim-scripts/closetag.vim'
Plug 'alvan/vim-closetag'

" Easy Alignment in vim
Plug 'junegunn/vim-easy-align'

" Indent Lines made beautiful
Plug 'Yggdroot/indentLine'

"
Plug 'sheerun/vim-polyglot'

" The interactive scratchpad for hackers.
Plug 'metakirby5/codi.vim'

Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'
Plug 'airblade/vim-rooter'

" }}}

call plug#end()

" Ranger Settings {{{{

let g:ranger_map_keys = 0

" }}}}

" Colors Settings {{{

colorscheme gruvbox
set background=dark

" lightline theme
let g:lightline = {
      \ 'colorscheme': 'gruvbox',
      \ }


let $NVIM_TUI_ENABLE_TRUE_COLOR=1
highlight Pmenu guibg=LightYellow1 guifg=black
highlight Comment cterm=italic
"highlight Comment gui=none
"highlight Normal gui=none
"highlight NonText guibg=none

" }}}

" C language Settings {{{

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

" FZF settings {{{


let g:fzf_tags_command = 'ctags -R'
" Border color
let g:fzf_layout = {'up':'~90%', 'window': { 'width': 0.8, 'height': 0.8,'yoffset':0.5,'xoffset': 0.5, 'highlight': 'Todo', 'border': 'sharp' } }

set wildmode=list:longest,list:full
set wildignore+=*.o,*.obj,.git,*.rbc,*.pyc,__pycache__
let $FZF_DEFAULT_COMMAND =  "find * -path '*/\.*' -prune -o -path 'node_modules/**' -prune -o -path 'target/**' -prune -o -path 'dist/**' -prune -o  -type f -print -o -type l -print 2> /dev/null"

" Get text in files with Rg
command! -bang -nargs=* Rg
  \ call fzf#vim#grep(
  \   'rg --column --line-number --no-heading --color=always --smart-case '.shellescape(<q-args>), 1,
  \   fzf#vim#with_preview(), <bang>0)

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
let g:fzf_command_prefix='Fzf'
nnoremap <silent> <leader>pf :FZF<CR>
nnoremap <silent> <leader>pb :FzfBuffers<CR>
nnoremap <silent> <leader>gf :FzfGFiles<CR>
nnoremap <silent> <leader>ll :FzfLines<CR>
nnoremap <silent> <leader>bl :FzfBLines<CR>
nnoremap <silent> <leader>tt :FzfTags<CR>
nnoremap <silent> <leader>bt :FzfBTags<CR>
nnoremap <silent> <leader>fl :FzfLocate<space>
nnoremap <silent> <leader>mm :FzfMarks<CR>
nnoremap <silent> <leader>ww :FzfWindows<CR>
nnoremap <silent> <leader>ss :FzfSnippets<CR>
nnoremap <silent> <leader>cm :FzfCommits<CR>
nnoremap <silent> <leader>cb :FzfBCommits<CR>
nnoremap <silent> <leader>co :FzfCommands<CR>
nnoremap <silent> <leader>mp :FzfMaps<CR>
nnoremap <silent> <leader>ht :FzfHelpTags<CR>
nnoremap <silent> <leader>ag :FzfAg<CR>
nnoremap <silent> <leader>rg :FzfRg<CR>
nnoremap <silent> <leader>cc :FzfColors<CR>
nnoremap <silent> <leader>hh :FzfHistory<CR>
nnoremap <silent> <leader>hc :FzfHistory:<CR>
nnoremap <silent> <leader>hs :FzfHistory/<CR>

"Recovery commands from history through FZF
nmap <leader>y :History:<CR>

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

" }}}

" Abbreviations{{{ "

abbr funciton function
abbr teh the
abbr tempalte template
abbr fitler filter
abbr cosnt const
abbr attribtue attribute
abbr attribuet attribute
abbr reciever receiver

" }}} Abbreviations "

" coc.nvim settins {{{

" Prettier command for coc-prettier
command! -nargs=0 Prettier :CocCommand prettier.formatFile

let g:coc_global_extensions = [
				\ 'coc-css',
				\ 'coc-dictionary',
				\ 'coc-emmet',
				\ 'coc-eslint',
				\ 'coc-git',
				\ 'coc-gitignore',
				\ 'coc-go',
				\ 'coc-gocode',
				\ 'coc-highlight',
				\ 'coc-html',
				\ 'coc-json',
				\ 'coc-lists',
				\ 'coc-neosnippet',
				\ 'coc-pairs',
				\ 'coc-prettier',
				\ 'coc-python',
				\ 'coc-sh',
				\ 'coc-smartf',
				\ 'coc-snippets',
				\ 'coc-svg',
				\ 'coc-ultisnips',
				\ 'coc-vimlsp',
				\ 'coc-xml',
				\ 'coc-yaml',
				\ 'coc-yank',
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

nmap <expr> <silent> <C-A-d> <SID>select_current_word()
function! s:select_current_word()
  if !get(g:, 'coc_cursors_activated', 0)
    return "\<Plug>(coc-cursors-word)"
  endif
  return "*\<Plug>(coc-cursors-word):nohlsearch\<CR>"
endfunc

" Highlight symbol under cursor on CursorHold
autocmd CursorHold * silent call CocActionAsync('highlight')

" Remap for rename current word
nmap <silent> <F2> <Plug>(coc-rename)

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
nnoremap <silent> <leader>ld  :<C-u>CocList diagnostics<cr>
" Manage extensions
nnoremap <silent> <leader>le  :<C-u>CocList extensions<cr>
" Show commands
nnoremap <silent> <leader>lc  :<C-u>CocList commands<cr>
" Find symbol of current document
nnoremap <silent> <leader>lo  :<C-u>CocList outline<cr>
" Search workspace symbols
nnoremap <silent> <leader>ls  :<C-u>CocList -I symbols<cr>
" Do default action for next item.
nnoremap <silent> <leader>ln  :<C-u>CocNext<CR>
" Do default action for previous item.
nnoremap <silent> <leader>lp  :<C-u>CocPrev<CR>
" Resume latest coc list
nnoremap <silent> <leader>lr  :<C-u>CocListResume<CR>

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

" Coloring {{{

syntax on
set bg=dark
set noswapfile
set guioptions=egmrti
" set guifont=Ubuntu\ Mono\ 12
set guifont=UbuntuMono\ Nerd\ Font\ 12

" Opaque Background (Comment out to use terminal's profile)
set termguicolors

""" for planelight theme
if (has("nvim"))
	"For Neovim 0.1.3 and 0.1.4 < https://github.com/neovim/neovim/pull/2198 >
	let $NVIM_TUI_ENABLE_TRUE_COLOR=1
endif

" }}}

" Open help in vertical split {{{

augroup vimrc_help
	autocmd!
	autocmd BufEnter *.txt if &buftype == 'help' | wincmd L | endif
augroup END

" }}}

" Converting Markdown to html OR HTML to Markdown {{{

if has("autocmd")
	let pandoc_pipeline  = "pandoc --from=html --to=markdown"
	let pandoc_pipeline .= " | pandoc --from=markdown --to=html"
	autocmd FileType html let &l:formatprg=pandoc_pipeline
endif

" }}}

" Neovim :Terminal {{{

autocmd BufWinEnter,WinEnter term://* startinsert
autocmd BufLeave term://* stopinsert

" }}}

" Supertab {{{

let g:SuperTabClosePreviewOnPopupClose = 1
let g:SuperTabDefaultCompletionType = "<C-n>"

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

fun! TrimWhitespace()
    let l:save = winsaveview()
    keeppatterns %s/\s\+$//e
    call winrestview(l:save)
endfun

autocmd BufWritePre * :call TrimWhitespace()

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

" goneovim key mappings {{{

" nmap <Leader>pf :GonvimFuzzyFiles<CR>
" nmap <Leader>pb :GonvimFuzzyBuffers<CR>
" nmap <Leader>pl :GonvimFuzzyBLines<CR>
" nmap <Leader>/ :GonvimFuzzyAg<CR>
" nmap <Leader>r/ :GonvimFuzzyResume<CR>

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
" count the current matched number
nmap <Leader>* *<c-o>:%s///gn<cr>
nmap <Leader>u :PlugUpdate<CR>
nmap <Leader>cl :PlugClean<CR>
nmap <Leader>w :TagbarToggle<CR>
nmap \ <Leader>q<Leader>w
nmap <Leader>r :so ~/.vimrc<CR>
nmap <Leader>e :e ~/.vimrc<CR>

" select whole file text in visual mode
map <C-c> <esc>ggVG<CR>

" scroll the viewport faster
nnoremap <C-e> 3<C-e>
nnoremap <C-y> 3<C-y>
nmap <Leader>th <C-w>s<C-w>j:terminal<CR>
nmap <Leader>tv <C-w>v<C-w>l:terminal<CR>
nmap <Leader>h :RainbowParentheses!!<CR>
autocmd FileType python nmap <Leader>x :0,$!~/.config/nvim/env/bin/python -m yapf<CR>

" Allow saving of files as sudo when I forgot to start vim using sudo.
" http://stackoverflow.com/questions/2600783/how-does-the-vim-write-with-sudo-trick-work
cmap w!! %!sudo tee > /dev/null %

" save
noremap <silent> <Leader>, :w<CR>

" clear highlighted search
noremap <silent> <Leader>h :set hlsearch! hlsearch?<cr>
nnoremap <CR> :noh<CR><CR>

" exit or quit with leader
noremap <silent> <Leader>x :q<cr>

" For putting the file name in insert mode on the current position of cursor
" from Derek Wyatt
imap <Leader>fn <c-r>=expand('%:t:r')<cr>


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
nnoremap <leader>v <C-w>v
nnoremap sh <C-w>S

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

" Tmux Resizing and ballancing {{{

" automatically rebalance windows on vim resize
autocmd VimResized * :wincmd =

" zoom a vim pane, <C-w>= to re-balance
nnoremap <leader>- :wincmd _<cr>:wincmd \|<cr>
nnoremap <leader>= :wincmd =<cr>

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

" trigger easymotion
map <Leader>j <Plug>(easymotion-prefix)

" <Leader>f{char} to move to {char}
map  <Leader>ff <Plug>(easymotion-bd-f)
nmap <Leader>fw <Plug>(easymotion-overwin-f)

" s{char}{char} to move to {char}{char}
nmap s <Plug>(easymotion-overwin-f2)
nmap t <Plug>(easymotion-t2)

"" Move to line
map <Leader>jli <Plug>(easymotion-bd-jk)
nmap <Leader>jlo <Plug>(easymotion-overwin-line)

"" Move to word
map  <Leader>wi <Plug>(easymotion-bd-w)
nmap <Leader>wo <Plug>(easymotion-overwin-w)

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

set relativenumber                      " relative line numbers
set cursorline                          " highlight the current line
set tags=./tags;/
set clipboard=unnamedplus               " Paste from system clipboard
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
set showbreak=…                         " show ellipsis at breaking
set autoindent                          " automatically set indent of new line
set ttyfast                             " faster redrawing
set diffopt+=vertical
set laststatus=2                        " show the satus line all the time
set so=7                                " set 7 lines to the cursors - when moving vertical
set hidden                              " current buffer can be put into background
set noshowmode                          " don't show which mode disabled for PowerLine
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

" error bells
set noerrorbells
set visualbell
set t_vb=
set tm=500

" Tab control
set noexpandtab                         " insert tabs rather than spaces for <Tab>
set smarttab                            " tab respects 'tabstop', 'shiftwidth', and 'softtabstop'
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

augroup filetype javascript syntax=javascript

" }}}

" Startify Settings {{{

" returns all modified files of the current git repo
" `2>/dev/null` makes the command fail quietly, so that when we are not
" in a git repo, the list will be empty
function! s:gitModified()
    let files = systemlist('git ls-files -m 2>/dev/null')
    return map(files, "{'line': v:val, 'path': v:val}")
endfunction

" same as above, but show untracked files, honouring .gitignore
function! s:gitUntracked()
    let files = systemlist('git ls-files -o --exclude-standard 2>/dev/null')
    return map(files, "{'line': v:val, 'path': v:val}")
endfunction

let g:startify_lists = [
        \ { 'type': 'files',     'header': ['   Recent Files']            },
        \ { 'type': 'dir',       'header': ['   Current Dir Files '. getcwd()] },
        \ { 'type': 'sessions',  'header': ['   Sessions']       },
        \ { 'type': 'bookmarks', 'header': ['   Bookmarks']      },
        \ { 'type': function('s:gitModified'),  'header': ['   git modified']},
        \ { 'type': function('s:gitUntracked'), 'header': ['   git untracked']},
        \ { 'type': 'commands',  'header': ['   Commands']       },
        \ ]

let g:startify_session_dir = '~/.config/nvim/session'

let g:startify_session_autoload = 1
let g:startify_session_delete_buffers = 1
let g:startify_change_to_vcs_root = 1
let g:startify_fortune_use_unicode = 1
let g:startify_session_persistence = 1

let g:webdevicons_enable_startify = 1

let g:startify_bookmarks = [
            \ { 'i': '~/.config/nvim/init.vim' },
            \ { 'z': '~/.zshrc' },
            \ ]

let g:startify_enable_special = 0

"}}}

"Filetype Specific Configurations {{{

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
