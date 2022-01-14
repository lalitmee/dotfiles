let SessionLoad = 1
let s:so_save = &g:so | let s:siso_save = &g:siso | setg so=0 siso=0 | setl so=-1 siso=-1
let v:this_session=expand("<sfile>:p")
let SignatureMarkerTextHLDynamic =  0 
let UltiSnipsExpandTrigger = "<tab>"
let UltiSnipsJumpForwardTrigger = "<c-j>"
let UltiSnipsRemoveSelectModeMappings =  1 
let SignatureMarkTextHL = "SignatureMarkText"
let UltiSnipsDebugPort =  8080 
let SignatureDeferPlacement =  1 
let SignaturePeriodicRefresh =  1 
let CoolTotalMatches =  1 
let SignatureMarkerLineHL = "SignatureMarkerLine"
let SignatureErrorIfNoAvailableMarks =  1 
let SignatureMarkerTextHL = "SignatureMarkerText"
let UltiSnipsEnableSnipMate =  1 
let SignatureIncludeMarkers = ")!@#$%^&*("
let SignatureEnabledAtStartup =  1 
let SignatureIncludeMarks = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ"
let Mundo_PluginLoaded =  1 
let UltiSnipsDebugServerEnable =  0 
let UltiSnipsJumpBackwardTrigger = "<c-k>"
let SignatureWrapJumps =  1 
let SignatureForceMarkerPlacement =  0 
let SignatureForceMarkPlacement =  0 
let SignaturePurgeConfirmation =  0 
let UltiSnipsDebugHost = "localhost"
let UltiSnipsListSnippets = "<c-tab>"
let SignatureMarkLineHL = "SignatureMarkLine"
let UltiSnipsEditSplit = "normal"
let SignatureForceRemoveGlobal =  0 
let SignaturePrioritizeMarks =  1 
let UltiSnipsPMDebugBlocking =  0 
let SignatureDeleteConfirmation =  0 
let SignatureMarkTextHLDynamic =  0 
let SignatureMarkOrder = "pm"
let SignatureRecycleMarks =  0 
silent only
silent tabonly
cd ~/dotfiles
if expand('%') == '' && !&modified && line('$') <= 1 && getline(1) == ''
  let s:wipebuf = bufnr('%')
endif
set shortmess=aoO
argglobal
%argdel
edit nvim/.config/nvim/lua/lk/colorscheme/init.lua
let s:save_splitbelow = &splitbelow
let s:save_splitright = &splitright
set splitbelow splitright
let &splitbelow = s:save_splitbelow
let &splitright = s:save_splitright
wincmd t
let s:save_winminheight = &winminheight
let s:save_winminwidth = &winminwidth
set winminheight=0
set winheight=1
set winminwidth=0
set winwidth=1
argglobal
balt nvim/.config/nvim/lua/lk/colorscheme/kanagawa.lua
let s:l = 4 - ((3 * winheight(0) + 27) / 54)
if s:l < 1 | let s:l = 1 | endif
keepjumps exe s:l
normal! zt
keepjumps 4
normal! 0
lcd ~/dotfiles
tabnext 1
badd +44 ~/dotfiles/goneovim/.config/goneovim/setting.toml
badd +66 ~/dotfiles/nvim/.config/nvim/lua/plugins.lua
badd +1 ~/dotfiles/nvim/.config/nvim/ginit.vim
badd +3 ~/dotfiles/nvim/.config/nvim/after/plugin/neovide.vim
badd +195 ~/dotfiles/nvim/.config/nvim/lua/lk/plugins/telescope/init.lua
badd +3 ~/dotfiles/nvim/.config/nvim/lua/lk/colorscheme/init.lua
badd +3 ~/dotfiles/nvim/.config/nvim/lua/lk/statusline/lualine.lua
badd +1403 ~/dotfiles/kitty/.config/kitty/kitty.conf
badd +18 ~/dotfiles/nvim/.config/nvim/lua/lk/plugins/which-key.lua
badd +4 ~/dotfiles/nvim/.config/nvim/lua/lk/colorscheme/github.lua
badd +21 ~/dotfiles/nvim/.config/nvim/lua/lk/plugins/toggleterm.lua
badd +1 ~/dotfiles/chemacs/.emacs-profile
badd +289 ~/dotfiles/nvim/.config/nvim/lua/lk/settings.lua
badd +11 ~/dotfiles/bin/.local/bin/tmux-cht.sh
badd +2 term://~/dotfiles//2192897:/usr/bin/zsh
badd +2 term://~/dotfiles//2194682:/usr/bin/zsh
badd +1 ~/dotfiles/nvim/.config/nvim/lua/lk/colorscheme/kanagawa.lua
if exists('s:wipebuf') && len(win_findbuf(s:wipebuf)) == 0 && getbufvar(s:wipebuf, '&buftype') isnot# 'terminal'
  silent exe 'bwipe ' . s:wipebuf
endif
unlet! s:wipebuf
set winheight=1 winwidth=20 shortmess=fFsToAWcOt
let &winminheight = s:save_winminheight
let &winminwidth = s:save_winminwidth
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
