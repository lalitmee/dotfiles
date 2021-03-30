" https://github.com/lalitmee/dotfiles
" Created By: Lalit Kumar

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

source $HOME/.config/nvim/general/functions.vim
source $HOME/.config/nvim/general/options.vim

" General Settings }}}

" Lua Plugins {{{

luafile $HOME/.config/nvim/lua/lk/init.lua

" Lua Plugins }}}

" Plugins Configurations {{{

" source $HOME/.config/nvim/plug-config/vsnip.vim
source $HOME/.config/nvim/plug-config/fzf.vim
source $HOME/.config/nvim/plug-config/incsearch.vim

" Plugins Configurations }}}

" Keys Mappings {{{

source $HOME/.config/nvim/keys/all.vim
source $HOME/.config/nvim/keys/fzf.vim
source $HOME/.config/nvim/keys/harpoon.vim
source $HOME/.config/nvim/keys/lsp.vim
source $HOME/.config/nvim/keys/mappings.vim
source $HOME/.config/nvim/keys/navigation.vim
source $HOME/.config/nvim/keys/telescope.vim
source $HOME/.config/nvim/keys/vim-zettel.vim
source $HOME/.config/nvim/keys/which-key.vim
source $HOME/.config/nvim/keys/windows.vim

" Keys Mappings }}}
