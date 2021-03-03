
" Important!!
if has('termguicolors')
  set termguicolors
endif

" For dark version.
set background=dark

" " For light version.
" set background=light

" Set contrast.
" This configuration option should be placed before `colorscheme gruvbox-material`.
" Available values: 'hard', 'medium'(default), 'soft'
let g:gruvbox_material_background = 'hard'

" enable italics
let g:gruvbox_material_enable_italic = 1

" To enable bold in function name just like the original gruvbox
let g:gruvbox_material_enable_bold = 1

" transparent background
let g:gruvbox_material_transparent_background = 1

" Some plugins support highlighting error/warning/info/hint lines
let g:gruvbox_material_diagnostic_line_highlight = 1

" better performance
let g:gruvbox_material_better_performance = 1

colorscheme gruvbox-material
