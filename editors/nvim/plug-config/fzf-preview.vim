" Commands used for fzf preview.
" The file name selected by fzf becomes {}
" let g:fzf_preview_command = 'cat'                               " Not installed bat
let g:fzf_preview_command = 'bat --color=always --plain {-1}' " Installed bat

" Commands used to get the file list from project
let g:fzf_preview_filelist_command = 'git ls-files --exclude-standard'               " Not Installed ripgrep
" let g:fzf_preview_filelist_command = 'rg --files --follow --no-messages -g \!"* *"' " Installed ripgrep

" Use vim-devicons
let g:fzf_preview_use_dev_icons = 1

augroup fzf_preview
  autocmd!
  autocmd User fzf_preview#rpc#initialized call s:fzf_preview_settings() " fzf_preview#remote#initialized or fzf_preview#coc#initialized
augroup END

function! s:fzf_preview_settings() abort
  let g:fzf_preview_command = 'COLORTERM=truecolor ' . g:fzf_preview_command
  let g:fzf_preview_grep_preview_cmd = 'COLORTERM=truecolor ' . g:fzf_preview_grep_preview_cmd
endfunction

autocmd VimEnter * call vista#RunForNearestMethodOrFunction()
