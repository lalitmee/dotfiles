" set guifont=SauceCodePro\ Nerd\ Font:h11
" set guifont=CaskaydiaCove\ Nerd\ Font:h10
" set guifont=Operator\ Mono\ Nerd\ Font:h11
" set guifont=Operator\ Mono\ Lig:h11
" set guifont=JetbrainsMono\ Nerd\ Font\ Mono:h10
" set guifont=mononoki\ Nerd\ Font\ Mono:h13
" set guifont=UbuntuMono\ Nerd\ Font:h13
" set guifont=Consolas\ NF:h12
set guifont=BlexMono\ Nerd\ Font\ Mono:h10
" set guifont=SpaceMono\ Nerd\ Font\ Mono:h10
" set guifont=MonoLisa\ Font:h10

" colorscheme nightfox
" colorscheme nordfox
" colorscheme themer_ayu_dark
" colorscheme themer_gruvbox
" colorscheme themer_gruvbox-material-dark-hard
" colorscheme themer_catppuccin
" colorscheme themer_kanagawa
" lua require('colorbuddy').colorscheme('cobalt2')

lua << EOF
 require("themer").setup({
    colorscheme = "ayu_dark",
    styles = {
      comment = { style = "italic" },
      }
    })
EOF
