#!/bin/zsh
# Phase 0: Base Ubuntu Setup
# Installs essential prerequisites for the system

source "$(dirname "$0")/../utils.zsh"

gum_style "🚀 Phase 0: Base Ubuntu Setup"
gum_style "Installing essential prerequisites..."

# Install git first (critical for cloning dotfiles)
execute_command \
    "sudo apt install -y git" \
    "git installed successfully." \
    "Failed to install git."

# Install curl and wget (needed for many installations)
execute_command \
    "sudo apt install -y curl wget" \
    "curl and wget installed successfully." \
    "Failed to install curl and wget."

# Install build essentials (needed for compiling some packages)
execute_command \
    "sudo apt install -y build-essential" \
    "build-essential installed successfully." \
    "Failed to install build-essential."

# Install software-properties-common (for adding repositories)
execute_command \
    "sudo apt install -y software-properties-common apt-transport-https" \
    "software-properties-common installed successfully." \
    "Failed to install software-properties-common."

# Install Rust and Cargo (required for cargo packages)
execute_command \
    "curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y" \
    "Rust and Cargo installed successfully." \
    "Failed to install Rust and Cargo."

# Add cargo to PATH for current session
export PATH="$HOME/.cargo/bin:$PATH"

# Install Go (required for gum and other tools)
execute_command \
    "sudo apt install -y golang-go" \
    "Go installed successfully." \
    "Failed to install Go."

# Clean up
execute_command \
    "sudo apt autoremove -y && sudo apt clean" \
    "Cleanup completed after base setup." \
    "Failed to clean up after installation."

gum_style "✅ Phase 0: Base Ubuntu Setup completed successfully!"
gum_style "System is now ready for the main installation phases."