function! s:console_log() abort
  let l:word = expand('<cword>')
  execute 'norm!oconsole.log('''.l:word.''', '.l:word.');'
  silent! call repeat#set("\<Plug>(JsConsoleLog)")
endfunction

nnoremap <silent><Plug>(JsConsoleLog) :<C-u>call <sid>console_log()<CR>
