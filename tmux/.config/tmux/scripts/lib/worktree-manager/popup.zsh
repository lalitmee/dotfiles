#!/usr/bin/env zsh

# Gum-backed popup surface for worktree actions. Invoked as
# `worktree-manager.sh __action <checkout|rename|remove> <repo> <path>`,
# normally inside `tmux display-popup -E`. Reuses the action functions in
# actions.zsh; only the confirmation/input/result layer is gum-styled.

typeset -g WM_ACCENT="#00AAFF"
typeset -g WM_HIGHLIGHT="#FFC600"
typeset -g WM_SUCCESS="#5fff00"
typeset -g WM_ERROR="#d70000"
typeset -g WM_SELECT_BG="#185294"

# Gate on stdin only: gum input is captured via $(...) so stdout is a pipe,
# but the TUI still renders to the tty and the value goes to stdout.
_worktree_popup_gum() {
    command -v gum >/dev/null 2>&1 && [[ -t 0 ]]
}

worktree_manager_terminal_geometry() {
    emulate -L zsh
    if [[ -n "${TMUX:-}" ]]; then
        tmux display-message -p '#{pane_width} #{pane_height}'
    else
        local cols lines
        cols=$(tput cols 2>/dev/null) || cols=${COLUMNS:-80}
        lines=$(tput lines 2>/dev/null) || lines=${LINES:-24}
        print -r -- "$cols $lines"
    fi
}

# Centered scan spinner with a rounded border; clears the pane before returning.
worktree_manager_run_scan_spinner() {
    emulate -L zsh
    local title="$1"; shift
    local cols lines box_width box_text box_height total_height pad_top margin_h full_title geometry rc=0

    if ! _worktree_popup_gum; then
        "$@" || return $?
        return 0
    fi

    geometry="$(worktree_manager_terminal_geometry)"
    cols="${geometry%% *}"
    lines="${geometry##* }"
    (( cols > 0 )) || cols=${COLUMNS:-80}
    (( lines > 0 )) || lines=${LINES:-24}

    box_width=72
    (( cols < box_width + 4 )) && box_width=$(( cols - 4 ))
    (( box_width < 48 )) && box_width=48

    box_text="$(gum style --border rounded --border-foreground "$WM_ACCENT" \
        --foreground "$WM_HIGHLIGHT" --padding '1 2' --width "$box_width" \
        --align center "$title")" || return 1

    box_height=$(printf '%s\n' "$box_text" | wc -l | tr -d ' ')
    # Spinner renders on the first title line; keep the bordered message on the next lines.
    total_height=$(( box_height + 1 ))
    pad_top=0
    (( lines > total_height )) && pad_top=$(( (lines - total_height) / 2 ))
    margin_h=0
    (( cols > box_width )) && margin_h=$(( (cols - box_width) / 2 ))
    full_title=$'\n'"$box_text"

    gum spin --spinner dot \
        --spinner.foreground="$WM_ACCENT" \
        --title "$full_title" \
        --padding "$pad_top 0 0 $margin_h" -- \
        "$@" || rc=$?

    [[ -t 1 ]] && clear
    return $rc
}

# Blocking notice surface. `__notice` runs inside a tmux popup; callers outside
# tmux fall back to the same text-and-key interaction in the current pane.
worktree_notice() {
    emulate -L zsh
    local level="$1" message="$2" color="$WM_ACCENT"
    local frame_width="${COLUMNS:-80}" frame_height=$((${LINES:-24} - 1)) text_height top_padding vertical_padding i
    local -a message_lines
    message_lines=("${(@f)message}")
    text_height=${#message_lines}
    (( frame_width > 0 )) || frame_width=80
    (( frame_height > 4 )) || frame_height=5
    top_padding=$(((frame_height - 4 - text_height) / 2))
    (( top_padding > 0 )) || top_padding=0
    for (( i=0; i<top_padding; i++ )); do vertical_padding+=$'\n'; done
    case "$level" in
        error) color="$WM_ERROR" ;;
        warning) color="$WM_HIGHLIGHT" ;;
        success) color="$WM_SUCCESS" ;;
    esac
    if _worktree_popup_gum; then
        gum style --border rounded --border-foreground "$color" \
            --foreground "$color" --padding '1 2' --width "$frame_width" \
            --height "$frame_height" --align center "${vertical_padding}${message}"
    else
        print -r -- "${level:u}: $message"
    fi
    print -n -r -- 'Press any key to continue...'
    read -u 0 -k 1 -s -r
    print
}

