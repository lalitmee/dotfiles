let mapleader=" "
cnoremap <C-p> <Up>
cnoremap <C-n> <Down>
" count the current matched number
" nmap <silent> <leader>u :PlugUpdate<CR>
" nmap <silent> <leader>cl :PlugClean<CR>
" nmap <silent> <leader>r :so ~/.config/nvim/init.vim<CR>
" nmap <silent> <leader>e :e ~/.config/nvim/init.vim<CR>

" select whole file text in visual mode
map <C-c> <esc>ggVG<CR>

" scroll the viewport faster
nnoremap <C-e> 3<C-e>
nnoremap <C-y> 3<C-y>
" turn terminal to normal mode with escape
tnoremap <Esc> <C-\><C-n>
tnoremap <silent> <C-[><C-[> <C-\><C-n>
" nmap <leader>th <C-w>s<C-w>j:terminal<CR>
" nmap <leader>tv <C-w>v<C-w>l:terminal<CR>

" Allow saving of files as sudo when I forgot to start vim using sudo.
" http://stackoverflow.com/questions/2600783/how-does-the-vim-write-with-sudo-trick-work
cmap w!! %!sudo tee > /dev/null %

" save
" noremap <silent> <leader>fs :w<CR>
" noremap <silent> <leader>, :w<CR>

" clear highlighted search
nnoremap <silent> <CR> :noh<CR><CR>

" exit or quit with leader
" noremap <silent> <leader>x :q<cr>

" For putting the file name in insert mode on the current position of cursor
" from Derek Wyatt
" imap <leader>fn <c-r>=expand('%:t:r')<cr>

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

" " Easy CAPS
" inoremap <c-u> <ESC>viwUi
" nnoremap <c-u> viwU<Esc>

" Better tabbing
vnoremap < <gv
vnoremap > >gv

" nnoremap <leader>o o<Esc>^Da
" nnoremap <leader>O O<Esc>^Da

""" repeat `n.` after editing the searched word
nnoremap Q @='n.'<CR>


" Neovim Terminal Settings
" Got it from here: https://www.reddit.com/r/neovim/comments/cger8p/how_quickly_close_a_terminal_buffer/eupal7q?utm_source=share&utm_medium=web2x&context=3
augroup terminal_settings
  autocmd!

  autocmd BufWinEnter,WinEnter term://* startinsert
  autocmd BufLeave term://* stopinsert

  " Ignore various filetypes as those will close terminal automatically
  " Ignore fzf, ranger, coc
  autocmd TermClose term://*
        \ if (expand('<afile>') !~ "fzf") && (expand('<afile>') !~ "ranger") && (expand('<afile>') !~ "coc") |
        \   call nvim_input('<CR>')  |
        \ endif
augroup END

" Terminal key mappings
if has('nvim')
  tnoremap <Esc> <C-\><C-n>
  tnoremap <M-[> <Esc>
  tnoremap <C-v><Esc> <Esc>
  " Terminal mode:
  tnoremap <M-h> <c-\><c-n><c-w>h
  tnoremap <M-j> <c-\><c-n><c-w>j
  tnoremap <M-k> <c-\><c-n><c-w>k
  tnoremap <M-l> <c-\><c-n><c-w>l
  " Insert mode:
  inoremap <M-h> <Esc><c-w>h
  inoremap <M-j> <Esc><c-w>j
  inoremap <M-k> <Esc><c-w>k
  inoremap <M-l> <Esc><c-w>l
  " Visual mode:
  vnoremap <M-h> <Esc><c-w>h
  vnoremap <M-j> <Esc><c-w>j
  vnoremap <M-k> <Esc><c-w>k
  vnoremap <M-l> <Esc><c-w>l
  " Normal mode:
  nnoremap <M-h> <c-w>h
  nnoremap <M-j> <c-w>j
  nnoremap <M-k> <c-w>k
  nnoremap <M-l> <c-w>l
  " pasting from registers in terminal
  tnoremap <expr> <A-r> '<C-\><C-N>"'.nr2char(getchar()).'pi'
endif

" transpose characters using repeat.vim
" picked from http://vimcasts.org/episodes/creating-repeatable-mappings-with-repeat-vim/
nnoremap <silent> <Plug>TransposeCharacters xp
      \ :call repeat#set("\<Plug>TransposeCharacters")<CR>
nmap cp <Plug>TransposeCharacters


" populate args list with only those files which have matching text in them
command! -nargs=0 -bar Qargs execute 'args' QuickfixFilenames()
function! QuickfixFilenames()
  " Building a hash ensures we get each buffer only once
  let buffer_numbers = {}
  for quickfix_item in getqflist()
    let buffer_numbers[quickfix_item['bufnr']] = bufname(quickfix_item['bufnr'])
  endfor
  return join(map(values(buffer_numbers), 'fnameescape(v:val)'))
endfunction

" Start interactive EasyAlign in visual mode (e.g. vipga)
xmap ga <Plug>(EasyAlign)

" Start interactive EasyAlign for a motion/text object (e.g. gaip)
nmap ga <Plug>(EasyAlign)

" count number of lines in visual mode
vmap L  g<C-g>

" search and replace the word under cursor
nmap <leader>* :%s/<C-r><C-w>//<Left>
