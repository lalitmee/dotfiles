function! LspCurrentFunction() abort
  if g:lspconfig == 1
    let current_function = nvim_treesitter#statusline(90)
    if current_function == v:null || current_function == ""
      return ""
    else
      return current_function
    endif
  endif
  return ""
endfunction

function! LspStatus() abort
  if luaeval('#vim.lsp.buf_get_clients() > 0')
    return luaeval("require('lsp-status').status()")
  endif

  return ''
endfunction
