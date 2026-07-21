#!/bin/zsh
# Phase 7: Config Stowing
# Symlinks dotfiles configurations to home directory using GNU Stow

source "$(dirname "$0")/../utils.zsh"

gum_style "🔗 Phase 7: Config Stowing"
gum_style "Creating symlinks for your dotfiles..."

# Define dotfiles directory
DOTFILES_DIR="$(dirname "$(dirname "$(dirname "$0")")")"

# Validate dotfiles directory exists
if [[ ! -d "$DOTFILES_DIR" ]]; then
    gum_style "❌ Error: Dotfiles directory not found at $DOTFILES_DIR"
    exit 1
fi

# Validate we're in a git repository
if [[ ! -d "$DOTFILES_DIR/.git" ]]; then
    gum_style "⚠️ Warning: Dotfiles directory is not a git repository"
fi

# Define active stow packages based on installed tools
STOW_PACKAGES_CORE="i3 i3-layout-manager sxhkd polybar picom rofi"
STOW_PACKAGES_TERMINAL="ghostty zsh"
STOW_PACKAGES_DEV="nvim tmux tmuxinator git lazygit gh gh-dash zed"
STOW_PACKAGES_UTILS="fzf ripgrep bat lsd atuin zoxide sesh"
# Desktop & UI (only active ones - user confirmed using dunst)
STOW_PACKAGES_DESKTOP="dunst"
# Note: Other desktop configs available for manual stowing:
# - nitrogen: wallpaper setter
# - gtk-3.0: GTK theme settings (dark theme)
# - x11: X11 startup configuration
# - keyd: keyboard remapping (caps lock to escape/control)
# To stow manually: cd $DOTFILES_DIR && stow <package>
STOW_PACKAGES_APPS="thunar flameshot ulauncher blueman cbatticon unclutter xpad vimium"
STOW_PACKAGES_TOOLS="stylua opencode codex nerd-dictation"

# Combine all active packages
STOW_PACKAGES="$STOW_PACKAGES_CORE $STOW_PACKAGES_TERMINAL $STOW_PACKAGES_DEV $STOW_PACKAGES_UTILS $STOW_PACKAGES_DESKTOP $STOW_PACKAGES_APPS $STOW_PACKAGES_TOOLS"

# Function to check if a tool is installed
is_installed() {
    local tool="$1"
    case "$tool" in
        "i3"|"i3-layout-manager"|"sxhkd"|"polybar"|"picom"|"rofi")
            command -v "$tool" &> /dev/null ;;
        "ghostty")
            command -v ghostty &> /dev/null ;;
        "zsh")
            command -v zsh &> /dev/null ;;
        "nvim")
            command -v nvim &> /dev/null ;;
        "tmux"|"tmuxinator")
            command -v "$tool" &> /dev/null ;;
        "git")
            command -v git &> /dev/null ;;
        "lazygit")
            command -v lazygit &> /dev/null ;;
        "gh"|"gh-dash")
            command -v "$tool" &> /dev/null ;;
        "zed")
            command -v zed &> /dev/null ;;
        "fzf")
            command -v fzf &> /dev/null ;;
        "ripgrep")
            command -v rg &> /dev/null ;;
        "bat")
            command -v bat &> /dev/null ;;
        "lsd")
            command -v lsd &> /dev/null ;;
        "atuin")
            command -v atuin &> /dev/null ;;
        "zoxide")
            command -v zoxide &> /dev/null ;;
        "sesh")
            command -v sesh &> /dev/null ;;
        "dunst")
            command -v dunst &> /dev/null ;;
        "nitrogen")
            command -v nitrogen &> /dev/null ;;
        "thunar")
            command -v thunar &> /dev/null ;;
        "flameshot")
            command -v flameshot &> /dev/null ;;
        "ulauncher")
            command -v ulauncher &> /dev/null ;;
        "blueman")
            command -v blueman-manager &> /dev/null ;;
        "cbatticon")
            command -v cbatticon &> /dev/null ;;
        "unclutter")
            command -v unclutter &> /dev/null ;;
        "xpad")
            command -v xpad &> /dev/null ;;
        "stylua")
            command -v stylua &> /dev/null ;;
        "opencode")
            command -v opencode &> /dev/null ;;
        "codex")
            command -v codex &> /dev/null ;;
        *)
            # For configs that don't have direct binaries or are always stowed
            [[ -d "$DOTFILES_DIR/$tool" ]] ;;
    esac
}

# Apply the Codex theme setting without rewriting the rest of the live config.
apply_codex_theme_config() {
    local package_config="$DOTFILES_DIR/codex/.codex/config.toml"
    local live_config="$HOME/.codex/config.toml"
    local theme_line

    if [[ ! -f "$package_config" ]]; then
        gum_style "⚠️  Skipping Codex config: package config not found"
        return 1
    fi

    theme_line="$(grep -E '^tui\.theme[[:space:]]*=' "$package_config" | head -n 1)"
    if [[ -z "$theme_line" ]]; then
        gum_style "⚠️  Skipping Codex config: theme line not found in package config"
        return 1
    fi

    mkdir -p "$HOME/.codex"

    if [[ -f "$live_config" ]]; then
        if grep -qE '^[[:space:]]*tui\.theme[[:space:]]*=' "$live_config"; then
            perl -0pi -e 's/^[[:space:]]*tui\.theme[[:space:]]*=.*$/tui.theme = "cobalt2"/m' "$live_config"
        else
            printf '%s\n' "$theme_line" >> "$live_config"
        fi
    else
        printf '%s\n' "$theme_line" > "$live_config"
    fi

    gum_style "✅ Updated Codex theme config"
}

