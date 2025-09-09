#!/bin/zsh
# Phase 6: Desktop Apps
# Installs desktop applications: brave, firefox, slack, telegram, spotify, bitwarden

source "$(dirname "$0")/../utils.zsh"

gum_style "🖥️ Phase 6: Desktop Applications"
gum_style "Installing essential desktop applications..."

# Install Brave browser
execute_command \
    "sudo apt install -y apt-transport-https curl" \
    "Prerequisites for Brave installed successfully." \
    "Failed to install Brave prerequisites."

execute_command \
    "sudo curl -fsSLo /usr/share/keyrings/brave-browser-archive-keyring.gpg https://brave-browser-apt-release.s3.brave.com/brave-browser-archive-keyring.gpg" \
    "Brave GPG key added successfully." \
    "Failed to add Brave GPG key."

execute_command \
    "echo 'deb [signed-by=/usr/share/keyrings/brave-browser-archive-keyring.gpg] https://brave-browser-apt-release.s3.brave.com/ stable main' | sudo tee /etc/apt/sources.list.d/brave-browser-release.list" \
    "Brave repository added successfully." \
    "Failed to add Brave repository."

execute_command \
    "sudo apt update && sudo apt install -y brave-browser" \
    "Brave browser installed successfully." \
    "Failed to install Brave browser."

# Install Firefox
execute_command \
    "sudo apt install -y firefox" \
    "Firefox installed successfully." \
    "Failed to install Firefox."

# Install Slack (using apt if available, otherwise skip)
if apt-cache show slack-desktop &> /dev/null; then
    execute_command \
        "sudo apt install -y slack-desktop" \
        "Slack installed successfully." \
        "Failed to install Slack."
else
    gum_style "⚠️ Slack not available via apt. You may need to install it manually."
fi

# Install Telegram
execute_command \
    "sudo apt install -y telegram-desktop" \
    "Telegram installed successfully." \
    "Failed to install Telegram."

# Install Spotify
execute_command \
    "curl -sS https://download.spotify.com/debian/pubkey_C85668DF69375001.gpg | sudo gpg --dearmor --yes -o /etc/apt/trusted.gpg.d/spotify.gpg" \
    "Spotify GPG key added successfully." \
    "Failed to add Spotify GPG key."

execute_command \
    "echo 'deb http://repository.spotify.com stable non-free' | sudo tee /etc/apt/sources.list.d/spotify.list" \
    "Spotify repository added successfully." \
    "Failed to add Spotify repository."

execute_command \
    "sudo apt update && sudo apt install -y spotify-client" \
    "Spotify installed successfully." \
    "Failed to install Spotify."

# Install Bitwarden (using apt if available)
if apt-cache show bitwarden &> /dev/null; then
    execute_command \
        "sudo apt install -y bitwarden" \
        "Bitwarden installed successfully." \
        "Failed to install Bitwarden."
else
    gum_style "⚠️ Bitwarden not available via apt. You may need to install it manually."
fi

# Clean up
execute_command \
    "sudo apt autoremove -y && sudo apt clean" \
    "Cleanup completed after desktop apps installation." \
    "Failed to clean up after installation."

gum_style "✅ Phase 6: Desktop Applications completed successfully!"
gum_style "All essential desktop applications are now installed."