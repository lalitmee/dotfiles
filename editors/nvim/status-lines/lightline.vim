      " " \ 'colorscheme': 'landscape',
      " " \ 'colorscheme': 'wombat',
      " " \ 'colorscheme': 'landscape',
      " " \ 'colorscheme': 'srcery_drk',
      " " \ 'colorscheme': 'ayu_dark',
      " " \ 'colorscheme': 'solarized',
      " " \ 'colorscheme': '16color',
      " " \ 'colorscheme': 'ayu_mirage',
      " " \ 'colorscheme': 'deus',
      " " \ 'colorscheme': 'one',


      " " \ 'colorscheme': 'nord',
      " " \ 'colorscheme': 'material',
      " " \ 'colorscheme': 'powerline',
      " " \ 'colorscheme': 'powerlineish',
      " " \ 'colorscheme': 'materia',

" let g:lightline = {
      " \ 'colorscheme': 'onedark',
      " \ 'active': {
      " \   'left': [ [ 'mode', 'paste' ],
      " \             [ 'gitbranch', 'readonly', 'filename', 'modified'],
      " \             [ 'cocstatus'],
      " \ ]
      " \ },
      " \ 'component_function': {
      " \   'gitbranch': 'FugitiveHead',
      " \   'fileformat': 'LightlineFileformat',
      " \   'filetype': 'LightlineFiletype',
      " \   'mode': 'LightlineMode',
      " \   'filename': 'LightlineFilename',
      " \   'readonly': 'LightlineReadonly',
      " \   'modified': 'LightlineModified',
      " \ },
      " \ }
      " " \   'filename_with_icon': 'LightLineFileTypeWithIcon',

" function! LightlineModified()
  " return &filetype=='help' ? "" : &modified ? "●" : &modifiable ? "" : "🔒"
" endfunction

" function! LightlineReadonly()
  " return &readonly && &filetype !=# 'help' ? '🔒' : ''
" endfunction

" function! LightlineFilename()
  " let filetype_with_icon = &filetype !=# '' ? &filetype : 'no ft'
  " let root = fnamemodify(get(b:, 'git_dir'), ':h')
  " let path = expand('%:p')
  " if path[:len(root)-1] ==# root
    " return WebDevIconsGetFileTypeSymbol() . ' ' . path[len(root)+1:]
  " endif
  " return WebDevIconsGetFileTypeSymbol() . ' ' . expand('%')
" endfunction

" function! LightlineMode()
  " return expand('%:t') =~# '^__Tagbar__' ? 'Tagbar':
      "   \ expand('%:t') ==# 'ControlP' ? 'CtrlP' :
      "   \ &filetype ==# 'unite' ? 'Unite' :
      "   \ &filetype ==# 'vimfiler' ? 'VimFiler' :
      "   \ &filetype ==# 'vimshell' ? 'VimShell' :
      "   \ lightline#mode()
" endfunction

" function! LightlineFileformat()
  " return winwidth(0) > 70 ? &fileformat : ''
" endfunction

" function! LightlineFiletype()
  " return winwidth(0) > 70 ? (&filetype !=# '' ? WebDevIconsGetFileTypeSymbol() . ' ' . &filetype : 'no ft') : ''
" endfunction

let g:lightline_delphinus_use_nerd_fonts_glyphs = 1
" let g:lightline_delphinus_tagbar_enable = 1
" let g:lightline_delphinus_use_powerline_glyphs = 1
" let g:lightline_delphinus_gitgutter_enable = 1
let g:lightline_delphinus_colorscheme = 'nord_improved'
" let g:lightline_delphinus_colorscheme = 'solarized_improved'