# Function to stow a package
stow_package() {
    local package="$1"

    if [[ ! -d "$DOTFILES_DIR/$package" ]]; then
        gum_style "⚠️  Skipping $package: directory not found"
        return 1
    fi

    if ! is_installed "$package"; then
        gum_style "⚠️  Skipping $package: tool not installed"
        return 1
    fi

    gum_style "🔗 Stowing $package..."

    # Change to dotfiles directory for stowing
    if ! cd "$DOTFILES_DIR"; then
        gum_style "❌ Error: Could not change to dotfiles directory $DOTFILES_DIR"
        return 1
    fi

    # Stow the package with error handling
    if [[ "$package" == "codex" ]]; then
        if stow --ignore='config\.toml' -v "$package" 2>&1; then
            STOW_EXIT_CODE=0
        else
            STOW_EXIT_CODE=$?
        fi
    else
        if stow -v "$package" 2>&1; then
            STOW_EXIT_CODE=0
        else
            STOW_EXIT_CODE=$?
        fi
    fi

    if [[ $STOW_EXIT_CODE -eq 0 ]]; then
        gum_style "✅ Successfully stowed $package"
        if [[ "$package" == "codex" ]]; then
            apply_codex_theme_config
        fi
        return 0
    else
        gum_style "❌ Failed to stow $package (exit code: $STOW_EXIT_CODE)"
        gum_style "💡 This might be due to existing files. Try: rm -rf ~/$package && cd $DOTFILES_DIR && stow $package"
        return 1
    fi
}

# Create backup of existing configs if they exist
gum_style "📦 Creating backups of existing configurations..."

BACKUP_DIR="$HOME/.dotfiles-backup-$(date +%Y%m%d_%H%M%S)"
if ! mkdir -p "$BACKUP_DIR"; then
    gum_style "❌ Error: Could not create backup directory $BACKUP_DIR"
    exit 1
fi

# Backup common config locations
for config_dir in .config .local/share .local/bin; do
    if [[ -d "$HOME/$config_dir" ]]; then
        cp -r "$HOME/$config_dir" "$BACKUP_DIR/" 2>/dev/null || true
    fi
done

# Backup common dotfiles
for dotfile in .zshrc .gitconfig .tmux.conf; do
    if [[ -f "$HOME/$dotfile" ]]; then
        cp "$HOME/$dotfile" "$BACKUP_DIR/" 2>/dev/null || true
    fi
done

if [[ -f "$HOME/.codex/config.toml" ]]; then
    mkdir -p "$BACKUP_DIR/.codex"
    cp "$HOME/.codex/config.toml" "$BACKUP_DIR/.codex/" 2>/dev/null || true
fi

gum_style "📦 Backup created at: $BACKUP_DIR"

# Stow packages
STOW_SUCCESS=0
STOW_FAILED=0

for package in $STOW_PACKAGES; do
    if stow_package "$package"; then
        ((STOW_SUCCESS++))
    else
        ((STOW_FAILED++))
    fi
done

# Special handling for packages that need custom stow commands
gum_style "🔧 Handling special stow cases..."

# Handle playerctl (no direct binary check needed)
if [[ -d "$DOTFILES_DIR/playerctl" ]]; then
    cd "$DOTFILES_DIR" && stow -v playerctl && gum_style "✅ Successfully stowed playerctl" || gum_style "❌ Failed to stow playerctl"
fi

# Summary
echo ""
gum_style "📊 Stowing Summary:"
echo "  ✅ Successfully stowed: $STOW_SUCCESS packages"
echo "  ❌ Failed to stow: $STOW_FAILED packages"
echo "  📦 Backup location: $BACKUP_DIR"

if [[ $STOW_FAILED -gt 0 ]]; then
    gum_style "⚠️  Some packages failed to stow. Check the output above for details."
    gum_style "💡 You can manually stow failed packages later with: cd $DOTFILES_DIR && stow <package>"
fi

# Verify some key symlinks
echo ""
gum_style "🔍 Verifying key configurations..."
echo "  i3 config: $(readlink -f ~/.config/i3/config 2>/dev/null || echo 'Not linked')"
echo "  zshrc: $(readlink -f ~/.zshrc 2>/dev/null || echo 'Not linked')"
echo "  nvim: $(readlink -f ~/.config/nvim 2>/dev/null || echo 'Not linked')"
echo "  tmux: $(readlink -f ~/.tmux.conf 2>/dev/null || echo 'Not linked')"

# Activate pre-commit hooks
gum_style " activating Git Hooks..."
if command -v pre-commit &> /dev/null; then
    execute_command \
        "cd \"$DOTFILES_DIR\" && pre-commit install" \
        "pre-commit hooks activated successfully." \
        "Failed to activate pre-commit hooks."
else
    gum_style "⚠️  pre-commit command not found, skipping hook activation."
fi

gum_style "✅ Phase 7: Config stowing completed!"
gum_style "Your dotfiles are now symlinked to your home directory."
echo ""
gum_style "📝 Optional desktop configs available for manual stowing:"
echo "  nitrogen  - wallpaper setter"
echo "  gtk-3.0   - GTK dark theme settings"
echo "  x11       - X11 startup configuration"
echo "  keyd      - keyboard remapping (caps→esc/ctrl)"
echo ""
gum_style "To stow manually: cd $DOTFILES_DIR && stow <package>"
