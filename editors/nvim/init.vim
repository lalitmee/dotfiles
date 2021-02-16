autocmd VimEnter *
  \  if len(filter(values(g:plugs), '!isdirectory(v:val.dir)'))
  \|   PlugInstall --sync | q
  \| endif

" let $NVIM_CONFIG_DIR = expand('$HOME/.config/nvim')

" if has('nvim-0.5')
"     " nightly config
"     source $NVIM_CONFIG_DIR/init.vim
" else
"     " stable config
"     source $NVIM_CONFIG_DIR/init.vim
" end

" Plugins
source $HOME/.config/nvim/vim-plug/plugins.vim

" General Settings
source $HOME/.config/nvim/general/abbreviations.vim
source $HOME/.config/nvim/general/buffers.vim
source $HOME/.config/nvim/general/cursor.vim
source $HOME/.config/nvim/general/fold.vim
source $HOME/.config/nvim/general/fonts.vim
source $HOME/.config/nvim/general/functions.vim
source $HOME/.config/nvim/general/hosts.vim
source $HOME/.config/nvim/general/search.vim
source $HOME/.config/nvim/general/settings.vim
source $HOME/.config/nvim/general/tmux.vim


" Lua Plugins
" luafile $HOME/.config/nvim/lua-config/formatter.lua
" luafile $HOME/.config/nvim/lua-config/status-lines/express_line.lua
" luafile $HOME/.config/nvim/lua-config/status-lines/galaxylines/1.lua
" luafile $HOME/.config/nvim/lua-config/status-lines/nvcodeline.lua
luafile $HOME/.config/nvim/lua-config/fuzzy/telescope.lua
luafile $HOME/.config/nvim/lua-config/themes/colorizer.lua
luafile $HOME/.config/nvim/lua-config/treesitter.lua
" luafile $HOME/.config/nvim/lua-config/bufferline.lua
" luafile $HOME/.config/nvim/lua/lsp.lua

" Colorschemes
" source $HOME/.config/nvim/themes/nvcode.vim
" source $HOME/.config/nvim/themes/solarized.vim
" source $HOME/.config/nvim/themes/gruvbox.vim
" source $HOME/.config/nvim/themes/gruvbox8.vim
" source $HOME/.config/nvim/themes/gruvbuddy.vim
source $HOME/.config/nvim/themes/nord.vim
" source $HOME/.config/nvim/themes/onedark.vim

" Status Lines
" source $HOME/.config/nvim/status-lines/barow.vim
source $HOME/.config/nvim/status-lines/lightline.vim
" source $HOME/.config/nvim/status-lines/airline.vim
" source $HOME/.config/nvim/status-lines/barbar.vim

" Tab Lines
source $HOME/.config/nvim/plug-config/xtabline.vim

" Plugins Configurations
source $HOME/.config/nvim/plug-config/nvim-tree.vim
source $HOME/.config/nvim/plug-config/coc.vim
source $HOME/.config/nvim/plug-config/cyclist.vim
source $HOME/.config/nvim/plug-config/emmet.vim
source $HOME/.config/nvim/plug-config/far.vim
source $HOME/.config/nvim/plug-config/floaterm.vim
source $HOME/.config/nvim/plug-config/formatter.vim
source $HOME/.config/nvim/plug-config/fugitive.vim
source $HOME/.config/nvim/plug-config/fzf-preview.vim
source $HOME/.config/nvim/plug-config/fzf.vim
source $HOME/.config/nvim/plug-config/git-messenger.vim
source $HOME/.config/nvim/plug-config/incsearch.vim
source $HOME/.config/nvim/plug-config/indentLine.vim
source $HOME/.config/nvim/plug-config/magit.vim
source $HOME/.config/nvim/plug-config/quickscope.vim
source $HOME/.config/nvim/plug-config/rainbow.vim
source $HOME/.config/nvim/plug-config/ranger.vim
source $HOME/.config/nvim/plug-config/rnvimr.vim
source $HOME/.config/nvim/plug-config/startify.vim
source $HOME/.config/nvim/plug-config/tabular.vim
source $HOME/.config/nvim/plug-config/tagalong.vim
source $HOME/.config/nvim/plug-config/ultisnips.vim
source $HOME/.config/nvim/plug-config/vim-better-whitespace.vim
source $HOME/.config/nvim/plug-config/vim-closetag.vim
source $HOME/.config/nvim/plug-config/vim-markdown.vim
source $HOME/.config/nvim/plug-config/window-swap.vim
" source $HOME/.config/nvim/plug-config/lsp.vim

" Keys Mappings
source $HOME/.config/nvim/keys/mappings.vim
source $HOME/.config/nvim/keys/telescope.vim
source $HOME/.config/nvim/keys/which-key.vim
source $HOME/.config/nvim/keys/windows.vim

