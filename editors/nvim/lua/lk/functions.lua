vim.api.nvim_exec([[
      " put the cursor on the first searched word in the center
      function! CenterSearch()
        let cmdtype = getcmdtype()
        if cmdtype == '/' || cmdtype == '?'
          return "\<enter>zz"
        endif
        return "\<enter>"
      endfunction

      cnoremap <silent> <expr> <enter> CenterSearch()

      function! Console_Log() abort
        let l:word = expand('<cword>')
        execute 'norm!oconsole.log({'.l:word.'});'
        silent! call repeat#set("\<Plug>(JsConsoleLog)")
      endfunction

      nnoremap <silent><Plug>(JsConsoleLog) :<C-u>call Console_Log()<CR>
  ]], false)
