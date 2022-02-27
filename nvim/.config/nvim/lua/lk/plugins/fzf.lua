-- Border color
vim.g.fzf_layout = {
  up = '~90%',
  window = {
    width = 0.9,
    height = 0.9,
    yoffset = 0.5,
    xoffset = 0.5,
    border = 'rounded',
  },
}

vim.g.fzf_preview_window = 'right:60%'
vim.g.fzf_command_prefix = 'Fzf'
vim.g.fzf_tags_command = 'ctags -R .'

vim.cmd [[set wildmenu]]
vim.cmd [[set wildmode=longest:full,full]]
vim.cmd [[set wildignore+=*.o,*.obj,.git,*.rbc,*.pyc,__pycache__]]

vim.api.nvim_exec([[

      let $FZF_DEFAULT_OPTS = '--layout=reverse --inline-info --multi --bind=ctrl-a:select-all,ctrl-d:deselect-all'
      let $FZF_DEFAULT_COMMAND = "find * -path '*/\.*' -prune -o -path 'node_modules/**' -prune -o -path 'target/**' -prune -o -path 'dist/**' -prune -o -type f -print -o -type l -print 2> /dev/null"

      " ripgrep
      if executable('rg')
        let $FZF_DEFAULT_COMMAND = 'rg --files --hidden --follow --glob "!.git/*"'
        set grepprg=rg\ --vimgrep
        command! -bang -nargs=* Find call fzf#vim#grep(' rg --column line-number no-heading fixed-strings ignore-case hidden follow glob "!.git/*" color "always" '.shellescape(<q-args>).'| tr -d "\017"', 1, <bang>0)
      endif

      " CTRL-A CTRL-O to select all and build quickfix list
      function! Build_quickfix_list(lines)
        call setqflist(map(copy(a:lines), '{ "filename": v:val }'))
        copen
        cc
      endfunction

      let g:fzf_action = { 'ctrl-o': function('Build_quickfix_list'), 'ctrl-t': 'tab split', 'ctrl-x': 'split', 'ctrl-v': 'vsplit' }

      aug fzf_setup
        au!
        autocmd! FileType fzf tnoremap <buffer><nowait> <esc> <c-c>
      aug END

      tnoremap <expr> <Esc> (&filetype == "fzf") ? "<Esc>" : "<c-\><c-n>"


      " Keys and Commands {{{

      command! -bang -nargs=? -complete=dir Files call Fzf_files(<q-args>)
      command! -bang -nargs=* Rg call Fzfrg_without_file_names(<q-args>, <bang>0)
      command! -bang -nargs=* RG call RipgrepFzf(<q-args>, <bang>0)
      command! -bang -nargs=* GGrep call Fzfgit_grep(<q-args>, <bang>0)
      command! -bang -nargs=* BatThemes call Fzfbat_themes()
      command! -bang FzfDotfiles call Fzfdotfiles()
      command! -bang FzfNvimConfig call Fzfnvim_config()
      command! NeighbouringFiles call FzfNeighbouringFiles()
      command! GitBranchFiles call FzfGitBranchFiles()
      command! CustomFzfBuffers call FzfBuffers()

      " }}}

      " insert mode completions {{{

      inoremap <silent> <C-f><C-o> :call Fzfinsert_file_path()<CR>

      function! Make_sentence(lines)
        return substitute(join(a:lines), '^.', '\=toupper(submatch(0))', '').'.'
      endfunction

      " Global words completion
      inoremap <expr> <c-x><c-s> fzf#vim#complete({ 'source'  : 'cat /usr/share/dict/words', 'reducer' : function('Make_sentence'), 'options' : '--multi --reverse --margin 15%,0', 'left'    : 30})

      " Global line completion (not just open buffers. ripgrep required.)
      inoremap <expr> <c-x><c-l> fzf#vim#complete(fzf#wrap({ 'prefix': '^.*$', 'source': 'rg -n ^ --color always', 'options': '--ansi --delimiter : --nth 3..', 'reducer': { lines -> join(split(lines[0], ':\zs')[2:], '') }}))

      " }}}

      " Functions {{{

      " NOTE: Neovim configs
      function! Fzfnvim_config()
        call fzf#vim#files('~/.config/nvim', fzf#vim#with_preview({ 'options': [ '--layout=reverse', '--inline-info' ] }))
      endfunction


      " NOTE: dotfiles
      function! Fzfdotfiles()
        call fzf#vim#files('~/Desktop/Github/dotfiles', fzf#vim#with_preview({ 'options': [ '--layout=reverse', '--inline-info' ] }))
      endfunction


      " NOTE: Bat themes
      function! Fzfbat_themes()
        call fzf#vim#grep('bat --list-themes', 0)
      endfunction


      " NOTE: Grep using RG
      function! FzfGrep()
        let g:fzf_current_mode = 'GREP'
        let command = 'rg --vimgrep -H --no-heading --column --smart-case -P "%s"'

        function! Rg_to_qf(line)
          let parts = split(a:line, ':')
          return {'filename': parts[0], 'lnum': parts[1], 'col': parts[2], 'text': join(parts[3:], ':')}
        endfunction

        function! Rg_handler(lines)
          if len(a:lines) < 2 | return | endif

          let list = map(a:lines[1:], 'Rg_to_qf(v:val)')

          let first = list[0]
          execute first.lnum
          execute 'normal!' first.col.'|zz'

          if len(list) > 1
            call setqflist(list)
            copen
            wincmd p
          endif
        endfunction

        call fzf#run(fzf#wrap({ 'source':  printf(command,  escape('^(?=.)', '"\')), 'sink*':   function('Rg_handler'), 'options': $FZF_DEFAULT_OPTS.'--delimiter : --nth 4..' }))
      endfunction


      " NOTE: Git grep
      function! Fzfgit_grep(query, fullscreen)
        call fzf#vim#grep( 'git grep --line-number '.shellescape(a:query), 0, fzf#vim#with_preview({ 'dir': systemlist('git rev-parse --show-toplevel')[0] }), a:fullscreen)
      endfunction


      " NOTE: Ripgrep advanced
      function! RipgrepFzf(query, fullscreen)
        let command_fmt = 'rg --column --line-number --no-heading --color=always --smart-case %s || true'
        let initial_command = printf(command_fmt, shellescape(a:query))
        let reload_command = printf(command_fmt, '{q}')
        let spec = {'options': ['--phony', '--query', a:query, '--bind', 'change:reload:'.reload_command]}
        call fzf#vim#grep(initial_command, 1, fzf#vim#with_preview(spec), a:fullscreen)
      endfunction


      " NOTE: Ripgrep with only file contents and not file names
      function! Fzfrg_without_file_names(query, fullscreen)
        let command_fmt = 'rg --column --line-number --no-heading --color=always --smart-case %s || true'
        let initial_command = printf(command_fmt, shellescape(a:query))
        let reload_command = printf(command_fmt, '{q}')
        let spec = {'options': ['--query', a:query]}
        call fzf#vim#grep(initial_command, 1, fzf#vim#with_preview(spec), a:fullscreen)
      endfunction


      " NOTE: inline path completion for import statements
      function! Fzfinsert_file_path()
        let command = $FZF_DEFAULT_COMMAND

        call fzf#run(fzf#wrap({ 'source':  command, 'sink':    function('general#AppendToLine'), 'options': $FZF_DEFAULT_OPTS, }))
      endfunction


      " NOTE: Files
      function! Fzf_files(query)
        call fzf#vim#files(a:query, fzf#vim#with_preview({ 'options': [ '--layout=reverse', '--inline-info' ] }), a:query)
      endfunction


      " NOTE: Open buffers
      function! FzfBuffers()
        let g:fzf_current_mode = 'BUFFERS'
        function! Buflist()
          redir => ls
          silent ls
          redir END
          return split(ls, '\n')
        endfunction

        function! Bufopen(e)
          execute 'buffer' matchstr(a:e, '^[ 0-9]*')
        endfunction

        call fzf#run(fzf#wrap({ 'source':  reverse(<sid>buflist()), 'sink':    function('Bufopen'), 'options': $FZF_DEFAULT_OPTS }))
      endfunction

      "NOTE: Files that are in the same directory as the current buffer
      function! FzfNeighbouringFiles()
        let g:fzf_current_mode = 'CWD_FILES'
        let current_file = expand("%")
        let cwd = fnamemodify(current_file, ':p:h')
        let command = $FZF_DEFAULT_COMMAND . ' --maxdepth 1'

        call fzf#run(fzf#wrap({ 'source': command, 'dir': cwd, 'options': $FZF_DEFAULT_OPTS }))
      endfunction


      "NOTE: Files in $PWD that have changed in current branch compared to develop
      function! FzfGitBranchFiles()
        let g:fzf_current_mode = 'GIT_BRANCH_FILES'
        let command = 'git diff --name-only master'

        call fzf#run(fzf#wrap({ 'source': command, 'options': $FZF_DEFAULT_OPTS }))
      endfunction

      " }}}
]], true)
