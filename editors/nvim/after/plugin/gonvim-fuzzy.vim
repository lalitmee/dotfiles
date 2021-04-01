if exists('g:goneovim')
  " goneovim colorscheme
  " luafile $HOME/.config/nvim/lua/lk/colorscheme/nord.lua
  " colorscheme nvcode
  " colorscheme nord

  " goneovim key mappings
  noremap <silent> <C-p> :GonvimFuzzyFiles<CR>
  noremap <silent> <C-l> :GonvimFuzzyBLines<CR>
  noremap <silent> <C-b> :GonvimFuzzyBLines<CR>

  " goneovim ag command
  " let g:gonvim_fuzzy_ag_cmd = '/home/linuxbrew/.linuxbrew/bin/rg --hidden --ignore node_modules --follow --glob "!.git/*"'

endif
