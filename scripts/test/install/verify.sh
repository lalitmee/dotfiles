#!/usr/bin/env bash

# Verification script to check if core CLI tools are installed.

echo "🔍 Verifying installation of core tools..."

# List of tools to check
tools_to_check=(
    "zsh"
    "tmux"
    "fzf"
    "rg"
    "bat"
    "lsd"
    "stow"
    "gum"
    "zoxide"
    "atuin"
    "wakatime"
    "nvim"
    "lazygit"
    "pre-commit"
)

all_found=true

for tool in "${tools_to_check[@]}"; do
    if command -v "$tool" &> /dev/null; then
        echo "✅ $tool found."
    else
        echo "❌ ERROR: $tool not found!"
        all_found=false
    fi
done

if [[ "$all_found" == "true" ]]; then
    echo "🎉 All core tools verified successfully."
    exit 0
else
    echo "🔥 Verification failed. Some tools are missing."
    exit 1
fi
