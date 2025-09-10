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

    # Detect OS version and architecture
    OS_VERSION=$(detect_os_version)
    ARCH=$(detect_architecture)

    # Map OS version to ghostty release naming
    case $OS_VERSION in
        ubuntu_2204)
            GHOSTTY_DEB="ghostty_1.1.3-0.ppa2_${ARCH}_22.04.deb"
            ;;
        ubuntu_2404)
            GHOSTTY_DEB="ghostty_1.1.3-0.ppa2_${ARCH}_24.04.deb"
            ;;
        ubuntu_2410)
            GHOSTTY_DEB="ghostty_1.1.3-0.ppa2_${ARCH}_24.10.deb"
            ;;
        ubuntu_2504)
            GHOSTTY_DEB="ghostty_1.1.3-0.ppa2_${ARCH}_25.04.deb"
            ;;
        debian_bookworm)
            GHOSTTY_DEB="ghostty_1.1.3-0.ppa2_${ARCH}_bookworm.deb"
            ;;
        *)
            gum_style "Warning: Unsupported OS version $OS_VERSION, falling back to Ubuntu 24.04"
            GHOSTTY_DEB="ghostty_1.1.3-0.ppa2_${ARCH}_24.04.deb"
            ;;
    esac

    # Construct download URL
    DOWNLOAD_URL="https://github.com/mkasberg/ghostty-ubuntu/releases/download/1.1.3-0-ppa2/${GHOSTTY_DEB}"

    # Download and install ghostty
    execute_command \
        "wget -O \"$TMP_DIR/ghostty.deb\" \"$DOWNLOAD_URL\"" \
        "Ghostty deb package ($GHOSTTY_DEB) downloaded successfully." \
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