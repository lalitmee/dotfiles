#!/bin/zsh
# Phase 4: Development Core
# Installs development environment: neovim, pyenv, rbenv, fnm, lazygit

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

# Install neovim
execute_command \
    "sudo apt install -y neovim" \
    "neovim installed successfully." \
    "Failed to install neovim."

# Install python3 and pip (required for pyenv and some tools)
execute_command \
    "sudo apt install -y python3 python3-pip python3-dev python3-venv" \
    "Python3 and development tools installed successfully." \
    "Failed to install Python3."

# Install pyenv (Python version manager)
execute_command \
    "curl https://pyenv.run | bash" \
    "pyenv installed successfully." \
    "Failed to install pyenv."

# Add pyenv to PATH (for current session)
export PATH="$HOME/.pyenv/bin:$PATH"
eval "$(pyenv init -)"

# Install pyenv-virtualenv
execute_command \
    "git clone https://github.com/pyenv/pyenv-virtualenv.git $(pyenv root)/plugins/pyenv-virtualenv" \
    "pyenv-virtualenv plugin installed successfully." \
    "Failed to install pyenv-virtualenv."

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

# Install fnm (Fast Node Manager)
execute_command \
    "curl -fsSL https://fnm.vercel.app/install | bash" \
    "fnm (Fast Node Manager) installed successfully." \
    "Failed to install fnm."

# Add fnm to PATH
export PATH="$HOME/.fnm:$PATH"
eval "$(fnm env --use-on-cd)"

# Install lazygit via go
execute_command \
    "go install github.com/jesseduffield/lazygit@latest" \
    "lazygit installed successfully." \
    "Failed to install lazygit."

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