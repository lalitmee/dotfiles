function! helpers#lightline#git_branch()
  let git_branch_icon = ""
  let git_branch_icon =
        \ &filetype=='help' ||
        \ &filetype=='startify' ||
        \ &filetype=='NeogitStatus' ||
        \ &filetype==''
        \ ? ' - '
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

function! kelpers#lightline#lsp_current_function() abort
  if g:lspconfig
    let current_function = nvim_treesitter#statusline(90)
    if current_function == v:null
      return ""
    else
      return nvim_treesitter#statusline(90)
    endif
  else
    return get(b:, 'coc_current_function', '')
  endif
endfunction


