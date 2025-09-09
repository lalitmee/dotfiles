#!/bin/zsh
# Phase 1: i3 Core
# Installs i3 window manager and essential components only

source "$(dirname "$0")/../utils.zsh"

gum_style "🏗️ Phase 1: i3 Core Installation"
gum_style "Installing i3 window manager and essential components..."

# Install i3 window manager
execute_command \
    "sudo apt install -y i3 i3-wm" \
    "i3 window manager installed successfully." \
    "Failed to install i3 window manager."

# Install i3lock (screen locker)
execute_command \
    "sudo apt install -y i3lock" \
    "i3lock installed successfully." \
    "Failed to install i3lock."

# Install xss-lock for screen locking integration
execute_command \
    "sudo apt install -y xss-lock" \
    "xss-lock installed successfully." \
    "Failed to install xss-lock."

# Install dex for desktop entry execution
execute_command \
    "sudo apt install -y dex" \
    "dex (desktop entry execution) installed successfully." \
    "Failed to install dex."

# Install lxappearance for GTK theme management
execute_command \
    "sudo apt install -y lxappearance" \
    "lxappearance (GTK theme manager) installed successfully." \
    "Failed to install lxappearance."

# Clean up
execute_command \
    "sudo apt autoremove -y && sudo apt clean" \
    "Cleanup completed after i3 core installation." \
    "Failed to clean up after installation."

gum_style "✅ Phase 1: i3 Core installation completed successfully!"
gum_style "i3 window manager is now installed and ready for configuration."