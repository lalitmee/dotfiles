"---------------------------------------------------------------------
" NOTE: centered search {{{
"---------------------------------------------------------------------
function! CenterSearch()
  let cmdtype = getcmdtype()
  if cmdtype == '/' || cmdtype == '?'
    return "\<enter>zz"
  endif
  return "\<enter>"
endfunction

cnoremap <silent> <expr> <enter> CenterSearch()
" }}}
"---------------------------------------------------------------------

"---------------------------------------------------------------------
" NOTE: toggle maximize {{{
"---------------------------------------------------------------------
function! ToggleZoom(zoom)
  if exists("t:restore_zoom") && (a:zoom == v:true || t:restore_zoom.win != winnr())
    exec t:restore_zoom.cmd
    unlet t:restore_zoom
  elseif a:zoom
    let t:restore_zoom = { 'win': winnr(), 'cmd': winrestcmd() }
    exec "normal \<C-W>\|\<C-W>_"
  endif
endfunction

augroup restorezoom
  au WinEnter * silent! :call ToggleZoom(v:false)
augroup END
" }}}
"---------------------------------------------------------------------

"---------------------------------------------------------------------
" NOTE: Redir ex cmd {{{
" Redirect the output of a Vim or external command into a scratch buffer
"---------------------------------------------------------------------
function! Redir(cmd, rng, start, end)
  for win in range(1, winnr('$'))
    if getwinvar(win, 'scratch')
      execute win . 'windo close'
    endif
  endfor
  if a:cmd =~ '^!'
    let cmd = a:cmd =~' %'
          \ ? matchstr(substitute(a:cmd, ' %', ' ' . expand('%:p'), ''), '^!\zs.*')
          \ : matchstr(a:cmd, '^!\zs.*')
    if a:rng == 0
      let output = systemlist(cmd)
    else
      let joined_lines = join(getline(a:start, a:end), '\n')
      let cleaned_lines = substitute(shellescape(joined_lines), "'\\\\''", "\\\\'", 'g')
      let output = systemlist(cmd . " <<< $" . cleaned_lines)
    endif
  else
    redir => output
    execute a:cmd
    redir END
    let output = split(output, "\n")
  endif
  vnew
  let w:scratch = 1
  setlocal buftype=nofile bufhidden=wipe nobuflisted noswapfile
  call setline(1, output)
endfunction

command! -nargs=1 -complete=command -bar -range Redir silent call Redir(<q-args>, <range>, <line1>, <line2>)
" }}}
"---------------------------------------------------------------------

"---------------------------------------------------------------------
" NOTE: format with gq {{{
" gq wrapper that:
" - tries its best at keeping the cursor in place
" - tries to handle formatter errors
"---------------------------------------------------------------------
function! Format(type, ...)
  normal! '[v']gq
  if v:shell_error > 0
    silent undo
    redraw
    echomsg 'formatprg "' . &formatprg . '" exited with status ' . v:shell_error
  endif
  call winrestview(w:gqview)
  unlet w:gqview
endfunction
nmap <silent> gq :let w:gqview = winsaveview()<CR>:set opfunc=Format<CR>g@
" }}}
"---------------------------------------------------------------------

"---------------------------------------------------------------------
" NOTE: substitute operator {{{
" Usage:
"   <key>ipfoo<CR>         Substitute every occurrence of the word under
"                          the cursor with 'foo' in the current paragraph
"   <key>Gfoo<CR>          Same, from here to the end of the buffer
"   <key>?bar<CR>foo<CR>   Same, from previous occurrence of 'bar'
"                          to current line
"---------------------------------------------------------------------
function! Substitute(type, ...)
	let cur = getpos("''")
	call cursor(cur[1], cur[2])
	let cword = expand('<cword>')
	execute "'[,']s/" . cword . "/" . input(cword . '/')
	call cursor(cur[1], cur[2])
endfunction
nmap <silent> s m':set opfunc=Substitute<CR>g@
" }}}
"---------------------------------------------------------------------

"---------------------------------------------------------------------
" NOTE: Terminal command {{{
"---------------------------------------------------------------------
command! -nargs=? Terminal call s:Term(<q-args>)
function! s:Term(args)
  if has('nvim')
    tabnew
    execute 'terminal ' . a:args
    " no left gutter
    setlocal signcolumn=no
    setlocal norelativenumber
    setlocal nonumber
    " if no errors, auto-close
    autocmd! TermClose <buffer=abuf> if !v:event.status | exec 'bd! '..expand('<abuf>') | endif | checktime
    startinsert
  elseif has('terminal')
    " vim 8
    execute 'tab terminal ++close ' . a:args
  else
    " vim 7
    execute 'silent !( ' . (a:args != '' ? a:args : $SHELL) . ') || ( echo "Hit Enter"; read; )' | redraw!
  endif
endfunction
" }}}
"---------------------------------------------------------------------

" vim:foldmethod=marker
