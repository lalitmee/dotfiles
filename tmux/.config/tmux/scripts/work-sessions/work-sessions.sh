#!/usr/bin/env zsh

# ============================================================================
# WORK-SESSIONS.SH - Multi-Presets Tmux Session Launcher
# ============================================================================
# Open multiple tmux sessions at once from parent directories
#
# Usage:
#   work-sessions.sh                  # Interactive preset picker
#   work-sessions.sh <preset_num>     # Open preset directly (1-9)
#   work-sessions.sh --list           # List all presets
#   work-sessions.sh --help           # Show help

# Debug logging (file only, not to popup)
DEBUG_LOG="/tmp/work-sessions-debug.log"
debug_log() {
    echo "$*" >> "$DEBUG_LOG"
}

# Start debug
debug_log "=== Script started: args=$@"
debug_log "=== PWD=$PWD"
debug_log "=== 0=$0"

# Resolve SCRIPT_DIR using dirname (more reliable in tmux popup)
if [[ -L "$0" ]]; then
    SCRIPT_DIR="$(cd "$(dirname "$(readlink -f "$0")")" && pwd)"
else
    SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
fi
debug_log "SCRIPT_DIR=$SCRIPT_DIR"

CONFIG_FILE="$SCRIPT_DIR/work-sessions.conf"
debug_log "CONFIG_FILE=$CONFIG_FILE"

# Load configuration
load_config() {
    debug_log "load_config: Checking config file..."
    if [[ ! -f "$CONFIG_FILE" ]]; then
        echo "Error: Config file not found at $CONFIG_FILE"
        debug_log "load_config: ERROR - Config file not found"
        exit 1
    fi
    debug_log "load_config: Sourcing $CONFIG_FILE"
    source "$CONFIG_FILE"
    debug_log "load_config: Config loaded successfully"
}

# List all available presets
list_presets() {
    load_config
    local count=0
    for i in {1..9}; do
        local name_var="PRESET_${i}_NAME"
        local paths_var="PRESET_${i}_PATHS"
        local name="${(P)name_var}"
        local paths="${(P)paths_var}"
        if [[ -n "$name" ]]; then
            count=$((count + 1))
            if [[ "$paths" == *"__FILE__"* ]]; then
                echo "$i: $name (file-based: ~/.work-sessions/${i}.txt)"
            else
                local path_count=$(echo "$paths" | grep -v '^#' | grep -v '^$' | grep -c '.')
                echo "$i: $name ($path_count path(s))"
            fi
        fi
    done
    if [[ $count -eq 0 ]]; then
        echo "No presets configured. Edit $CONFIG_FILE"
    fi
}

