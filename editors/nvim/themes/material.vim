" For Neovim 0.1.3 and 0.1.4 - https://github.com/neovim/neovim/pull/2198
if (has('nvim'))
  let $NVIM_TUI_ENABLE_TRUE_COLOR = 1
endif

let g:material_terminal_italics = 1
" let g:material_theme_style = 'default'
" let g:material_theme_style = 'palenight'
" let g:material_theme_style = 'ocean'
" let g:material_theme_style = 'lighter'
" let g:material_theme_style = 'darker'
" let g:material_theme_style = 'default-community'
" let g:material_theme_style = 'palenight-community'
let g:material_theme_style = 'ocean-community'
" let g:material_theme_style = 'lighter-community'
" let g:material_theme_style = 'darker-community'
colorscheme material

let g:airline_theme = 'material'

