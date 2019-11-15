#!/bin/bash

echo "======================="
echo "Preparing...."
echo "======================="

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
echo "Installing Git, Curl, Powerline, Powerline fonts and zsh for showing the messages"
echo "======================="

sudo apt install git curl powerline fonts-powerline

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
rsync -avz --progress ~/Desktop/Github/dotfiles/system/zsh/.zshrc ~/
rsync -avz --progress ~/Desktop/Github/dotfiles/system/zsh/.zsh_history ~/
rsync -avz --progress ~/Desktop/Github/dotfiles/system/zsh/.zsh_profile ~/
rsync -avz --progress ~/Desktop/Github/dotfiles/system/zsh/.zprofile ~/
rsync -avz --progress ~/Desktop/Github/dotfiles/system/.profile ~/
source ~/.zshrc

echo "======================="
echo "Installed OH_MY_ZSH"
echo "======================="

figlet "Done"
