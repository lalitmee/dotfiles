#!/bin/sh

# install.sh - The single entry point for bootstrapping the dotfiles environment.
# This script is POSIX-compliant and designed to run on a bare system.

# Exit on any error
set -e

# 1. Update package cache
echo "Updating package cache..."
sudo apt-get update

# 2. Install core dependencies
echo "Installing core dependencies (git, curl, zsh, stow)..."
sudo apt-get install -y git curl zsh stow

# 3. Stow the 'bin' directory to make helper scripts available
echo "Stowing bin directory to activate helper scripts..."
# The -D flag ensures any existing conflicting links are removed first.
stow -D bin
stow bin

# 4. Add the newly stowed bin directory to the PATH for this session
# This makes gum_style and other scripts available to the main installer.
# Assuming stow links to ~/.config/bin based on repo structure.
export PATH="$HOME/.config/bin:$PATH"

# 5. Execute the main Zsh installer
echo "Executing main installer..."
zsh ./scripts/install/main-installer.zsh

echo "Bootstrap complete. Main installer has finished."
