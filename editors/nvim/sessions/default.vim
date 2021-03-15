let SessionLoad = 1
let s:so_save = &g:so | let s:siso_save = &g:siso | setg so=0 siso=0 | setl so=-1 siso=-1
let v:this_session=expand("<sfile>:p")
let VtrClearBeforeSend = "1"
let SignatureMarkerTextHLDynamic =  0 
let UltiSnipsExpandTrigger = "<tab>"
let VtrClearSequence = ""
let VtrAppendNewline = "0"
let SignatureMarkLineHL = "SignatureMarkLine"
let UltiSnipsRemoveSelectModeMappings =  1 
let VtrPrompt = "Command to run: "
let VtrUseVtrMaps = "0"
let VtrClearOnReorient = "1"
let SignaturePrioritizeMarks =  1 
let SignatureIncludeMarkers = ")!@#$%^&*("
let SignatureMarkTextHL = "SignatureMarkText"
let SignatureMarkOrder = "pm"
let DevIconsArtifactFixChar = "            "
let SignatureDeferPlacement =  1 
let SignaturePeriodicRefresh =  1 
let SignatureMarkerLineHL = "SignatureMarkerLine"
let SignatureErrorIfNoAvailableMarks =  1 
let DevIconsAppendArtifactFix =  1 
let VtrOrientation = "v"
let SignatureMarkTextHLDynamic =  0 
let SignatureIncludeMarks = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ"
let VtrPercentage = "20"
let SignaturePurgeConfirmation =  0 
let UltiSnipsJumpBackwardTrigger = "<c-k>"
let VtrDisplayPaneNumbers = "1"
let VtrClearOnReattach = "1"
let SignatureWrapJumps =  1 
let SignatureMarkerTextHL = "SignatureMarkerText"
let VtrClearEmptyLines = "1"
let UltiSnipsEnableSnipMate =  1 
let SignatureForceMarkerPlacement =  0 
let SignatureForceMarkPlacement =  0 
let SignatureEnabledAtStartup =  1 
let UltiSnipsListSnippets = "<c-tab>"
let VtrStripLeadingWhitespace = "1"
let UltiSnipsEditSplit = "context"
let SignatureDeleteConfirmation =  0 
let VtrDetachedName = "VTR_Pane"
let SignatureForceRemoveGlobal =  0 
let VtrInitialCommand = ""
let VtrGitCdUpOnOpen = "0"
let UltiSnipsJumpForwardTrigger = "<c-j>"
let SignatureRecycleMarks =  0 
silent only
silent tabonly
cd ~/data/Github/dotfiles
if expand('%') == '' && !&modified && line('$') <= 1 && getline(1) == ''
  let s:wipebuf = bufnr('%')
endif
set shortmess=aoO
badd +1372 system/kitty/kitty.conf
badd +46 editors/nvim/plug-config/coc.vim
badd +45 editors/nvim/keys/which-key.vim
argglobal
%argdel
edit editors/nvim/plug-config/coc.vim
set splitbelow splitright
wincmd t
set winminheight=0
set winheight=1
set winminwidth=0
set winwidth=1
argglobal
balt editors/nvim/keys/which-key.vim
setlocal fdm=marker
setlocal fde=0
setlocal fmr={{{,}}}
setlocal fdi=#
setlocal fdl=999
setlocal fml=1
setlocal fdn=10
setlocal fen
let s:l = 68 - ((25 * winheight(0) + 25) / 51)
if s:l < 1 | let s:l = 1 | endif
keepjumps exe s:l
normal! zt
keepjumps 68
normal! 04|
lcd ~/data/Github/dotfiles
tabnext 1
if exists('s:wipebuf') && len(win_findbuf(s:wipebuf)) == 0&& getbufvar(s:wipebuf, '&buftype') isnot# 'terminal'
  silent exe 'bwipe ' . s:wipebuf
endif
unlet! s:wipebuf
set winheight=1 winwidth=20 winminheight=1 winminwidth=1 shortmess=filnxtToOFIc
let s:sx = expand("<sfile>:p:r")."x.vim"
if filereadable(s:sx)
  exe "source " . fnameescape(s:sx)
endif
let &g:so = s:so_save | let &g:siso = s:siso_save
nohlsearch
doautoall SessionLoadPost
unlet SessionLoad
" vim: set ft=vim :
