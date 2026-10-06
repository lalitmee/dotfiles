#!/usr/bin/env zsh

# -------------------------------------------------------------------
# Workmux Command Palette
# -------------------------------------------------------------------
# Interactive command palette for workmux lifecycle commands.
# Launched via tmux keybinding (C-a C-g x) in a temporary window.
#
# Requirements: workmux, gum
# Palette selector: set PALETTE_UI to "gum" or "fzf" below.
# fzf is required when PALETTE_UI is "fzf"; worktree selection auto-detects it.
# -------------------------------------------------------------------

# -------------------------------------------------------------------
# Configuration {{{
# -------------------------------------------------------------------

LOG_DIR="$HOME/.local/share/tmux/logs"
LOG_FILE="$LOG_DIR/workmux-palette.log"
PALETTE_UI="fzf" # Change to "fzf" to use fzf for the action palette.

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
        "add         Create new worktree + window"
        "pr          Checkout PR into new worktree"
        "open        Open existing worktree"
        "close       Close worktree window"
        "merge       Merge branch + cleanup"
        "rebase      Rebase onto base branch"
        "remove      Remove worktree + branch"
        "rename      Rename worktree/window/branch"
        "send        Send prompt to running agent"
        "resurrect   Restore crashed windows"
    )

    local selection
    case "$PALETTE_UI" in
        gum)
            selection=$(printf '%s\n' "${actions[@]}" | gum filter \
                --header "Workmux Command Palette" \
                --header.foreground "$COLOR_HEADER" \
                --indicator.foreground "$COLOR_ACCENT")
            ;;
        fzf)
            if ! command -v fzf > /dev/null 2>&1; then
                style_message "❌ Error: fzf is required when PALETTE_UI is fzf" "$COLOR_DANGER" >&2
                return 1
            fi
            selection=$(printf '%s\n' "${actions[@]}" | fzf \
                --prompt "Workmux Command Palette > " \
                --header "Select an action" \
                --height "100%" \
                --layout reverse \
                --bind "change:first")
            ;;
        *)
            style_message "❌ Error: PALETTE_UI must be \"gum\" or \"fzf\"" "$COLOR_DANGER" >&2
            return 1
            ;;
    esac

    if [[ -z "$selection" ]]; then
        log_message "action selection cancelled"
        exit 0
    fi

    # The command is the first field; descriptions start in a fixed column.
    echo "$selection" | awk '{print $1}'
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
        style_message "No active worktrees found" "$COLOR_WARNING" >&2
        log_message "no worktrees found"
        sleep 2 >&2
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
        pr)
            # PR number or full GitHub/GitLab URL
            extra_input=$(gum input \
                --placeholder "123 or https://github.com/owner/repo/pull/123" \
                --header "Checkout Pull Request" \
                --header.foreground "$COLOR_HEADER" \
                --cursor.foreground "$COLOR_ACCENT")
            if [[ -z "$extra_input" ]]; then
                log_message "pr: input cancelled"
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
            style_message "❌ Unknown action: $action" "$COLOR_DANGER" >&2
            sleep 2 >&2
            exit 1
            ;;
    esac

    # Return the args as null-separated values to preserve multiline strings
    if (( ${#cmd_args[@]} > 0 )); then
        printf '%s\0' "${cmd_args[@]}"
    fi
} # }}}

# -------------------------------------------------------------------
# }}}
# -------------------------------------------------------------------

# -------------------------------------------------------------------
# Flags Picker {{{
# -------------------------------------------------------------------

pick_flags() { # {{{
    local action="$1"
    local -a available_flags=()

    case "$action" in
        add)
            available_flags=(
                "--background"
                "--sandbox"
                "--prompt-editor"
                "--open-if-exists"
                "--with-changes"
                "--session"
                "--agent"
            )
            ;;
        merge)
            available_flags=(
                "--squash"
                "--rebase"
                "--keep"
                "--no-verify"
                "--cleanup"
                "--notification"
            )
            ;;
        remove)
            available_flags=(
                "--force"
                "--keep-branch"
                "--gone"
                "--all"
            )
            ;;
        open)
            available_flags=(
                "--run-hooks"
                "--force-files"
                "--new"
                "--continue"
                "--session"
            )
            ;;
        rename)
            available_flags=("--branch")
            ;;
        *)
            # No flags for close, rebase, send, resurrect, pr
            return
            ;;
    esac

    if (( ${#available_flags[@]} == 0 )); then
        return
    fi

    style_message "Optional flags (Enter to skip):" "$COLOR_DIMMED" >&2

    local selected_flags
    selected_flags=$(printf '%s\n' "${available_flags[@]}" | gum choose \
        --no-limit \
        --header "Select flags (optional)" \
        --header.foreground "$COLOR_HEADER" \
        --cursor.foreground "$COLOR_ACCENT" \
        --selected.foreground "$COLOR_INFO")

    if [[ -z "$selected_flags" ]]; then
        return
    fi

    local -a flags_array=()
    local flag
    while IFS= read -r flag; do
        [[ -n "$flag" ]] && flags_array+=("$flag")
    done <<< "$selected_flags"

    # Handle value-bearing flags: --agent needs a follow-up input
    local -a final_flags=()
    for flag in "${flags_array[@]}"; do
        if [[ "$flag" == "--agent" ]]; then
            local agent_name
            agent_name=$(gum input \
                --placeholder "e.g., opencode, claude, agy, pi" \
                --header "Agent name" \
                --header.foreground "$COLOR_HEADER" \
                --cursor.foreground "$COLOR_ACCENT")
            if [[ -n "$agent_name" ]]; then
                final_flags+=("--agent" "$agent_name")
            else
                log_message "pick_flags: agent name omitted"
            fi
        else
            final_flags+=("$flag")
        fi
    done

    if (( ${#final_flags[@]} > 0 )); then
        printf '%s\0' "${final_flags[@]}"
    fi
} # }}}

# -------------------------------------------------------------------
# }}}
# -------------------------------------------------------------------

# -------------------------------------------------------------------
# Execution {{{
# -------------------------------------------------------------------

execute_command() { # {{{
    local action="$1"
    shift
    local -a args=("$@")

    # "pr" is a palette alias for `workmux add --pr <input>`
    local wm_action="$action"
    local -a wm_args=("${args[@]}")
    if [[ "$action" == "pr" ]]; then
        wm_action="add"
        wm_args=("--pr" "${args[@]}")
    fi

    local full_cmd="workmux $wm_action"
    if (( ${#wm_args[@]} > 0 )); then
        full_cmd="workmux $wm_action ${wm_args[*]}"
    fi

    echo ""
    if command -v gum > /dev/null 2>&1; then
        local running_label
        running_label=$(gum style --foreground "$COLOR_ACCENT" --bold "Running:")
        local running_val
        running_val=$(gum style --foreground "$COLOR_HEADER" --bold "$full_cmd")
        echo "${running_label} ${running_val}"
        gum style --foreground "$COLOR_ACCENT" '───────────────────────────────────'
    else
        echo "Running: $full_cmd"
        echo "───────────────────────────────────"
    fi

    log_message "executing: $full_cmd"

    # Execute and capture exit code
    local exit_code
    workmux "$wm_action" "${wm_args[@]}"
    exit_code=$?

    return $exit_code
} # }}}

handle_result() { # {{{
    local exit_code="$1"

    echo ""
    if [[ "$exit_code" -eq 0 ]]; then
        style_message "✅ Command completed successfully" "$COLOR_SUCCESS"
        log_message "command succeeded"
        sleep 2
        # Return to the previous window before exiting
        tmux select-window -l 2>/dev/null || true
    else
        style_message "❌ Command failed with exit code $exit_code" "$COLOR_DANGER"
        log_message "command failed with exit code $exit_code"
        echo ""
        style_message "Press Ctrl-D or type 'exit' to close..." "$COLOR_DIMMED"
        exec /bin/zsh
    fi
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

    # Step 1: Pick the action
    local action
    action=$(pick_action)

    if [[ -z "$action" ]]; then
        log_message "no action selected"
        exit 0
    fi

    log_message "action selected: $action"

    # Step 2: Collect per-action input (worktree name, branch name, etc.)
    local -a cmd_args=()
    local arg
    while IFS= read -r -d '' arg; do
        [[ -n "$arg" ]] && cmd_args+=("$arg")
    done < <(get_action_input "$action")

    # Validate collected inputs; exit cleanly if cancelled
    case "$action" in
        add|pr|open|close|merge|rebase|remove)
            if (( ${#cmd_args[@]} < 1 )); then
                exit 0
            fi
            ;;
        rename)
            if (( ${#cmd_args[@]} < 2 )); then
                exit 0
            fi
            ;;
        send)
            if (( ${#cmd_args[@]} < 2 )); then
                exit 0
            fi
            # Defensive check: if prompt was split across lines, join all elements after worktree name
            if (( ${#cmd_args[@]} > 2 )); then
                local wt_name="${cmd_args[1]}"
                local prompt_text="${(F)cmd_args[2,-1]}"
                cmd_args=("$wt_name" "$prompt_text")
            fi
            ;;
        resurrect)
            if (( ${#cmd_args[@]} < 1 )); then
                exit 0
            fi
            cmd_args=()
            ;;
    esac

    # Step 3: Optional flags
    local -a flag_args=()
    while IFS= read -r -d '' arg; do
        [[ -n "$arg" ]] && flag_args+=("$arg")
    done < <(pick_flags "$action")

    # Combine: command args + flags
    local -a all_args=("${cmd_args[@]}" "${flag_args[@]}")

    if (( ${#all_args[@]} > 0 )); then
        log_message "full command: workmux $action ${all_args[*]}"
    else
        log_message "full command: workmux $action"
    fi

    # Step 4: Execute
    execute_command "$action" "${all_args[@]}"
    local exit_code=$?

    # Step 5: Handle result
    handle_result "$exit_code"
} # }}}

if [[ "${ZSH_EVAL_CONTEXT:-}" == toplevel ]]; then
    main "$@"
fi

# -------------------------------------------------------------------
# }}}
# -------------------------------------------------------------------
