" enable powerline fonts
let g:airline_powerline_fonts = 1

" Switch to your current theme
let g:airline_theme = 'onedark'
" let g:airline_theme = 'one'
" let g:airline_theme = 'material'
" let g:airline_theme = 'nord'
" let g:airline_theme = 'gruvbox'
" let g:airline_theme = 'molokai'
" let g:airline_theme = 'powerlineish'
" let g:airline_theme = 'bubblegum'

" Always show tabs
set showtabline=2

" We don't need to see things like -- INSERT -- anymore
set noshowmode

" air-line
let g:airline_powerline_fonts = 1

if !exists('g:airline_symbols')
  let g:airline_symbols = {}
endif

" unicode symbols
let g:airline_left_sep = '»'
let g:airline_left_sep = '▶'
let g:airline_right_sep = '«'
let g:airline_right_sep = '◀'
let g:airline_symbols.linenr = '␊'
let g:airline_symbols.linenr = '␤'
let g:airline_symbols.linenr = '¶'
let g:airline_symbols.branch = '⎇'
let g:airline_symbols.paste = 'ρ'
let g:airline_symbols.paste = 'Þ'
let g:airline_symbols.paste = '∥'
let g:airline_symbols.whitespace = 'Ξ'

" airline symbols
let g:airline_left_sep = ''
let g:airline_left_alt_sep = ''
let g:airline_right_sep = ''
let g:airline_right_alt_sep = ''
let g:airline_symbols.branch = ''
let g:airline_symbols.readonly = ''
let g:airline_symbols.linenr = ''

" enable coc
let g:airline#extensions#coc#enabled = 1
let airline#extensions#coc#error_symbol = 'E:'
let airline#extensions#coc#warning_symbol = 'W:'
let airline#extensions#coc#stl_format_err = '%E{[%e(#%fe)]}'
let airline#extensions#coc#stl_format_warn = '%W{[%w(#%fw)]}'

" enable fzf
let g:airline#extensions#fzf#enabled = 1

" enable search count
let g:airline#extensions#searchcount#enabled = 1

" enable keymap
let g:airline#extensions#keymap#enabled = 1

