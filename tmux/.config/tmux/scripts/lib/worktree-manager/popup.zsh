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
    read -k 1 -s -r
    print
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
        destination=$(gum input \
            --header="Rename worktree — new absolute path" \
            --prompt="Path: " \
            --placeholder="$current" \
            --prompt.foreground="$WM_HIGHLIGHT" \
            --cursor.foreground="$WM_HIGHLIGHT") || return 1
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
    local repo="$1" selected="$2" force="$3" manager_window="$4" rc=0
    if _worktree_popup_gum; then
        gum spin --spinner dot --title "Removing ${selected:t}..." --show-output -- \
            zsh "$WM_SELF" __remove-action "$repo" "$selected" "$force" || rc=$?
    else
        print -r -- "Removing $selected..."
        remove_worktree "$repo" "$selected" "$force" || rc=$?
    fi
    if (( rc == 0 )); then
        print -r -- 'Worktree deleted successfully.'
    else
        print -u2 -r -- "Worktree deletion failed (exit $rc). Check the error above."
    fi
    print -n -r -- 'Press any key to close and refresh the manager...'
    read -k 1 -s -r
    print
    tmux send-keys -t "$manager_window" C-f
    return "$rc"
}

worktree_remove_action() {
    remove_worktree "$@"
}
