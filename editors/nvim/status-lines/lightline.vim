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

" let g:lightline = {
"       \ 'colorscheme': 'nord',
"       \ 'active': {
"       \   'left': [
"       \             [ 'mode', 'paste' ],
"       \             [ 'gitbranch', 'readonly', 'filename', 'modified'],
"       \             [ 'coc_info', 'coc_hints', 'coc_errors', 'coc_warnings', 'coc_ok' ],
"       \             [ 'diagnostic', 'coc_status'],
"       \           ],
"       \ },
"       \ 'component_function': {
"       \   'gitbranch': 'FugitiveHead',
"       \   'fileformat': 'LightlineFileformat',
"       \   'filetype': 'LightlineFiletype',
"       \   'mode': 'LightlineMode',
"       \   'filename': 'LightlineFilename',
"       \   'readonly': 'LightlineReadonly',
"       \   'modified': 'LightlineModified',
"       \ },
"       \ }

" call lightline#coc#register()

" " for coc lsp
let g:lightline = {
      \ 'colorscheme': 'nord',
      \ 'active': {
      \   'left': [
      \             [ 'mode', 'paste' ],
      \             [ 'gitbranch', 'readonly', 'filename', 'modified'],
      \             [ 'coc_info', 'coc_hints', 'coc_errors', 'coc_warnings', 'coc_ok' ],
      \             [ 'coc_status', 'gitsigns_status', 'nearest_vista'],
      \           ],
      \ },
      \ 'component_function': {
      \   'gitbranch'       : 'LightlineGitSignsHead',
      \   'fileformat'      : 'LightlineFileformat',
      \   'filetype'        : 'LightlineFiletype',
      \   'mode'            : 'LightlineMode',
      \   'filename'        : 'LightlineFilename',
      \   'readonly'        : 'LightlineReadonly',
      \   'modified'        : 'LightlineModified',
      \   'gitsigns_status' : 'LightlineGitSignsStatus',
      \ },
      \ }

" " " for nvim-lsp
" let g:lightline = {
"       \ 'colorscheme': 'nord',
"       \ 'active': {
"       \   'left': [
"       \             [ 'mode', 'paste' ],
"       \             [ 'gitbranch', 'readonly', 'filename', 'modified'],
"       \             [ 'lsp_info', 'lsp_hints', 'lsp_errors', 'lsp_warnings', 'lsp_ok' ],
"       \             [ 'lsp_status', 'nearest_vista' ],
"       \             [ 'gitsigns_head' ],
"       \           ],
"       \ },
"       \ 'component_function': {
"       \   'gitbranch': 'LightlineGitSignsHead',
"       \   'fileformat': 'LightlineFileformat',
"       \   'filetype': 'LightlineFiletype',
"       \   'mode': 'LightlineMode',
"       \   'filename': 'LightlineFilename',
"       \   'readonly': 'LightlineReadonly',
"       \   'modified': 'LightlineModified',
"       \   'gitsigns_head': 'LightlineGitSignsStatus',
"       \   'nvim_lsp': 'LspStatus',
"       \   'nearest_vists': 'NearestMethodOrFunction',
"       \ },
"       \ }
"       " \   'current_func': 'LspStatusCurrentFunction',

call lightline#lsp#register()

function! LightlineGitSignsHead()
  return '  ' . get(b:,'gitsigns_head','')
endfunction

function! LightlineGitSignsStatus()
  return get(b:,'gitsigns_status','')
endfunction

function! LightlineGitSignsHead()
  return '  ' . get(b:,'gitsigns_head','')
endfunction

function! LightlineGitSignsStatus()
  return get(b:,'gitsigns_status','')
endfunction

function! LightlineModified()
  return &filetype=='help' ? "" : &modified ? "＋" : &modifiable ? "" : "🔒"
endfunction

function! LightlineReadonly()
  return &readonly && &filetype !=# 'help' ? 'RO | 🔒' : ''
endfunction

function! LightlineFilename()
  let filetype_with_icon = &filetype !=# '' ? &filetype : 'no ft'
  let root = fnamemodify(get(b:, 'git_dir'), ':h')
  let path = expand('%:p')
  if path[:len(root)-1] ==# root
    return WebDevIconsGetFileTypeSymbol() . ' ' . path[len(root)+1:]
  endif
  return WebDevIconsGetFileTypeSymbol() . ' ' . expand('%')
endfunction

function! LightlineMode()
  return expand('%:t') =~# '^__Tagbar__' ? 'Tagbar':
        \ expand('%:t') ==# 'ControlP' ? 'CtrlP' :
        \ &filetype ==# 'unite' ? 'Unite' :
        \ &filetype ==# 'vimfiler' ? 'VimFiler' :
        \ &filetype ==# 'vimshell' ? 'VimShell' :
        \ lightline#mode()
endfunction

function! LightlineFileformat()
  return winwidth(0) > 70 ? &fileformat : ''
endfunction

function! LightlineFiletype()
  return winwidth(0) > 70 ? (&filetype !=# '' ? WebDevIconsGetFileTypeSymbol() . ' ' . &filetype : 'no ft') : ''
endfunction

function! LspStatus() abort
  let status = luaeval('require("lsp-status").status()')
  return trim(status)
endfunction

function! LspStatusCurrentFunction() abort
  let current_function = luaeval('require("lsp-status").update_current_function()')
  return trim(current_function)
endfunction

function! NearestMethodOrFunction() abort
  return get(b:, 'vista_nearest_method_or_function', '')
endfunction


" let g:lightline_delphinus_use_nerd_fonts_glyphs = 1
" let g:lightline_delphinus_tagbar_enable = 1
" let g:lightline_delphinus_use_powerline_glyphs = 1
" let g:lightline_delphinus_gitgutter_enable = 1
" let g:lightline_delphinus_colorscheme = 'nord_improved'
" let g:lightline_delphinus_colorscheme = 'solarized_improved'
