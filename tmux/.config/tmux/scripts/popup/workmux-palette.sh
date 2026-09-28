#!/usr/bin/env zsh

# -------------------------------------------------------------------
# Workmux Command Palette
# -------------------------------------------------------------------
# Interactive command palette for workmux lifecycle commands.
# Launched via tmux keybinding (C-a C-g x) in a temporary window.
#
# Requirements: workmux, gum
# Optional: fzf (falls back to gum filter)
# -------------------------------------------------------------------

# -------------------------------------------------------------------
# Configuration {{{
# -------------------------------------------------------------------

LOG_DIR="$HOME/.local/share/tmux/logs"
LOG_FILE="$LOG_DIR/workmux-palette.log"

# Cobalt2 palette
COLOR_ACCENT="#00AAFF"
COLOR_HEADER="#FFC600"
COLOR_SUCCESS="#3AD900"
COLOR_DANGER="#FF0000"
COLOR_WARNING="#FFC600"
COLOR_INFO="#80FCFF"
COLOR_DIMMED="#808080"

# -------------------------------------------------------------------
# }}}
# -------------------------------------------------------------------

# -------------------------------------------------------------------
# Helper Functions {{{
# -------------------------------------------------------------------

log_message() { # {{{
    mkdir -p "$LOG_DIR" 2>/dev/null || return
    echo "$(date +'%Y-%m-%d %H:%M:%S') - $*" >> "$LOG_FILE" 2>/dev/null || true
} # }}}

append_to_path() { # {{{
    local dir="$1"

    if [[ -d "$dir" && ":$PATH:" != *":$dir:"* ]]; then
        export PATH="$dir:$PATH"
    fi
} # }}}

setup_environment() { # {{{
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
    append_to_path "$HOME/.local/share/fnm/aliases/default/bin"
    append_to_path "/opt/homebrew/bin"
    append_to_path "/opt/homebrew/sbin"
    append_to_path "/usr/local/bin"
    append_to_path "/usr/local/sbin"
    append_to_path "/home/linuxbrew/.linuxbrew/bin"
    append_to_path "$HOME/.cargo/bin"

    rehash 2>/dev/null || true
} # }}}

style_message() { # {{{
    local message="$1"
    local color="${2:-$COLOR_ACCENT}"

    if command -v gum > /dev/null 2>&1; then
        echo "$message" | gum style --foreground "$color"
    else
        echo "$message"
    fi
} # }}}

style_header() { # {{{
    local message="$1"

    if command -v gum > /dev/null 2>&1; then
        gum style \
            --foreground "$COLOR_HEADER" \
            --bold \
            --border rounded \
            --border-foreground "$COLOR_ACCENT" \
            --padding "0 2" \
            --margin "1 0" \
            "$message"
    else
        echo "=== $message ==="
    fi
} # }}}

ensure_required_commands() { # {{{
    local missing=()
    local cmd

    for cmd in workmux gum; do
        if ! command -v "$cmd" > /dev/null 2>&1; then
            missing+=("$cmd")
        fi
    done

    if (( ${#missing[@]} > 0 )); then
        log_message "missing required commands: ${missing[*]}"
        style_message "❌ Error: Missing required command(s): ${missing[*]}" "$COLOR_DANGER"
        sleep 2
        exit 1
    fi
} # }}}

# -------------------------------------------------------------------
# }}}
# -------------------------------------------------------------------

# -------------------------------------------------------------------
# Action Menu {{{
# -------------------------------------------------------------------

pick_action() { # {{{
    local actions=(
        "➕  add        Create new worktree + window"
        "📂  open       Open existing worktree"
        "🚪  close      Close worktree window"
        "🔀  merge      Merge branch + cleanup"
        "🔄  rebase     Rebase onto base branch"
        "🗑️   remove     Remove worktree + branch"
        "✏️   rename     Rename worktree/window/branch"
        "💬  send       Send prompt to running agent"
        "🔮  resurrect  Restore crashed windows"
    )

    local selection
    selection=$(printf '%s\n' "${actions[@]}" | gum choose \
        --header "Workmux Command Palette" \
        --header.foreground "$COLOR_HEADER" \
        --cursor.foreground "$COLOR_ACCENT" \
        --selected.foreground "$COLOR_INFO")

    if [[ -z "$selection" ]]; then
        log_message "action selection cancelled"
        exit 0
    fi

    # Extract the command name (second field)
    echo "$selection" | awk '{print $2}'
} # }}}

# -------------------------------------------------------------------
# }}}
# -------------------------------------------------------------------

# -------------------------------------------------------------------
# Main {{{
# -------------------------------------------------------------------

main() { # {{{
    setup_environment
    ensure_required_commands

    log_message "palette launched"

    style_header "🚀 Workmux Command Palette"

    local action
    action=$(pick_action)

    if [[ -z "$action" ]]; then
        log_message "no action selected"
        exit 0
    fi

    log_message "action selected: $action"

    # DEBUG: show selected action and exit (will be replaced in Task 2)
    style_message "Selected action: $action" "$COLOR_INFO"
    sleep 1
} # }}}

main "$@"

# -------------------------------------------------------------------
# }}}
# -------------------------------------------------------------------
