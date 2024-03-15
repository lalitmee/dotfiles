# XDG configuration home
if [[ -z $XDG_CONFIG_HOME ]]
then
    export XDG_CONFIG_HOME=$HOME/.config
fi

# XDG data home
if [[ -z $XDG_DATA_HOME ]]
then
    export XDG_DATA_HOME=$HOME/.local/share
fi

# -------------------------------------------------------------------
# NOTE: terminal {{{
# -------------------------------------------------------------------
export ZSH="$HOME/.oh-my-zsh"
export LANG=en_US.UTF-8
export LC_CTYPE=en_US.UTF-8
export TERM="xterm-256color"
# }}}
# -------------------------------------------------------------------

# -------------------------------------------------------------------
# NOTE: editor {{{
# -------------------------------------------------------------------
export EDITOR="nvim"
export VISUAL="nvr --remote-wait +'set bufhidden=wipe'"
export GIT_EDITOR="nvim"
export NVIM_LOG_FILE_PATH="$HOME/.logs/nvim"
# }}}
# -------------------------------------------------------------------

# -------------------------------------------------------------------
# NOTE: exporting path {{{
# -------------------------------------------------------------------
# rofi
export PATH=$HOME/.config/rofi/scripts:$PATH

# doom-emacs
export PATH="$HOME/.config/emacs/bin:$PATH"

# local scripts
export PATH="$HOME/.local/bin:$PATH"

# .config scripts
export PATH="$HOME/.config/bin:$PATH"

# cargo
export PATH="$HOME/cargo/bin:$PATH"
. "$HOME/.cargo/env"

# go
export PATH=$PATH:$GOROOT/bin:$GOPATH/bin
export GOPATH=$HOME/go

# deno
export DENO_INSTALL="/home/lenovo/.deno"
export PATH="$DENO_INSTALL/bin:$PATH"

# pyenv
export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"

# yarn
export PATH="$HOME/.yarn/bin:$HOME/.config/yarn/global/node_modules/.bin:$PATH"

# rbenv
export PATH="$HOME/.rbenv/bin:$PATH"

# t-smart-session-manager
export PATH=$HOME/.tmux/plugins/t-smart-tmux-session-manager/bin:$PATH
# }}}
# -------------------------------------------------------------------

# -------------------------------------------------------------------
# NOTE: nvm {{{
# -------------------------------------------------------------------
export NVM_LAZY_LOAD=true

# NOTE: for linux
# export NVM_DIR="$HOME/.config/nvm"
# [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
# [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# NOTE: for mac
export NVM_DIR="$HOME/.nvm"
[ -s "/opt/homebrew/opt/nvm/nvm.sh" ] && \. "/opt/homebrew/opt/nvm/nvm.sh"  # This loads nvm
[ -s "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm" ] && \. "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm"  # This loads nvm bash_completion
# }}}
# -------------------------------------------------------------------

# -------------------------------------------------------------------
# NOTE: s search {{{
# for s-search from the terminal
# -------------------------------------------------------------------
if [ -f $GOPATH/src/github.com/zquestz/s/autocomplete/s-completion.bash ]; then
    . $GOPATH/src/github.com/zquestz/s/autocomplete/s-completion.bash
fi
# }}}
# -------------------------------------------------------------------

# -------------------------------------------------------------------
# NOTE: ruby for mac {{{
# -------------------------------------------------------------------
export PATH="/opt/homebrew/opt/ruby/bin:$PATH"
export LDFLAGS="-L/opt/homebrew/opt/ruby/lib"
export CPPFLAGS="-I/opt/homebrew/opt/ruby/include"
# }}}
# -------------------------------------------------------------------
