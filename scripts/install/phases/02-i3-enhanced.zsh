#!/bin/zsh
# Phase 2: i3 Enhanced
# Installs i3ass suite, sxhkd, rofi, polybar, picom, and essential utilities

source "$(dirname "$0")/../utils.zsh"

gum_style "⚡ Phase 2: i3 Enhanced Installation"
gum_style "Installing i3ass suite and essential enhancements..."

# Create temporary directory for building
TMP_DIR=$(mktemp -d)
trap 'rm -rf "$TMP_DIR"' EXIT

# Install i3ass suite from https://github.com/budlabs/i3ass
gum_style "Installing i3ass suite..."

# Install dependencies for i3ass
execute_command \
    "sudo apt install -y libxcb-keysyms1-dev libxcb-util0-dev libxcb-icccm4-dev libyajl-dev libstartup-notification0-dev libxcb-randr0-dev libev-dev libxcb-cursor-dev libxcb-xinerama0-dev libxcb-xkb-dev libxkbcommon-dev libxkbcommon-x11-dev autoconf xutils-dev libtool automake" \
    "i3ass build dependencies installed successfully." \
    "Failed to install i3ass dependencies."

# Clone and build i3ass
execute_command \
    "git clone https://github.com/budlabs/i3ass.git \"$TMP_DIR/i3ass\"" \
    "i3ass repository cloned successfully." \
    "Failed to clone i3ass repository."

cd "$TMP_DIR/i3ass" || { gum_style "Error: Could not enter i3ass directory"; exit 1; }

# Build and install each i3ass component
for component in i3run i3viswiz i3flip i3Kornhe i3fyra i3zen; do
    if [[ -d "$component" ]]; then
        cd "$component" || continue
        execute_command \
            "autoreconf -fiv && ./configure && make && sudo make install" \
            "$component installed successfully." \
            "Failed to install $component."
        cd ..
    fi
done

cd - || { gum_style "Error: Could not return to previous directory"; exit 1; }

# Install sxhkd (simple X hotkey daemon)
execute_command \
    "sudo apt install -y sxhkd" \
    "sxhkd (hotkey daemon) installed successfully." \
    "Failed to install sxhkd."

# Install rofi (application launcher)
execute_command \
    "sudo apt install -y rofi" \
    "rofi (application launcher) installed successfully." \
    "Failed to install rofi."

# Install polybar dependencies and build from source
execute_command \
    "sudo apt install -y cmake cmake-data pkg-config python3-sphinx libcairo2-dev libxcb1-dev libxcb-util0-dev libxcb-randr0-dev libxcb-composite0-dev python3-xcbgen xcb-proto libxcb-image0-dev libxcb-ewmh-dev libxcb-icccm4-dev libxcb-xkb-dev libxcb-xrm-dev libxcb-cursor-dev libasound2-dev libpulse-dev libjsoncpp-dev libcurl4-openssl-dev libnl-genl-3-dev" \
    "Polybar build dependencies installed successfully." \
    "Failed to install polybar dependencies."

# Clone and build polybar
execute_command \
    "git clone --recursive https://github.com/polybar/polybar \"$TMP_DIR/polybar\"" \
    "Polybar repository cloned successfully." \
    "Failed to clone polybar repository."

cd "$TMP_DIR/polybar" || { gum_style "Error: Could not enter polybar directory"; exit 1; }

execute_command \
    "mkdir build && cd build && cmake .. && make -j$(nproc) && sudo make install" \
    "Polybar built and installed successfully." \
    "Failed to build/install polybar."

cd - || { gum_style "Error: Could not return to previous directory"; exit 1; }

# Install picom (compositor)
execute_command \
    "sudo apt install -y picom" \
    "picom (compositor) installed successfully." \
    "Failed to install picom."

# Install feh (wallpaper setter)
execute_command \
    "sudo apt install -y feh" \
    "feh (wallpaper setter) installed successfully." \
    "Failed to install feh."

# Install ulauncher (application launcher)
execute_command \
    "sudo apt install -y ulauncher" \
    "ulauncher (application launcher) installed successfully." \
    "Failed to install ulauncher."

# Install flameshot (screenshot tool)
execute_command \
    "sudo apt install -y flameshot" \
    "flameshot (screenshot tool) installed successfully." \
    "Failed to install flameshot."

# Install blueman (bluetooth manager)
execute_command \
    "sudo apt install -y blueman" \
    "blueman (bluetooth manager) installed successfully." \
    "Failed to install blueman."

# Install thunar (file manager)
execute_command \
    "sudo apt install -y thunar" \
    "thunar (file manager) installed successfully." \
    "Failed to install thunar."

# Install xpad (sticky notes)
execute_command \
    "sudo apt install -y xpad" \
    "xpad (sticky notes) installed successfully." \
    "Failed to install xpad."

# Install cbatticon (battery tray icon)
execute_command \
    "sudo apt install -y cbatticon" \
    "cbatticon (battery tray icon) installed successfully." \
    "Failed to install cbatticon."

# Install unclutter (mouse cursor hider)
execute_command \
    "sudo apt install -y unclutter" \
    "unclutter (mouse cursor hider) installed successfully." \
    "Failed to install unclutter."

# Install btop (system monitor)
execute_command \
    "sudo apt install -y btop" \
    "btop (system monitor) installed successfully." \
    "Failed to install btop."

# Install cmus (terminal music player)
execute_command \
    "sudo apt install -y cmus" \
    "cmus (terminal music player) installed successfully." \
    "Failed to install cmus."

# Install playerctl (media control)
execute_command \
    "sudo apt install -y playerctl" \
    "playerctl (media control) installed successfully." \
    "Failed to install playerctl."

# Clean up
execute_command \
    "sudo apt autoremove -y && sudo apt clean" \
    "Cleanup completed after i3 enhanced installation." \
    "Failed to clean up after installation."

gum_style "✅ Phase 2: i3 Enhanced installation completed successfully!"
gum_style "i3ass suite and all essential enhancements are now installed."