# Centered confirmation popup using gum style + gum confirm.
# Returns 0 on yes, 1 on no/cancel.
worktree_confirm() {
    emulate -L zsh
    local message="$1" affirmative="${2:-Yes}" negative="Cancel" color="$WM_HIGHLIGHT" rc=0
    local frame_width="${COLUMNS:-80}" frame_height=$((${LINES:-24} - 1))
    (( frame_width > 0 )) || frame_width=80
    (( frame_height > 4 )) || frame_height=5

    if _worktree_popup_gum; then
        # Use gum style for the centered message box, then gum confirm for input
        local styled_message
        styled_message=$(gum style --border rounded --border-foreground "$color" \
            --foreground "$color" --padding '1 2' --width "$frame_width" \
            --height "$frame_height" --align center "$message")
        gum confirm \
            --prompt.foreground="$WM_HIGHLIGHT" \
            --selected.foreground="#FFFFFF" --selected.background="$WM_SELECT_BG" \
            --unselected.foreground="#8a8a8a" \
            --affirmative="$affirmative" --negative="$negative" \
            "$styled_message" || rc=$?
    else
        print -r -- "$message"
        print -n -r -- "Type ${affirmative:-yes} to confirm: "
        local answer
        IFS= read -r answer || return 1
        [[ "$answer" == "${affirmative:-yes}" ]] || rc=1
    fi
    return $rc
}

manager_show_notice() {
    emulate -L zsh
    local level="$1" message="$2"
    tmux display-popup -E -w 80% -h 60% \
        "zsh ${(qq)WM_SELF} __notice ${(qq)level} ${(qq)message}" && return 0
    worktree_notice "$level" "$message"
}

# Absolute destination for a rename; echoes it on success, non-zero on cancel.
worktree_popup_destination() {
    emulate -L zsh
    local current="$1" destination
    if _worktree_popup_gum; then
        destination=$(gum-input input \
            --header="Rename worktree — new absolute path" \
            --prompt="Path: " \
            --placeholder="$current") || return 1
    else
        print -u2 -n -r -- 'Destination (absolute path; blank cancels): '
        IFS= read -r destination || return 1
    fi
    [[ "$destination" == /* ]] || return 1
    print -r -- "$destination"
}

# Entry point for `__action`. Returns 0 only when the worktree actually changed,
# so the picker refreshes on success and stays put on cancel/failure.
worktree_popup() {
    emulate -L zsh
    local action="$1"; shift
    local rc=0 message notice_level=error
    case "$action" in
        checkout) manager_checkout "$@" || rc=$? ;;
        rename)   manager_mutation ctrl-r "$@" || rc=$? ;;
        remove)   manager_mutation ctrl-d "$@" || rc=$? ;;
        *) print -u2 -r -- "worktree-manager: unknown action: $action"; return 2 ;;
    esac
    if (( rc == 0 )); then
        case "$action" in
            checkout) message='Checkout completed.' ;;
            rename) message='Worktree renamed.' ;;
            remove) message='Worktree removed.' ;;
        esac
    elif [[ -n "$feedback" ]]; then
        message="$feedback"
        [[ "$message" == 'No available branches.' ]] && notice_level=info
        worktree_notice "$notice_level" "$message"
    fi
    if (( rc == 0 )); then
        worktree_notice success "$message"
    fi
    return $rc
}

# Run deletion in its own window; notify the suspended manager picker to rescan
# after the user has seen the result and dismissed this window.
worktree_remove_job() {
    emulate -L zsh
    local repo="$1" selected="$2" force="$3" manager_window="$4" rc=0 message
    if _worktree_popup_gum; then
        gum spin --spinner dot --title "Removing ${selected:t}..." --show-output -- \
            zsh "$WM_SELF" __remove-action "$repo" "$selected" "$force" || rc=$?
    else
        print -r -- "Removing $selected..."
        remove_worktree "$repo" "$selected" "$force" || rc=$?
    fi
    if (( rc == 0 )); then
        message='Worktree deleted successfully.'
        worktree_notice success "$message"
    else
        message="Worktree deletion failed (exit $rc). Check the error above."
        worktree_notice error "$message"
    fi
    tmux send-keys -t "$manager_window" C-f
    return "$rc"
}

worktree_remove_action() {
    remove_worktree "$@"
}
