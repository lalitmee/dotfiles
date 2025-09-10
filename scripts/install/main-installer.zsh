#!/bin/zsh
# ============================================================================
# Main Installer Script for Complete System Setup
# ============================================================================
#
# DESCRIPTION:
#   This script orchestrates the installation of a complete development
#   environment based on the SYSTEM_SETUP_CONTEXT.md decisions. It provides
#   an interactive interface for installing system components in phases.
#
# FEATURES:
#   - Interactive phase selection (full/custom/single)
#   - Error handling and rollback capabilities
#   - Comprehensive logging
#   - System validation and prerequisite checking
#   - Progress tracking and status reporting
#
# USAGE:
#   ./main-installer.zsh              # Interactive mode
#   ./main-installer.zsh --help       # Show help (future feature)
#
# PHASES:
#   0: Base Ubuntu Setup (git, curl, build tools)
#   1: i3 Core (window manager essentials)
#   2: i3 Enhanced (i3ass suite, polybar, picom, etc.)
#   3: System Foundation (zsh, tmux, development tools)
#   4: Development Core (neovim, pyenv, rbenv, fnm)
#   5: Productivity Layer (ghostty terminal)
#   6: Desktop Apps (browsers, communication tools)
#   7: Config Stowing (symlink dotfiles)
#   8: Final Setup (fonts, themes, cleanup)
#
# REQUIREMENTS:
#   - Ubuntu 20.04+ or compatible Debian-based system
#   - Internet connection for downloads
#   - sudo privileges
#   - At least 5GB free disk space
#
# ERROR HANDLING:
#   - Script exits on critical errors
#   - Rollback available for failed phases
#   - Comprehensive logging to ~/dotfiles-install-*.log
#
# AUTHOR: Lalit Kumar
# VERSION: 2.1
# LAST UPDATED: 2025-01-10
# ============================================================================

# Set script directory
SCRIPT_DIR="$(dirname "$0")"

# Set up PATH for installed tools (needed for gum and other tools)
export PATH="$HOME/.cargo/bin:$PATH"
export PATH="$HOME/go/bin:$PATH"

# Create log file for installation tracking
LOG_FILE="$HOME/dotfiles-install-$(date +%Y%m%d_%H%M%S).log"
exec > >(tee -a "$LOG_FILE") 2>&1

gum_style "📝 Installation log: $LOG_FILE"

# Source utilities
if [[ -f "$SCRIPT_DIR/utils.zsh" ]]; then
    source "$SCRIPT_DIR/utils.zsh"
else
    echo "Error: utils.zsh not found in $SCRIPT_DIR" >&2
    exit 1
fi

# Define installation phases
PHASES=(
    "00-base-ubuntu:Base Ubuntu Setup (git, curl, build-essential)"
    "01-i3-core:i3 Core (i3-wm, i3lock, xss-lock, dex, lxappearance)"
    "02-i3-enhanced:i3 Enhanced (i3ass suite, sxhkd, rofi, polybar, picom, feh, ulauncher, flameshot, blueman, thunar, xpad, cbatticon, unclutter, btop, cmus, playerctl)"
    "03-system-foundation:System Foundation (zsh, tmux, fzf, ripgrep, bat, lsd, stow, gum, zoxide, atuin, wakatime, sesh, tmuxinator) [cargo/go]"
    "04-development-core:Development Core (neovim, pyenv, rbenv, fnm, lazygit) [go]"
    "05-productivity-layer:Productivity Layer (ghostty terminal)"
    "06-desktop-apps:Desktop Apps (brave, firefox, slack, telegram, spotify, bitwarden)"
    "07-config-stow:Config Stowing (symlink dotfiles to home directory)"
    "08-final-setup:Final Setup (fonts, basic themes, validation)"
)

# Global variable to track installed packages for rollback
INSTALLED_PACKAGES=()

# Function to track installed packages
track_package() {
    local package="$1"
    INSTALLED_PACKAGES+=("$package")
}

