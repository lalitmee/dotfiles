" NOTE: goneovim colorschemes

" " vim-hybrid-material {{{

" let g:enable_bold_font = 1
" let g:enable_italic_font = 1
" let g:hybrid_transparent_background = 1

" set background=dark
" " colorscheme hybrid_material
" colorscheme hybrid_reverse

" " }}}

" " onedark {{{

let g:onedark_hide_endofbuffer = 1
let g:onedark_termcolors = 256
let g:onedark_terminal_italics = 1

set background=dark
colorscheme onedark

" " }}}

" nord {{{

" let g:nord_cursor_line_number_background = 1
" let g:nord_uniform_status_lines = 1
" let g:nord_bold_vertical_split_line = 1
" let g:nord_uniform_diff_background = 1
" let g:nord_bold = 1
" let g:nord_italic = 1
" let g:nord_italic_comments = 1
" let g:nord_underline = 1

" set background=dark
" colorscheme nord

" }}}

" gruvbox {{{

" let g:gruvbox_italic = 1
" let g:gruvbox_underline = 1
" let g:gruvbox_contrast_dark = 'hard'
" let g:gruvbox_invert_indent_guides = 1
" let g:gruvbox_sign_column = 'bg0'

" colorscheme gruvbox

" }}}

" Telescope Highlights {{{

highlight TelescopeSelection      guibg=#3C3836 gui=bold " selected item
highlight TelescopeSelectionCaret guifg=#CC241D " selection caret
highlight TelescopeMultiSelection guifg=#928374 " multisections
highlight TelescopeNormal         guibg=#00000  " floating windows created by telescope.

" Border highlight groups.
highlight TelescopeBorder         guifg=#ffffff
highlight TelescopePromptBorder   guifg=#ffffff
highlight TelescopeResultsBorder  guifg=#ffffff
highlight TelescopePreviewBorder  guifg=#ffffff

" Used for highlighting characters that you match.
highlight TelescopeMatching       guifg=#FE8019

" Used for the prompt prefix
highlight TelescopePromptPrefix   guifg=red
"}}}
