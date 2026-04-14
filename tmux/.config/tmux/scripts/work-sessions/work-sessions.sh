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

SCRIPT_DIR="${0:A:h}"
CONFIG_FILE="$SCRIPT_DIR/work-sessions.conf"

# Load configuration
load_config() {
    if [[ ! -f "$CONFIG_FILE" ]]; then
        echo "Error: Config file not found at $CONFIG_FILE"
        exit 1
    fi
    source "$CONFIG_FILE"
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
            local path_count=$(echo "$paths" | grep -v '^#' | grep -v '^$' | grep -c '.')
            echo "$i: $name ($path_count path(s))"
        fi
    done
    if [[ $count -eq 0 ]]; then
        echo "No presets configured. Edit $CONFIG_FILE"
    fi
}

# Get paths for a preset (returns expanded paths)
get_preset_paths() {
    local preset_num=$1
    local name_var="PRESET_${preset_num}_NAME"
    local paths_var="PRESET_${preset_num}_PATHS"
    local name="${(P)name_var}"
    local paths="${(P)paths_var}"
    
    if [[ -z "$name" ]]; then
        echo "Preset $preset_num not configured" >&2
        return 1
    fi
    
    echo "$paths" | grep -v '^#' | grep -v '^$' | while read -r path; do
        echo "${path/#~/$HOME}"
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
    local session_name="work/$(basename "$dir")"
    
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
    
    local paths=$(get_preset_paths "$preset_num")
    if [[ -z "$paths" ]]; then
        return 1
    fi
    
    # Build fzf command with multiple directory sources
    local fzf_sources=""
    local preview_cmd='echo {}; echo "---"; ls -la {} 2>/dev/null | head -10'
    
    while IFS= read -r path; do
        [[ -z "$path" ]] && continue
        [[ ! -d "$path" ]] && continue
        fzf_sources="$fzf_sources\n$path"
    done <<< "$paths"
    
    # If there's only one path, use it directly
    local single_path=$(echo "$paths" | grep -v '^$' | head -1)
    local only_path=""
    local path_count=0
    while IFS= read -r p; do
        [[ -z "$p" ]] && continue
        path_count=$((path_count + 1))
        only_path="$p"
    done <<< "$paths"
    
    local selected_dirs
    
    if [[ $path_count -eq 1 ]] && [[ -d "$only_path" ]]; then
        # Single directory - use simple picker
        selected_dirs=$(ls -1 "$only_path" 2>/dev/null | fzf \
            --multi \
            --prompt="Select repos: " \
            --height=~70% \
            --border \
            --preview="$preview_cmd" \
            --preview-window=right:40% \
            --bind='tab:select-all,btab:deselect-all')
    else
        # Multiple directories - need to show full paths
        selected_dirs=$(while IFS= read -r path; do
            [[ -z "$path" ]] && continue
            [[ ! -d "$path" ]] && continue
            ls -1 "$path" 2>/dev/null | while read -r repo; do
                echo "$path/$repo"
            done
        done <<< "$paths" | fzf \
            --multi \
            --prompt="Select repos: " \
            --height=~70% \
            --border \
            --preview="$preview_cmd" \
            --preview-window=right:40% \
            --bind='tab:select-all,btab:deselect-all')
    fi
    
    if [[ -z "$selected_dirs" ]]; then
        echo "No repos selected"
        return 1
    fi
    
    # Create sessions for selected repos
    local first_session=""
    local created_count=0
    
    if [[ $path_count -eq 1 ]]; then
        # Paths are relative to the single parent
        while IFS= read -r repo; do
            [[ -z "$repo" ]] && continue
            local full_path="$only_path/$repo"
            if [[ -d "$full_path" ]]; then
                local session_name="work/$repo"
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
        # Full paths provided
        while IFS= read -r full_path; do
            [[ -z "$full_path" ]] && continue
            if [[ -d "$full_path" ]]; then
                local session_name="work/$(basename "$full_path")"
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
    load_config
    
    local options=()
    local preset_nums=()
    for i in {1..9}; do
        local name_var="PRESET_${i}_NAME"
        local name="${(P)name_var}"
        if [[ -n "$name" ]]; then
            options+=("$i: $name")
            preset_nums+=("$i")
        fi
    done
    
    if [[ ${#options[@]} -eq 0 ]]; then
        echo "No presets configured. Edit $CONFIG_FILE"
        return 1
    fi
    
    local selected=$(printf '%s\n' "${options[@]}" | fzf --prompt="Select preset: " --height=~50% --border)
    
    if [[ -z "$selected" ]]; then
        return 1
    fi
    
    local preset_num="${selected%%:*}"
    open_preset "$preset_num"
}

# Kill work sessions (multi-select)
kill_work_session() {
    local sessions=$(tmux list-sessions -F '#{session_name}' 2>/dev/null | grep '^work/')
    if [[ -z "$sessions" ]]; then
        echo "No work sessions to kill"
        return 1
    fi
    
    local selected=$(echo "$sessions" | fzf \
        --multi \
        --prompt="Kill sessions (TAB to multi-select): " \
        --height=~50% \
        --border \
        --bind='tab:select-all,btab:deselect-all')
    
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
}

main "$@"