# Get paths for a preset (returns expanded paths)
# Sets IS_FILE_BASED=1 if preset uses file-based approach
get_preset_paths() {
    local preset_num=$1
    debug_log "get_preset_paths: preset_num=$preset_num"

    local name_var="PRESET_${preset_num}_NAME"
    local paths_var="PRESET_${preset_num}_PATHS"
    local name="${(P)name_var}"
    local paths="${(P)paths_var}"

    debug_log "get_preset_paths: name=$name"
    debug_log "get_preset_paths: raw paths=$paths"

    if [[ -z "$name" ]]; then
        echo "Preset $preset_num not configured" >&2
        debug_log "get_preset_paths: ERROR - Preset $preset_num not configured"
        return 1
    fi

    # Check for __FILE__ marker - read paths from text file
    if [[ "$paths" == *"__FILE__"* ]]; then
        debug_log "get_preset_paths: __FILE__ marker detected, reading from text file"
        local file_path="$HOME/.work-sessions/${preset_num}.txt"
        if [[ ! -f "$file_path" ]]; then
            echo "Error: File not found at $file_path" >&2
            debug_log "get_preset_paths: ERROR - File not found: $file_path"
            return 1
        fi
        while IFS= read -r path; do
            # Skip comments and empty lines
            [[ "$path" =~ ^[[:space:]]*# ]] && continue
            [[ -z "${path// }" ]] && continue
            # Trim whitespace
            path="${path#"${path%%[![:space:]]*}"}"
            path="${path%"${path##*[![:space:]]}"}"
            [[ -z "$path" ]] && continue
            debug_log "get_preset_paths: file path='$path'"
            echo "$path"
        done < "$file_path"
        return 0
    fi

    debug_log "get_preset_paths: Expanding paths..."
    echo "$paths" | grep -v '^#' | grep -v '^$' | tr -d '\r' | while IFS= read -r path; do
        # Trim leading/trailing whitespace
        path="${path#"${path%%[![:space:]]*}"}"
        path="${path%"${path##*[![:space:]]}"}"
        # Skip if empty
        [[ -z "$path" ]] && continue
        # Expand ~ to $HOME
        local expanded="${path/#\~/$HOME}"
        debug_log "get_preset_paths: path='$path' expanded='$expanded'"
        echo "$expanded"
    done
}

# Count repos in paths
count_repos() {
    local total=0
    while IFS= read -r path; do
        [[ -z "$path" ]] && continue
        [[ ! -d "$path" ]] && continue
        local count=$(ls -1 "$path" 2>/dev/null | wc -l)
        total=$((total + count))
    done
    echo $total
}

# Create a tmux session for a directory
create_session() {
    local dir="$1"
    local session_name="$(basename "$dir")"

    if [[ ! -d "$dir" ]]; then
        return 1
    fi

    if tmux has-session -t "$session_name" 2>/dev/null; then
        return 0
    fi

    tmux new-session -ds "$session_name" -c "$dir" 2>/dev/null
    return 0
}

# Open a preset - show fzf picker and create sessions
open_preset() {
    local preset_num=$1
    debug_log "open_preset: called with preset_num=$preset_num"

    debug_log "open_preset: Loading config..."
    load_config

    # Check for __FILE__ marker directly (before subshell call)
    local paths_var="PRESET_${preset_num}_PATHS"
    local raw_paths="${(P)paths_var}"

    # Reset file-based flag based on marker
    if [[ "$raw_paths" == *"__FILE__"* ]]; then
        IS_FILE_BASED=1
        debug_log "open_preset: File-based preset detected"
    else
        IS_FILE_BASED=0
        debug_log "open_preset: Parent-based preset"
    fi

    local paths=$(get_preset_paths "$preset_num")
    debug_log "open_preset: got paths=$paths"
    debug_log "open_preset: IS_FILE_BASED=$IS_FILE_BASED"

    if [[ -z "$paths" ]]; then
        debug_log "open_preset: ERROR - paths is empty"
        echo "Error: Could not load preset $preset_num"
        read -p "Press Enter to close..."
        return 1
    fi

    debug_log "open_preset: About to count paths..."

    # Filter to only actual paths (not debug lines)
    local valid_paths=""
    local only_path=""
    local path_count=0

    while IFS= read -r p; do
        # Skip empty lines and debug log lines
        [[ -z "$p" ]] && continue
        [[ "$p" == \[* ]] && continue  # Skip debug log lines starting with [
        path_count=$((path_count + 1))
        only_path="$p"
        valid_paths="$valid_paths"$'\n'"$p"
    done <<< "$paths"

    debug_log "open_preset: path_count=$path_count, only_path=$only_path"

    local selected_dirs=""

    # File-based mode: no fzf picker, use all paths directly
    if [[ "$IS_FILE_BASED" == "1" ]]; then
        debug_log "open_preset: File-based mode - using all paths directly (no fzf)"
        selected_dirs="$valid_paths"
    else
        # Parent-based mode: show fzf picker
        local preview_cmd='echo {}; echo "---"; ls -la {} 2>/dev/null | head -10'

        if [[ $path_count -eq 1 ]] && [[ -d "$only_path" ]]; then
            # Single parent mode: list repos inside parent
            debug_log "open_preset: Single path mode, launching fzf in $only_path"
            selected_dirs=$(ls -1 "$only_path" 2>/dev/null | fzf \
                --cycle \
                --multi \
                --prompt="Select repos (TAB to toggle): ")
        else
            # Multiple parents mode: list repos from multiple parents
            debug_log "open_preset: Multiple paths mode, launching fzf"
            selected_dirs=$(while IFS= read -r path; do
                [[ -z "$path" ]] && continue
                [[ "$path" == \[* ]] && continue  # Skip debug lines
                [[ ! -d "$path" ]] && continue
                ls -1 "$path" 2>/dev/null | while read -r repo; do
                    echo "$path/$repo"
                done
            done <<< "$valid_paths" | fzf \
                --cycle \
                --multi \
                --prompt="Select repos (TAB to toggle): " \
                --height=~70% \
                --preview="$preview_cmd" \
                --preview-window=right:40%)
        fi
    fi

    debug_log "open_preset: fzf returned selected_dirs=$selected_dirs"

    if [[ -z "$selected_dirs" ]]; then
        debug_log "open_preset: No repos selected, exiting"
        echo "No repos selected"
        read -p "Press Enter to close..."
        return 1
    fi

    # Create sessions for selected repos
    local first_session=""
    local created_count=0

    # File-based mode or multi-parent mode: paths are full paths
    if [[ "$IS_FILE_BASED" == "1" ]] || [[ $path_count -gt 1 ]]; then
        debug_log "open_preset: Creating sessions from full paths"
        while IFS= read -r full_path; do
            [[ -z "$full_path" ]] && continue
            [[ "$full_path" == \[* ]] && continue  # Skip debug lines
            # Expand ~ if present
            full_path="${full_path/#\~/$HOME}"
            if [[ -d "$full_path" ]]; then
                local session_name="$(basename "$full_path")"
                if tmux has-session -t "$session_name" 2>/dev/null; then
                    echo "Skipping (exists): $session_name"
                else
                    if tmux new-session -ds "$session_name" -c "$full_path" 2>/dev/null; then
                        echo "Created: $session_name"
                        created_count=$((created_count + 1))
                    fi
                fi
                if [[ -z "$first_session" ]]; then
                    first_session="$session_name"
                fi
            fi
        done <<< "$selected_dirs"
    else
        # Single parent mode: paths are relative to parent
        debug_log "open_preset: Creating sessions from relative paths"
        while IFS= read -r repo; do
            [[ -z "$repo" ]] && continue
            [[ "$repo" == \[* ]] && continue  # Skip debug lines
            local full_path="$only_path/$repo"
            if [[ -d "$full_path" ]]; then
                local session_name="$repo"
                if tmux has-session -t "$session_name" 2>/dev/null; then
                    echo "Skipping (exists): $session_name"
                else
                    if tmux new-session -ds "$session_name" -c "$full_path" 2>/dev/null; then
                        echo "Created: $session_name"
                        created_count=$((created_count + 1))
                    fi
                fi
                if [[ -z "$first_session" ]]; then
                    first_session="$session_name"
                fi
            fi
        done <<< "$selected_dirs"
    fi

    if [[ -n "$first_session" ]]; then
        echo "Switching to: $first_session"
        tmux switch-client -t "$first_session"
    fi

    echo "Done. Created $created_count session(s)"
}

# Interactive preset picker using fzf
pick_preset() {
    debug_log "pick_preset: Loading config..."
    load_config

    debug_log "pick_preset: Building options list..."
    local options=()
    local preset_nums=()
    for i in {1..9}; do
        local name_var="PRESET_${i}_NAME"
        local name="${(P)name_var}"
        debug_log "pick_preset: Checking preset $i, name=$name"
        if [[ -n "$name" ]]; then
            options+=("$i: $name")
            preset_nums+=("$i")
        fi
    done

    debug_log "pick_preset: options count=${#options[@]}"

    if [[ ${#options[@]} -eq 0 ]]; then
        debug_log "pick_preset: ERROR - No presets configured"
        echo "No presets configured. Edit $CONFIG_FILE"
        return 1
    fi

    debug_log "pick_preset: Launching fzf preset picker..."
    local selected=$(printf '%s\n' "${options[@]}" | fzf --prompt="Select preset: " \
        --cycle \
        --height=~50% \
    )

    debug_log "pick_preset: fzf returned selected=$selected"

    if [[ -z "$selected" ]]; then
        debug_log "pick_preset: No preset selected"
        return 1
    fi

    local preset_num="${selected%%:*}"
    debug_log "pick_preset: Calling open_preset with preset_num=$preset_num"
    open_preset "$preset_num"
}

# Kill work sessions (multi-select)
kill_work_session() {
    local sessions=$(tmux list-sessions -F '#{session_name}' 2>/dev/null)
    if [[ -z "$sessions" ]]; then
        echo "No sessions to kill"
        return 1
    fi

    local selected=$(echo "$sessions" | fzf \
        --cycle \
        --multi \
        --prompt="Kill sessions (TAB to toggle): " \
        --height=~50%)

    if [[ -z "$selected" ]]; then
        return 1
    fi

    local killed_count=0
    while IFS= read -r session; do
        [[ -z "$session" ]] && continue
        tmux kill-session -t "$session" 2>/dev/null
        echo "Killed: $session"
        killed_count=$((killed_count + 1))
    done <<< "$selected"

    echo "Done. Killed $killed_count session(s)"
}

# Show help
show_help() {
    cat << 'EOF'
Work Sessions - Multi-Presets Tmux Session Launcher

USAGE:
    work-sessions <command|preset>

COMMANDS:
    work-sessions.sh              Open interactive preset picker
    work-sessions.sh <1-9>       Open preset directly
    work-sessions.sh --list       List all presets
    work-sessions.sh --help       Show this help

CONFIG:
    Edit: ~/.config/tmux/scripts/work-sessions/work-sessions.conf

EXAMPLES:
    work-sessions.sh 1           # Open preset 1 (shows fzf picker)
    work-sessions.sh --list      # List configured presets

NOTES:
    - Config stores PARENT directories, not individual repos
    - When opening a preset, fzf picker appears to select repos
    - Multiple paths per preset are supported
EOF
}

# Main
main() {
    local cmd="${1:-}"
    debug_log "main: cmd=$cmd"

    case "$cmd" in
        --help|-h)
            show_help
            ;;
        --list|-l)
            list_presets
            ;;
        --kill|-k)
            kill_work_session
            ;;
        [1-9])
            open_preset "$cmd"
            ;;
        *)
            if [[ -n "$cmd" ]]; then
                echo "Unknown command: $cmd"
                show_help
                exit 1
            fi
            pick_preset
            ;;
    esac

    debug_log "main: Script completed, keeping popup open for debugging..."
    echo ""
    echo "=== Debug log: /tmp/work-sessions-debug.log ==="
    echo "Press Enter to close..."
    read -r
    debug_log "main: Script exiting"
}

debug_log "Calling main..."
main "$@"
debug_log "main returned"
