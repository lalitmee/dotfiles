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
# NOTE: colored man pages {{{
# -------------------------------------------------------------------
export LESS_TERMCAP_mb=$'\e[1;32m'
export LESS_TERMCAP_md=$'\e[1;32m'
export LESS_TERMCAP_me=$'\e[0m'
export LESS_TERMCAP_se=$'\e[0m'
export LESS_TERMCAP_so=$'\e[01;33m'
export LESS_TERMCAP_ue=$'\e[0m'
export LESS_TERMCAP_us=$'\e[1;4;31m'
# }}}
# -------------------------------------------------------------------

# -------------------------------------------------------------------
# NOTE: editor {{{
# -------------------------------------------------------------------
export EDITOR="nvim"
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
# }}}
# -------------------------------------------------------------------

# -------------------------------------------------------------------
# NOTE: nvm {{{
# -------------------------------------------------------------------
export NVM_LAZY_LOAD=true
export NVM_DIR="$HOME/.config/nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
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
