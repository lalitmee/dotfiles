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
# NOTE: kitty settings {{{
# -------------------------------------------------------------------
autoload -Uz compinit
compinit
# Completion for kitty
kitty + complete setup zsh | source /dev/stdin
# }}}
# -------------------------------------------------------------------

# -------------------------------------------------------------------
# NOTE: colorscript {{{
# from https://gitlab.com/dwt1/shell-color-scripts
# shows random colors and things in starting of the terminal
# -------------------------------------------------------------------
colorscript random
# }}}
# -------------------------------------------------------------------

# -------------------------------------------------------------------
# NOTE: powerlevel10k theme {{{
# -------------------------------------------------------------------
# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

export PYENV_VIRTUALENV_DISABLE_PROMPT=1
ZSH_PYENV_QUIET=true
# }}}
# -------------------------------------------------------------------

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
  alias-finder
  alias-tips
  aliases
  autojump
  autoupdate
  brew
  browse-commit
  colored-man-pages
  command-not-found
  common-aliases
  copyfile
  debian
  dircycle
  dirhistory
  docker
  docker-compose
  dotenv
  emoji
  encode64
  extract
  fancy-ctrl-z
  fasd
  fd
  fig
  frontend-search
  # fzf
  fzf-tab
  fzf-zsh-plugin
  gem
  gh
  git
  git-auto-fetch
  git-extra-commands
  git-extras
  gitfast
  golang
  history
  hitchhiker
  hitokoto
  jira
  k
  last-working-dir
  magic-enter
  ng
  node
  npm
  nvm
  pip
  pyenv
  rand-quote
  react-native
  repo
  ripgrep
  rsync
  ruby
  rust
  rvm
  screen
  screen
  sprunge
  sudo
  taskwarrior
  thefuck
  themes
  tig
  tmux
  tmuxinator
  vi-mode
  virtualenvwrapper
  web-search
  yarn
  zoxide
  zsh-256color
  zsh-autosuggestions
  zsh-syntax-highlighting
)

source $ZSH/oh-my-zsh.sh

# }}}
# -------------------------------------------------------------------

# -------------------------------------------------------------------
# NOTE: zsh plugins settings {{{
# -------------------------------------------------------------------
# vi-mode settings
VI_MODE_RESET_PROMPT_ON_MODE_CHANGE=true
VI_MODE_SET_CURSOR=true

# jira url
JIRA_URL="https://koinearth.atlassian.net"
JIRA_NAME="lalitmee"
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

# exporting editor
export EDITOR=nvim

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
export LANG=en_US.UTF-8
export LC_CTYPE=en_US.UTF-8

export LDFLAGS="-L/home/linuxbrew/.linuxbrew/opt/libnsl/lib"
export CPPFLAGS="-I/home/linuxbrew/.linuxbrew/opt/libnsl/include"

export PKG_CONFIG_PATH="/home/linuxbrew/.linuxbrew/opt/libnsl/lib/pkgconfig"

export RUBY_CONFIGURE_OPTS="--with-openssl-dir=$(brew --prefix openssl@1.1)"

if [ -e /home/lalitmee/.nix-profile/etc/profile.d/nix.sh ]; then . /home/lalitmee/.nix-profile/etc/profile.d/nix.sh; fi # added by Nix installer

export GO111MODULE=off

# ssh
# export SSH_KEY_PATH="~/.ssh/rsa_id"
# }}}
# -------------------------------------------------------------------

# -------------------------------------------------------------------
# NOTE: aliases {{{
# -------------------------------------------------------------------
# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"

# output in a url
alias tb="nc termbin.com 9999"

alias ciu="caniuse"
alias iu="is-up"
alias aw="awesome-hub"
alias st="speed"

# alias for fzf get the output
alias f="| fzf"
alias fk="fkill"
alias procs="procs | fzf -d 40%"

# gitmoji aliases
alias gm="gitmoji -s"
alias gml="gitmoji -l | fzf -d 40%"

# alias for system
# alias s="sudo reboot"

#alias for imgur-uploader
alias img="imgur-uploader"

#alias for speedtest
alias speed="speedtest-cli"

# for ls replacement with exa
# alias ls="exa"
alias ls="lsd" # possible values are: lsd, colorls, exa, ls
alias cat="bat"
alias c="clear"

# hacker-new client
alias hn="haxor-news"

# # alias for cheatsheet command
# alias cheat="cheatsheet"

# for finding swap files
alias swps="find . -name .\*.sw[op]"

# wikit alias
alias wi="wikit"

# dict alias
alias d="dict"

