" set guifont=SauceCodePro\ Nerd\ Font:h14
set guifont=CaskaydiaCove\ Nerd\ Font:h15
" set guifont=Operator\ Mono\ Nerd\ Font:h14
" set guifont=JetbrainsMono\ Nerd\ Font:h14

if exists('g:fvim_loaded')
    FVimCursorSmoothMove v:true
    FVimCursorSmoothBlink v:true

    " good old 'set guifont' compatibility
    " set guifont=UbuntuMono\ Nerd\ Font:h16
    " set guifont=SauceCodePro\ Nerd\ Font:h14
    " set guifont=CaskaydiaCove\ Nerd\ Font:h14
    " set guifont=JetbrainsMono\ Nerd\ Font:h14
    " set guifont=Monaco\ Nerd\ Font:h13
    " Ctrl-ScrollWheel for zooming in/out
    nnoremap <silent> <C-ScrollWheelUp> :set guifont=+<CR>
    nnoremap <silent> <C-ScrollWheelDown> :set guifont=-<CR>
    nnoremap <A-CR> :FVimToggleFullScreen<CR>
    " colorscheme darkblue
    lua require('colorbuddy').colorscheme('gruvbuddy')
endif

if exists('g:GuiLoaded')
    " Guifont Operator Mono Lig Book:h11
    " Guifont OperatorMono Nerd Font:h11
    Guifont JetbrainsMono Nerd Font:h11
    lua require('colorbuddy').colorscheme('gruvbuddy')
endif

if exists('g:GtkGuiLoaded')
    set guifont=JetbrainsMono\ Nerd\ Font:h14
    lua require('colorbuddy').colorscheme('gruvbuddy')
endif

