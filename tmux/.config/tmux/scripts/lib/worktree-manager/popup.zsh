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
    local rc=0
    case "$action" in
        checkout) manager_checkout "$@" || rc=$? ;;
        rename)   manager_mutation ctrl-r "$@" || rc=$? ;;
        remove)   manager_mutation ctrl-d "$@" || rc=$? ;;
        *) print -u2 -r -- "worktree-manager: unknown action: $action"; return 2 ;;
    esac
    (( rc == 0 )) && _worktree_popup_gum && gum style --foreground="$WM_SUCCESS" "✓ Done"
    return $rc
}
