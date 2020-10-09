# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH

# Path to your oh-my-zsh installation.
export ZSH="/home/lalit/.oh-my-zsh"

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time oh-my-zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/robbyrussell/oh-my-zsh/wiki/Themes
ZSH_THEME="robbyrussell"
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
alias-tips
autojump
autoupdate
brew
colored-man-pages
command-not-found
common-aliases
copyfile
dirhistory
docker
encode64
fzf-tab
gem
git
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
web-search
yarn
z
zsh-autosuggestions
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

# alias for fzf get the output
alias f="| fzf"
alias fk="fkill"

# gitmoji aliases
alias gm="gitmoji -s"
alias gml="gitmoji -l | fzf"

# alias for system
# alias s="sudo reboot"

#alias for imgur-uploader
alias img="imgur-uploader"

#alias for speedtest
alias speed="speedtest-cli"

# for ls replacement with exa
alias ls="exa"
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
alias update="sudo apt-fast update -y && sudo apt-fast upgrade -y"
alias upd="sudo apt-fast update -y"
alias upg="sudo apt-fast upgrade -y"
alias updg="sudo apt-fast dist-upgrade -y"
alias install="sudo apt-fast install -y"
alias fix="sudo apt-fast install -f -y"
alias purge="sudo apt-fast purge -y"
alias remove="sudo apt-fast autoremove -y"
alias dpkg="sudo dpkg -i"
alias snapi="sudo snap install"
alias snapr="sudo snap remove"
alias snapu="sudo snap refresh"
alias snapl="snap list"
alias bu="brew update"
alias bug="brew upgrade"

# aliases for editing and sourcing zshrc
alias ze="vim ~/.zshrc"
alias zs="source ~/.zshrc"

# alias for editing the hyper config
alias eh="vim ~/.hyper.js"

# alias for editing the alacritty config
alias ea="vim ~/.config/alacritty/alacritty.yml"

# aliases for some terminal programmes
alias yt="youtube-dl"
alias wt="curl wttr.in"
alias wk="wikit"
alias wb="wikit -b"
alias hw="how2"

# aliases for web search from terminal
alias goo="google"
alias bi="bing"
alias du="ddg"
alias d="ddgr"

# alias for sublime command
alias sb="subl ."
alias at="atom ."
alias co="code ."
alias ci="code-insiders ."
alias o="oni ."
alias e="emacs26 ."
alias em="emacs25 ."

# alias for using nvim instead of vim
alias vi="vim"
alias vim="nvim"

#aliases for npm
alias ni="npm install"
alias nig="npm install -g"
alias nis="npm install --save"
alias nid="npm install --save-dev"

# common aliases
alias rm="rm -i"
alias rmnode="rm -rf node_modules"
alias rmpack="rm -rf package-lock.json"
alias hs="history | grep"
alias h="history | fzf"
alias a="alias | fzf"
alias myip="curl http://ipecho.net/plain; echo"

# tmuxinator aliases
alias tsv="tmuxinator start vscode"
alias tev="tmuxinator edit vscode"
alias tsp="tmuxinator start portfolio"
alias tep="tmuxinator edit portfolio"
alias tsg="tmuxinator start github-search"
alias teg="tmuxinator edit github-search"
alias tsq="tmuxinator start c-quotes"
alias teq="tmuxinator edit c-quotes"
alias tsw="tmuxinator start wfws"
alias tew="tmuxinator edit wfws"
alias tspw="tmuxinator start pwa-service"
alias tepw="tmuxinator edit pwa-service"
alias tsj="tmuxinator start jarvis"
alias tej="tmuxinator edit jarvis"
alias tsps="tmuxinator start pdf-service"
alias teps="tmuxinator edit pdf-service"
alias tsa="tmuxinator start annamalai-portfolio"
alias tea="tmuxinator edit annamalai-portfolio"
alias tn="tmuxinator new"
alias ts="tmuxinator start"
alias te="tmuxinator edit"

# alias for todo.txt-cli
alias t="~/todo.txt_cli-2.11.0/todo.sh"

# alias for taskwarrior
alias to="task"

# vim remote send stuff
alias g="vim --remote-silent"

# tmuxinator completion file
# source ~/tmuxinator.bash

# nvim path for oni
# export ONI_NEOVIM_PATH='/home/lalit/app_images/nvim.appimage'
export ONI_NEOVIM_PATH='/usr/bin/nvim'

