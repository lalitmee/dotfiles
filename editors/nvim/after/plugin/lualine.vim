function! LspCurrentFunction() abort
  if g:lspconfig
    let current_function = nvim_treesitter#statusline(90)
    if current_function == v:null || current_function == ""
      return ""
    else
      " return 'ƒ '. nvim_treesitter#statusline(90)
      " return nvim_treesitter#statusline(90)
      return ""
    endif
  endif
  return ""
endfunction
