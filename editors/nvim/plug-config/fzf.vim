" Border color
let g:fzf_layout = {
      \ 'up':'~90%',
      \ 'window': {
        \ 'width': 0.8,
        \ 'height': 0.8,
        \ 'yoffset':0.5,
        \ 'xoffset': 0.5,
        \ 'highlight': 'Todo',
        \ 'border': 'sharp'
      \ }
    \ }
let g:fzf_preview_window = 'right:60%'
let g:fzf_command_prefix='Fzf'
let g:fzf_tags_command = 'ctags -R .'

set wildmenu
set wildmode=longest:full,full
set wildignore+=*.o,*.obj,.git,*.rbc,*.pyc,__pycache__
let $FZF_DEFAULT_OPTS = '--layout=reverse --inline-info'
let $FZF_DEFAULT_COMMAND = "
      \ find *
      \ -path '*/\.*'
      \ -prune -o -path 'node_modules/**'
      \ -prune -o -path 'target/**'
      \ -prune -o -path 'dist/**'
      \ -prune -o
      \ -type f
      \ -print
      \ -o
      \ -type l
      \ -print 2> /dev/null
      \ "


"Get Files
command! -bang -nargs=? -complete=dir Files
      \ call fzf#vim#files(
        \ <q-args>,
        \ fzf#vim#with_preview(
          \ {
          \ 'options': [
            \ '--layout=reverse',
            \ '--inline-info'
          \ ]
          \ }
      \ ), <bang>0)

" Make Ripgrep ONLY search file contents and not filenames
command! -bang -nargs=* Rg
  \ call fzf#vim#grep(
  \   'rg --column --line-number --hidden --smart-case --no-heading --color=always '.shellescape(<q-args>), 1,
  \   <bang>0 ? fzf#vim#with_preview({'options': '--delimiter : --nth 4..'}, 'up:60%')
  \           : fzf#vim#with_preview({'options': '--delimiter : --nth 4.. -e'}, 'right:50%', '?'),
  \   <bang>0)

" Ripgrep advanced
function! RipgrepFzf(query, fullscreen)
  let command_fmt = 'rg --column --line-number --no-heading --color=always --smart-case %s || true'
  let initial_command = printf(command_fmt, shellescape(a:query))
  let reload_command = printf(command_fmt, '{q}')
  let spec = {'options': ['--phony', '--query', a:query, '--bind', 'change:reload:'.reload_command]}
  call fzf#vim#grep(initial_command, 1, fzf#vim#with_preview(spec), a:fullscreen)
endfunction

command! -nargs=* -bang RG call RipgrepFzf(<q-args>, <bang>0)

" Git grep
command! -bang -nargs=* GGrep
  \ call fzf#vim#grep(
  \   'git grep --line-number '.shellescape(<q-args>), 0,
  \   fzf#vim#with_preview({'dir': systemlist('git rev-parse --show-toplevel')[0]}), <bang>0)

" ripgrep
if executable('rg')
  let $FZF_DEFAULT_COMMAND = 'rg --files --hidden --follow --glob "!.git/*"'
  set grepprg=rg\ --vimgrep
  command! -bang -nargs=* Find call fzf#vim#grep('rg --column --line-number --no-heading --fixed-strings --ignore-case --hidden --follow --glob "!.git/*" --color "always" '.shellescape(<q-args>).'| tr -d "\017"', 1, <bang>0)
endif

" The Silver Searcher
if executable('ag')
  let $FZF_DEFAULT_COMMAND = 'ag --hidden --ignore .git -g ""'
  set grepprg=ag\ --nogroup\ --nocolor
endif
