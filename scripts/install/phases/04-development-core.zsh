#!/bin/zsh
# Phase 4: Development Core
# Installs development environment: neovim, pyenv, rbenv, fnm, lazygit, Node.js, Ruby

source "$(dirname "$0")/../utils.zsh"

gum_style "💻 Phase 4: Development Core"
gum_style "Installing development environment and tools..."

# Ensure Go is available
if ! command -v go &> /dev/null; then
    gum_style "❌ Go not found. Please ensure Phase 0 completed successfully."
    exit 1
fi

# Set up PATH for go
export PATH="$HOME/go/bin:$PATH"

# Clean up existing installations to ensure clean state
gum_style "🧹 Cleaning up existing installations..."
execute_command \
    "rm -rf ~/.pyenv ~/.rbenv ~/.fnm ~/Desktop/Github" \
    "User-level installations cleaned up." \
    "Warning: Could not clean up user-level installations."

# Clean up system-level installations (requires sudo)
if [[ -f /usr/local/bin/nvim ]]; then
    execute_command \
        "sudo rm -f /usr/local/bin/nvim" \
        "System-level neovim cleaned up." \
        "Warning: Could not clean up system-level neovim."
fi

# Install python3 and pip (required for pyenv and some tools)
execute_command \
    "sudo apt install -y python3 python3-pip python3-dev python3-venv" \
    "Python3 and development tools installed successfully." \
    "Failed to install Python3."

# Install pipx for isolated Python package management
execute_command \
    "sudo apt install -y pipx" \
    "pipx installed successfully." \
    "Failed to install pipx."

# Install pyenv (Python version manager)
PYENV_URL="https://pyenv.run"
PYENV_HASH="1065197a9fff657e0e2941e4ca8c8b6e72833833466b777b9eddd0fff335ec41"
PYENV_INSTALLER="/tmp/pyenv_installer.sh"

if download_and_verify "$PYENV_URL" "$PYENV_HASH" "$PYENV_INSTALLER"; then
    if safe_execute_script "$PYENV_INSTALLER"; then
        gum_style "pyenv installed successfully."
    else
        gum_style "Error: Failed to install pyenv." >&2
        exit 1
    fi
    rm -f "$PYENV_INSTALLER"
else
    gum_style "Error: Failed to download or verify pyenv installer." >&2
    exit 1
fi

# Add pyenv to PATH (for current session)
export PATH="$HOME/.pyenv/bin:$PATH"
eval "$(pyenv init -)"

# Install pyenv-virtualenv (if not already installed by pyenv)
if [[ ! -d "$(pyenv root)/plugins/pyenv-virtualenv" ]]; then
    execute_command \
        "git clone https://github.com/pyenv/pyenv-virtualenv.git $(pyenv root)/plugins/pyenv-virtualenv" \
        "pyenv-virtualenv plugin installed successfully." \
        "Failed to install pyenv-virtualenv."
else
    gum_style "pyenv-virtualenv plugin already installed by pyenv."
fi

# Install rbenv (Ruby version manager)
execute_command \
    "sudo apt install -y rbenv" \
    "rbenv installed successfully." \
    "Failed to install rbenv."

# Initialize rbenv
eval "$(rbenv init - zsh)"

# Install ruby-build (for rbenv)
execute_command \
    "mkdir -p \"$(rbenv root)\"/plugins && git clone https://github.com/rbenv/ruby-build.git \"$(rbenv root)\"/plugins/ruby-build" \
    "ruby-build plugin for rbenv installed successfully." \
    "Failed to install ruby-build."

# Install Ruby using rbenv (with timeout to avoid hanging)
timeout 300 rbenv install 3.3.0
if [[ $? -eq 0 ]]; then
    rbenv global 3.3.0
    gum_style "Ruby 3.3.0 installed successfully."
else
    gum_style "⚠️ Ruby installation timed out or failed, continuing with system Ruby."
fi

