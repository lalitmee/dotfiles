# -------------------------------------------------------------------
# NOTE: Helper function {{{
# -------------------------------------------------------------------
# Appends a directory to the PATH environment variable if it exists and is not already present
# Args:
#   $1 (string): The directory to append to PATH
append_to_path() {
    local dir="$1"
    if [[ -d "$dir" && ":$PATH:" != *":$dir:"* ]]; then
        export PATH="$dir:$PATH"
    fi
}
# }}}
# -------------------------------------------------------------------

# -------------------------------------------------------------------
# NOTE: XDG configuration home {{{
# -------------------------------------------------------------------
if [[ -z $XDG_CONFIG_HOME ]]; then
    export XDG_CONFIG_HOME="$HOME/.config"
fi

if [[ -z $XDG_DATA_HOME ]]; then
    export XDG_DATA_HOME="$HOME/.local/share"
fi
# }}}
# -------------------------------------------------------------------

# -------------------------------------------------------------------
# NOTE: terminal {{{
# -------------------------------------------------------------------
export ZSH="$HOME/.oh-my-zsh"
export LANG="en_US.UTF-8"
export LC_CTYPE="en_US.UTF-8"
export TERM="xterm-256color"
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
# NOTE: fzf {{{
# -------------------------------------------------------------------
# sourcing fzf scripts
[[ -f ~/.fzf.zsh ]] && source ~/.fzf.zsh

# fzf config
[[ -f ~/.fzf_config ]] && source ~/.fzf_config
# }}}
# -------------------------------------------------------------------

# -------------------------------------------------------------------
# NOTE: exporting path {{{
# -------------------------------------------------------------------
# rofi
append_to_path "$HOME/.config/rofi/scripts"

# doom-emacs
append_to_path "$HOME/.config/emacs/bin"

# local scripts
append_to_path "$HOME/.local/bin"

# .config scripts
append_to_path "$HOME/.config/bin"

# cargo
append_to_path "$HOME/cargo/bin"
[[ -f "$HOME/.cargo/env" ]] && source "$HOME/.cargo/env"

# go
export GOPATH="$HOME/go"
append_to_path "$GOROOT/bin"
append_to_path "$GOPATH/bin"

# # deno
# export DENO_INSTALL="$HOME/.deno"
# append_to_path "$DENO_INSTALL/bin"

# pyenv
export PYENV_ROOT="$HOME/.pyenv"
append_to_path "$PYENV_ROOT/bin"

# # yarn
# append_to_path "$HOME/.yarn/bin"
# append_to_path "$HOME/.config/yarn/global/node_modules/.bin"

# # rbenv
# append_to_path "$HOME/.rbenv/bin"

# atuin
append_to_path "$HOME/.atuin/bin"
[[ -f "$HOME/.atuin/bin/env" ]] && source "$HOME/.atuin/bin/env"

# fnm
FNM_PATH="$HOME/.local/share/fnm"
append_to_path "$FNM_PATH"

# Homebrew
append_to_path "/home/linuxbrew/.linuxbrew/bin"

# }}}
# -------------------------------------------------------------------

# -------------------------------------------------------------------
# NOTE: s search {{{
# for s-search from the terminal
# -------------------------------------------------------------------
if [[ -f "$GOPATH/src/github.com/zquestz/s/autocomplete/s-completion.bash" ]]; then
    source "$GOPATH/src/github.com/zquestz/s/autocomplete/s-completion.bash"
fi
# }}}
# -------------------------------------------------------------------

# -------------------------------------------------------------------
# NOTE: ruby for mac {{{
# -------------------------------------------------------------------
if [[ -d "/opt/homebrew/opt/ruby/bin" ]]; then
    append_to_path "/opt/homebrew/opt/ruby/bin"
    export LDFLAGS="-L/opt/homebrew/opt/ruby/lib"
    export CPPFLAGS="-I/opt/homebrew/opt/ruby/include"
fi
# }}}
# -------------------------------------------------------------------

# -------------------------------------------------------------------
# NOTE: ripgrep {{{
# -------------------------------------------------------------------
export RIPGREP_CONFIG_PATH="$HOME/.config/ripgrep/config"
# }}}
# -------------------------------------------------------------------

# -------------------------------------------------------------------
# NOTE: flutter {{{
# -------------------------------------------------------------------
append_to_path "$HOME/development/flutter/bin"
# }}}
# -------------------------------------------------------------------

# -------------------------------------------------------------------
# NOTE: android-studio {{{
# for running android studio from anywhere
append_to_path "$HOME/android-studio/bin"

# for setting the tools of android sdk
append_to_path "$HOME/Android/Sdk/emulator"
append_to_path "$HOME/Android/Sdk/tools"
append_to_path "$HOME/Android/Sdk/tools/bin"
append_to_path "$HOME/Android/Sdk/platform-tools"
# }}}
# -------------------------------------------------------------------

# -------------------------------------------------------------------
# NOTE: neovim as man pager {{{
# -------------------------------------------------------------------
export MANPAGER='nvim +Man!'
# export PAGER='nvimpager'
# }}}
# -------------------------------------------------------------------

# -------------------------------------------------------------------
# NOTE: AI in terminal {{{
# -------------------------------------------------------------------
append_to_path "$HOME/.opencode/bin"
# }}}
# -------------------------------------------------------------------
