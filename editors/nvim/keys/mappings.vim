let mapleader=" "

" General keymappings {{{

" count number of lines in visual mode
vmap L  g<C-g>

cnoremap <C-n> <Down>
cnoremap <C-p> <Up>

" select whole file text in visual mode
map <C-c> <esc>ggVG<CR>

" turn terminal to normal mode with escape
tnoremap <buffer><nowait> <Esc> <C-\><C-n>
tnoremap <silent> <C-[><C-[> <C-\><C-n>

" Allow saving of files as sudo when I forgot to start vim using sudo.
" http://stackoverflow.com/questions/2600783/how-does-the-vim-write-with-sudo-trick-work
cmap w!! %!sudo tee > /dev/null %

" clear highlighted search
nnoremap <silent> <CR> :noh<CR><CR>

" resize panes
nnoremap <silent> <Right> :vertical resize +5<cr>
nnoremap <silent> <Left> :vertical resize -5<cr>
nnoremap <silent> <Up> :resize +5<cr>
nnoremap <silent> <Down> :resize -5<cr>

""" move line up and down using topope vim-unimpaired
" Bubble single lines
nmap <S-Up> [e
nmap <S-Down> ]e
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


" }}}

" Neovim Terminal Settings {{{

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

" }}}

" Transpose characters xp {{{

" picked from http://vimcasts.org/episodes/creating-repeatable-mappings-with-repeat-vim/
nnoremap <silent> <Plug>TransposeCharacters xp
      \ :call repeat#set("\<Plug>TransposeCharacters")<CR>
nmap cp <Plug>TransposeCharacters

"}}}

" EasyAlign {{{

" Start interactive EasyAlign in visual mode (e.g. vipga)
xmap ga <Plug>(EasyAlign)

" Start interactive EasyAlign for a motion/text object (e.g. gaip)
nmap ga <Plug>(EasyAlign)

" }}}

" function! s:conditional_nnoremap ( name )
"     if maparg(a:name, 'n') == ""
"         execute 'nnoremap  <unique> ' . a:name . ' ' . a:name
"     endif
" endfunction
" call s:conditional_nnoremap( "g'" )
" call s:conditional_nnoremap( 'g#' )
" call s:conditional_nnoremap( 'g$' )
" call s:conditional_nnoremap( 'g&' )
" call s:conditional_nnoremap( 'g*' )
" call s:conditional_nnoremap( 'g,' )
" call s:conditional_nnoremap( 'g0' )
" call s:conditional_nnoremap( 'g8' )
" call s:conditional_nnoremap( 'g;' )
" call s:conditional_nnoremap( 'g<' )
" call s:conditional_nnoremap( 'g<C-G>' )
" call s:conditional_nnoremap( 'g<C-H>' )
" call s:conditional_nnoremap( 'g<C-]>' )
" call s:conditional_nnoremap( 'g<Down>' )
" call s:conditional_nnoremap( 'g<End>' )
" call s:conditional_nnoremap( 'g<Home>' )
" call s:conditional_nnoremap( 'g<LeftMouse>' )
" call s:conditional_nnoremap( 'g<MiddleMouse>' )
" call s:conditional_nnoremap( 'g<RightMouse>' )
" call s:conditional_nnoremap( 'g<Up>' )
" call s:conditional_nnoremap( 'g?' )
" call s:conditional_nnoremap( 'g??' )
" call s:conditional_nnoremap( 'g?g?' )
" call s:conditional_nnoremap( 'g@' )
" call s:conditional_nnoremap( 'gD' )
" call s:conditional_nnoremap( 'gE' )
" call s:conditional_nnoremap( 'gF' )
" call s:conditional_nnoremap( 'gH' )
" call s:conditional_nnoremap( 'gI' )
" call s:conditional_nnoremap( 'gJ' )
" call s:conditional_nnoremap( 'gP' )
" call s:conditional_nnoremap( 'gR' )
" call s:conditional_nnoremap( 'gU' )
" call s:conditional_nnoremap( 'gUU' )
" call s:conditional_nnoremap( 'gUgU' )
" call s:conditional_nnoremap( 'gV' )
" call s:conditional_nnoremap( 'g]' )
" call s:conditional_nnoremap( 'g^' )
" call s:conditional_nnoremap( 'g`' )
" call s:conditional_nnoremap( 'ga' )
" call s:conditional_nnoremap( 'gd' )
" call s:conditional_nnoremap( 'ge' )
" call s:conditional_nnoremap( 'gf' )
" call s:conditional_nnoremap( 'gg' )
" call s:conditional_nnoremap( 'gh' )
" call s:conditional_nnoremap( 'gi' )
" call s:conditional_nnoremap( 'gj' )
" call s:conditional_nnoremap( 'gk' )
" call s:conditional_nnoremap( 'gm' )
" call s:conditional_nnoremap( 'go' )
" call s:conditional_nnoremap( 'gp' )
" call s:conditional_nnoremap( 'gq' )
" call s:conditional_nnoremap( 'gr' )
" call s:conditional_nnoremap( 'gs' )
" call s:conditional_nnoremap( 'gu' )
" call s:conditional_nnoremap( 'gugu' )
" call s:conditional_nnoremap( 'guu' )
" call s:conditional_nnoremap( 'gv' )
" call s:conditional_nnoremap( 'gw' )
" call s:conditional_nnoremap( 'g~' )
" call s:conditional_nnoremap( 'g~g~' )
" call s:conditional_nnoremap( 'g~~' )
" call s:conditional_nnoremap( 'gx' )

" " Make gn jump into visual block mode, instead if plain visual mode
" nnoremap gn  gn<C-V>

"}}}


