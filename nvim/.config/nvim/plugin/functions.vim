""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" NOTE: centered search {{{
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
function! CenterSearch()
  let cmdtype = getcmdtype()
  if cmdtype == '/' || cmdtype == '?'
    return "\<enter>zz"
  endif
  return "\<enter>"
endfunction

cnoremap <silent> <expr> <enter> CenterSearch()
" }}}
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" NOTE: toggle maximize {{{
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
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
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" NOTE: Redir ex cmd {{{
" Redirect the output of a Vim or external command into a scratch buffer
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
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
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""


" vim:foldmethod=marker
