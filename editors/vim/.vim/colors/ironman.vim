" Vim color file 
" Maintainer:  Michael Boehler 
" Mail:        michael@familie-boehler.de 
" Last Change: 2015-2-25 
" Version:     3.3 
" This color scheme uses a light background. 
" GUI only 
" inspired by colorsheme PYTE 
 
set background=light 
hi clear 
if exists("syntax_on") 
   syntax reset 
endif 
 
let colors_name = "ironman" 
 
hi Normal                    guifg=#222222 guibg=#F2F2F2 
                              
" Search 
hi IncSearch                 gui=NONE guifg=Black guibg=#FFFF4B 
hi Search                    gui=NONE guifg=Black guibg=#FFFF9F 
 
" Messages 
hi ErrorMsg                  gui=NONE guifg=#FF0000 guibg=NONE     
hi WarningMsg                gui=NONE guifg=#FF6600 guibg=NONE 
hi ModeMsg                   gui=NONE guifg=#0070ff guibg=NONE 
hi MoreMsg                   gui=NONE guifg=#FF6600 guibg=NONE 
hi Question                  gui=NONE guifg=#008050 guibg=NONE 
 
" Completion Popup Menu 
hi Pmenu                     gui=NONE guifg=#303040 guibg=#ccff00 
hi PmenuSel                  gui=NONE guifg=#303040 guibg=#ffff00 
" hi PmenuSbar	scrollbar  |hl-PmenuSbar| 
" hi PmenuThumb	thumb of the scrollbar  |hl-PmenuThumb| 
 
" Split area 
hi StatusLine                gui=ITALIC guifg=white   guibg=#8090a0 
hi StatusLineNC              gui=ITALIC guifg=#506070 guibg=#a0b0c0 
hi VertSplit                 gui=NONE guifg=#a0b0c0 guibg=#8090a0 
hi WarningMsgildMenu         gui=NONE guifg=Black   guibg=Orange 
" hi WildMenu                  gui=UNDERLINE guifg=#56A0EE guibg=#E9E9F4 
 
" Diff 
hi DiffText                  gui=NONE guifg=#2020ff guibg=#c8f2ea 
hi DiffDelete                gui=NONE guifg=#f83010 guibg=#ffeae0 
hi DiffAdd                   gui=NONE guifg=#006800 guibg=#d0ffd0 
hi DiffChange                gui=NONE guifg=#2020ff guibg=#c8f2ea 
                              
" Cursor 
hi Cursor                    gui=NONE guifg=#ffffff guibg=#ff0000 
hi lCursor                   gui=NONE guifg=#ffffff guibg=#ff0000 
hi CursorIM                  gui=NONE guifg=#ffffff guibg=#ff0000 
hi CursorLine                gui=NONE guifg=NONE    guibg=#f9f9f9 
hi CursorLineNr              gui=NONE guifg=#8090ac 
hi CursorColumn              gui=NONE guifg=NONE    guibg=#F9F9F9 
hi MarkedLine                gui=NONE guifg=NONE    guibg=#A8EB8C 
                              
" Fold 
hi Folded                    gui=NONE guifg=#3399ff guibg=#EAF5FF 
hi FoldColumn                gui=NONE guifg=#3399ff guibg=#EAF5FF 
                              
" Other hi Directory         gui=NONE guifg=#0000ff guibg=NONE 
hi LineNr                    gui=NONE guifg=#ffffff guibg=#8090a0 
hi NonText                   gui=NONE guifg=#C0C0C0 guibg=#E0E0E0 
hi SpecialKey                gui=NONE guifg=#35E0DF guibg=NONE 
hi Title                     gui=NONE guifg=#004060 guibg=#c8f0f8 
hi Visual                    gui=NONE guibg=#BDDFFF 
hi MatchParen                gui=NONE guifg=NONE    guibg=#9FFF82 
 
