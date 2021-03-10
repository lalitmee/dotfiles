function! helpers#lightline#git_branch()
  let git_branch_icon = ""
  let git_branch_icon =
        \ &filetype=='help' ||
        \ &filetype=='startify' ||
        \ &filetype =='NeogitStatus'
        \ ? ''
        \ : '  '
  return git_branch_icon . '' . get(b:,'gitsigns_head','')
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
  let name = ""
  if winwidth(0) < 150
    let subs = split(expand('%'), "/")
    let i = 1
    for s in subs
      let parent = name
      if  i == len(subs)
        let name = parent . '/' . s
      elseif i == 1
        let name = strpart(s, 0, 1)
      else
        let name = parent . '/' . strpart(s, 0, 1)
      endif
      let i += 1
    endfor
  else
    let root = fnamemodify(get(b:, 'git_dir'), ':h')
    let path = expand('%:p')
    if path[:len(root)-1] ==# root
      let name = path[len(root)+1:]
    endif
    let name = expand('%')
  endif
  return name
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
  " let g:current_function = luaeval('require("lsp-status").update_current_function()')
  " if current_function
  "   lua require("lsp-status").update_current_function()
  " endif
  autocmd CursorHold * silent! lua require'lsp-status'.update_current_function()
endfunction

function! helpers#lightline#coc_current_function() abort
  return get(b:, 'coc_current_function', '')
endfunction

