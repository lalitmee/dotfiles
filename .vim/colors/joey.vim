" edit default colorscheme

hi clear
if exists("syntax_on")
    syntax reset
endif

" load base colorscheme
runtime colors/default.vim

" override name
let g:colors_name = "joey"

" clear the colors we want to change
hi clear Folded
hi clear FoldedColumn

hi clear SpellBad
hi clear SpellCap
hi clear SpellRare
hi clear SpellLocal

hi clear DiffAdd
hi clear DiffChange
hi clear DiffDelete

hi clear SignColumn

hi clear Pmenu

hi clear ColorColumn

" set up new colors
hi Folded term=standout ctermfg=17 ctermbg=248 guifg=black guibg=LightGrey
hi FoldedColumn term=standout ctermfg=17 ctermbg=248 guifg=black guibg=LightGrey

hi SpellBad ctermbg=9 ctermfg=230
hi SpellCap ctermbg=11
hi SpellRare ctermbg=81
hi SpellLocal term=underline ctermfg=230 ctermbg=14 gui=undercurl guisp=DarkCyan

hi ColorColumn term=standout ctermfg=0 ctermbg=11 guifg=Blue guibg=Yellow
