" GVim Configurations


" window size of Gvim
set lines=64
set columns=120

" font face and font size
set gfn=Ubuntu\ Mono\ 14

" Make shift-insert work like in Xterm
map <S-Insert> <MiddleMouse>
map! <S-Insert> <MiddleMouse>
" Paste in insert mode
imap <C-v> <ESC>"+pa

" enabling tabline
let g:airline#extensions#tabline#enabled = 1

" disabling folding in markdown
let g:vim_markdown_folding_disabled = 1

" markdown syntax highlighting
set syntax=markdown
let g:gfm_syntax_enable_always = 0
let g:gfm_syntax_enable_filetypes = ['markdown.gfm']
autocmd BufRead,BufNew,BufNewFile README.md setlocal ft=markdown.gfm


" Nerd Tree Toggle by ,ne
let mapleader = ","
nmap <leader>ne :NERDTree<cr>

