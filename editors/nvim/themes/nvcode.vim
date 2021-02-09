hi Comment cterm=italic
let g:nvcode_termcolors=256

" configure nvcode-color-schemes
let g:nvcode_termcolors=256

syntax on
" colorscheme nord
colorscheme nvcode
" colorscheme onedark
" colorscheme snazzy
" colorscheme aurora
" colorscheme gruvbox
" colorscheme palenight

" checks if your terminal has 24-bit color support
if (has("termguicolors"))
    set termguicolors
    hi LineNr ctermbg=NONE guibg=NONE
endif
