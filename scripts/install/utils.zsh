#!/bin/zsh

set -e  # Exit on error
set -o pipefail  # Catch errors in piped commands

# Function to style output using gum (if available) or echo as fallback
gum_style() {
    local message="$1"

    if command -v gum >/dev/null 2>&1; then
        echo "$message" | gum style --foreground 39
    else
        echo "$message"
    fi
}

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

# Function to detect Ubuntu/Debian version
detect_os_version() {
    if [[ -f /etc/os-release ]]; then
        . /etc/os-release
        if [[ "$ID" == "ubuntu" ]]; then
            echo "ubuntu_${VERSION_ID//./}"
        elif [[ "$ID" == "debian" ]]; then
            echo "debian_${VERSION_CODENAME}"
        else
            echo "unknown"
        fi
    else
        echo "unknown"
    fi
}

# Function to detect system architecture
detect_architecture() {
    local arch=$(uname -m)
    case $arch in
        x86_64)
            echo "amd64"
            ;;
        aarch64|arm64)
            echo "arm64"
            ;;
        *)
            echo "unknown"
            ;;
    esac
}

# Function to download a file and verify its SHA256 hash
# Usage: download_and_verify <url> <expected_hash> <output_path>
download_and_verify() {
    local url="$1"
    local expected_hash="$2"
    local output_path="$3"

    gum_style "Downloading and verifying $url..."

    if ! curl -fsSL "$url" -o "$output_path"; then
        gum_style "Error: Failed to download $url" >&2
        return 1
    fi

    local actual_hash=$(sha256sum "$output_path" | awk '{print $1}')
    if [[ "$actual_hash" != "$expected_hash" ]]; then
        gum_style "Error: SHA256 hash mismatch for $url" >&2
        gum_style "Expected: $expected_hash" >&2
        gum_style "Actual:   $actual_hash" >&2
        rm -f "$output_path"
        return 1
    fi

    gum_style "Verification successful."
    return 0
}

# Function to safely execute a downloaded script
# Usage: safe_execute_script <script_path> [args...]
safe_execute_script() {
    local script_path="$1"
    shift

    if [[ ! -f "$script_path" ]]; then
        gum_style "Error: Script not found at $script_path" >&2
        return 1
    fi

    # Make it executable if it's not
    chmod +x "$script_path"

    # Execute the script
    if ! "$script_path" "$@"; then
        gum_style "Error: Execution of $script_path failed" >&2
        return 1
    fi

    return 0
}
