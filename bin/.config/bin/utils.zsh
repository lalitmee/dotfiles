#!/bin/zsh

set -e  # Exit on error
set -o pipefail  # Catch errors in piped commands

# Function to execute a command and handle errors
execute_command() {
    local cmd="$1"
    local success_msg="$2"
    local error_msg="$3"

    if eval "$cmd"; then
        gum_style "$success_msg"
    else
        gum_style "Error: $error_msg" >&2
        exit 1
    fi
}

# Function to verify if a package or command is installed
verify_installation() {
    local cmd_name="$1"

    if command -v "$cmd_name" >/dev/null 2>&1; then
        gum_style "$cmd_name is installed and available in PATH."
    elif dpkg -l | grep -i "$cmd_name"; then
        gum_style "$cmd_name package is installed but might not be available in PATH."
    else
        gum_style "Error: $cmd_name installation verification failed." >&2
        exit 1
    fi
}

# Function to check and install a dependency (like curl)
ensure_dependency() {
    local package="$1"

    if ! command -v "$package" >/dev/null 2>&1; then
        execute_command \
            "sudo apt install -y $package" \
            "$package installed successfully." \
            "Failed to install $package."
    else
        gum_style "$package is already installed."
    fi
}
