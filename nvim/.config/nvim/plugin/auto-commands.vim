" coc pairs autocommands
autocmd FileType TelescopePrompt let b:coc_pairs_disabled = ['"', "'", "("]
autocmd FileType vim let b:coc_pairs_disabled = ['"']

" ESC mapping
if has("nvim")
  au TermOpen * tnoremap <buffer> <Esc> <c-\><c-n>
  au FileType fzf tunmap <buffer> <Esc>
endif