" Syntax group 
hi Comment                   gui=ITALIC guifg=#A0B0C0 guibg=#EFEFFF 
hi Paren                     gui=NONE guifg=#9326C1 guibg=NONE 
hi Comma                     gui=NONE guifg=#C12660 guibg=NONE 
hi Constant                  gui=NONE guifg=NONE    guibg=#E8F1FF 
hi Statement                 gui=NONE guifg=#005EC4 guibg=NONE 
hi Error                     gui=BOLD,UNDERLINE     guifg=#ff4080 guibg=NONE 
hi Identifier                gui=NONE guifg=#339933 guibg=NONE 
hi Ignore                    gui=NONE guifg=#f8f8f8 guibg=NONE 
hi Number                    gui=NONE guifg=#087B4D guibg=NONE 
hi PreProc                   gui=NONE guifg=#0070e6 guibg=NONE 
hi Special                   gui=NONE guifg=#0000ff guibg=#ccf7ee 
hi Delimiter                 gui=BOLD guifg=#A8360F guibg=NONE 
hi Todo                      gui=NONE guifg=#ff0070 guibg=#ffe0f4 
hi Type                      gui=NONE guifg=#eb7950 guibg=NONE 
hi Underlined                gui=UNDERLINE guifg=#0000ff guibg=NONE 
hi Conditional               gui=None guifg=#0053FF guibg=bg 
hi Repeat                    gui=None guifg=#E460FF guibg=bg 
hi Operator                  gui=None guifg=#0085B1 guibg=bg 
hi Keyword                   gui=None guifg=DarkBlue guibg=bg 
hi Exception                 gui=None guifg=DarkBlue guibg=bg 
hi Function                  gui=BOLD guifg=#333333 
 
if has("spell") 
    hi SpellBad    guisp=#FF0000 gui=undercurl 
    hi SpellCap    guisp=#7070F0 gui=undercurl 
    hi SpellLocal  guisp=#70F0F0 gui=undercurl 
    hi SpellRare   guisp=#FFFFFF gui=undercurl 
endif 
 
hi! link String	Constant 
hi! link SpecialComment Comment 
hi! link Character	Constant 
hi! link Boolean	Constant 
hi! link Float		Number 
hi! link Label		Statement 
hi! link Include	PreProc 
hi! link Define	PreProc 
hi! link Macro		PreProc 
hi! link PreCondit	PreProc 
hi! link StorageClass	Type 
hi! link Structure	Type 
hi! link Typedef	Type 
hi! link SpecialChar	Special 
hi! link Debug		Special 
 
" HTML 
hi htmlLink                  gui=UNDERLINE guifg=#0000ff guibg=NONE 
hi htmlBold                  gui=BOLD 
hi htmlBoldItalic            gui=BOLD,ITALIC 
hi htmlBoldUnderline         gui=BOLD,UNDERLINE 
hi htmlBoldUnderlineItalic   gui=BOLD,UNDERLINE,ITALIC 
hi htmlItalic                gui=ITALIC 
hi htmlUnderline             gui=UNDERLINE 
hi htmlUnderlineItalic       gui=UNDERLINE,ITALIC 
 
" Tabs {{{1 
highlight TabLine            gui=underline guibg=LightGrey 
highlight TabLineFill        gui=reverse 
highlight TabLineSel         gui=bold 
 
highlight SpellBad           gui=undercurl guisp=Red 
highlight SpellCap           gui=undercurl guisp=Blue 
highlight SpellRare          gui=undercurl guisp=Magenta 
highlight SpellLocale        gui=undercurl guisp=DarkCyan 
 
" Completion {{{1 
highlight Pmenu              guifg=Black   guibg=#BDDFFF 
highlight PmenuSel           guifg=Black   guibg=Orange 
highlight PmenuSbar          guifg=#CCCCCC guibg=#CCCCCC 
highlight PmenuThumb         gui=reverse guifg=Black   guibg=#AAAAAA 
