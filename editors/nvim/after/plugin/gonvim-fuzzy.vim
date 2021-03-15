if exists('g:goneovim')
  " goneovim colorscheme
  " source $HOME/.config/nvim/colorschemes/goneovim-colors.vim
  " luafile $HOME/.config/nvim/lua/config/colorschemes/nord.lua

  " goneovim key mappings
  noremap <silent> <C-p> :GonvimFuzzyFiles<CR>

  " goneovim ag command
  let g:gonvim_fuzzy_ag_cmd = 'rg --hidden --ignore node_modules --follow --glob "!.git/*"'

endif
