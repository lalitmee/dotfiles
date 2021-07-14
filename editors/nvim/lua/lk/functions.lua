vim.api.nvim_exec([[
      function! Console_Log() abort
        let l:word = expand('<cword>')
        execute 'norm!oconsole.log({'.l:word.'});'
        silent! call repeat#set("\<Plug>(JsConsoleLog)")
      endfunction

      nnoremap <silent><Plug>(JsConsoleLog) :<C-u>call Console_Log()<CR>

      " H to open help docs
      function! Plug_doc()
        let name = matchstr(getline('.'), '^- \zs\S\+\ze:')
        if has_key(g:plugs, name)
          for doc in split(globpath(g:plugs[name].dir, 'doc/*.txt'), '\n')
            execute 'tabe' doc
          endfor
        endif
      endfunction

      augroup PlugHelp
        autocmd!
        autocmd FileType vim-plug nnoremap <buffer> <silent> H :call Plug_doc()<cr>
      augroup END

      " gx to open GitHub URLs on browser
      function! Plug_gx()
        let line = getline('.')
        let sha  = matchstr(line, '^  \X*\zs\x\{7,9}\ze ')
        let name = empty(sha) ? matchstr(line, '^[-x+] \zs[^:]\+\ze:') : getline(search('^- .*:$', 'bn'))[2:-2]
        let uri  = get(get(g:plugs, name, {}), 'uri', '')
        if uri !~ 'github.com'
          return
        endif
        let repo = matchstr(uri, '[^:/]*/'.name)
        let url  = empty(sha) ? 'https://github.com/'.repo : printf('https://github.com/%s/commit/%s', repo, sha)
        call netrw#BrowseX(url, 0)
      endfunction

      augroup PlugGx
        autocmd!
        autocmd FileType vim-plug nnoremap <buffer> <silent> gx :call Plug_gx()<cr>
      augroup END

      " Browse help files and README.md
      function! Plug_help_sink(line)
        let dir = g:plugs[a:line].dir
        for pat in ['doc/*.txt', 'README.md']
          let match = get(split(globpath(dir, pat), "\n"), 0, '')
          if len(match)
            execute 'tabedit' match
            return
          endif
        endfor
        tabnew
        execute 'Explore' dir
      endfunction

      command! PlugHelp call fzf#run(fzf#wrap({ 'source': sort(keys(g:plugs)), 'sink':   function('Plug_help_sink')}))
  ]], false)
