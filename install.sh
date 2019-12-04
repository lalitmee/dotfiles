#!/bin/bash

# function for creating symbolic link

function linkDotfile {
	# second argument will be the file name
	# first argument will be the destination of the file from which 
	# I need to create symlink

  dest="${1}"
	fileName="${2}"

  if [ -h ${fileName} ]; then
    # Existing symlink 
    echo "Removing existing symlink: ${fileName}"
    rm ${fileName} 

  elif [ -f "${fileName}" ]; then
    # Existing file
    echo "Removing existing file: ${fileName}"
    rm ${fileName} 
  fi

  echo "Creating new symlink: ${fileName}"
  ln -s ${dest} ${fileName}
}

echo "======================="
echo "Preparing...."
echo "======================="

echo "======================="
echo "Upgrading System"
echo "======================="

sudo apt update -y
sudo apt upgrade -y
sudo apt install software-properties-common apt-transport-https wget build-essential

# figlet for showing the messages
echo "======================="
echo "Installing Figlet for showing the messages"
echo "======================="

sudo apt install figlet toilet

echo "======================="
echo "figlet installed...."
echo "======================="

figlet "Hurray!!!"

echo "======================="
echo "Installing git, curl, wget, powerline, powerline fonts and zsh"
echo "======================="

sudo apt install git curl wget powerline fonts-powerline

figlet "zsh"
sudo apt install zsh
chsh -s /bin/zsh
sudo usermod -s /usr/bin/zsh $(whoami)

echo "======================="
echo "Cloning dotfiles from Github"
echo "======================="

mkdir ~/Desktop/Github
cd ~/Desktop/Github
git clone https://github.com/lalitmee/dotfiles.git 
figlet "Done"


echo "======================="
echo "Installing OH_MY_ZSH"
echo "======================="

figlet "OH-MY-ZSH"
cd ~/
sh -c "$(curl -fsSL https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
linkDotfile ~/Desktop/Github/dotfiles/system/zsh/.zshrc ~/.zshrc 
linkDotfile ~/Desktop/Github/dotfiles/system/zsh/.zsh_history ~/.zsh_history 
linkDotfile ~/Desktop/Github/dotfiles/system/zsh/.zsh_profile ~/.zsh_profile 
linkDotfile ~/Desktop/Github/dotfiles/system/zsh/.zprofile ~/.zprofile 
linkDotfile ~/Desktop/Github/dotfiles/system/.profile ~/.profile 
source ~/.zshrc
zs
figlet "Done"

echo "======================="
echo "Installed OH_MY_ZSH"
echo "======================="


# echo "======================="
# echo "Installing Node Package Manager"
# echo "======================="

# cd ~/
# figlet 'nodejs'
# read -p "Enter the latest installation url from nvm github repository" url
# url
# bash install_nvm.sh
# source ~/.profile
# nvm install node
# nvm install --lts

# figlet "Done"

# echo "======================="
# echo "Node Package Manager Installed"
# echo "======================="



echo "======================="
echo "Installing Snap Package Manager"
echo "======================="

figlet 'snap'
install snapd
figlet "Done"

echo "======================="
echo "Snap Package Manager Installed"
echo "======================="


figlet "Editors"

echo "======================="
echo "Installing vim, neovim and emacs"
echo "======================="

install vim neovim python-neovim python3-neovim

# repository for emacs
sudo add-apt-repository ppa:kelleyk/emacs && upd && install emacs26



echo "======================="
echo "Setting up vim, neovim and emacs"
echo "======================="

figlet "Emacs"
cd ~/ && git clone https://github.com/syl20bnr/spacemacs ~/.emacs.d
linkDotfile ~/Desktop/Github/dotfiles/editors/spacemacs/.spacemacs ~/.spacemacs 
figlet "Done"

figlet "Vim"
curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
linkDotfile ~/Desktop/Github/dotfiles/editors/vim/.vimrc ~/.vimrc 
figlet "Done"

figlet "Neovim"
curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
linkDotfile ~/Desktop/Github/dotfiles/editors/nvim/init.vim ~/.config/nvim/init.vim
linkDotfile ~/Desktop/Github/dotfiles/editors/nvim/coc-settings.json ~/.config/nvim/coc-settings.json
figlet "Done"


echo "======================="
echo "Installing Visual Studio Code, Insiders and Sublime"
echo "======================="

figlet "vscode"
snapi code --classic
snapi code-insiders --classic
figlet "Done"

figlet "sublime"
snapi sublime-text --classic
figlet "Done"

figlet "goland"
snapi goland --classic
figlet "Done"

figlet "webstorm"
snapi webstorm --classic
figlet "Done"

echo "======================="
echo "Editors Set Up Done"
echo "======================="


echo "======================="
echo "Installing Languages"
echo "======================="

figlet "golang"
snapi go --classic
figlet "Done"

echo "======================="
echo "Languages Installed"
echo "======================="


echo "======================="
echo "Installing Collaboration softwares"
echo "======================="

figlet "discord"
snapi discord
figlet "Done"

figlet "slack"
snapi slack --classic
figlet "Done"

figlet "gitter"
snapi gitter-desktop
figlet "Done"

figlet "skype"
snapi skype --classic
figlet "Done"

figlet "rocketchat"
snapi rocketchat-server
figlet "Done"

figlet "telegram"
snapi telegram-desktop
figlet "Done"

figlet "hexchat"
snapi hexchat
figlet "Done"

figlet "gitkraken"
snapi gitkraken
figlet "Done"

echo "======================="
echo "Collaboration softwares Installed"
echo "======================="

echo "======================="
echo "Installing Postamn and Insomnia"
echo "======================="

figlet "postman"
snapi postamn
figlet "Done"

figlet "insmonia"
snapi insmonia
figlet "Done"

echo "======================="
echo "Postamn and Insomnia Installed"
echo "======================="


echo "======================="
echo "Installing Music and Video Softwares"
echo "======================="

figlet "spotify"
snapi spotify
figlet "Done"

figlet "vlc"
snapi vlc
figlet "Done"

echo "======================="
echo "Music and Video Softwares Installed"
echo "======================="


echo "======================="
echo "Installing Terminals and Terminal applications"
echo "======================="

figlet "heroku"
snapi heroku
figlet "Done"

figlet "termius"
snapi termius-app
figlet "Done"

echo "======================="
echo "Terminals and Terminal applications Installed"
echo "======================="


echo "======================="
echo "Installing Browsers"
echo "======================="

figlet "chromium"
snapi chromium
figlet "Done"

echo "======================="
echo "Browsers Installed"
echo "======================="


echo "======================="
echo "Installing General Softwares"
echo "======================="

figlet "mailspring"
snapi mailspring
figlet "Done"

figlet "jupyter"
snapi jupyter
figlet "Done"

figlet "zenkit"
snapi zenkit
figlet "Done"

figlet "youtube-dl"
snapi youtube-dl
figlet "Done"



echo "======================="
echo "General Softwares Installed"
echo "======================="