# Function to rollback failed installations
rollback_installation() {
    local failed_phase="$1"
    gum_style "🔄 Starting rollback for failed Phase $failed_phase..."

    # Remove recently installed packages (basic rollback)
    if [[ ${#INSTALLED_PACKAGES[@]} -gt 0 ]]; then
        gum_style "📦 Removing recently installed packages..."
        for package in "${INSTALLED_PACKAGES[@]}"; do
            if dpkg -l | grep -q "^ii.*$package"; then
                sudo apt remove -y "$package" 2>/dev/null || true
            fi
        done
    fi

    # Clean up temporary files
    gum_style "🧹 Cleaning up temporary files..."
    rm -rf /tmp/*dotfiles* 2>/dev/null || true

    gum_style "✅ Rollback completed. You can try running the phase again."
}

# Function to run a specific phase
run_phase() {
    local phase_number="$1"
    local phase_script="$SCRIPT_DIR/phases/${phase_number}.zsh"

    if [[ -f "$phase_script" ]]; then
        gum_style "🔄 Starting Phase $phase_number..."
        if "$phase_script"; then
            gum_style "✅ Phase $phase_number completed successfully!"
            return 0
        else
            gum_style "❌ Phase $phase_number failed!"
            gum_style "💡 Would you like to attempt rollback? (y/N)"
            read -r response
            if [[ "$response" =~ ^[Yy]$ ]]; then
                rollback_installation "$phase_number"
            fi
            return 1
        fi
    else
        gum_style "⚠️ Phase $phase_number script not found: $phase_script"
        return 1
    fi
}

# Function to show system information
show_system_info() {
    echo "📊 System Information:"
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo "🖥️  OS: $(lsb_release -d | cut -f2)"
    echo "🏗️  Kernel: $(uname -r)"
    echo "👤 User: $(whoami)"
    echo "📁 Home: $HOME"
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
}

# Function to check prerequisites
check_prerequisites() {
    local missing_deps=()

    # Note: gum will be installed in Phase 3, not as a prerequisite

    # Check if sudo is available
    if ! command -v sudo &> /dev/null; then
        missing_deps+=("sudo")
    fi

    # Check if curl is available
    if ! command -v curl &> /dev/null; then
        missing_deps+=("curl")
    fi

    if [[ ${#missing_deps[@]} -gt 0 ]]; then
        gum_style "❌ Missing prerequisites: ${missing_deps[*]}"
        gum_style "Please install them first and run this script again."
        exit 1
    fi
}

# Main function
main() {
    # Check prerequisites
    check_prerequisites

    # Show welcome message
    gum_style "🚀 Welcome to the Complete System Setup Installer"
    gum_style "This will install and configure your development environment based on your context file."
    echo ""

    # Show system information
    show_system_info
    echo ""

    # Ask user what they want to do
    local action=$(gum choose \
        "full-install:Complete installation (all phases)" \
        "custom-install:Custom installation (select phases)" \
        "single-phase:Install single phase" \
        "show-phases:Show available phases" \
        "exit:Exit installer" \
        --header "What would you like to do?")

    case $action in
        full-install*)
            gum_style "🔄 Starting complete installation..."
            for phase_info in "${PHASES[@]}"; do
                local phase_number=$(echo "$phase_info" | cut -d: -f1)
                if ! run_phase "$phase_number"; then
                    gum_style "❌ Installation failed at Phase $phase_number"
                    exit 1
                fi
            done
            gum_style "🎉 Complete installation finished successfully!"
            ;;

        custom-install*)
            gum_style "📋 Select phases to install:"
            local selected_phases=$(printf '%s\n' "${PHASES[@]}" | \
                gum choose --no-limit --header "Select phases to install:")

            if [[ -z "$selected_phases" ]]; then
                gum_style "❌ No phases selected. Exiting."
                exit 1
            fi

            gum_style "🔄 Starting custom installation..."
            for phase_info in "${selected_phases[@]}"; do
                local phase_number=$(echo "$phase_info" | cut -d: -f1)
                if ! run_phase "$phase_number"; then
                    gum_style "❌ Installation failed at Phase $phase_number"
                    exit 1
                fi
            done
            gum_style "🎉 Custom installation finished successfully!"
            ;;

        single-phase*)
            local selected_phase=$(printf '%s\n' "${PHASES[@]}" | \
                gum choose --header "Select phase to install:")

            if [[ -z "$selected_phase" ]]; then
                gum_style "❌ No phase selected. Exiting."
                exit 1
            fi

            local phase_number=$(echo "$selected_phase" | cut -d: -f1)
            gum_style "🔄 Installing Phase $phase_number..."
            if run_phase "$phase_number"; then
                gum_style "✅ Phase $phase_number installed successfully!"
            else
                gum_style "❌ Phase $phase_number installation failed!"
                exit 1
            fi
            ;;

        show-phases*)
            gum_style "📋 Available Installation Phases:"
            echo ""
            for phase_info in "${PHASES[@]}"; do
                local phase_number=$(echo "$phase_info" | cut -d: -f1)
                local phase_description=$(echo "$phase_info" | cut -d: -f2)
                echo "  $phase_number: $phase_description"
            done
            echo ""
            gum_style "Run this script again to start installation."
            ;;

        exit*)
            gum_style "👋 Goodbye!"
            exit 0
            ;;

        *)
            gum_style "❌ Invalid selection. Exiting."
            exit 1
            ;;
    esac

    # Post-installation message
    echo ""
    gum_style "🎉 Installation completed!"
    gum_style "📝 Next steps:"
    echo "  1. Log out and log back in to apply changes"
    echo "  2. Run your dotfiles stow script: ./install"
    echo "  3. Set up your git configuration from dotfiles"
    echo "  4. Enjoy your new development environment!"
}

# Run main function
main "$@"