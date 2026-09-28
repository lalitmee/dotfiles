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
# Worktree Picker {{{
# -------------------------------------------------------------------

get_worktree_list() { # {{{
    # Get worktree names from workmux list, stripping ANSI codes and header
    workmux list 2>/dev/null | sed 's/\x1b\[[0-9;]*m//g' | awk 'NF > 0 {print $1}' | grep -v '^$' | grep -v '^─' | grep -v '^BRANCH$'
} # }}}

pick_worktree() { # {{{
    local prompt="${1:-Select worktree}"
    local worktrees
    worktrees=$(get_worktree_list)

    if [[ -z "$worktrees" ]]; then
        style_message "No active worktrees found" "$COLOR_WARNING"
        log_message "no worktrees found"
        sleep 2
        exit 0
    fi

    local selection
    if command -v fzf > /dev/null 2>&1; then
        selection=$(echo "$worktrees" | fzf \
            --prompt "$prompt > " \
            --height "100%" \
            --layout reverse \
            --bind "change:first")
    else
        selection=$(echo "$worktrees" | gum filter \
            --header "$prompt" \
            --header.foreground "$COLOR_HEADER" \
            --indicator.foreground "$COLOR_ACCENT")
    fi

    if [[ -z "$selection" ]]; then
        log_message "worktree selection cancelled"
        exit 0
    fi

    echo "$selection"
} # }}}

# -------------------------------------------------------------------
# }}}
# -------------------------------------------------------------------

# -------------------------------------------------------------------
# Action Input Flows {{{
# -------------------------------------------------------------------

get_action_input() { # {{{
    local action="$1"
    local worktree_name=""
    local extra_input=""
    local cmd_args=()

    case "$action" in
        add)
            # Branch name via gum input
            extra_input=$(gum input \
                --placeholder "Enter branch name..." \
                --header "New Branch Name" \
                --header.foreground "$COLOR_HEADER" \
                --cursor.foreground "$COLOR_ACCENT")
            if [[ -z "$extra_input" ]]; then
                log_message "add: branch name input cancelled"
                exit 0
            fi
            cmd_args+=("$extra_input")
            ;;
        open|close|merge|rebase|remove|rename)
            worktree_name=$(pick_worktree "Select worktree to $action")
            if [[ -z "$worktree_name" ]]; then
                exit 0
            fi
            cmd_args+=("$worktree_name")
            # rename needs a new name too
            if [[ "$action" == "rename" ]]; then
                extra_input=$(gum input \
                    --placeholder "Enter new name..." \
                    --header "New Worktree Name" \
                    --header.foreground "$COLOR_HEADER" \
                    --cursor.foreground "$COLOR_ACCENT")
                if [[ -z "$extra_input" ]]; then
                    log_message "rename: new name input cancelled"
                    exit 0
                fi
                cmd_args+=("$extra_input")
            fi
            ;;
        send)
            worktree_name=$(pick_worktree "Select worktree to send prompt to")
            if [[ -z "$worktree_name" ]]; then
                exit 0
            fi
            cmd_args+=("$worktree_name")
            # Prompt text via gum write (multiline)
            extra_input=$(gum write \
                --placeholder "Type your prompt..." \
                --header "Prompt to Send" \
                --header.foreground "$COLOR_HEADER" \
                --char-limit 0 \
                --width 80)
            if [[ -z "$extra_input" ]]; then
                log_message "send: prompt text cancelled"
                exit 0
            fi
            cmd_args+=("$extra_input")
            ;;
        resurrect)
            # Confirmation only
            if ! gum confirm \
                --prompt.foreground "$COLOR_WARNING" \
                "Resurrect all crashed worktree windows?"; then
                log_message "resurrect: cancelled"
                exit 0
            fi
            cmd_args+=("__CONFIRMED__")
            ;;
        *)
            log_message "unknown action: $action"
            style_message "❌ Unknown action: $action" "$COLOR_DANGER"
            sleep 2
            exit 1
            ;;
    esac

    # Return the args as newline-separated values
    printf '%s\n' "${cmd_args[@]}"
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

    # Collect per-action input (worktree name, branch name, etc.)
    local -a cmd_args=()
    local line
    while IFS= read -r line; do
        [[ -n "$line" ]] && cmd_args+=("$line")
    done < <(get_action_input "$action")

    # Validate collected inputs; exit cleanly if cancelled
    case "$action" in
        add|open|close|merge|rebase|remove)
            if (( ${#cmd_args[@]} < 1 )); then
                exit 0
            fi
            ;;
        rename|send)
            if (( ${#cmd_args[@]} < 2 )); then
                exit 0
            fi
            ;;
        resurrect)
            if (( ${#cmd_args[@]} < 1 )); then
                exit 0
            fi
            cmd_args=()
            ;;
    esac

    # DEBUG: show constructed command and exit (will be replaced in Task 3)
    log_message "would run: workmux $action ${cmd_args[*]}"
    style_message "Action: workmux $action ${cmd_args[*]}" "$COLOR_INFO"
    sleep 2
} # }}}

main "$@"

# -------------------------------------------------------------------
# }}}
# -------------------------------------------------------------------