# git worktree aliases
alias gwl="git worktree list"
alias gwa="git worktree add"
alias gwo="git worktree lock"
alias gwm="git worktree move"
alias gwp="git worktree prune"
alias gwr="git worktree remove"
alias gwu="git worktree unlock"

# aliases for updating and installing packages
alias aptl="apt list | fzf"
alias brewl="brew list | fzf"
alias fix="sudo apt-fast install -f -y"
alias install="sudo apt-fast install -y"
alias purge="sudo apt-fast purge -y"
alias remove="sudo apt-fast autoremove -y"
alias snapi="sudo snap install"
alias snapl="snap list | fzf"
alias snapr="sudo snap remove"
alias snapu="sudo snap refresh"
alias upd="sudo apt-fast update -y"
alias update="
  sudo apt-fast update -y &&
  sudo apt-fast upgrade -y &&
  sudo flatpak update -y &&
  snapu &&
  bubc"
alias updg="sudo apt-fast dist-upgrade -y"
alias upg="sudo apt-fast upgrade -y"

# aliases for editing and sourcing zshrc
alias ze="nvim ~/.zshrc"
alias zs="source ~/.zshrc"

# alias for emacs
alias db="doom build"
alias dc="doom clean"
alias dd="doom doctor"
alias dp="doom purge"
alias ds="doom sync"
alias du="doom upgrade"
alias ed="emacs --with-profile default"
alias es="emacs --with-profile spacemacs"

alias manfzf="man -k . | fzf --prompt='Man> ' | awk '{print $1}' | xargs -r man"

# aliases for some terminal programmes
alias hw="how2"
alias hi="howdoi"
alias wb="wikit -b"
alias wk="wikit"
alias wt="curl wttr.in"
alias yt="youtube-dl"

# alias for gui nvims
alias gvim="~/goneovim/goneovim &"
alias lpc="~/Desktop/Softwares/editors/lapce &"
alias glm="glrnvim"
alias neovide="~/Desktop/Softwares/editors/neovide &"
alias oni="${HOME}/Applications/Onivim2-x86_64-master_8bbaf25b07ff2ac4dc6c74823d5a69bc.AppImage"

# alias for sublime command
alias at="atom ."
alias ci="code-insiders ."
alias co="code ."
alias o="oni ."
alias sb="subl ."
alias vi="nvim"
alias vim="nvim"
alias gv="gvim"
alias nv="neovide"

# common aliases
alias a="alias | fzf -d 40%"
alias h="history | fzf -d 40%"
alias hs="history | grep"
alias myip="curl http://ipecho.net/plain; echo"
alias rm="rm -i"
alias rmnode="rm -rf node_modules"
alias rmpack="rm -rf package-lock.json"
alias rmyarn="rm -rf yarn.lock"

# make aliases for building neovim from source
alias mc="sudo make clean && sudo make distclean"
alias mr="make CMAKE_BUILD_TYPE=Release"
alias mi="sudo make install"

# alias for duckduckgo from terminal
alias sd="ddgr"

# alias for todo.txt-cli
alias t="~/todo.txt_cli-2.11.0/todo.sh"

# alias for taskwarrior
alias to="task"

# vim remote send stuff
# alias g="vim --remote-silent"

# alias for colorls
alias lc='colorls -lA --sd'

# alias for running tmux with screen-256color
# alias tmux="env TERM=alacritty tmux -2"
# }}}
# -------------------------------------------------------------------

# -------------------------------------------------------------------
# NOTE: exporting paths {{{
# -------------------------------------------------------------------
# perl
PATH="/home/lalitmee/perl5/bin${PATH:+:${PATH}}"; export PATH;
PERL5LIB="/home/lalitmee/perl5/lib/perl5${PERL5LIB:+:${PERL5LIB}}"; export PERL5LIB;
PERL_LOCAL_LIB_ROOT="/home/lalitmee/perl5${PERL_LOCAL_LIB_ROOT:+:${PERL_LOCAL_LIB_ROOT}}"; export PERL_LOCAL_LIB_ROOT;
PERL_MB_OPT="--install_base \"/home/lalitmee/perl5\""; export PERL_MB_OPT;
PERL_MM_OPT="INSTALL_BASE=/home/lalitmee/perl5"; export PERL_MM_OPT;

# yarn
export PATH="$HOME/.yarn/bin:$HOME/.config/yarn/global/node_modules/.bin:$PATH"

# neovim logs
export NVIM_LOG_FILE_PATH="$HOME/.logs/nvim"

# ruby manager
export PATH="$HOME/.rbenv/bin:$PATH"
eval "$(rbenv init -)"

