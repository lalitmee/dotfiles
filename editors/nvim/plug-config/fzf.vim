autocmd! FileType fzf set laststatus=0 noshowmode noruler
  \| autocmd BufLeave <buffer> set laststatus=2 showmode ruler

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

" ripgrep
if executable('rg')
  let $FZF_DEFAULT_COMMAND = 'rg --files --hidden --follow --glob "!.git/*"'
  set grepprg=rg\ --vimgrep
  command! -bang -nargs=* Find call fzf#vim#grep('
        \ rg
        \ --column
        \ --line-number
        \ --no-heading
        \ --fixed-strings
        \ --ignore-case
        \ --hidden
        \ --follow
        \ --glob
        \ "!.git/*"
        \ --color
        \ "always"
        \ '.shellescape(<q-args>).'| tr -d "\017"', 1, <bang>0)
endif

" The Silver Searcher
if executable('ag')
  let $FZF_DEFAULT_COMMAND = 'ag --hidden --ignore .git -g ""'
  set grepprg=ag\ --nogroup\ --nocolor
endif



