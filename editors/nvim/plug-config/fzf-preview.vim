" Commands used for fzf preview.
" The file name selected by fzf becomes {}
" let g:fzf_preview_command = 'cat'                               " Not installed bat
let g:fzf_preview_command = 'bat --color=always --plain {-1}' " Installed bat

" Commands used to get the file list from project
" let g:fzf_preview_filelist_command = 'git ls-files --exclude-standard'               " Not Installed ripgrep
let g:fzf_preview_filelist_command = 'rg --files --hidden --follow --no-messages -g \!"* *"' " Installed ripgrep

" Use vim-devicons
let g:fzf_preview_use_dev_icons = 1
