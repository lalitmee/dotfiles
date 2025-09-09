#!/bin/zsh
# Phase 8: Final Setup
# Installs fonts and basic themes

source "$(dirname "$0")/../utils.zsh"

gum_style "🎨 Phase 8: Final Setup"
gum_style "Installing fonts and basic themes..."

# Create fonts directory
execute_command \
    "mkdir -p ~/.local/share/fonts" \
    "Fonts directory created successfully." \
    "Failed to create fonts directory."

# Install Nerd Fonts (for icons in terminal)
execute_command \
    "sudo apt install -y fonts-noto-color-emoji fonts-firacode fonts-jetbrains-mono" \
    "Basic programming fonts installed successfully." \
    "Failed to install programming fonts."

# Download and install FiraCode Nerd Font
execute_command \
    "curl -fLo \"/tmp/FiraCode.zip\" https://github.com/ryanoasis/nerd-fonts/releases/download/v3.0.2/FiraCode.zip" \
    "FiraCode Nerd Font downloaded successfully." \
    "Failed to download FiraCode Nerd Font."

execute_command \
    "unzip -o \"/tmp/FiraCode.zip\" -d ~/.local/share/fonts/" \
    "FiraCode Nerd Font extracted successfully." \
    "Failed to extract FiraCode Nerd Font."

# Download and install JetBrains Mono Nerd Font
execute_command \
    "curl -fLo \"/tmp/JetBrainsMono.zip\" https://github.com/ryanoasis/nerd-fonts/releases/download/v3.0.2/JetBrainsMono.zip" \
    "JetBrains Mono Nerd Font downloaded successfully." \
    "Failed to download JetBrains Mono Nerd Font."

execute_command \
    "unzip -o \"/tmp/JetBrainsMono.zip\" -d ~/.local/share/fonts/" \
    "JetBrains Mono Nerd Font extracted successfully." \
    "Failed to extract JetBrains Mono Nerd Font."

# Update font cache
execute_command \
    "fc-cache -fv" \
    "Font cache updated successfully." \
    "Failed to update font cache."

# Install basic GTK themes
execute_command \
    "sudo apt install -y arc-theme" \
    "Arc GTK theme installed successfully." \
    "Failed to install Arc theme."

# Create post-installation script
cat > ~/post-install-setup.sh << 'EOF'
#!/bin/bash
echo "Post-Installation Setup Script"
echo "=============================="
echo ""
echo "Recommended next steps:"
echo "1. Log out and log back in to apply all changes"
echo "2. Run your dotfiles stow script: ./install"
echo "3. Configure your themes using lxappearance"
echo "4. Set up your wallpaper using feh"
echo "5. Configure your notification daemon"
echo "6. Set up your keybindings and test i3"
echo "7. Install any additional tools you need"
echo ""
echo "Useful commands:"
echo "- lxappearance     # GTK theme configuration"
echo "- feh              # Wallpaper configuration"
echo ""
echo "Your git configuration should come from your dotfiles."
echo "Make sure to run: git config --global user.name 'Your Name'"
echo "                  git config --global user.email 'your.email@example.com'"
EOF

execute_command \
    "chmod +x ~/post-install-setup.sh" \
    "Post-installation script created successfully." \
    "Failed to create post-installation script."

# Clean up
execute_command \
    "sudo apt autoremove -y && sudo apt clean && sudo apt autoclean" \
    "Final cleanup completed." \
    "Failed to complete final cleanup."

gum_style "✅ Phase 7: Final Setup completed successfully!"
gum_style "🎉 Your complete development environment is now ready!"
gum_style ""
gum_style "📋 Next steps:"
echo "  1. Run: ~/post-install-setup.sh"
echo "  2. Log out and log back in"
echo "  3. Run your dotfiles stow script: ./install"
echo "  4. Enjoy your new setup!"