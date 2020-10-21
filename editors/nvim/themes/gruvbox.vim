let g:gruvbox_italic=1
let g:gruvbox_improved_warnings=1

let g:gruvbox_contrast_dark = 'hard'

if exists('+termguicolors')
    let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
    let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"
endif

" let g:gruvbox_invert_indent_guides='1'
" let g:gruvbox_improved_strings='1'
" let g:gruvbox_vert_split='gray_245'
let g:gruvbox_hls_cursor="purple"
let g:gruvbox_hls_highlight="faded_yellow"

colorscheme gruvbox
