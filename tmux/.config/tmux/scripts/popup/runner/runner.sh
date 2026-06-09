#!/usr/bin/env -S zsh -i

# -------------------------------------------------------------------
# Prerequisites
# -------------------------------------------------------------------
# This script requires `jq`, `fzf`, and a package manager (`npm` or `yarn`).
# `gum` and `gum_style` are optional and only used for styled messages.
# -------------------------------------------------------------------

# -------------------------------------------------------------------
# Configuration
# -------------------------------------------------------------------

LOG_DIR="$HOME/.local/share/tmux/logs"
LOG_FILE="$LOG_DIR/runner.log"

# -------------------------------------------------------------------
# Helper Functions
# -------------------------------------------------------------------

log_message() {
    mkdir -p "$LOG_DIR" 2>/dev/null || return
    echo "$(date +'%Y-%m-%d %H:%M:%S') - $*" >> "$LOG_FILE" 2>/dev/null || true
}

append_to_path() {
    local dir="$1"

    if [[ -d "$dir" && ":$PATH:" != *":$dir:"* ]]; then
        export PATH="$dir:$PATH"
    fi
}

setup_environment() {
    if [[ -f /opt/homebrew/bin/brew ]]; then
        eval "$(/opt/homebrew/bin/brew shellenv)"
    elif [[ -f /usr/local/bin/brew ]]; then
        eval "$(/usr/local/bin/brew shellenv)"
    elif [[ -f "$HOME/.linuxbrew/bin/brew" ]]; then
        eval "$("$HOME/.linuxbrew/bin/brew" shellenv)"
    elif [[ -f /home/linuxbrew/.linuxbrew/bin/brew ]]; then
        eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
    fi

    append_to_path "$HOME/.local/bin"
    append_to_path "$HOME/.config/bin"
    append_to_path "$HOME/.fzf/bin"
    append_to_path "$HOME/.local/share/fnm"
    append_to_path "/opt/homebrew/bin"
    append_to_path "/opt/homebrew/sbin"
    append_to_path "/usr/local/bin"
    append_to_path "/usr/local/sbin"
    append_to_path "/home/linuxbrew/.linuxbrew/bin"

    rehash 2>/dev/null || true
}

style_message() {
    local message="$1"

    if command -v gum_style >/dev/null 2>&1; then
        gum_style "$message"
    elif command -v gum >/dev/null 2>&1; then
        echo "$message" | gum style --foreground 39
    else
        echo "$message"
    fi
}

log_command_paths() {
    local cmd
    local resolved

    log_message "PATH=$PATH"

    for cmd in tmux jq fzf gum gum_style node npm yarn fnm; do
        resolved="$(command -v "$cmd" 2>/dev/null || true)"
        log_message "$cmd=${resolved:-missing}"
    done
}

ensure_required_commands() {
    local missing=()
    local cmd

    for cmd in tmux jq fzf; do
        if ! command -v "$cmd" >/dev/null 2>&1; then
            missing+=("$cmd")
        fi
    done

    if (( ${#missing[@]} > 0 )); then
        log_message "missing required commands: ${missing[*]}"
        style_message "Error: Missing required command(s): ${missing[*]}"
        sleep 2
        exit 1
    fi
}

create_command_script() {
    local temp_script
    local current_pane_path_literal
    local command_to_run_literal

    temp_script="$(mktemp /tmp/tmux-runner.XXXXXX)"
    current_pane_path_literal="$(printf "%q" "$current_pane_path")"
    command_to_run_literal="$(printf "%q" "$command_to_run")"

    cat > "$temp_script" <<EOF
tmux setw allow-rename off 2>/dev/null
trap 'echo ""; echo "Process interrupted. Press Enter to close the window."; read; exit' INT

current_pane_path=$current_pane_path_literal
command_to_run=$command_to_run_literal

echo "Running: \$command_to_run"
echo "Directory: \$current_pane_path"
echo "───────────────────────────────────"
cd -- "\$current_pane_path"
eval "\$command_to_run"
exit_code=\$?

if [[ \$exit_code -eq 0 ]]; then
    echo ""
    echo "✅ Command completed successfully"
elif [[ \$exit_code -eq 130 ]]; then
    echo ""
    echo "⚠️  Command was interrupted"
else
    echo ""
    echo "❌ Command failed with exit code \$exit_code"
fi
echo ""
echo "Press Ctrl-D or 'exit' to close this window..."
exec /bin/zsh
EOF

    echo "$temp_script"
}

run_command_in_current_window() {
    local temp_script="$1"

    log_message "reusing runner window for command: $command_to_run"
    tmux rename-window "$clean_name" 2>/dev/null || true
    exec /bin/zsh "$temp_script"
}

run_command_in_new_window() {
    local temp_script="$1"
    local temp_script_literal

    temp_script_literal="$(printf "%q" "$temp_script")"
    log_message "spawning command window: $clean_name"
    tmux new-window -n "$clean_name" -c "$current_pane_path" /bin/zsh -lic "exec /bin/zsh $temp_script_literal"
}

# -------------------------------------------------------------------
# Script Logic
# -------------------------------------------------------------------

setup_environment
log_message "launch mode reuse=${RUNNER_REUSE_WINDOW:-0}"
log_command_paths

if [[ -z "$TMUX" ]]; then
    style_message "❌ Error: This script must be run inside a tmux session."
    exit 1
fi

ensure_required_commands

current_pane_path="${1:-$(tmux display-message -p '#{pane_current_path}' 2>/dev/null || pwd)}"
package_json_path="$current_pane_path/package.json"

if [[ ! -f "$package_json_path" ]]; then
    log_message "package.json not found in $current_pane_path"
    style_message "❌ Error: package.json not found in $current_pane_path"
    sleep 2
    exit 1
fi
export package_json_path current_pane_path

SCRIPT_DIR="${0:A:h}"
source "$SCRIPT_DIR/functions.sh"

available_scripts="$(get_all_scripts)"

if [[ -z "$available_scripts" ]]; then
    log_message "no supported package manager found"
    style_message "❌ Error: npm or yarn not found in PATH"
    sleep 2
    exit 1
fi

selection=$(print -r -- "$available_scripts" | fzf --prompt="Select a script to run > " --height="100%" --layout=reverse --print-query)

if [[ -z $selection ]]; then
    log_message "selection cancelled"
    exit 0
fi

query=$(echo "$selection" | head -n 1)
command_to_run=$(echo "$selection" | tail -n 1)

if [[ -z $command_to_run && -n $query ]]; then
    command_to_run=$query
fi

if [[ -z "$command_to_run" ]]; then
    log_message "empty command selection"
    exit 0
fi

clean_name="${command_to_run// /-}"

log_message "selected command: $command_to_run"
temp_script="$(create_command_script)"

if [[ "$RUNNER_REUSE_WINDOW" == "1" ]]; then
    run_command_in_current_window "$temp_script"
else
    run_command_in_new_window "$temp_script"
fi
# -------------------------------------------------------------------