# path for ruby manager
export PATH="$HOME/.rbenv/bin:$PATH"
eval "$(rbenv init -)"

# snap path
export PATH="$PATH:/snap/bin"

# pyenv root
export PYENV_ROOT="$(pyenv root)"

# exporting editor
export EDITOR=nvim

# Tilix settings
# if [ $TILIX_ID ] || [ $VTE_VERSION ]; then
#         source /etc/profile.d/vte.sh
# fi

# start tmux while starting new terminal
_not_inside_tmux() { [[ -z "$TMUX" ]] }

ensure_tmux_is_running() {
  if _not_inside_tmux; then
    ~/Desktop/Github/dotfiles/bin/tat
  fi
}

ensure_tmux_is_running

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# fzf path settings
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh


export FZF_DEFAULT_COMMAND='ag --nocolor --ignore node_modules -g ""'
export FZF_CTRL_R_OPTS="--preview 'echo {}' --preview-window down:3:hidden:wrap --bind '?:toggle-preview' --bind 'ctrl-y:execute-silent(echo -n {2..} | pbcopy)+abort' --header 'Press CTRL-Y to copy command into clipboard' "
export FZF_DEFAULT_OPTS='--height 40% --layout=reverse --border'

export ANDROID_HOME=/home/lalit/Android/Sdk
export PATH=${PATH}:$ANDROID_HOME/tools:$ANDROID_HOME/platform-tools
export JAVA_HOME=/usr/lib/jvm/java-11-openjdk-amd64

autoload -Uz compinit bashcompinit
compinit
bashcompinit

# autojump
[ -f /home/linuxbrew/.linuxbrew/etc/profile.d/autojump.sh ] && . /home/linuxbrew/.linuxbrew/etc/profile.d/autojump.sh

# transfer.sh alias
transfer() { if [ $# -eq 0 ]; then echo -e "No arguments specified. Usage:\necho transfer /tmp/test.md\ncat /tmp/test.md | transfer test.md"; return 1; fi
	tmpfile=$( mktemp -t transferXXX ); if tty -s; then basefile=$(basename "$1" | sed -e 's/[^a-zA-Z0-9._-]/-/g'); curl --progress-bar --upload-file "$1" "https://transfer.sh/$basefile" >> $tmpfile; else curl --progress-bar --upload-file "-" "https://transfer.sh/$1" >> $tmpfile ; fi; cat $tmpfile; rm -f $tmpfile; }
fpath+=${ZDOTDIR:-~}/.zsh_functions

### Bashhub.com Installation
if [ -f ~/.bashhub/bashhub.zsh ]; then
    source ~/.bashhub/bashhub.zsh
fi

source ~/.aliasme/aliasme.sh
export PATH="$HOME/.rbenv/bin:$PATH"
eval "$(rbenv init -)"
export PATH="/home/linuxbrew/.linuxbrew/bin:/home/linuxbrew/.linuxbrew/sbin/:$PATH"
export MANPATH="/home/linuxbrew/.linuxbrew/share/man:$MANPATH"
export INFOPATH="/home/linuxbrew/.linuxbrew/share/info:$INFOPATH"
export PATH="/home/linuxbrew/.linuxbrew/opt/openssl@1.1/bin:$PATH"
export PATH="$HOME/cargo/bin:$PATH"

# old aliases
# alias tsk="tmuxinator start katerra"
# alias tek="tmuxinator edit katerra"
# alias tsc="tmuxinator start scheduling"
# alias tec="tmuxinator edit scheduling"
# alias tsd="tmuxinator start dashboard"
# alias ted="tmuxinator edit dashboard"
# alias tss="tmuxinator start sonyliv"
# alias tes="tmuxinator edit sonyliv"
# alias tst="tmuxinator start talaria"
# alias tet="tmuxinator edit talaria"

# forgit
source ~/Desktop/Github/forgit/forgit.plugin.zsh

# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$('/home/lalit/anaconda3/bin/conda' 'shell.bash' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "/home/lalit/anaconda3/etc/profile.d/conda.sh" ]; then
        . "/home/lalit/anaconda3/etc/profile.d/conda.sh"
    else
        export PATH="/home/lalit/anaconda3/bin:$PATH"
    fi
fi
unset __conda_setup
# <<< conda initialize <<<

# Navi: An interactive cheatsheet tool for the command-line and application launchers
source <(navi widget zsh)

eval "$(starship init zsh)"
eval "$(thefuck --alias)"
