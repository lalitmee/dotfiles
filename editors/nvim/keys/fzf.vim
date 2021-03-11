" close fzf window on esc
if has('nvim')
  aug fzf_setup
    au!
    autocmd! FileType fzf tnoremap <buffer><nowait> <esc> <c-c>
  aug END
end

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

" Global line completion (not just open buffers. ripgrep required.)
inoremap <expr> <c-x><c-l> fzf#vim#complete(fzf#wrap({
      \ 'prefix': '^.*$',
      \ 'source': 'rg -n ^ --color always',
      \ 'options': '--ansi --delimiter : --nth 3..',
      \ 'reducer': { lines -> join(split(lines[0], ':\zs')[2:], '') }}))

function! s:make_sentence(lines)
  return substitute(join(a:lines), '^.', '\=toupper(submatch(0))', '').'.'
endfunction

inoremap <expr> <c-x><c-s> fzf#vim#complete({
      \ 'source'  : 'cat /usr/share/dict/words',
      \ 'reducer' : function('<sid>make_sentence'),
      \ 'options' : '--multi --reverse --margin 15%,0',
      \ 'left'    : 30})


" Make Ripgrep ONLY search file contents and not filenames
command! -bang -nargs=* BatThemes
      \ call fzf#vim#grep(
      \   'bat --list-themes',
      \   <bang>0 ? fzf#vim#with_preview({'options': '--delimiter : --nth 4..'}, 'up:60%')
      \           : fzf#vim#with_preview({'options': 'bat --theme={} --color=always ~/data/Github/dotfiles/install.sh'}, 'right:50%', '?'),
      \   <bang>0)

command! -bang FzfDotfiles call fzf#vim#files('~/data/Github/dotfiles',
      \ fzf#vim#with_preview(
      \ {
      \ 'options': [
      \ '--layout=reverse',
      \ '--inline-info'
      \ ]
      \ }
      \ ), <bang>0)

command! -bang FzfNvimConfig call fzf#vim#files('~/.config/nvim',
      \ fzf#vim#with_preview(
      \ {
      \ 'options': [
      \ '--layout=reverse',
      \ '--inline-info'
      \ ]
      \ }
      \ ), <bang>0)
