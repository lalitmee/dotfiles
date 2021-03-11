" \ 'colorscheme': 'landscape',
" \ 'colorscheme': 'wombat',
" \ 'colorscheme': 'landscape',
" \ 'colorscheme': 'srcery_drk',
" \ 'colorscheme': 'ayu_dark',
" \ 'colorscheme': 'solarized',
" \ 'colorscheme': '16color',
" \ 'colorscheme': 'ayu_mirage',
" \ 'colorscheme': 'deus',
" \ 'colorscheme': 'one',


" \ 'colorscheme': 'nord',
" \ 'colorscheme': 'material',
" \ 'colorscheme': 'powerline',
" \ 'colorscheme': 'powerlineish',
" \ 'colorscheme': 'materia',
" \ 'colorscheme': 'monokai_pro',
" \ 'colorscheme': 'sonokai',
" \ 'colorscheme': 'edge',

" " " for coc lsp
" let g:lightline = {
"       \ 'colorscheme': 'nord',
"       \ 'active': {
"       \   'left': [
"       \             [ 'mode', 'paste' ],
"       \             [ 'gitbranch', 'readonly', 'filename', 'modified'],
"       \             [ 'coc_info', 'coc_hints', 'coc_errors', 'coc_warnings', 'coc_ok' ],
"       \             [ 'coc_status', 'gitsigns_status', 'current_function'],
"       \           ],
"       \   'right': [ [ 'lineinfo' ],
"       \              [ 'percent' ],
"       \              [ 'filetype' ] ],
"       \ },
"       \ 'component_function': {
"       \   'gitbranch': 'helpers#lightline#git_branch',
"       \   'fileformat': 'helpers#lightline#format',
"       \   'filetype': 'helpers#lightline#filetype',
"       \   'mode': 'helpers#lightline#mode',
"       \   'filename': 'helpers#lightline#filename',
"       \   'readonly': 'helpers#lightline#readonly',
"       \   'modified': 'helpers#lightline#modified',
"       \   'gitsigns_status': 'helpers#lightline#gitsigns_status',
"       \   'current_function': 'helpers#lightline#coc_current_function',
"       \ },
"       \ 'mode_map': {
"         \ 'n' : '<N>',
"         \ 'i' : '<I>',
"         \ 'R' : '<R>',
"         \ 'v' : '<V>',
"         \ 'V' : '<VL>',
"         \ "\<C-v>": '<VB>',
"         \ 'c' : '<C>',
"         \ 's' : '<S>',
"         \ 'S' : '<SL>',
"         \ "\<C-s>": '<SB>',
"         \ 't': '<T>',
"         \ },
"       \ }
" call lightline#coc#register()

" for nvim-lsp
let g:lightline = {
      \ 'colorscheme': 'nord',
      \ 'active': {
      \   'left': [
      \             [ 'mode', 'paste' ],
      \             [ 'gitbranch', 'readonly', 'filename', 'modified'],
      \             [ 'lsp_info', 'lsp_hints', 'lsp_errors', 'lsp_warnings', 'lsp_ok' ],
      \             [ 'lsp_status', 'current_function' ],
      \             [ 'gitsigns_status' ],
      \           ],
      \ },
      \ 'component_function': {
      \   'gitbranch': 'helpers#lightline#git_branch',
      \   'fileformat': 'helpers#lightline#format',
      \   'filetype': 'helpers#lightline#filetype',
      \   'mode': 'helpers#lightline#mode',
      \   'filename': 'helpers#lightline#filename',
      \   'readonly': 'helpers#lightline#readonly',
      \   'modified': 'helpers#lightline#modified',
      \   'gitsigns_status': 'helpers#lightline#gitsigns_status',
      \   'current_function': 'helpers#lightline#lsp_current_function',
      \ },
      \ 'mode_map': {
        \ 'n' : '<N>',
        \ 'i' : '<I>',
        \ 'R' : '<R>',
        \ 'v' : '<V>',
        \ 'V' : '<VL>',
        \ "\<C-v>": '<VB>',
        \ 'c' : '<C>',
        \ 's' : '<S>',
        \ 'S' : '<SL>',
        \ "\<C-s>": '<SB>',
        \ 't': '<T>',
        \ },
      \ }
call lightline#lsp#register()

" let g:lightline_delphinus_use_nerd_fonts_glyphs = 1
" let g:lightline_delphinus_tagbar_enable = 1
" let g:lightline_delphinus_use_powerline_glyphs = 1
" let g:lightline_delphinus_gitgutter_enable = 1
" let g:lightline_delphinus_colorscheme = 'nord_improved'
" let g:lightline_delphinus_colorscheme = 'solarized_improved'
