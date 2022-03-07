let SessionLoad = 1
let s:so_save = &g:so | let s:siso_save = &g:siso | setg so=0 siso=0 | setl so=-1 siso=-1
let v:this_session=expand("<sfile>:p")
let UltiSnipsExpandTrigger = "<tab>"
let UltiSnipsJumpForwardTrigger = "<c-j>"
let UltiSnipsRemoveSelectModeMappings =  0 
let CoolTotalMatches =  1 
let UltiSnipsEnableSnipMate =  1 
let UltiSnipsDebugServerEnable =  0 
let UltiSnipsJumpBackwardTrigger = "<c-k>"
let UltiSnipsDebugHost = "localhost"
let UltiSnipsListSnippets = "<c-tab>"
let UltiSnipsEditSplit = "vertical"
let UltiSnipsPMDebugBlocking =  0 
let UltiSnipsDebugPort =  8080 
silent only
silent tabonly
cd ~/dotfiles
if expand('%') == '' && !&modified && line('$') <= 1 && getline(1) == ''
  let s:wipebuf = bufnr('%')
endif
set shortmess=aoO
badd +45 goneovim/.config/goneovim/setting.toml
badd +9 nvim/.config/nvim/after/plugin/gonvim-fuzzy.vim
argglobal
%argdel
edit goneovim/.config/goneovim/setting.toml
argglobal
let s:l = 58 - ((39 * winheight(0) + 29) / 59)
if s:l < 1 | let s:l = 1 | endif
keepjumps exe s:l
normal! zt
keepjumps 58
normal! 013|
tabnext 1
if exists('s:wipebuf') && len(win_findbuf(s:wipebuf)) == 0 && getbufvar(s:wipebuf, '&buftype') isnot# 'terminal'
  silent exe 'bwipe ' . s:wipebuf
endif
unlet! s:wipebuf
set winheight=1 winwidth=20 shortmess=cFsoAtWTOfI
let s:sx = expand("<sfile>:p:r")."x.vim"
if filereadable(s:sx)
  exe "source " . fnameescape(s:sx)
endif
let &g:so = s:so_save | let &g:siso = s:siso_save
set hlsearch
nohlsearch
doautoall SessionLoadPost
unlet SessionLoad
" vim: set ft=vim :
