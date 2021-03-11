" Auto install vim-plug {{{

" auto-install vim-plug
if empty(glob('~/.config/nvim/autoload/plug.vim'))
  silent !curl -fLo
        \ ~/.config/nvim/autoload/plug.vim --create-dirs
        \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall
endif

" auto install not installed pacakges
autocmd VimEnter *
  \  if len(filter(values(g:plugs), '!isdirectory(v:val.dir)'))
  \|   PlugInstall --sync | q
  \| endif

" Auto install vim-plug }}}

" Reload config on save {{{

if !exists('*ReloadVimrc')
   fun! ReloadVimrc()
       let save_cursor = getcurpos()
       source $MYVIMRC
       call setpos('.', save_cursor)
   endfun
endif
autocmd! BufWritePost $MYVIMRC call ReloadVimrc()

" Reload config on save }}}

" Plugins {{{

source $HOME/.config/nvim/vim-plug/plugins.vim

" Plugins }}}

" General Settings {{{

source $HOME/.config/nvim/general/buffers.vim
source $HOME/.config/nvim/general/cursor.vim
source $HOME/.config/nvim/general/fonts.vim
source $HOME/.config/nvim/general/format.vim
source $HOME/.config/nvim/general/functions.vim
source $HOME/.config/nvim/general/hosts.vim
source $HOME/.config/nvim/general/search.vim
source $HOME/.config/nvim/general/settings.vim
source $HOME/.config/nvim/general/tmux.vim

" General Settings }}}

" Lua Plugins {{{

" luafile $HOME/.config/nvim/lua/config/lsp/init.lua
" luafile $HOME/.config/nvim/lua/config/status-lines/express_line.lua
" luafile $HOME/.config/nvim/lua/config/status-lines/galaxylines/1.lua
" luafile $HOME/.config/nvim/lua/config/status-lines/galaxylines/4.lua
" luafile $HOME/.config/nvim/lua/config/status-lines/lualine.lua
" luafile $HOME/.config/nvim/lua/plugins/bufferline.lua
" luafile $HOME/.config/nvim/lua/plugins/completion.lua
" luafile $HOME/.config/nvim/lua/plugins/formatter.lua
" luafile $HOME/.config/nvim/lua/plugins/indent-guides.lua
" luafile $HOME/.config/nvim/lua/plugins/kommentary.lua
" luafile $HOME/.config/nvim/lua/plugins/lsp-fuzzy.lua
" luafile $HOME/.config/nvim/lua/plugins/neuron.lua
luafile $HOME/.config/nvim/lua/config/globals/init.lua
luafile $HOME/.config/nvim/lua/config/telescope/init.lua
luafile $HOME/.config/nvim/lua/config/telescope/mappings.lua
luafile $HOME/.config/nvim/lua/plugins/auto-pairs.lua
luafile $HOME/.config/nvim/lua/plugins/colorizer.lua
luafile $HOME/.config/nvim/lua/plugins/gitsigns.lua
luafile $HOME/.config/nvim/lua/plugins/hlslens.lua
luafile $HOME/.config/nvim/lua/plugins/lightbulb.lua
luafile $HOME/.config/nvim/lua/plugins/snippets.lua
luafile $HOME/.config/nvim/lua/plugins/treesitter.lua

" Lua Plugins }}}

" Colorschemes {{{

" luafile $HOME/.config/nvim/lua/config/colors/nord.lua
" source $HOME/.config/nvim/colorschemes/test.vim
luafile $HOME/.config/nvim/lua/config/colors/gruvbuddy.lua

" Colorschemes }}}

" Status Lines {{{

" Status Lines
" source $HOME/.config/nvim/status-lines/airline.vim
" source $HOME/.config/nvim/status-lines/barow.vim
source $HOME/.config/nvim/status-lines/lightline.vim

" Tab Lines
" source $HOME/.config/nvim/tab-lines/barbar.vim
source $HOME/.config/nvim/tab-lines/xtabline.vim

" Status Lines }}}

" Plugins Configurations {{{

" source $HOME/.config/nvim/plug-config/cyclist.vim
" source $HOME/.config/nvim/plug-config/ranger.vim
" source $HOME/.config/nvim/plug-config/rnvimr.vim
source $HOME/.config/nvim/plug-config/action-menu.vim
source $HOME/.config/nvim/plug-config/any-jump.vim
source $HOME/.config/nvim/plug-config/auto-sessions.vim
source $HOME/.config/nvim/plug-config/coc.vim
source $HOME/.config/nvim/plug-config/crease.vim
source $HOME/.config/nvim/plug-config/emmet.vim
source $HOME/.config/nvim/plug-config/far.vim
source $HOME/.config/nvim/plug-config/floaterm.vim
source $HOME/.config/nvim/plug-config/fnr.vim
source $HOME/.config/nvim/plug-config/fugitive.vim
source $HOME/.config/nvim/plug-config/fzf-preview.vim
source $HOME/.config/nvim/plug-config/fzf.vim
source $HOME/.config/nvim/plug-config/git-blame.vim
source $HOME/.config/nvim/plug-config/hlslens.vim
source $HOME/.config/nvim/plug-config/incsearch.vim
source $HOME/.config/nvim/plug-config/indentLine.vim
source $HOME/.config/nvim/plug-config/mundo.vim
source $HOME/.config/nvim/plug-config/nvim-bqf.vim
source $HOME/.config/nvim/plug-config/nvim-tree.vim
source $HOME/.config/nvim/plug-config/openbrowser.vim
source $HOME/.config/nvim/plug-config/quickscope.vim
source $HOME/.config/nvim/plug-config/snippets.vim
source $HOME/.config/nvim/plug-config/startify.vim
source $HOME/.config/nvim/plug-config/tabular.vim
source $HOME/.config/nvim/plug-config/tagalong.vim
source $HOME/.config/nvim/plug-config/toggle-term.vim
source $HOME/.config/nvim/plug-config/ultisnips.vim
source $HOME/.config/nvim/plug-config/vim-awesome.vim
source $HOME/.config/nvim/plug-config/vim-better-whitespace.vim
source $HOME/.config/nvim/plug-config/vim-closetag.vim
source $HOME/.config/nvim/plug-config/vim-markdown.vim
source $HOME/.config/nvim/plug-config/vsnip.vim

" Plugins Configurations }}}

" Keys Mappings {{{

" source $HOME/.config/nvim/keys/lsp.vim
source $HOME/.config/nvim/keys/coc.vim
source $HOME/.config/nvim/keys/fzf.vim
source $HOME/.config/nvim/keys/mappings.vim
source $HOME/.config/nvim/keys/smooth-scroll.vim
source $HOME/.config/nvim/keys/telescope.vim
source $HOME/.config/nvim/keys/vim-zettel.vim
source $HOME/.config/nvim/keys/which-key.vim
source $HOME/.config/nvim/keys/windows.vim
source $HOME/.config/nvim/keys/accelerated-jk.vim

" Keys Mappings }}}

