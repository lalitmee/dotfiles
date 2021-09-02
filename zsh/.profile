# ~/.profile: executed by the command interpreter for login shells.
# This file is not read by bash(1), if ~/.bash_profile or ~/.bash_login
# exists.
# see /usr/share/doc/bash/examples/startup-files for examples.
# the files are located in the bash-doc package.

# the default umask is set in /etc/profile; for setting the umask
# for ssh logins, install and configure the libpam-umask package.
#umask 022

# if running bash
if [ -n "$BASH_VERSION" ]; then
    # include .bashrc if it exists
    if [ -f "$HOME/.bashrc" ]; then
	. "$HOME/.bashrc"
    fi
fi

# set PATH so it includes user's private bin if it exists
if [ -d "$HOME/bin" ] ; then
    PATH="$HOME/bin:$PATH"
fi

# set PATH so it includes user's private bin if it exists
if [ -d "$HOME/.local/bin" ] ; then
    PATH="$HOME/.local/bin:$PATH"
fi

# set PATH for doom emacs
if [ -d "$HOME/.emacs.d/doom" ] ; then
    PATH="$HOME/.emacs.d/doom:$PATH"
fi

# switch for caps lock to escape
setxkbmap -option caps:swapescape

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm

# eval $(/bin/brew shellenv)
eval $(/home/linuxbrew/.linuxbrew/bin/brew shellenv)

if [ -e /home/lalitmee/.nix-profile/etc/profile.d/nix.sh ]; then . /home/lalitmee/.nix-profile/etc/profile.d/nix.sh; fi # added by Nix installer


export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init --path)"
. "$HOME/.cargo/env"
