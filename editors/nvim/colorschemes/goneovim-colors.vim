" NOTE: goneovim colorschemes

" gruvbox {{{

" let g:gruvbox_italic = 1
" let g:gruvbox_underline = 1
" let g:gruvbox_contrast_dark = 'hard'
" let g:gruvbox_invert_indent_guides = 1
" let g:gruvbox_sign_column = 'bg0'

colorscheme gruvbox

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
