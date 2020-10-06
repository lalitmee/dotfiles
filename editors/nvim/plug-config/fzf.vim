" Border color
let g:fzf_layout = {'up':'~90%', 'window': { 'width': 0.8, 'height': 0.8,'yoffset':0.5,'xoffset': 0.5, 'highlight': 'Todo', 'border': 'sharp' } }
let g:fzf_preview_window = 'right:60%'

set wildmenu
set wildmode=longest:full,full
set wildignore+=*.o,*.obj,.git,*.rbc,*.pyc,__pycache__
let $FZF_DEFAULT_COMMAND =  "find * -path '*/\.*' -prune -o -path 'node_modules/**' -prune -o -path 'target/**' -prune -o -path 'dist/**' -prune -o  -type f -print -o -type l -print 2> /dev/null"

" Get text in files with Rg
command! -bang -nargs=* Rg
  \ call fzf#vim#grep(
  \   'rg --column --line-number --no-heading --color=always --smart-case '.shellescape(<q-args>), 1,
  \   fzf#vim#with_preview(), <bang>0)

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

" The Silver Searcher
if executable('ag')
  let $FZF_DEFAULT_COMMAND = 'ag --hidden --ignore .git -g ""'
  set grepprg=ag\ --nogroup\ --nocolor
endif

" ripgrep
if executable('rg')
  let $FZF_DEFAULT_COMMAND = 'rg --files --hidden --follow --glob "!.git/*"'
  set grepprg=rg\ --vimgrep
  command! -bang -nargs=* Find call fzf#vim#grep('rg --column --line-number --no-heading --fixed-strings --ignore-case --hidden --follow --glob "!.git/*" --color "always" '.shellescape(<q-args>).'| tr -d "\017"', 1, <bang>0)
endif

cnoremap <C-P> <C-R>=expand("%:p:h") . "/" <CR>
let g:fzf_command_prefix='Fzf'
nnoremap <silent> <leader>pf :FZF<CR>
nnoremap <silent> <leader>pb :FzfBuffers<CR>
nnoremap <silent> <leader>gf :FzfGFiles<CR>
nnoremap <silent> <leader>ll :FzfLines<CR>
nnoremap <silent> <leader>bl :FzfBLines<CR>
nnoremap <silent> <leader>tt :FzfTags<CR>
nnoremap <silent> <leader>bt :FzfBTags<CR>
nnoremap <silent> <leader>fl :FzfLocate<space>
nnoremap <silent> <leader>mm :FzfMarks<CR>
nnoremap <silent> <leader>ww :FzfWindows<CR>
nnoremap <silent> <leader>ss :FzfSnippets<CR>
nnoremap <silent> <leader>cm :FzfCommits<CR>
nnoremap <silent> <leader>cb :FzfBCommits<CR>
nnoremap <silent> <leader>co :FzfCommands<CR>
nnoremap <silent> <leader>mp :FzfMaps<CR>
nnoremap <silent> <leader>ht :FzfHelpTags<CR>
nnoremap <silent> <leader>ag :FzfAg<CR>
nnoremap <silent> <leader>rg :FzfRg<CR>
nnoremap <silent> <leader>cc :FzfColors<CR>
nnoremap <silent> <leader>hh :FzfHistory<CR>
nnoremap <silent> <leader>hc :FzfHistory:<CR>
nnoremap <silent> <leader>hs :FzfHistory/<CR>

"Recovery commands from history through FZF
nmap <leader>y :History:<CR>

" Customize fzf colors to match your color scheme
let g:fzf_colors =
\ { 'fg':      ['fg', 'Normal'],
  \ 'bg':      ['bg', 'Normal'],
  \ 'hl':      ['fg', 'Comment'],
  \ 'fg+':     ['fg', 'CursorLine', 'CursorColumn', 'Normal'],
  \ 'bg+':     ['bg', 'CursorLine', 'CursorColumn'],
  \ 'hl+':     ['fg', 'Statement'],
  \ 'info':    ['fg', 'PreProc'],
  \ 'border':  ['fg', 'Ignore'],
  \ 'prompt':  ['fg', 'Conditional'],
  \ 'pointer': ['fg', 'Exception'],
  \ 'marker':  ['fg', 'Keyword'],
  \ 'spinner': ['fg', 'Label'],
  \ 'header':  ['fg', 'Comment'] }

