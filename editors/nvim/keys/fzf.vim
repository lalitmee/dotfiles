" CTRL-A CTRL-Q to select all and build quickfix list
function! s:build_quickfix_list(lines)
  call setqflist(map(copy(a:lines), '{ "filename": v:val }'))
  copen
  cc
endfunction

let g:fzf_action = {
  \ 'ctrl-o': function('s:build_quickfix_list'),
  \ 'ctrl-t': 'tab split',
  \ 'ctrl-x': 'split',
  \ 'ctrl-v': 'vsplit' }

" close fzf window on esc
if has('nvim')
  aug fzf_setup
    au!
    autocmd! FileType fzf tnoremap <buffer><nowait> <esc> <c-c>
  aug END
end


" Keys and Commands {{{

command! -bang -nargs=? -complete=dir Files call s:fzf_files(<q-args>)
command! -bang -nargs=* Rg call s:fzf_rg_without_file_names(<q-args>)
command! -nargs=* -bang RG call RipgrepFzf(<q-args>, <bang>0)
command! -bang -nargs=* GGrep call s:fzf_git_grep(<q-args>, <bang>0)
command! -bang -nargs=* BatThemes call s:fzf_bat_themes()
command! -bang FzfDotfiles call s:fzf_dotfiles()
command! -bang FzfNvimConfig call s:fzf_nvim_config()
command! NeighbouringFiles call s:fzf_NeighbouringFiles()
command! GitBranchFiles call s:fzf_GitBranchFiles()
command! CustomFzfBuffers call s:fzf_Buffers()

" }}}

" insert mode completions {{{

inoremap <silent> <C-F> <C-O>:call <sid>fzf_insert_file_path()<CR>

function! s:make_sentence(lines)
  return substitute(join(a:lines), '^.', '\=toupper(submatch(0))', '').'.'
endfunction

" Global words completion
inoremap <expr> <c-x><c-s> fzf#vim#complete({
      \ 'source'  : 'cat /usr/share/dict/words',
      \ 'reducer' : function('<sid>make_sentence'),
      \ 'options' : '--multi --reverse --margin 15%,0',
      \ 'left'    : 30})

" Global line completion (not just open buffers. ripgrep required.)
inoremap <expr> <c-x><c-l> fzf#vim#complete(fzf#wrap({
      \ 'prefix': '^.*$',
      \ 'source': 'rg -n ^ --color always',
      \ 'options': '--ansi --delimiter : --nth 3..',
      \ 'reducer': { lines -> join(split(lines[0], ':\zs')[2:], '') }}))

" }}}

" Functions {{{

" NOTE: Neovim configs
function! s:fzf_nvim_config()
  call fzf#vim#files('~/.config/nvim',
        \ fzf#vim#with_preview({
        \ 'options': [
        \ '--layout=reverse',
        \ '--inline-info'
        \ ]
        \ }
        \ ))
endfunction


" NOTE: dotfiles
function! s:fzf_dotfiles()
  call fzf#vim#files('~/data/Github/dotfiles',
        \ fzf#vim#with_preview({
        \ 'options': [
        \ '--layout=reverse',
        \ '--inline-info'
        \ ]
        \ }
        \ ))
endfunction


" NOTE: Bat themes
function! s:fzf_bat_themes()
  call fzf#vim#grep('bat --list-themes', 0)
endfunction


" NOTE: Grep using RG
function! s:fzf_Grep()
  let g:fzf_current_mode = 'GREP'
  let command = 'rg --vimgrep -H --no-heading --column --smart-case -P "%s"'

  function! s:rg_to_qf(line)
    let parts = split(a:line, ':')
    return {'filename': parts[0], 'lnum': parts[1], 'col': parts[2],
          \ 'text': join(parts[3:], ':')}
  endfunction

  function! s:rg_handler(lines)
    if len(a:lines) < 2 | return | endif

    let list = map(a:lines[1:], 's:rg_to_qf(v:val)')

    let first = list[0]
    execute first.lnum
    execute 'normal!' first.col.'|zz'

    if len(list) > 1
      call setqflist(list)
      copen
      wincmd p
    endif
  endfunction

  call fzf#run(fzf#wrap({
        \ 'source':  printf(command,  escape('^(?=.)', '"\')),
        \ 'sink*':   function('s:rg_handler'),
        \ 'options': $FZF_DEFAULT_OPTS.'--delimiter : --nth 4..'
        \ }))
endfunction


" NOTE: Git grep
function! s:fzf_git_grep(query, fullscreen)
  call fzf#vim#grep(
        \ 'git grep --line-number '.shellescape(a:query), 0,
        \ fzf#vim#with_preview({
        \ 'dir': systemlist('git rev-parse --show-toplevel')[0]
        \ }), a:fullscreen)
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
function! s:fzf_rg_without_file_names(query)
  call fzf#vim#grep(
        \ 'rg --column --line-number --hidden --smart-case --no-heading --color=always '
        \ .shellescape(a:query), 1, a:query
        \ ? fzf#vim#with_preview({'options': '--delimiter : --nth 4..'}, 'up:60%')
        \ : fzf#vim#with_preview({'options': '--delimiter : --nth 4.. -e'}, 'right:50%', '?'),
        \   a:query)
endfunction


" NOTE: inline path completion for import statements
function! s:fzf_insert_file_path()
  let command = $FZF_DEFAULT_COMMAND

  call fzf#run(fzf#wrap({
        \ 'source':  command,
        \ 'sink':    function('general#AppendToLine'),
        \ 'options': $FZF_DEFAULT_OPTS,
        \ }))
endfunction


" NOTE: Files
function! s:fzf_files(query)
  call fzf#vim#files(a:query,
        \ fzf#vim#with_preview({
        \ 'options': [ '--layout=reverse', '--inline-info' ]
        \ }), a:query)
endfunction


" NOTE: Open buffers
function! s:fzf_Buffers()
  let g:fzf_current_mode = 'BUFFERS'
  function! s:buflist()
    redir => ls
    silent ls
    redir END
    return split(ls, '\n')
  endfunction

  function! s:bufopen(e)
    execute 'buffer' matchstr(a:e, '^[ 0-9]*')
  endfunction

  call fzf#run(fzf#wrap({
        \ 'source':  reverse(<sid>buflist()),
        \ 'sink':    function('s:bufopen'),
        \ 'options': $FZF_DEFAULT_OPTS
        \ }))
endfunction


"NOTE: Files that are in the same directory as the current buffer
function! s:fzf_NeighbouringFiles()
  let g:fzf_current_mode = 'CWD_FILES'
  let current_file = expand("%")
  let cwd = fnamemodify(current_file, ':p:h')
  let command = $FZF_DEFAULT_COMMAND . ' --maxdepth 1'

  call fzf#run(fzf#wrap({
        \ 'source': command,
        \ 'dir': cwd,
        \ 'options': $FZF_DEFAULT_OPTS
        \ }))
endfunction


"NOTE: Files in $PWD that have changed in current branch compared to develop
function! s:fzf_GitBranchFiles()
  let g:fzf_current_mode = 'GIT_BRANCH_FILES'
  let command = 'git diff --name-only master'

  call fzf#run(fzf#wrap({
        \ 'source': command,
        \ 'options': $FZF_DEFAULT_OPTS
        \ }))
endfunction

" }}}
