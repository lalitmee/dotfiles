# zmodload zsh/zprof

unsetopt INC_APPEND_HISTORY
unsetopt SHARE_HISTORY
SAVEHIST=0

# -------------------------------------------------------------------
# # NOTE: auto start tmux {{{
# start tmux while starting new terminal
# -------------------------------------------------------------------
_not_inside_tmux() { [[ -z "$TMUX" ]]; }

ensure_tmux_is_running() {
    if _not_inside_tmux; then
        ~/.tat
    fi
}

ensure_tmux_is_running
# -------------------------------------------------------------------
# }}}
# -------------------------------------------------------------------

# -------------------------------------------------------------------
# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi


# Download Znap, if it's not there yet.
[[ -r ~/.oh-my-zsh/custom/plugins/znap/znap.zsh ]] ||
    git clone --depth 1 -- \
    https://github.com/marlonrichert/zsh-snap.git ~/.oh-my-zsh/custom/plugins/znap
    source "$ZSH/custom/plugins/znap/znap.zsh"

# -------------------------------------------------------------------
# # NOTE: oh-my-zsh {{{
# -------------------------------------------------------------------
# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH

# Path to your oh-my-zsh installation.

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time oh-my-zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/robbyrussell/oh-my-zsh/wiki/Themes
ZSH_THEME="powerlevel10k/powerlevel10k"

# Set list of themes to pick from when loading at random
# Setting this variable when ZSH_THEME=random will cause zsh to load
# a theme from this variable instead of looking in ~/.oh-my-zsh/themes/
# If set to an empty array, this variable will have no effect.
# ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment the following line to disable bi-weekly auto-update checks.
# DISABLE_AUTO_UPDATE="true"

# Uncomment the following line to change how often to auto-update (in days).
export UPDATE_ZSH_DAYS=5

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# export DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# export ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
export COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# You can set one of the optional three formats:
# "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# or set a custom format using the strftime function format specifications,
# see 'man strftime' for details.
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# -------------------------------------------------------------------
# # NOTE: plugins {{{
# -------------------------------------------------------------------
# Which plugins would you like to load?
# Standard plugins can be found in ~/.oh-my-zsh/plugins/*
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(
    fast-syntax-highlighting
    fzf-tab
    git
    vi-mode
    zsh-autosuggestions
    zsh-wakatime
)

# zsh completions
fpath+=${ZSH_CUSTOM:-${ZSH:-~/.oh-my-zsh}/custom}/plugins/zsh-completions/src

source $ZSH/oh-my-zsh.sh

# # ~/.zshrc — disable Powerlevel10k when Cursor Agent runs
# if [[ -n "$CURSOR_AGENT" ]]; then
#     # Skip theme initialization for better compatibility
# else
#     # Load p10k prompt first (no output)
[[ -r "${HOME}/.p10k.zsh" ]] && source "${HOME}/.p10k.zsh"
# fi

# }}}
# -------------------------------------------------------------------

# }}}
# -------------------------------------------------------------------

# -------------------------------------------------------------------
# # NOTE: user configurations {{{
# -------------------------------------------------------------------
if [[ $TERM == xterm ]]; then
    TERM=screen-256color
fi
# }}}
# -------------------------------------------------------------------

# -------------------------------------------------------------------
# # NOTE: sourcing some of the other things {{{
# -------------------------------------------------------------------

# aliases
[[ -f ~/.zsh_aliases ]] && source ~/.zsh_aliases

# secrete tokens
[[ -f ~/.secret-tokens ]] && source ~/.secret-tokens

# awesome zsh functions
[[ -f ~/.zsh_functions ]] && source ~/.zsh_functions

# keybindings
[[ -f ~/.zsh_keybindings ]] && source ~/.zsh_keybindings

# plugins config
[[ -f ~/.zsh_plugins_config/init.zsh ]] && source ~/.zsh_plugins_config/init.zsh
# }}}
# -------------------------------------------------------------------

# # -------------------------------------------------------------------
# # NOTE: starship prompt {{{
# # -------------------------------------------------------------------
# znap eval starship "starship init zsh --print-full-init"
# znap prompt
# # }}}
# # -------------------------------------------------------------------

# -------------------------------------------------------------------
# # NOTE: zoxide {{{
# -------------------------------------------------------------------
# znap eval zoxide "zoxide init zsh"
# znap eval zoxide "zoxide init zsh --cmd cd"
eval "$(zoxide init zsh)"
# }}}
# -------------------------------------------------------------------

# -------------------------------------------------------------------
# # NOTE: pyenv {{{
# -------------------------------------------------------------------
znap eval pyenv "pyenv init -"
eval "$(pyenv init --path)"
eval "$(pyenv init -)"
eval "$(pyenv virtualenv-init -)"
# }}}
# -------------------------------------------------------------------

# -------------------------------------------------------------------
# # NOTE: rbenv {{{
# -------------------------------------------------------------------
znap eval rbenv "rbenv init -"
# }}}
# -------------------------------------------------------------------

# -------------------------------------------------------------------
# # NOTE: fnm {{{
# -------------------------------------------------------------------
# Then load fnm silently
eval "$(fnm env --use-on-cd --shell zsh)" >/dev/null 2>&1
# }}}
# -------------------------------------------------------------------

# -------------------------------------------------------------------
# # NOTE: linuxbrew {{{
# -------------------------------------------------------------------
# Load Homebrew shell environment if it's installed
znap compadd /home/linuxbrew/.linuxbrew/bin/brew &>/dev/null && eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
# }}}
# -------------------------------------------------------------------

# -------------------------------------------------------------------
# # NOTE: atuin {{{
# -------------------------------------------------------------------
# This line loads Atuin and defines the `atuin-search` widgets
eval "$(atuin init zsh)"

# --- FORCE ATUIN BINDING ---
# This block runs LAST, ensuring Atuin wins the fight for Ctrl+R
bindkey -M emacs '^R' atuin-search
bindkey -M viins '^R' atuin-search-viins
bindkey -M vicmd '^R' atuin-search
# }}}
# -------------------------------------------------------------------

# -------------------------------------------------------------------
# # NOTE: dynamic REPOSITORY_PATH variable {{{
# -------------------------------------------------------------------

# Add the function to the precmd_functions hook array, ensuring it's loaded
autoload -U add-zsh-hook
add-zsh-hook precmd update_repo_path

# -------------------------------------------------------------------
# }}}
# -------------------------------------------------------------------

#-------------------------------------------------------------------------------
# # NOTE: Extend Limitations {{{
#-------------------------------------------------------------------------------

# Increase file descriptor limit on macOS only
if [[ "$OSTYPE" == "darwin"* ]]; then
    ulimit -n 40480
fi

#-------------------------------------------------------------------------------
# }}}
#-------------------------------------------------------------------------------

#-------------------------------------------------------------------------------
# # NOTE: AI Editors {{{
#-------------------------------------------------------------------------------

[[ "$TERM_PROGRAM" == "kiro" ]] && . "$(kiro --locate-shell-integration-path zsh)"

#-------------------------------------------------------------------------------
# }}}
#-------------------------------------------------------------------------------


# zprof

# vim:foldmethod=marker