# Install bundler (if Ruby is available)
if command -v gem >/dev/null 2>&1; then
    execute_command \
        "gem install bundler" \
        "Bundler installed successfully." \
        "Failed to install bundler."
else
    gum_style "⚠️ gem not available, skipping bundler installation."
fi

# Install fd (find replacement) via cargo
execute_command \
    "cargo install fd-find" \
    "fd (find replacement) installed successfully." \
    "Failed to install fd."

# Install fnm (Fast Node Manager)
FNM_URL="https://fnm.vercel.app/install"
FNM_HASH="8431644b1c205ad25d4b09cfe10e0688944d1d2cd542f38d7b3b10e954db8ad9"
FNM_INSTALLER="/tmp/fnm_installer.sh"

if download_and_verify "$FNM_URL" "$FNM_HASH" "$FNM_INSTALLER"; then
    if safe_execute_script "$FNM_INSTALLER"; then
        gum_style "fnm installed successfully."
    else
        gum_style "Error: Failed to install fnm." >&2
        exit 1
    fi
    rm -f "$FNM_INSTALLER"
else
    gum_style "Error: Failed to download or verify fnm installer." >&2
    exit 1
fi

# Add fnm to PATH
export PATH="$HOME/.fnm:$PATH"
eval "$(fnm env --use-on-cd)"

# Install Node.js using fnm
execute_command \
    "fnm install --lts && fnm use lts-latest" \
    "Node.js LTS installed successfully." \
    "Failed to install Node.js."

# Install global npm packages
execute_command \
    "npm install -g yarn pnpm typescript @types/node" \
    "Global npm packages installed successfully." \
    "Failed to install global npm packages."

# Install neovim dependencies
execute_command \
    "sudo apt install -y autoconf automake cmake g++ gettext libncurses5-dev libtool libtool-bin libunibilium-dev libunibilium4 ninja-build pkg-config unzip" \
    "neovim build dependencies installed successfully." \
    "Failed to install neovim build dependencies."

# Install neovim from source
# Determine the correct path to build-neovim script
DOTFILES_DIR="$(dirname "$(dirname "$(dirname "$0")")")"
BUILD_NEOVIM_SCRIPT="$DOTFILES_DIR/bin/.config/bin/build-neovim"

if [[ ! -f "$BUILD_NEOVIM_SCRIPT" ]]; then
    gum_style "❌ Error: build-neovim script not found at $BUILD_NEOVIM_SCRIPT"
    exit 1
fi

execute_command \
    "$BUILD_NEOVIM_SCRIPT" \
    "neovim built and installed successfully from source." \
    "Failed to build neovim from source."

# Install lazygit via go
execute_command \
    "go install github.com/jesseduffield/lazygit@latest" \
    "lazygit installed successfully." \
    "Failed to install lazygit."

# Install tig via apt
execute_command \
    "sudo apt install -y tig" \
    "tig (git text-mode interface) installed successfully." \
    "Failed to install tig."

# Install GitHub CLI via apt
execute_command \
    "sudo apt install -y gh" \
    "gh (GitHub CLI) installed successfully." \
    "Failed to install gh."

# Install lazydocker via go
execute_command \
    "go install github.com/jesseduffield/lazydocker@latest" \
    "lazydocker installed successfully." \
    "Failed to install lazydocker."

# Install gh-dash via go
execute_command \
    "go install github.com/dlvhdr/gh-dash@latest" \
    "gh-dash (GitHub dashboard) installed successfully." \
    "Failed to install gh-dash."

# Install development libraries (needed for various tools)
execute_command \
    "sudo apt install -y libssl-dev libreadline-dev zlib1g-dev libsqlite3-dev libbz2-dev libffi-dev liblzma-dev" \
    "Development libraries installed successfully." \
    "Failed to install development libraries."

# Clean up
execute_command \
    "sudo apt autoremove -y && sudo apt clean" \
    "Cleanup completed after development core installation." \
    "Failed to clean up after installation."

gum_style "✅ Phase 4: Development Core completed successfully!"
gum_style "Development environment is now fully set up."
