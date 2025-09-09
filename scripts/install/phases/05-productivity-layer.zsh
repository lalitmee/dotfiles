#!/bin/zsh
# Phase 5: Productivity Layer
# Installs ghostty terminal

source "$(dirname "$0")/../utils.zsh"

gum_style "⚡ Phase 5: Productivity Layer"
gum_style "Installing ghostty terminal..."

# Install ghostty (terminal)
if ! command -v ghostty &> /dev/null; then
    # Create temporary directory
    TMP_DIR=$(mktemp -d)
    trap 'rm -rf "$TMP_DIR"' EXIT

    # Download and install ghostty
    execute_command \
        "wget -O \"$TMP_DIR/ghostty.deb\" https://release.files.ghostty.org/ghostty_1.0.1_amd64.deb" \
        "Ghostty deb package downloaded successfully." \
        "Failed to download ghostty."

    execute_command \
        "sudo dpkg -i \"$TMP_DIR/ghostty.deb\" || sudo apt install -f -y" \
        "Ghostty installed successfully." \
        "Failed to install ghostty."
else
    gum_style "ℹ️ ghostty is already installed."
fi

# Clean up
execute_command \
    "sudo apt autoremove -y && sudo apt clean" \
    "Cleanup completed after productivity layer installation." \
    "Failed to clean up after installation."

gum_style "✅ Phase 5: Productivity Layer completed successfully!"
gum_style "Ghostty terminal is now installed."