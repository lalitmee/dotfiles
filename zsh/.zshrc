zmodload zsh/zprof

# -------------------------------------------------------------------
# NOTE: oh-my-zsh {{{
# -------------------------------------------------------------------
# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH

# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time oh-my-zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/robbyrussell/oh-my-zsh/wiki/Themes
# ZSH_THEME="powerlevel10k/powerlevel10k"

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
DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
COMPLETION_WAITING_DOTS="true"

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
# NOTE: plugins {{{
# -------------------------------------------------------------------
# Which plugins would you like to load?
# Standard plugins can be found in ~/.oh-my-zsh/plugins/*
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(
    aliases
    brew
    colored-man-pages
    command-not-found
    common-aliases
    debian
    docker
    docker-compose
    dotenv
    extract
    fast-syntax-highlighting
    fzf-tab
    fzf-zsh-plugin
    gem
    gh
    git
    git-auto-fetch
    git-extras
    gitfast
    golang
    history
    last-working-dir
    node
    npm
    ripgrep
    rust
    sprunge
    sudo
    tmux
    tmuxinator
    vi-mode
    yarn
    zoxide
    zsh-autosuggestions
    # zsh-syntax-highlighting
    zsh-wakatime
)

# zsh completions
fpath+=${ZSH_CUSTOM:-${ZSH:-~/.oh-my-zsh}/custom}/plugins/zsh-completions/src

source $ZSH/oh-my-zsh.sh

# }}}
# -------------------------------------------------------------------

# -------------------------------------------------------------------
# NOTE: zsh plugins settings {{{
# -------------------------------------------------------------------
# vi-mode settings
VI_MODE_RESET_PROMPT_ON_MODE_CHANGE=true
VI_MODE_SET_CURSOR=true
# }}}
# -------------------------------------------------------------------

# }}}
# -------------------------------------------------------------------

# -------------------------------------------------------------------
# NOTE: user configurations {{{
# -------------------------------------------------------------------
export TERM="xterm-256color"

if [[ $TERM == xterm ]]; then
    TERM=screen-256color;
fi

# You may need to manually set your language environment
export LANG=en_US.UTF-8
export LC_CTYPE=en_US.UTF-8

# export CPPFLAGS="-I$(brew --prefix openssl)/include"
# export CFLAGS="-I$(brew --prefix openssl)/include"
# export LDFLAGS="-L$(brew --prefix openssl)/lib"
# export PKG_CONFIG_PATH="/home/linuxbrew/.linuxbrew/opt/libnsl/lib/pkgconfig"
# export RUBY_CONFIGURE_OPTS="--with-openssl-dir=$(brew --prefix openssl@1.1)"
# }}}
# -------------------------------------------------------------------

# -------------------------------------------------------------------
# NOTE: pomodoro {{{
# -------------------------------------------------------------------
declare -A pomo_options
pomo_options["work"]="45"
pomo_options["break"]="10"

pomodoro () {
  if [ -n "$1" -a -n "${pomo_options["$1"]}" ]; then
  val=$1
  echo $val | lolcat
  timer ${pomo_options["$val"]}m
  spd-say "'$val' session done"
  fi
}

alias wo="pomodoro 'work'"
alias br="pomodoro 'break'"
# }}}
# -------------------------------------------------------------------

# -------------------------------------------------------------------
# NOTE: aliases {{{
# -------------------------------------------------------------------
source ~/.aliases
# }}}
# -------------------------------------------------------------------

# -------------------------------------------------------------------
# NOTE: fzf {{{
# -------------------------------------------------------------------
# fzf path settings
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# great functions for fzf from
# https://gist.github.com/junegunn/8b572b8d4b5eddd8b85e5f4d40f17236
[ -f ~/Desktop/Github/fzf-git.sh/fzf-git.sh ] && source ~/Desktop/Github/fzf-git.sh/fzf-git.sh

export FZF_DEFAULT_COMMAND='rg --hidden --ignore node_modules --follow --glob "!.git/*"'
export FZF_CTRL_R_OPTS="--preview 'echo {}' --preview-window down:3:hidden:wrap --bind '?:toggle-preview' --bind 'ctrl-y:execute-silent(echo -n {2..} | pbcopy)+abort' --header 'Press CTRL-Y to copy command into clipboard' "
export FZF_DEFAULT_OPTS='--layout=reverse --inline-info --height=100% --bind=ctrl-a:select-all,ctrl-j:down,ctrl-k:up,ctrl-d:deselect-all'

