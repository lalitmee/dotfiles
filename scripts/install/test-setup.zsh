#!/bin/zsh
# Test Setup Script
# Verifies that installations are working correctly

source "$(dirname "$0")/utils.zsh"

gum_style "🧪 Testing Installation Setup"
gum_style "Verifying that all components are working correctly..."

# Test function
test_command() {
    local cmd="$1"
    local description="$2"

    if command -v "$cmd" &> /dev/null; then
        gum_style "✅ $description: $cmd found"
        return 0
    else
        gum_style "❌ $description: $cmd not found"
        return 1
    fi
}

# Test i3 ecosystem
echo ""
gum_style "🏗️ Testing i3 Window Manager Ecosystem:"
test_command "i3" "i3 window manager"
test_command "i3run" "i3run (i3ass)"
test_command "i3viswiz" "i3viswiz (i3ass)"
test_command "i3flip" "i3flip (i3ass)"
test_command "sxhkd" "sxhkd hotkey daemon"
test_command "rofi" "rofi application launcher"
test_command "polybar" "polybar status bar"
test_command "picom" "picom compositor"
test_command "feh" "feh wallpaper setter"

# Test shell and terminal
echo ""
gum_style "🐚 Testing Shell & Terminal:"
test_command "zsh" "zsh shell"
test_command "tmux" "tmux terminal multiplexer"
test_command "ghostty" "ghostty terminal"
test_command "fzf" "fzf fuzzy finder"

# Test development tools
echo ""
gum_style "💻 Testing Development Tools:"
test_command "nvim" "neovim editor"
test_command "pyenv" "pyenv python manager"
test_command "rbenv" "rbenv ruby manager"
test_command "fnm" "fnm node manager"
test_command "lazygit" "lazygit TUI"

# Test productivity tools
echo ""
gum_style "⚡ Testing Productivity Tools:"
test_command "zoxide" "zoxide smart cd"
test_command "atuin" "atuin shell history"
test_command "sesh" "sesh session manager"
test_command "bat" "bat cat replacement"
test_command "lsd" "lsd ls replacement"
test_command "ripgrep" "ripgrep search tool"
test_command "stow" "stow dotfile manager"
test_command "gum" "gum TUI framework"

# Test desktop applications
echo ""
gum_style "🖥️ Testing Desktop Applications:"
test_command "brave-browser" "brave browser"
test_command "firefox" "firefox browser"
test_command "spotify" "spotify music player"

# Test utilities
echo ""
gum_style "🔧 Testing Utilities:"
test_command "flameshot" "flameshot screenshot tool"
test_command "ulauncher" "ulauncher application launcher"
test_command "blueman-manager" "blueman bluetooth manager"
test_command "thunar" "thunar file manager"
test_command "xpad" "xpad sticky notes"
test_command "cbatticon" "cbatticon battery tray"
test_command "unclutter" "unclutter mouse hider"
test_command "btop" "btop system monitor"
test_command "cmus" "cmus terminal music player"
test_command "playerctl" "playerctl media control"

# Test font installation
echo ""
gum_style "🔤 Testing Font Installation:"
if fc-list | grep -q "FiraCode"; then
    gum_style "✅ FiraCode font: installed"
else
    gum_style "❌ FiraCode font: not found"
fi

if fc-list | grep -q "JetBrains"; then
    gum_style "✅ JetBrains font: installed"
else
    gum_style "❌ JetBrains font: not found"
fi

# Test Python environments
echo ""
gum_style "🐍 Testing Python Environment:"
if pyenv versions &> /dev/null; then
    gum_style "✅ pyenv: working"
else
    gum_style "❌ pyenv: not working"
fi

# Test Node.js
echo ""
gum_style "📦 Testing Node.js Environment:"
if fnm list &> /dev/null; then
    gum_style "✅ fnm: working"
else
    gum_style "❌ fnm: not working"
fi

# Summary
echo ""
gum_style "📊 Installation Test Summary"
gum_style "=============================="
echo ""
echo "If you see mostly ✅ marks above, your installation is successful!"
echo "If you see ❌ marks, you may need to:"
echo "  1. Re-run the specific phase that failed"
echo "  2. Check system logs: journalctl -xe"
echo "  3. Verify internet connection"
echo "  4. Check disk space: df -h"
echo ""
gum_style "🎉 Test completed! Review the results above."