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
    nvm
    pyenv
    rand-quote
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

# alias for dooit
alias dt="dooit"

# output in a url
alias tb="nc termbin.com 9999"

# cht.sh
alias ch="cht.sh"

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

# lazygit
# alias lg="lazygit"

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
bubc
"
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
alias es="emacs --with-profile spacemacs"
alias ed="emacs --with-profile doom-emacs"

alias m="man -k . | fzf --prompt='Man> ' | awk '{print $1}' | xargs -r man"

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
alias neovide="~/Desktop/Softwares/editors/neovide/neovide &"
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

# alias for taskwarrior
alias to="task"
alias tt="taskwarrior-tui"

# vim remote send stuff
# alias g="vim --remote-silent"

# alias for colorls
alias lc='colorls -lA --sd'

# aliases for npm
alias npd='npm run dev'

# alias for running tmux with screen-256color
# alias tmux="env TERM=alacritty tmux -2"

# aliases for sound fix
alias goodaudio="pactl set-card-profile $(pactl list cards |grep 'Name: bluez' |awk '{print $2}') a2dp-sink"
alias headset="pactl set-card-profile $(pactl list cards |grep 'Name: bluez' |awk '{print $2}') headset-head-unit"

# >> change wallpaper aliases
alias random_wallpaper="feh -FD3600 --randomize --bg-fill $HOME/Desktop/Wallpapers/*"
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

# vim:foldmethod=marker
