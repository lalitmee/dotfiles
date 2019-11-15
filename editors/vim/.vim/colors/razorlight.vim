"
" Version 1.0
" Author: Matthias Beyer <mail@beyermatthias.de>
" Date: 03-11-2015
" License: Public Domain
"
" ---
"
" Colorscheme for vim and neovim. Created mainly with vim.ink
"

hi clear
syntax reset
let g:colors_name = "razorlight"
set background="dark"
set colorcolumn=81

hi Boolean                     gui=NONE        guifg=#403dff        guibg=NONE
hi ColorColumn                 gui=NONE        guifg=NONE           guibg=#1a1a1a
if has("nvim")
  hi Comment                   gui=italic      guifg=#3399ff        guibg=NONE
else
  hi Comment                   gui=NONE        ctermfg=LightBlue    guibg=NONE
endif
hi Conceal                     gui=NONE        guifg=#808080        guibg=NONE
hi Conditional                 gui=NONE        guifg=#4be4e7        guibg=NONE
hi Constant                    gui=NONE        guifg=#808080        guibg=NONE
hi Cursor                      gui=reverse     guifg=NONE           guibg=NONE
hi CursorColumn                gui=NONE        guifg=NONE           guibg=#1a1a1a
hi CursorLine                  gui=NONE        guifg=Yellow         guibg=#454545
hi CursorLineNr                gui=bold        guifg=DarkYellow     guibg=NONE
hi DiffAdd                     gui=NONE        guifg=NONE           guibg=#082608
hi DiffChange                  gui=NONE        guifg=NONE           guibg=#1a1a1a
hi DiffDelete                  gui=NONE        guifg=NONE           guibg=#260808
hi DiffText                    gui=NONE        guifg=NONE           guibg=#333333
hi Directory                   gui=NONE        guifg=#8f8f8f        guibg=NONE
hi Error                       gui=NONE        guifg=NONE           guibg=#260808
hi ErrorMsg                    gui=NONE        guifg=NONE           guibg=#260808
hi FoldColumn                  gui=NONE        guifg=#616161        guibg=NONE
hi Folded                      gui=NONE        guifg=#707070        guibg=NONE
hi Ignore                      gui=NONE        guifg=NONE           guibg=NONE
hi IncSearch                   gui=NONE        guifg=NONE           guibg=#333333
hi LineNr                      gui=NONE        guifg=DarkYellow     guibg=NONE
hi MatchParen                  gui=NONE        guifg=NONE           guibg=#333333
hi ModeMsg                     gui=NONE        guifg=NONE           guibg=NONE
hi MoreMsg                     gui=NONE        guifg=NONE           guibg=NONE
hi NonText                     gui=NONE        guifg=#616161        guibg=NONE
hi Normal                      gui=bold        guifg=#d0d0d0        guibg=#262626
hi Number                      gui=NONE        guifg=#808080        guibg=NONE
hi Pmenu                       gui=NONE        guifg=NONE           guibg=#1a1a1a
hi PmenuSbar                   gui=NONE        guifg=NONE           guibg=#262626
hi PmenuSel                    gui=NONE        guifg=NONE           guibg=#333333
hi PmenuThumb                  gui=NONE        guifg=NONE           guibg=#424242
hi Question                    gui=NONE        guifg=NONE           guibg=NONE
hi Search                      gui=NONE        guifg=NONE           guibg=#262626
hi SignColumn                  gui=NONE        guifg=#616161        guibg=NONE
hi Special                     gui=NONE        guifg=#808080        guibg=NONE
hi SpecialKey                  gui=NONE        guifg=#616161        guibg=NONE
hi SpellBad                    gui=undercurl   guisp=NONE           guifg=NONE guibg=#260808
hi SpellCap                    gui=undercurl   guisp=NONE           guifg=NONE guibg=NONE
hi SpellLocal                  gui=undercurl   guisp=NONE           guifg=NONE guibg=#082608
hi SpellRare                   gui=undercurl   guisp=NONE           guifg=NONE guibg=#262626
hi Statement                   gui=NONE        guifg=#d9aa59        guibg=NONE
hi StatusLine                  gui=NONE        guifg=#6e6e6e        guibg=#262626
hi StatusLineNC                gui=NONE        guifg=#707070        guibg=#262626
hi StorageClass                gui=NONE        guifg=#05f3ff        guibg=NONE
hi String                      gui=NONE        guifg=#ff0000        guibg=NONE
hi TabLine                     gui=NONE        guifg=#666666        guibg=#262626
hi TabLineFill                 gui=NONE        guifg=NONE           guibg=#262626
hi TabLineSel                  gui=NONE        guifg=#9e9e9e        guibg=#262626
hi Title                       gui=NONE        guifg=#808080        guibg=NONE
hi Todo                        gui=standout    guifg=NONE           guibg=NONE
hi Type                        gui=NONE        guifg=#00fa00        guibg=NONE
hi Underlined                  gui=NONE        guifg=NONE           guibg=NONE
hi VertSplit                   gui=NONE        guifg=#333333        guibg=NONE
hi Visual                      gui=NONE        guifg=NONE           guibg=#333333
hi VisualNOS                   gui=NONE        guifg=NONE           guibg=NONE
hi WarningMsg                  gui=NONE        guifg=NONE           guibg=#260808
hi WildMenu                    gui=NONE        guifg=NONE           guibg=#525252
hi lCursor                     gui=NONE        guifg=NONE           guibg=NONE
hi Identifier                  gui=NONE        guifg=NONE           guibg=NONE
hi PreProc                     gui=NONE        guifg=NONE           guibg=NONE

hi PmenuSel    ctermfg=Black ctermbg=Cyan       gui=none cterm=none term=none
hi Pmenu       ctermfg=White ctermbg=DarkBlue   gui=none cterm=none term=none
hi PmenuSbar   ctermfg=White ctermbg=LightCyan  gui=none cterm=none term=none
hi PmenuThumb  ctermfg=White ctermbg=DarkGreen  gui=none cterm=none term=none

" Spelling...
hi SpellBad    ctermfg=DarkRed      ctermbg=black  gui=none cterm=none term=none
hi SpellCap    ctermfg=DarkBlue     ctermbg=black  gui=none cterm=none term=none
hi SpellRare   ctermfg=DarkYellow   ctermbg=black  gui=none cterm=none term=none
hi SpellLocal  ctermfg=DarkGreen    ctermbg=black  gui=none cterm=none term=none

" Disable syntax highlighing changes for diff
hi DiffAdd      ctermbg=NONE ctermfg=NONE gui=NONE guifg=NONE guibg=NONE
hi DiffChange   ctermbg=NONE ctermfg=NONE gui=NONE guifg=NONE guibg=NONE
hi DiffDelete   ctermbg=NONE ctermfg=NONE gui=NONE guifg=NONE guibg=NONE
hi DiffText     ctermbg=NONE ctermfg=NONE gui=NONE guifg=NONE guibg=NONE

