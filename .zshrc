# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH

# Path to your oh-my-zsh installation.
export ZSH="/home/lalit/.oh-my-zsh"

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time oh-my-zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/robbyrussell/oh-my-zsh/wiki/Themes
ZSH_THEME="robbyrussell"
#ZSH_THEME="agnoster"
#ZSH_THEME="bira"
#ZSH_THEME="spaceship"
#ZSH_THEME="powerlevel9k/powerlevel9k"
#ZSH_THEME="bullet-train"
#ZSH_THEME="agnosterzak"

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
export UPDATE_ZSH_DAYS=10

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# COMPLETION_WAITING_DOTS="true"

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
geeknote
gitfast
rand-quote
screen
taskwarrior
fasd
encode64
autojump
git
git-extras
tmuxinator
tmux
command-not-found
common-aliases
dirhistory
docker
gem
history
ng
node
npm
pip
pyenv
ruby
rvm
repo
sudo
web-search
colored-man-pages
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

# for finding swap files
alias swps='find . -name .\*.sw[op]'

# wikit alias
alias wi="wikit"

# wikit alias
alias d="dict"

# aliases for updating and installing packages
alias upd="sudo apt-fast update"
alias upg="sudo apt-fast upgrade -y"
alias updg="sudo apt-fast dist-upgrade -y"
alias install="sudo apt-fast install"
alias purge="sudo apt-fast purge"
alias remove="sudo apt-fast autoremove"
alias dpkg="sudo dpkg -i"

# aliases for editing and sourcing zshrc
alias ze="vim ~/.zshrc"
alias zs="source ~/.zshrc"

# aliases for some terminal programmes
alias yt="youtube-dl"
alias wt="curl wttr.in/bangalore"
alias wk="wikit"
alias wb="wikit -b"

# aliases for web search from terminal
alias goo="google"
alias bi="bing"
alias du="ddg"

# alias for sublime command
alias s="subl ."
alias a="atom ."
alias c="code ."
alias ci="code-insiders ."
alias o="oni ."
alias e="emacs26 ."
alias em="emacs25 ."

# alias for using nvim instead of vim
alias vim="nvim"

# aliases for git cloning
alias gclo="git clone"
alias gco="git checkout"
alias gcn="git checkout -b"
alias gfu="git fetch upstream"
alias gco="git checkout master"


# alias for git commands
alias gs="git status"
alias ga="git add ."
alias gcm="git commit -m"
alias gc="git commit"
alias gp="git push"
alias gi="git init"
alias gl="git log"
alias glo="git log --oneline"
alias gls="git log --stat"
alias glp="git log -p"
alias gd="git diff"
alias gpull="git pull"

# aliases for katerra git pull and push
alias gplo="git pull origin Observations"
alias gpsl="git push origin list-template"

# tmuxinator aliases
alias tsk="tmuxinator start katerra"
alias tek="tmuxinator edit katerra"
alias tsc="tmuxinator start scheduling"
alias tec="tmuxinator edit scheduling"
alias tsd="tmuxinator start dashboard"
alias ted="tmuxinator edit dashboard"
alias tss="tmuxinator start sonyliv"
alias tes="tmuxinator edit sonyliv"
alias tsv="tmuxinator start vscode"
alias tev="tmuxinator edit vscode"
alias tsp="tmuxinator start portfolio"
alias tep="tmuxinator edit portfolio"
alias tsg="tmuxinator start github-search"
alias teg="tmuxinator edit github-search"
alias tsq="tmuxinator start c-quotes"
alias teq="tmuxinator edit c-quotes"
alias tst="tmuxinator start talaria"
alias tet="tmuxinator edit talaria"
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
source ~/tmuxinator.bash

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
if [ $TILIX_ID ] || [ $VTE_VERSION ]; then
        source /etc/profile.d/vte.sh
fi

# autojump Path settings
[[ -s ~/.autojump/etc/profile.d/autojump.sh ]] && . ~/.autojump/etc/profile.d/autojump.sh

# fzf path settings
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

export FZF_DEFAULT_COMMAND='ag --nocolor --ignore node_modules -g ""'

export ANDROID_HOME=/home/lalit/Android/Sdk
export PATH=${PATH}:$ANDROID_HOME/tools:$ANDROID_HOME/platform-tools
export JAVA_HOME=/usr/lib/jvm/java-11-openjdk-amd64

# transfer.sh alias
transfer() { if [ $# -eq 0 ]; then echo -e "No arguments specified. Usage:\necho transfer /tmp/test.md\ncat /tmp/test.md | transfer test.md"; return 1; fi 
	tmpfile=$( mktemp -t transferXXX ); if tty -s; then basefile=$(basename "$1" | sed -e 's/[^a-zA-Z0-9._-]/-/g'); curl --progress-bar --upload-file "$1" "https://transfer.sh/$basefile" >> $tmpfile; else curl --progress-bar --upload-file "-" "https://transfer.sh/$1" >> $tmpfile ; fi; cat $tmpfile; rm -f $tmpfile; } 
fpath+=${ZDOTDIR:-~}/.zsh_functions
