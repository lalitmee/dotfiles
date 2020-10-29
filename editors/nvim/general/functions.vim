function! s:console_log() abort
  let l:word = expand('<cword>')
  execute 'norm!oconsole.log('''.l:word.''', '.l:word.');'
  silent! call repeat#set("\<Plug>(JsConsoleLog)")
endfunction

nnoremap <silent><Plug>(JsConsoleLog) :<C-u>call <sid>console_log()<CR>

" function! FilesPicker(A,L,P) abort
"   let l:cmd = 'fd . -t f'
"   let l:items = l:cmd->systemlist
"   if a:A->len() > 0
"     return l:items->matchfuzzy(a:A)
"   else
"     return l:items
"   endif
" endfunction

" function! FilesRunner(args) abort
" 	exe 'e ' .. a:args
" endfunction

" command! -nargs=1 -bar -complete=customlist,FilesPicker Files call FilesRunner(<q-args>)
