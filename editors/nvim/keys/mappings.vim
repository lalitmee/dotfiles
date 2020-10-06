let mapleader=" "
cnoremap <C-p> <Up>
cnoremap <C-n> <Down>
" count the current matched number
nmap <leader>* *<c-o>:%s///gn<cr>
nmap <leader>u :PlugUpdate<CR>
nmap <leader>cl :PlugClean<CR>
nmap \ <leader>q<Leader>w
nmap <leader>r :so ~/.config/nvim/init.vim<CR>
nmap <leader>e :e ~/.config/nvim/init.vim<CR>

" select whole file text in visual mode
map <C-c> <esc>ggVG<CR>

" scroll the viewport faster
nnoremap <C-e> 3<C-e>
nnoremap <C-y> 3<C-y>
nmap <leader>th <C-w>s<C-w>j:terminal<CR>
nmap <leader>tv <C-w>v<C-w>l:terminal<CR>
nmap <leader>h :RainbowParentheses!!<CR>

" Allow saving of files as sudo when I forgot to start vim using sudo.
" http://stackoverflow.com/questions/2600783/how-does-the-vim-write-with-sudo-trick-work
cmap w!! %!sudo tee > /dev/null %

" save
noremap <silent> <leader>fs :w<CR>
noremap <silent> <leader>, :w<CR>

" clear highlighted search
nnoremap <CR> :noh<CR><CR>

" exit or quit with leader
noremap <silent> <leader>x :q<cr>

" For putting the file name in insert mode on the current position of cursor
" from Derek Wyatt
imap <leader>fn <c-r>=expand('%:t:r')<cr>

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

" I hate escape more than anything else
inoremap jk <Esc>
inoremap kj <Esc>

" Easy CAPS
inoremap <c-u> <ESC>viwUi
nnoremap <c-u> viwU<Esc>

" Better tabbing
vnoremap < <gv
vnoremap > >gv

nnoremap <leader>o o<Esc>^Da
nnoremap <leader>O O<Esc>^Da

""" repeat `n.` after editing the searched word
nnoremap Q @='n.'<CR>

" yank all lines of a file
nnoremap <leader>yl :%y<CR>


" Edit command to remove the last file name of the current directory {{{
map <leader>ew :e <C-R>=expand("%:p:h") . "/" <CR>
map <leader>es :sp <C-R>=expand("%:p:h") . "/" <CR>
map <leader>ev :vsp <C-R>=expand("%:p:h") . "/" <CR>
map <leader>et :tabe <C-R>=expand("%:p:h") . "/" <CR>
