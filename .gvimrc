" GVim Configurations
"
" filetype indent
filetype indent on

" Shortcut to save
nmap <leader>, :w<cr>

" make backspace behave in a sane manner
set backspace=indent,eol,start

syntax on

" Buffers command
map <S-Tab> :bprevious<CR>
map <Tab> :bnext<CR>

" open help vertically
command! -nargs=* -complete=help Help vertical belowright help <args>
autocmd FileType help wincmd L

" Better split switching
map <C-j> <C-W>j
map <C-k> <C-W>k
map <C-h> <C-W>h
map <C-l> <C-W>l

""" files
set path+=**

""" for making ctags
command! MakeTags !ctags -R .

set undofile
set undodir=~/.vim/undodir

" ----------------------------------------- "
" File Type settings                        "
" ----------------------------------------- "

au BufNewFile,BufRead *.vim setlocal noet ts=4 sw=4 sts=4
au BufNewFile,BufRead *.txt setlocal noet ts=4 sw=4
au BufNewFile,BufRead *.md setlocal nospell noet ts=4 sw=4
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

" Mark Multiple in vim key binding
let g:mark_multiple_trigger = "<C-m>"

" switch between current and last buffer
nmap <leader>. <c-^>

" let g:gfm_syntax_enable_filetypes = ['markdown.gfm']
autocmd BufRead,BufNewFile {*.markdown,*.mdown,*.mkdn,*.md,*.mkd,*.mdwn,*.mdtxt,*.mdtext,*.text} set filetype=markdown
autocmd FileType markdown setlocal nospell


" enable . command in visual mode
vnoremap . :normal .<cr>


" Indenting
map <C-j> mzgg=G`z

" Only window command
nnoremap <leader>on :on<cr>

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
set guifont=Monaco\ Regular\ 13


" Make shift-insert work like in Xterm
map <S-Insert> <MiddleMouse>
map! <S-Insert> <MiddleMouse>
" Paste in insert mode
imap <C-v> <ESC>"+pa

" enabling tabline
let g:airline#extensions#tabline#enabled = 1

" disabling folding in markdown
" markdown syntax highlighting
"set syntax=markdown
"let g:gfm_syntax_enable_always = 0
"let g:gfm_syntax_enable_filetypes = ['markdown.gfm']
"autocmd BufRead,BufNew,BufNewFile README.md setlocal ft=markdown.gfm

colorscheme gruvbox

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

set textwidth=80
set colorcolumn=+1



" Remove selected Highlight
"nnoremap <C-h> :noh<CR>

" clear highlighted search
noremap b :set hlsearch! hlsearch?<cr>


" Pretteir configurations
nmap <Leader>p <Plug>(Prettier)
"let g:prettier#autoformat = 0
"autocmd BufWritePre *.js,*.jsx,*.mjs,*.ts,*.tsx,*.css,*.less,*.scss,*.json,*.graphql,*.md, *.vue Prettier
let g:prettier#exec_cmd_path = "/home/lalit/.npm-global/bin/prettier"
let g:prettier#quickfix_enabled = 0
" max line length that prettier will wrap on
" Prettier default: 80
let g:prettier#config#print_width = 80

" number of spaces per indentation level
" Prettier default: 2
let g:prettier#config#tab_width = 4

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

" after a re-source, fix syntax matching issues (concealing brackets):
if exists('g:loaded_webdevicons')
    call webdevicons#refresh()
endif


" Edit the gvimrc files
nmap <leader>eg :e $MYGVIMRC<CR>
nmap <leader>sg :so $MYGVIMRC<CR>
nmap <leader>ev :e ~/.oh-my-vim/vimrc<CR>
nmap <leader>sv :so $MYVIMRC<CR>


""" move line up and down using topope vim-unimpaired
" Bubble single lines
nmap <C-Up> [e
nmap <C-Down> ]e
" Bubble multiple lines
vmap <C-Up> [egv
vmap <C-Down> ]egv


