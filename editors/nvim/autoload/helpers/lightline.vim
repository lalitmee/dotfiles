function! helpers#lightline#git_branch()
  return '  ' . get(b:,'gitsigns_head','')
endfunction

function! helpers#lightline#gitsigns_status()
  return get(b:,'gitsigns_status','')
endfunction

function! helpers#lightline#modified()
  return &filetype=='help' ? "" : &modified ? "＋" : &modifiable ? "" : "🔒"
endfunction

function! helpers#lightline#readonly()
  return &readonly && &filetype !=# 'help' ? 'RO | 🔒' : ''
endfunction

function! helpers#lightline#filename()
  let filetype_with_icon = &filetype !=# '' ? &filetype : 'no ft'
  let root = fnamemodify(get(b:, 'git_dir'), ':h')
  let path = expand('%:p')
  if path[:len(root)-1] ==# root
    return WebDevIconsGetFileTypeSymbol() . ' ' . path[len(root)+1:]
  endif
  return WebDevIconsGetFileTypeSymbol() . ' ' . expand('%')
endfunction

function! helpers#lightline#mode()
  return expand('%:t') =~# '^__Tagbar__' ? 'Tagbar':
        \ expand('%:t') ==# 'ControlP' ? 'CtrlP' :
        \ &filetype ==# 'unite' ? 'Unite' :
        \ &filetype ==# 'vimfiler' ? 'VimFiler' :
        \ &filetype ==# 'vimshell' ? 'VimShell' :
        \ lightline#mode()
endfunction

function! helpers#lightline#format()
  return winwidth(0) > 70 ? &fileformat : ''
endfunction

function! helpers#lightline#filetype()
  return winwidth(0) > 70 ? (&filetype !=# '' ? WebDevIconsGetFileTypeSymbol() . ' ' . &filetype : 'no ft') : ''
endfunction

function! helpers#lightline#lsp_status() abort
  let status = luaeval('require("lsp-status").status()')
  return trim(status)
endfunction

function! helpers#lightline#lsp_current_function() abort
  lua require("lsp-status").update_current_function()
endfunction

function! helpers#lightline#coc_current_function() abort
  return get(b:, 'coc_current_function', '')
endfunction