# snap path
export PATH="$PATH:/snap/bin"

# doom-emacs command
export PATH="$HOME/Desktop/Github/doom-emacs/bin:$PATH"

# nvim
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# rbenv
export PATH="$HOME/.rbenv/bin:$PATH"
eval "$(rbenv init -)"

# linuxbrew
export PATH="/home/linuxbrew/.linuxbrew/bin:/home/linuxbrew/.linuxbrew/sbin/:$PATH"
export MANPATH="/home/linuxbrew/.linuxbrew/share/man:$MANPATH"
export INFOPATH="/home/linuxbrew/.linuxbrew/share/info:$INFOPATH"
export PATH="/home/linuxbrew/.linuxbrew/opt/openssl@1.1/bin:$PATH"

# cargo
export PATH="$HOME/cargo/bin:$PATH"

# go
export GOPATH=$HOME/go
export PATH=$PATH:$GOROOT/bin:$GOPATH/bin

# pyenv
export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init --path)"
# }}}
# -------------------------------------------------------------------

# -------------------------------------------------------------------
# NOTE: fzf {{{
# -------------------------------------------------------------------
# great functions for fzf from
# https://gist.github.com/junegunn/8b572b8d4b5eddd8b85e5f4d40f17236

# fzf path settings
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
# . /usr/share/doc/fzf/examples/key-bindings.zsh

export FZF_DEFAULT_COMMAND='rg --hidden --ignore node_modules --follow --glob "!.git/*"'
export FZF_CTRL_R_OPTS="--preview 'echo {}' --preview-window down:3:hidden:wrap --bind '?:toggle-preview' --bind 'ctrl-y:execute-silent(echo -n {2..} | pbcopy)+abort' --header 'Press CTRL-Y to copy command into clipboard' "
export FZF_DEFAULT_OPTS='--layout=reverse --inline-info --height=100% --bind=ctrl-a:select-all,ctrl-d:deselect-all'

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
# NOTE: unknown {{{
# -------------------------------------------------------------------
# update cd bookmarks
chpwd_functions+=(update_marks)

autoload -Uz compinit bashcompinit
compinit
bashcompinit

fpath+=${ZDOTDIR:-~}/.zsh_functions
fpath=(~/.zsh.d/$fpath)
# }}}
# -------------------------------------------------------------------

# -------------------------------------------------------------------
# NOTE: custom plugins {{{
# -------------------------------------------------------------------

# NOTE: autojump {{{
# -------------------------------------------------------------------
# autojump
[ -f /home/linuxbrew/.linuxbrew/etc/profile.d/autojump.sh ] && . /home/linuxbrew/.linuxbrew/etc/profile.d/autojump.sh
# }}}
# -------------------------------------------------------------------

# -------------------------------------------------------------------
# NOTE: navi {{{
# -------------------------------------------------------------------
# Navi: An interactive cheatsheet tool for the command-line and application launchers
source <(navi widget zsh)
# }}}
# -------------------------------------------------------------------

# -------------------------------------------------------------------
# NOTE: almostontop {{{
# -------------------------------------------------------------------
# almost on top from github: https://github.com/Valiev/almostontop
source ~/Desktop/Github/almostontop/almostontop.plugin.zsh
# }}}
# -------------------------------------------------------------------

# -------------------------------------------------------------------
# NOTE: thfuck {{{
# -------------------------------------------------------------------
# eval "$(starship init zsh)"
eval "$(thefuck --alias)"
# }}}
# -------------------------------------------------------------------

# -------------------------------------------------------------------
# NOTE: zoxide {{{
# -------------------------------------------------------------------
# easily switch directories
# eval "$(lua /home/lalitmee/z.lua/z.lua --init zsh)"
eval "$(zoxide init zsh)"
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

# }}}
# -------------------------------------------------------------------

# -------------------------------------------------------------------
# NOTE: prompt {{{
# -------------------------------------------------------------------
# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# # To customize prompt, run `p10k configure` or edit ~/Desktop/Github/dotfiles/zsh/.p10k.zsh.
# [[ ! -f ~/dotfiles/zsh/.p10k.zsh ]] || source ~/dotfiles/zsh/.p10k.zsh
# }}}
# -------------------------------------------------------------------

# -------------------------------------------------------------------
# NOTE: automatically loaded {{{
# -------------------------------------------------------------------
# Generated for envman. Do not edit.
[ -s "$HOME/.config/envman/load.sh" ] && source "$HOME/.config/envman/load.sh"
# }}}
# -------------------------------------------------------------------

# vim:foldmethod=marker
