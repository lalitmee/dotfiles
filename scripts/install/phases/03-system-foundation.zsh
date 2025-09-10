#!/bin/zsh
# Phase 3: System Foundation
# Installs core productivity tools: zsh, tmux, fzf, ripgrep, bat, lsd, stow, gum

source "$(dirname "$0")/../utils.zsh"

gum_style "🛠️ Phase 3: System Foundation"
gum_style "Installing core productivity tools..."

# Ensure cargo is available
if ! command -v cargo &> /dev/null; then
    gum_style "❌ Cargo not found. Please ensure Phase 0 completed successfully."
    gum_style "💡 Try running Phase 0 first: ./scripts/install/phases/00-base-ubuntu.zsh"
    exit 1
fi

# Ensure Go is available
if ! command -v go &> /dev/null; then
    gum_style "❌ Go not found. Please ensure Phase 0 completed successfully."
    gum_style "💡 Try running Phase 0 first: ./scripts/install/phases/00-base-ubuntu.zsh"
    exit 1
fi

# Check available disk space (minimum 2GB)
AVAILABLE_SPACE=$(df "$HOME" | tail -1 | awk '{print $4}')
if [[ $AVAILABLE_SPACE -lt 2097152 ]]; then  # 2GB in KB
    gum_style "⚠️ Warning: Low disk space detected. At least 2GB recommended."
    gum_style "Available: $(($AVAILABLE_SPACE / 1024))MB"
fi

# Set up PATH for cargo and go
export PATH="$HOME/.cargo/bin:$PATH"
export PATH="$HOME/go/bin:$PATH"

# Also add to sudo PATH for commands that need it
export SUDO_PATH="$PATH"

# Install zsh
execute_command \
    "sudo apt install -y zsh" \
    "zsh shell installed successfully." \
    "Failed to install zsh."

# Install oh-my-zsh (zsh framework)
execute_command \
    "sh -c \"\$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)\" \"\" --unattended" \
    "oh-my-zsh installed successfully." \
    "Failed to install oh-my-zsh."

# Install powerlevel10k theme
execute_command \
    "git clone --depth=1 https://github.com/romkatv/powerlevel10k.git \${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k" \
    "Powerlevel10k theme installed successfully." \
    "Failed to install Powerlevel10k."

# Install tmux
execute_command \
    "sudo apt install -y tmux" \
    "tmux installed successfully." \
    "Failed to install tmux."

# Install TPM (Tmux Plugin Manager)
execute_command \
    "git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm" \
    "TPM (Tmux Plugin Manager) installed successfully." \
    "Failed to install TPM."

# Install fzf
execute_command \
    "sudo apt install -y fzf" \
    "fzf (fuzzy finder) installed successfully." \
    "Failed to install fzf."

# Install ripgrep via cargo
execute_command \
    "cargo install ripgrep" \
    "ripgrep installed successfully." \
    "Failed to install ripgrep."

# Install bat via cargo
execute_command \
    "cargo install bat" \
    "bat (cat replacement) installed successfully." \
    "Failed to install bat."

# Install lsd via cargo
execute_command \
    "cargo install lsd" \
    "lsd (ls replacement) installed successfully." \
    "Failed to install lsd."

# Install stow (dotfile manager)
execute_command \
    "sudo apt install -y stow" \
    "stow (dotfile manager) installed successfully." \
    "Failed to install stow."

# Install gum (TUI framework) via go
execute_command \
    "go install github.com/charmbracelet/gum@latest" \
    "gum (TUI framework) installed successfully." \
    "Failed to install gum."

# Install zoxide via cargo
execute_command \
    "cargo install zoxide" \
    "zoxide (smarter cd) installed successfully." \
    "Failed to install zoxide."

# Install atuin via cargo
execute_command \
    "cargo install atuin" \
    "atuin (shell history) installed successfully." \
    "Failed to install atuin."

# Install wakatime (time tracking)
execute_command \
    "sudo apt install -y python3-pip && pip3 install wakatime" \
    "wakatime (time tracking) installed successfully." \
    "Failed to install wakatime."

# Install sesh via Go
execute_command \
    "go install github.com/joshmedeski/sesh/v2@latest" \
    "sesh (session manager) installed successfully." \
    "Failed to install sesh."

# Install tmuxinator (tmux session manager)
execute_command \
    "sudo apt install -y tmuxinator" \
    "tmuxinator installed successfully." \
    "Failed to install tmuxinator."

# Clean up
execute_command \
    "sudo apt autoremove -y && sudo apt clean" \
    "Cleanup completed after system foundation installation." \
    "Failed to clean up after installation."

gum_style "✅ Phase 3: System Foundation completed successfully!"
gum_style "Core productivity tools are now installed and ready."