" Snippets from vim-help
" Credits: https://github.com/dahu/vim-help

let s:save_cpo = &cpoptions
set cpoptions&vim

function! s:setup_buffer()
  let b:undo_ftplugin .= ' | setlocal spell< list< hidden< iskeyword<'
        \ . " | execute 'nunmap <buffer> <CR>'"
        \ . " | execute 'nunmap <buffer> <BS>'"
        \ . " | execute 'nunmap <buffer> o'"
        \ . " | execute 'nunmap <buffer> O'"
        \ . " | execute 'nunmap <buffer> f'"
        \ . " | execute 'nunmap <buffer> F'"
        \ . " | execute 'nunmap <buffer> t'"
        \ . " | execute 'nunmap <buffer> T'"
        \ . " | execute 'nunmap <buffer> <leader>j'"
        \ . " | execute 'nunmap <buffer> <leader>k'"
        \ . " | execute 'nunmap <buffer> q'"

  setlocal nospell
  setlocal nolist
  setlocal nohidden
  setlocal iskeyword+=:
  setlocal iskeyword+=#
  setlocal iskeyword+=-

  " unsilent echomsg 'help edit' &ft bufname() 'type:' &buftype

  if s:count_windows() - 1 > 1
    wincmd K
  else
    wincmd L
  endif

  " Exit help window with 'q'
  nnoremap <silent><buffer> q :quit<CR>

  " Jump to links with enter
  nmap <buffer> <CR> <C-]>

  " Jump back with backspace
  nmap <buffer> <BS> <C-T>

  " Skip to next option link
  nmap <buffer> o /'[a-z]\{2,\}'<CR>

  " Skip to previous option link
  nmap <buffer> O ?'[a-z]\{2,\}'<CR>

  " find the next subject
  nnoremap <buffer> s /\|\zs\S\+\ze\|<CR>

  " find the previous subject
  nnoremap <buffer> S ?\|\zs\S\+\ze\|<CR>

  " Skip to next subject link
  nmap <buffer><nowait> f /\|\S\+\|<CR>l

  " Skip to previous subject link
  nmap <buffer> F h?\|\S\+\|<CR>l

  " Skip to next tag (subject anchor)
  nmap <buffer> t /\*\S\+\*<CR>l

  " Skip to previous tag (subject anchor)
  nmap <buffer> T h?\*\S\+\*<CR>l

  " Skip to next/prev quickfix list entry (from a helpgrep)
  nmap <buffer> <leader>j :cnext<CR>
  nmap <buffer> <leader>k :cprev<CR>
endfunction

" Count tab page windows
function! s:count_windows()
  let l:count = 0
  let l:tabnr = tabpagenr()
  let l:ignore = '^\(hover\|fern\|clap_\|defx\|denite\)'
  try
    let l:windows = gettabinfo(l:tabnr)[0].windows
    for l:win in l:windows
      if getwinvar(l:win, '&filetype') !~# l:ignore
        let l:count += 1
      endif
    endfor
  catch
    " Fallback
    let l:count = tabpagewinnr(l:tabnr, '$')
  endtry
  return l:count
endfunction

" Setup only when viewing help pages
if &buftype ==# 'help'
  call s:setup_buffer()
endif

function! HelpFormatExpr() abort
  if mode() ==# 'i' || v:char != ''
    return 1
  endif

  let line = getline(v:lnum)
  if line =~# '^=\+$'
    normal! macc
    normal! 78i=
    normal! `a
    undojoin
    return
  elseif line =~# '^\k\%(\k\|\s\)\+\s*\*\%(\k\|-\)\+\*\s*'
    let [header, link] = split(line, '^\k\%(\k\|\s\)\+\zs\s*')
    let header = substitute(header, '^\_s*\|\_s*$', '', 'g')
    let remainder = (&l:textwidth + 1) - len(header) - len(link)
    let line = header.repeat(' ', remainder).link
    call setline(v:lnum, line)
    return
  endif

  return 1
endfunction
setlocal formatexpr=HelpFormatExpr()

"---------------------------------------------------------------------
" NOTE: options {{{
"---------------------------------------------------------------------
let &cpoptions = s:save_cpo
set formatoptions-=o
setlocal expandtab
setlocal textwidth=78
setlocal tabstop=4
setlocal shiftwidth=4
" }}}
"---------------------------------------------------------------------
