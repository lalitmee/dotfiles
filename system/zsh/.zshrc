# start tmux while starting new terminal
_not_inside_tmux() { [[ -z "$TMUX" ]] }

ensure_tmux_is_running() {
  if _not_inside_tmux; then
    ~/data/Github/dotfiles/bin/tat
  fi
}

ensure_tmux_is_running

# kitty terminal {{{

autoload -Uz compinit
compinit
# Completion for kitty
kitty + complete setup zsh | source /dev/stdin

# }}}

# {{{

### RANDOM COLOR SCRIPT ###
colorscript random

# }}}

# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH

# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time oh-my-zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/robbyrussell/oh-my-zsh/wiki/Themes
ZSH_THEME="powerlevel10k/powerlevel10k"
# ZSH_THEME="robbyrussell"
# ZSH_THEME="pure"
# ZSH_THEME="random"
# ZSH_THEME="spaceship"
# ZSH_THEME="agnoster"
# ZSH_THEME="bira"
# ZSH_THEME="powerlevel9k/powerlevel9k"
# ZSH_THEME="bullet-train"
# ZSH_THEME="agnosterzak"

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

# Which plugins would you like to load?
# Standard plugins can be found in ~/.oh-my-zsh/plugins/*
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(
alias-finder
alias-tips
autojump
autoupdate
brew
colored-man-pages
command-not-found
common-aliases
copyfile
debian
dirhistory
docker
encode64
frontend-search
fzf-tab
gem
git
git-extra-commands
git-extras
gitfast
history
last-working-dir
ng
node
npm
pip
pyenv
rand-quote
repo
ruby
rvm
screen
sudo
taskwarrior
tmux
tmuxinator
ubuntu
web-search
yarn
zsh-autosuggestions
zsh-syntax-highlighting
)

source $ZSH/oh-my-zsh.sh

# User configuration

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
export LANG=en_US.UTF-8
export LC_CTYPE=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='mvim'
# fi

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# ssh
# export SSH_KEY_PATH="~/.ssh/rsa_id"

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"

alias ciu="caniuse"
alias aw="awesome-hub"
alias st="speed-test"

# alias for fzf get the output
alias f="| fzf-tmux"
alias fk="fkill"
alias procs="procs | fzf-tmux -d 40%"

# gitmoji aliases
alias gm="gitmoji -s"
alias gml="gitmoji -l | fzf-tmux -d 40%"

# alias for system
# alias s="sudo reboot"

#alias for imgur-uploader
alias img="imgur-uploader"

#alias for speedtest
alias speed="speedtest-cli"

# for ls replacement with exa
# alias ls="exa"
alias ls="lsd"
alias cat="bat"
alias c="clear"

# hacker-new client
alias hn="haxor-news"

# alias for cheatsheet command
alias cheat="cheatsheet"

# for finding swap files
alias swps="find . -name .\*.sw[op]"

# wikit alias
alias wi="wikit"

# wikit alias
alias d="dict"

# aliases for updating and installing packages
alias aptl="apt list | fzf-tmux"
alias brewl="brew list | fzf-tmux"
alias fix="sudo apt-fast install -f -y"
alias install="sudo apt-fast install -y"
alias purge="sudo apt-fast purge -y"
alias remove="sudo apt-fast autoremove -y"
alias snapi="sudo snap install"
alias snapl="snap list | fzf-tmux"
alias snapr="sudo snap remove"
alias snapu="sudo snap refresh"
alias upd="sudo apt-fast update -y"
alias update="sudo apt-fast update -y && sudo apt-fast upgrade -y"
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

alias manfzf="man -k . | fzf-tmux --prompt='Man> ' | awk '{print $1}' | xargs -r man"

# aliases for some terminal programmes
alias hw="how2"
alias wb="wikit -b"
alias wk="wikit"
alias wt="curl wttr.in"
alias yt="youtube-dl"

# alias for sublime command
alias at="atom ."
alias ci="code-insiders ."
alias co="code ."
alias o="oni ."
alias sb="subl ."

# alias for gui nvims
alias gnvim="~/goneovim/goneovim --nvim=/usr/local/bin/nvim &"
alias glrnvim="~/data/Github/glrnvim/target/release/glrnvim &"

# common aliases
alias a="alias | fzf-tmux -d 40%"
alias h="history | fzf-tmux -d 40%"
alias hs="history | grep"
alias myip="curl http://ipecho.net/plain; echo"
alias rm="rm -i"
alias rmnode="rm -rf node_modules"
alias rmpack="rm -rf package-lock.json"

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

# tmuxinator completion file
# source ~/tmuxinator.bash

# nvim path for oni
# export ONI_NEOVIM_PATH='/home/lalit/app_images/nvim.appimage'

# path for neovim logs
export NVIM_LOG_FILE_PATH="$HOME/.logs/nvim"

# path for ruby manager
export PATH="$HOME/.rbenv/bin:$PATH"
eval "$(rbenv init -)"

# snap path
export PATH="$PATH:/snap/bin"

# doom-emacs command
export PATH="$HOME/doom-emacs/bin:$PATH"

# pyenv root
export PYENV_ROOT="$(pyenv root)"

# exporting editor
export EDITOR=nvim

# Tilix settings
# if [ $TILIX_ID ] || [ $VTE_VERSION ]; then
#         source /etc/profile.d/vte.sh
# fi

# # z.sh
# source ~/data/Github/z/z.sh

