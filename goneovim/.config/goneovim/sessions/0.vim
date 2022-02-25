let SessionLoad = 1
let s:so_save = &g:so | let s:siso_save = &g:siso | setg so=0 siso=0 | setl so=-1 siso=-1
let v:this_session=expand("<sfile>:p")
let UltiSnipsExpandTrigger = "<tab>"
let UltiSnipsJumpForwardTrigger = "<c-j>"
let UltiSnipsRemoveSelectModeMappings =  1 
let UltiSnipsDebugPort =  8080 
let CoolTotalMatches =  1 
let UltiSnipsEnableSnipMate =  1 
let Mundo_PluginLoaded =  1 
let UltiSnipsDebugServerEnable =  0 
let UltiSnipsJumpBackwardTrigger = "<c-k>"
let UltiSnipsDebugHost = "localhost"
let UltiSnipsListSnippets = "<c-tab>"
let UltiSnipsEditSplit = "normal"
let UltiSnipsPMDebugBlocking =  0 
silent only
silent tabonly
cd ~/dotfiles
if expand('%') == '' && !&modified && line('$') <= 1 && getline(1) == ''
  let s:wipebuf = bufnr('%')
endif
set shortmess=aoO
badd +3 nvim/.config/nvim/lua/lk/colorscheme/gruvbuddy.lua
badd +2 nvim/.config/nvim/lua/plugins.lua
badd +17 nvim/.config/nvim/lua/lk/colorscheme/init.lua
badd +2 nvim/.config/nvim/lua/lk/colorscheme/test.lua
badd +220 nvim/.config/nvim/lua/lk/plugins/telescope/init.lua
badd +6 nvim/.config/nvim/lua/lk/statusline/lualine.lua
badd +1 kitty/.config/kitty/kitty-themes/Cobalt2.conf
badd +1239 nvim/.config/nvim/lua/lk/plugins/which-key.lua
badd +236 nvim/.config/nvim/lua/lk/utils.lua
badd +57 nvim/.config/nvim/lua/lk/plugins/coc.lua
badd +6 nvim/.config/nvim/syntax/NeogitStatus.vim
badd +4 ~/dotfiles/nvim/.config/nvim/lua/lk/colorscheme/catppuccin.lua
badd +4 nvim/.config/nvim/lua/lk/colorscheme/material.lua
badd +1439 ~/dotfiles/kitty/.config/kitty/kitty.conf
badd +1 ~/dotfiles/kitty/.config/kitty/kitty-themes/kanagawa.conf
badd +6 ~/dotfiles/nvim/.config/nvim/lua/lk/colorscheme/nightfox.lua
badd +5 nvim/.config/nvim/lua/lk/colorscheme/vscode.lua
argglobal
%argdel
edit nvim/.config/nvim/lua/plugins.lua
argglobal
balt nvim/.config/nvim/lua/lk/plugins/which-key.lua
let s:l = 4 - ((3 * winheight(0) + 27) / 54)
if s:l < 1 | let s:l = 1 | endif
keepjumps exe s:l
normal! zt
keepjumps 4
normal! 0
tabnext 1
if exists('s:wipebuf') && len(win_findbuf(s:wipebuf)) == 0 && getbufvar(s:wipebuf, '&buftype') isnot# 'terminal'
  silent exe 'bwipe ' . s:wipebuf
endif
unlet! s:wipebuf
set winheight=1 winwidth=20 shortmess=WcfosFtTOAI
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
