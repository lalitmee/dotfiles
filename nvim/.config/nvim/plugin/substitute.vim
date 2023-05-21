" "---------------------------------------------------------------------
" " NOTE: substitute operator {{{
" " Usage:
" "   <key>ipfoo<CR>         Substitute every occurrence of the word under
" "                          the cursor with 'foo' in the current paragraph
" "   <key>Gfoo<CR>          Same, from here to the end of the buffer
" "   <key>?bar<CR>foo<CR>   Same, from previous occurrence of 'bar'
" "                          to current line
" "---------------------------------------------------------------------
" function! Substitute(type, ...)
" 	let cur = getpos("''")
" 	call cursor(cur[1], cur[2])
" 	let cword = expand('<cword>')
" 	execute "'[,']s/" . cword . "/" . input(cword . '/')
" 	call cursor(cur[1], cur[2])
" endfunction
" nmap <silent> s m':set opfunc=Substitute<CR>g@
" " }}}
" "---------------------------------------------------------------------
