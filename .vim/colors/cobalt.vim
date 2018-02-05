
" Vim color file - cobalt
" Generated by http://bytefluent.com/vivify 2017-05-09
set background=dark
if version > 580
	hi clear
	if exists("syntax_on")
		syntax reset
	endif
endif

set t_Co=256
let g:colors_name = "cobalt"

"hi CTagsMember -- no settings --
"hi CTagsGlobalConstant -- no settings --
"hi Ignore -- no settings --
hi Normal guifg=#ffffff guibg=#001b33 guisp=#001b33 gui=bold ctermfg=15 ctermbg=233 cterm=bold
"hi CTagsImport -- no settings --
"hi CTagsGlobalVariable -- no settings --
"hi SpellRare -- no settings --
"hi EnumerationValue -- no settings --
"hi Union -- no settings --
"hi Question -- no settings --
"hi VisualNOS -- no settings --
"hi ModeMsg -- no settings --
"hi EnumerationName -- no settings --
"hi MoreMsg -- no settings --
"hi SpellCap -- no settings --
"hi SpellLocal -- no settings --
"hi DefinedName -- no settings --
"hi LocalVariable -- no settings --
"hi SpellBad -- no settings --
"hi CTagsClass -- no settings --
"hi Underlined -- no settings --
"hi clear -- no settings --
hi IncSearch guifg=#ffffff guibg=#0088ff guisp=#0088ff gui=NONE ctermfg=15 ctermbg=33 cterm=NONE
hi WildMenu guifg=NONE guibg=#909da8 guisp=#909da8 gui=NONE ctermfg=NONE ctermbg=109 cterm=NONE
hi SignColumn guifg=#1a1a1a guibg=#445291 guisp=#445291 gui=NONE ctermfg=234 ctermbg=60 cterm=NONE
hi SpecialComment guifg=#0088ff guibg=NONE guisp=NONE gui=bold,italic ctermfg=33 ctermbg=NONE cterm=bold
hi Typedef guifg=#40e0d0 guibg=NONE guisp=NONE gui=bold ctermfg=80 ctermbg=NONE cterm=bold
hi Title guifg=#ffffff guibg=NONE guisp=NONE gui=NONE ctermfg=15 ctermbg=NONE cterm=NONE
hi Folded guifg=#1a1a1a guibg=#909da8 guisp=#909da8 gui=italic ctermfg=234 ctermbg=109 cterm=NONE
hi PreCondit guifg=#c526ff guibg=NONE guisp=NONE gui=NONE ctermfg=13 ctermbg=NONE cterm=NONE
hi Include guifg=#c526ff guibg=NONE guisp=NONE gui=NONE ctermfg=13 ctermbg=NONE cterm=NONE
hi Float guifg=#ff0044 guibg=NONE guisp=NONE gui=NONE ctermfg=197 ctermbg=NONE cterm=NONE
hi StatusLineNC guifg=#ffffff guibg=#000000 guisp=#000000 gui=bold ctermfg=15 ctermbg=NONE cterm=bold
hi NonText guifg=#2e373e guibg=NONE guisp=NONE gui=italic ctermfg=237 ctermbg=NONE cterm=NONE
hi DiffText guifg=#ffffcd guibg=#5f2a5f guisp=#5f2a5f gui=NONE ctermfg=230 ctermbg=53 cterm=NONE
hi ErrorMsg guifg=#ffffff guibg=#3f0000 guisp=#3f0000 gui=NONE ctermfg=15 ctermbg=52 cterm=NONE
hi Debug guifg=#8b8a7c guibg=NONE guisp=NONE gui=NONE ctermfg=101 ctermbg=NONE cterm=NONE
hi PMenuSbar guifg=NONE guibg=#767c88 guisp=#767c88 gui=NONE ctermfg=NONE ctermbg=60 cterm=NONE
hi Identifier guifg=#40e0d0 guibg=NONE guisp=NONE gui=NONE ctermfg=80 ctermbg=NONE cterm=NONE
hi SpecialChar guifg=#c526ff guibg=NONE guisp=NONE gui=bold ctermfg=13 ctermbg=NONE cterm=bold
hi Conditional guifg=#ff9d00 guibg=NONE guisp=NONE gui=bold ctermfg=214 ctermbg=NONE cterm=bold
hi StorageClass guifg=#40e0d0 guibg=NONE guisp=NONE gui=bold,italic ctermfg=80 ctermbg=NONE cterm=bold
hi Todo guifg=#ffdd00 guibg=#000000 guisp=#000000 gui=NONE ctermfg=220 ctermbg=NONE cterm=NONE
hi Special guifg=#c526ff guibg=NONE guisp=NONE gui=bold ctermfg=13 ctermbg=NONE cterm=bold
hi LineNr guifg=#ffe4cc guibg=NONE guisp=NONE gui=NONE ctermfg=224 ctermbg=NONE cterm=NONE
hi StatusLine guifg=#ffffff guibg=#000000 guisp=#000000 gui=bold ctermfg=15 ctermbg=NONE cterm=bold
hi Label guifg=#ff9d00 guibg=NONE guisp=NONE gui=bold ctermfg=214 ctermbg=NONE cterm=bold
hi PMenuSel guifg=#ffffff guibg=#0088ff guisp=#0088ff gui=NONE ctermfg=15 ctermbg=33 cterm=NONE
hi Search guifg=#ffffff guibg=#0088ff guisp=#0088ff gui=NONE ctermfg=15 ctermbg=33 cterm=NONE
hi Delimiter guifg=#8b8a7c guibg=NONE guisp=NONE gui=NONE ctermfg=101 ctermbg=NONE cterm=NONE
hi Statement guifg=#ff9d00 guibg=NONE guisp=NONE gui=bold ctermfg=214 ctermbg=NONE cterm=bold
hi Comment guifg=#0088ff guibg=NONE guisp=NONE gui=italic ctermfg=33 ctermbg=NONE cterm=NONE
hi Character guifg=#ff0044 guibg=NONE guisp=NONE gui=NONE ctermfg=197 ctermbg=NONE cterm=NONE
hi TabLineSel guifg=#ffffff guibg=#0088ff guisp=#0088ff gui=bold ctermfg=15 ctermbg=33 cterm=bold
hi Number guifg=#ff0044 guibg=NONE guisp=NONE gui=NONE ctermfg=197 ctermbg=NONE cterm=NONE
hi Boolean guifg=#ff0044 guibg=NONE guisp=NONE gui=NONE ctermfg=197 ctermbg=NONE cterm=NONE
hi Operator guifg=#ff9d00 guibg=NONE guisp=NONE gui=bold ctermfg=214 ctermbg=NONE cterm=bold
hi CursorLine guifg=NONE guibg=#1d2a30 guisp=#1d2a30 gui=NONE ctermfg=NONE ctermbg=236 cterm=NONE
hi TabLineFill guifg=#1a1a1a guibg=#536570 guisp=#536570 gui=bold ctermfg=234 ctermbg=66 cterm=bold
hi WarningMsg guifg=#080808 guibg=#ffcc00 guisp=#ffcc00 gui=NONE ctermfg=232 ctermbg=220 cterm=NONE
hi DiffDelete guifg=#ff0044 guibg=NONE guisp=NONE gui=NONE ctermfg=197 ctermbg=NONE cterm=NONE
hi CursorColumn guifg=NONE guibg=#1d2a30 guisp=#1d2a30 gui=NONE ctermfg=NONE ctermbg=236 cterm=NONE
hi Define guifg=#8b8a7c guibg=NONE guisp=NONE gui=NONE ctermfg=101 ctermbg=NONE cterm=NONE
hi Function guifg=#40e0d0 guibg=NONE guisp=NONE gui=bold ctermfg=80 ctermbg=NONE cterm=bold
hi FoldColumn guifg=#1a1a1a guibg=#909da8 guisp=#909da8 gui=italic ctermfg=234 ctermbg=109 cterm=NONE
hi PreProc guifg=#c526ff guibg=NONE guisp=NONE gui=NONE ctermfg=13 ctermbg=NONE cterm=NONE
hi Visual guifg=#1a1a1a guibg=#e4dfff guisp=#e4dfff gui=NONE ctermfg=234 ctermbg=189 cterm=NONE
hi VertSplit guifg=#1a1a1a guibg=#536570 guisp=#536570 gui=bold ctermfg=234 ctermbg=66 cterm=bold
hi Exception guifg=#ff9d00 guibg=NONE guisp=NONE gui=bold ctermfg=214 ctermbg=NONE cterm=bold
hi Keyword guifg=#ffdd00 guibg=NONE guisp=NONE gui=bold ctermfg=220 ctermbg=NONE cterm=bold
hi Type guifg=#40e0d0 guibg=NONE guisp=NONE gui=bold ctermfg=80 ctermbg=NONE cterm=bold
hi DiffChange guifg=#ffffcd guibg=#306b8f guisp=#306b8f gui=NONE ctermfg=230 ctermbg=24 cterm=NONE
hi Cursor guifg=#000000 guibg=#f9e0f5 guisp=#f9e0f5 gui=NONE ctermfg=NONE ctermbg=225 cterm=NONE
hi Error guifg=#ffffff guibg=#3f0000 guisp=#3f0000 gui=NONE ctermfg=15 ctermbg=52 cterm=NONE
hi PMenu guifg=#ffffff guibg=#000000 guisp=#000000 gui=NONE ctermfg=15 ctermbg=NONE cterm=NONE
hi SpecialKey guifg=#ffdd00 guibg=NONE guisp=NONE gui=NONE ctermfg=220 ctermbg=NONE cterm=NONE
hi Constant guifg=#ff0044 guibg=NONE guisp=NONE gui=NONE ctermfg=197 ctermbg=NONE cterm=NONE
hi Tag guifg=#ff9d00 guibg=NONE guisp=NONE gui=NONE ctermfg=214 ctermbg=NONE cterm=NONE
hi String guifg=#3ad900 guibg=NONE guisp=NONE gui=NONE ctermfg=76 ctermbg=NONE cterm=NONE
hi PMenuThumb guifg=NONE guibg=#939aa8 guisp=#939aa8 gui=NONE ctermfg=NONE ctermbg=103 cterm=NONE
hi MatchParen guifg=#ffffff guibg=#d70061 guisp=#d70061 gui=bold ctermfg=15 ctermbg=161 cterm=bold
hi Repeat guifg=#ff9d00 guibg=NONE guisp=NONE gui=bold ctermfg=214 ctermbg=NONE cterm=bold
hi Directory guifg=#00bfff guibg=NONE guisp=NONE gui=NONE ctermfg=39 ctermbg=NONE cterm=NONE
hi Structure guifg=#ff9d00 guibg=NONE guisp=NONE gui=bold ctermfg=214 ctermbg=NONE cterm=bold
hi Macro guifg=#ffdd00 guibg=NONE guisp=NONE gui=NONE ctermfg=220 ctermbg=NONE cterm=NONE
hi DiffAdd guifg=NONE guibg=#3a3a3a guisp=#3a3a3a gui=NONE ctermfg=NONE ctermbg=237 cterm=NONE
hi TabLine guifg=#ffffff guibg=#000000 guisp=#000000 gui=bold ctermfg=15 ctermbg=NONE cterm=bold
hi cursorim guifg=#1a1a1a guibg=#445291 guisp=#445291 gui=NONE ctermfg=234 ctermbg=60 cterm=NONE
