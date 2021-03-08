if exists('g:fvim_loaded')
    FVimCursorSmoothMove v:true
    FVimCursorSmoothBlink v:true

    " good old 'set guifont' compatibility
    " set guifont=UbuntuMono\ Nerd\ Font:h16
    set guifont=SauceCodePro\ Nerd\ Font:h14
    " set guifont=CaskaydiaCove\ Nerd\ Font:h13
    " set guifont=JetbrainsMono\ Nerd\ Font:h13
    " set guifont=OperatorMono\ Nerd\ Font:h13
    " Ctrl-ScrollWheel for zooming in/out
    nnoremap <silent> <C-ScrollWheelUp> :set guifont=+<CR>
    nnoremap <silent> <C-ScrollWheelDown> :set guifont=-<CR>
    nnoremap <A-CR> :FVimToggleFullScreen<CR>
    colorscheme nvcode
endif

if exists('g:glrnvim_gui')
    " good old 'set guifont' compatibility
    " set guifont=UbuntuMono\ Nerd\ Font:h16
    set guifont=SauceCodePro\ Nerd\ Font:h14
    " set guifont=CaskaydiaCove\ Nerd\ Font:h13
    " set guifont=JetbrainsMono\ Nerd\ Font:h13
    " set guifont=OperatorMono\ Nerd\ Font:h13
    " Ctrl-ScrollWheel for zooming in/out
endif
