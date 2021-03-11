" floating window size ratio
let g:fzf_preview_floating_window_rate = 0.8

" Specify the color of fzf
" let g:fzf_preview_fzf_color_option = 'green'

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

" autocmd VimEnter * call vista#RunForNearestMethodOrFunction()