# great functions for fzf from
# https://gist.github.com/junegunn/8b572b8d4b5eddd8b85e5f4d40f17236
source ~/data/Github/dotfiles/system/fzf/init.zsh

# update cd bookmarks
chpwd_functions+=(update_marks)


export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# fzf path settings
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh


export FZF_DEFAULT_COMMAND='rg --hidden --ignore node_modules --follow --glob "!.git/*"'
export FZF_CTRL_R_OPTS="--preview 'echo {}' --preview-window down:3:hidden:wrap --bind '?:toggle-preview' --bind 'ctrl-y:execute-silent(echo -n {2..} | pbcopy)+abort' --header 'Press CTRL-Y to copy command into clipboard' "
export FZF_DEFAULT_OPTS='--layout=reverse --border --inline-info --height=100% --bind=ctrl-a:select-all,ctrl-d:deselect-all'
# # gruvbox color for fzf
export FZF_DEFAULT_OPTS=$FZF_DEFAULT_OPTS'; --color fg:#ebdbb2,bg:#282828,hl:#fabd2f,fg+:#ebdbb2,bg+:#3c3836,hl+:#fabd2f  --color info:#83a598,prompt:#bdae93,spinner:#fabd2f,pointer:#83a598,marker:#fe8019,header:#665c54'

# # nord color for fzf
# export FZF_DEFAULT_OPTS=$FZF_DEFAULT_OPTS' --color fg:#D8DEE9,bg:#2E3440,hl:#A3BE8C,fg+:#D8DEE9,bg+:#434C5E,hl+:#A3BE8C --color pointer:#BF616A,info:#4C566A,spinner:#4C566A,header:#4C566A,prompt:#81A1C1,marker:#EBCB8B'

autoload -Uz compinit bashcompinit
compinit
bashcompinit

# autojump
[ -f /home/linuxbrew/.linuxbrew/etc/profile.d/autojump.sh ] && . /home/linuxbrew/.linuxbrew/etc/profile.d/autojump.sh

# transfer.sh alias
transfer() { if [ $# -eq 0 ]; then echo -e "No arguments specified. Usage:\necho transfer /tmp/test.md\ncat /tmp/test.md | transfer test.md"; return 1; fi
	tmpfile=$( mktemp -t transferXXX ); if tty -s; then basefile=$(basename "$1" | sed -e 's/[^a-zA-Z0-9._-]/-/g'); curl --progress-bar --upload-file "$1" "https://transfer.sh/$basefile" >> $tmpfile; else curl --progress-bar --upload-file "-" "https://transfer.sh/$1" >> $tmpfile ; fi; cat $tmpfile; rm -f $tmpfile; }
fpath+=${ZDOTDIR:-~}/.zsh_functions

export PATH="$HOME/.rbenv/bin:$PATH"
eval "$(rbenv init -)"
export PATH="/home/linuxbrew/.linuxbrew/bin:/home/linuxbrew/.linuxbrew/sbin/:$PATH"
export MANPATH="/home/linuxbrew/.linuxbrew/share/man:$MANPATH"
export INFOPATH="/home/linuxbrew/.linuxbrew/share/info:$INFOPATH"
export PATH="/home/linuxbrew/.linuxbrew/opt/openssl@1.1/bin:$PATH"
export PATH="$HOME/cargo/bin:$PATH"
export GOPATH=$HOME/go
export PATH=$PATH:$GOROOT/bin:$GOPATH/bin

# # Navi: An interactive cheatsheet tool for the command-line and application launchers
# source <(navi widget zsh)

# eval "$(starship init zsh)"
eval "$(thefuck --alias)"

eval "$(lua /home/lalitmee/z.lua/z.lua --init zsh)"

export TERM="xterm-256color"
# if [ "$ISLINUX" '==' 'true' ]; then
  # { infocmp -1 xterm-256color ; echo "\tsitm=\\E[3m,\n\tritm=\\E[23m,"; } | \
    # tic -x -
# fi

if [[ $TERM == xterm ]]; then
  TERM=screen-256color;
fi

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# enabling colorls tab completion
source $(dirname $(gem which colorls))/tab_complete.sh

# for s-search from the terminal
if [ -f $GOPATH/src/github.com/zquestz/s/autocomplete/s-completion.bash ]; then
    . $GOPATH/src/github.com/zquestz/s/autocomplete/s-completion.bash
fi

export LDFLAGS="-L/home/linuxbrew/.linuxbrew/opt/libnsl/lib"
export CPPFLAGS="-I/home/linuxbrew/.linuxbrew/opt/libnsl/include"

export PKG_CONFIG_PATH="/home/linuxbrew/.linuxbrew/opt/libnsl/lib/pkgconfig"
source ~/powerlevel10k/powerlevel10k.zsh-theme

export PATH="$HOME/.pyenv/bin:$PATH"
eval "$(pyenv init -)"
eval "$(pyenv virtualenv-init -)"


export RUBY_CONFIGURE_OPTS="--with-openssl-dir=$(brew --prefix openssl@1.1)"

# To customize prompt, run `p10k configure` or edit ~/data/Github/dotfiles/system/zsh/.p10k.zsh.
[[ ! -f ~/data/Github/dotfiles/system/zsh/.p10k.zsh ]] || source ~/data/Github/dotfiles/system/zsh/.p10k.zsh


if [ -e /home/lalitmee/.nix-profile/etc/profile.d/nix.sh ]; then . /home/lalitmee/.nix-profile/etc/profile.d/nix.sh; fi # added by Nix installer


