" Statusline
function! LspStatus() abort
  if luaeval('#vim.lsp.buf_get_clients() > 0')
    return luaeval("require('lsp-status').status()")
  endif
  return ''
endfunction


" True color support
if (has("nvim"))
  "For Neovim 0.1.3 and 0.1.4 < https://github.com/neovim/neovim/pull/2198 >
  let $NVIM_TUI_ENABLE_TRUE_COLOR=1
endif

" set true colors
if has('termguicolors')
  set t_8f=\[[38;2;%lu;%lu;%lum
  set t_8b=\[[48;2;%lu;%lu;%lum
  set termguicolors
endif

hi! Normal ctermbg=NONE guibg=NONE
hi! NonText ctermbg=NONE guibg=NONE

" treesitter status
function! TreesitterStatus() abort
  let ts = nvim_treesitter#statusline(30)
  if ts ==# 'null'
    return ''
  else
    return ts
  endif
endfunction

" Faster Startup time (disable default plugins loading)
let g:did_install_default_menus = 1
let g:did_install_syntax_menu = 1
set guioptions=M
let g:loaded_vimball           = 1
let g:loaded_vimballPlugin     = 1
let g:loaded_getscript         = 1
let g:loaded_getscriptPlugin   = 1
let g:loaded_netrw             = 1
let g:loaded_netrwPlugin       = 1
let g:loaded_netrwSettings     = 1
let g:loaded_netrwFileHandlers = 1
let g:netrw_banner=0

" python hosts
let g:python3_host_prog = '/home/lalitmee/.pyenv/versions/neovim3/bin/python'
let g:python_host_prog = '/home/lalitmee/.pyenv/versions/neovim2/bin/python'

" cursors in different modes
if empty($TMUX)
  let &t_SI = "\<Esc>]50;CursorShape=1\x7"
  let &t_EI = "\<Esc>]50;CursorShape=0\x7"
  let &t_SR = "\<Esc>]50;CursorShape=2\x7"
else
  let &t_SI = "\<Esc>Ptmux;\<Esc>\<Esc>]50;CursorShape=1\x7\<Esc>\\"
  let &t_EI = "\<Esc>Ptmux;\<Esc>\<Esc>]50;CursorShape=0\x7\<Esc>\\"
  let &t_SR = "\<Esc>Ptmux;\<Esc>\<Esc>]50;CursorShape=2\x7\<Esc>\\"
endif



" put the cursor on the first searched word in the center
function! CenterSearch()
  let cmdtype = getcmdtype()
  if cmdtype == '/' || cmdtype == '?'
    return "\<enter>zz"
  endif
  return "\<enter>"
endfunction

cnoremap <silent> <expr> <enter> CenterSearch()

function! Console_Log() abort
  let l:word = expand('<cword>')
  execute 'norm!oconsole.log({'.l:word.'});'
  silent! call repeat#set("\<Plug>(JsConsoleLog)")
endfunction

nnoremap <silent><Plug>(JsConsoleLog) :<C-u>call Console_Log()<CR>