# # gruvbox color for fzf
# export FZF_DEFAULT_OPTS=$FZF_DEFAULT_OPTS'
#     --color fg:#ebdbb2,bg:#282828,hl:#fabd2f,fg+:#ebdbb2,bg+:#3c3836,hl+:#fabd2f
#     --color info:#83a598,prompt:#bdae93,spinner:#fabd2f,pointer:#83a598,marker:#fe8019,header:#665c54'

# # dracula theme for fzf
# export FZF_DEFAULT_OPTS=$FZF_DEFAULT_OPTS'
#     --color=fg:#f8f8f2,bg:#282a36,hl:#bd93f9
#     --color=fg+:#f8f8f2,bg+:#44475a,hl+:#bd93f9
#     --color=info:#ffb86c,prompt:#50fa7b,pointer:#ff79c6
#     --color=marker:#ff79c6,spinner:#ffb86c,header:#6272a4'

# # nord color for fzf
# export FZF_DEFAULT_OPTS=$FZF_DEFAULT_OPTS'
#     --color=fg:#e5e9f0,bg:#3b4252,hl:#81a1c1
#     --color=fg+:#e5e9f0,bg+:#3b4252,hl+:#81a1c1
#     --color=info:#eacb8a,prompt:#bf6069,pointer:#b48dac
#     --color=marker:#a3be8b,spinner:#b48dac,header:#a3be8b'

# cobalt2 color for fzf
export FZF_DEFAULT_OPTS=$FZF_DEFAULT_OPTS'
--color=fg:#00aaff,bg:#193549,hl:#ffc600
--color=fg+:#00aaff,bg+:#185294,hl+:#ffc600
--color=info:#FF9D00,prompt:#ff628c,pointer:#ff9a00
--color=marker:#ff628c,spinner:#ffc600,header:#ffc600'
# }}}
# -------------------------------------------------------------------

# -------------------------------------------------------------------
# NOTE: automatically loaded {{{
# -------------------------------------------------------------------
# Generated for envman. Do not edit.
[ -s "$HOME/.config/envman/load.sh" ] && source "$HOME/.config/envman/load.sh"
# }}}
# -------------------------------------------------------------------

# -------------------------------------------------------------------
# NOTE: kill port {{{
# -------------------------------------------------------------------
killport () {
    PID=$(sudo lsof -t -i:$1)
    sudo kill -9 ${PID}
}
# }}}
# -------------------------------------------------------------------

# -------------------------------------------------------------------
# NOTE: starship prompt {{{
# -------------------------------------------------------------------
eval "$(starship init zsh)"
# }}}
# -------------------------------------------------------------------

# -------------------------------------------------------------------
# NOTE: sourcing zsh_profile {{{
# -------------------------------------------------------------------
source ~/.zsh_profile
source ~/awesome-functions
# }}}
# -------------------------------------------------------------------

# -------------------------------------------------------------------
# NOTE: source local things {{{
# -------------------------------------------------------------------
source ~/.openai
# }}}
# -------------------------------------------------------------------

# -------------------------------------------------------------------
# NOTE: auto start tmux {{{
# start tmux while starting new terminal
# -------------------------------------------------------------------
_not_inside_tmux() { [[ -z "$TMUX" ]] }

ensure_tmux_is_running() {
    if _not_inside_tmux; then
        ~/dotfiles/zsh/tat
    fi
}

ensure_tmux_is_running
# }}}
# -------------------------------------------------------------------

# -------------------------------------------------------------------
# NOTE: time zsh {{{
# -------------------------------------------------------------------
timezsh() {
  shell=${1-$SHELL}
  for i in $(seq 1 10); do /usr/bin/time $shell -i -c exit; done
}
# }}}
# -------------------------------------------------------------------

# -------------------------------------------------------------------
# NOTE: pyenv {{{
# -------------------------------------------------------------------
eval "$(pyenv init -)"
eval "$(pyenv virtualenv-init -)"
# }}}
# -------------------------------------------------------------------

# vim:foldmethod=marker
source '/home/linuxbrew/.linuxbrew/opt/autoenv/activate.sh'
