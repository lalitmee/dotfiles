#!/usr/bin/env zsh

_worktree_manager_error() {
    print -u2 -r -- "worktree-manager: $*"
    return 1
}

# The selected path must still be a registered root in the selected repository.
# Sets dynamically scoped wm_action_flags and wm_action_status for callers.
_worktree_manager_validate() {
    emulate -L zsh
    local repo_root="${1:A}" worktree_path="${2:A}" scratch field common selected_common
    local -a fields
    _worktree_manager_is_root "$repo_root" || { _worktree_manager_error 'repository root is invalid'; return 1; }
    _worktree_manager_is_root "$worktree_path" || { _worktree_manager_error 'worktree is missing or invalid'; return 1; }
    common=$(git -C "$repo_root" rev-parse --path-format=absolute --git-common-dir) || return 1
    selected_common=$(git -C "$worktree_path" rev-parse --path-format=absolute --git-common-dir) || return 1
    [[ "${common:A}" == "${selected_common:A}" ]] || { _worktree_manager_error 'worktree belongs to another repository'; return 1; }
    scratch=$(mktemp "${TMPDIR:-/tmp}/worktree-action.XXXXXXXX") || return 1
    {
        git -C "$repo_root" worktree list --porcelain -z > "$scratch" || return 1
        while IFS= read -r -d '' field; do fields+=("$field"); done < <(parse_worktree_porcelain "$repo_root" "$scratch")
        local i
        for ((i=1; i<=${#fields}; i+=7)); do
            if [[ "${fields[i+3]:A}" == "$worktree_path" ]]; then
                wm_action_flags="${fields[i+5]}"
                wm_action_status=$(worktree_status "$worktree_path")
                [[ "$wm_action_status" == clean || "$wm_action_status" == dirty ]] || {
                    _worktree_manager_error 'worktree status cannot be determined'; return 1
                }
                return 0
            fi
        done
        _worktree_manager_error 'worktree is no longer registered'
    } always {
        rm -f -- "$scratch"
    }
}

open_worktree() {
    emulate -L zsh
    local worktree_path="${1:A}" repo_name="$2" branch="${3:-detached}" windows base name
    _worktree_manager_is_root "$worktree_path" || { _worktree_manager_error 'worktree is missing or invalid'; return 1; }
    windows=$(tmux list-windows -F '#{window_name}') || return 1
    base="$repo_name:$branch"
    # Keep names on one line even if repository names contain control characters.
    base="${base//$'\n'/ }"
    base="${base//$'\r'/ }"
    name="$base"
    local -a existing
    existing=("${(@f)windows}")
    local suffix=2
    while (( ${existing[(Ie)$name]} )); do
        name="$base-$suffix"
        (( suffix++ ))
    done
    tmux new-window -n "$name" -c "$worktree_path"
}

checkout_branch() {
    emulate -L zsh
    local repo_root="${1:A}" worktree_path="${2:A}" branch_ref="$3" create_tracking="${4:-0}"
    local wm_action_flags wm_action_status scratch field ref kind name occupied found=0
    local -a fields
    [[ "$create_tracking" == 0 || "$create_tracking" == 1 ]] || return 1
    _worktree_manager_validate "$repo_root" "$worktree_path" || return 1
    scratch=$(mktemp "${TMPDIR:-/tmp}/worktree-checkout.XXXXXXXX") || return 1
    {
        list_repository_branches "$repo_root" > "$scratch" || return 1
        while IFS= read -r -d '' field; do fields+=("$field"); done < "$scratch"
        local i
        for ((i=1; i<=${#fields}; i+=4)); do
            [[ "${fields[i]}" == "$branch_ref" ]] || continue
            found=1; kind="${fields[i+1]}"; name="${fields[i+2]}"; occupied="${fields[i+3]}"
            break
        done
        (( found )) || { _worktree_manager_error 'branch is no longer available'; return 1; }
        [[ -z "$occupied" || "$occupied" == "$worktree_path" ]] || {
            _worktree_manager_error "branch is checked out in $occupied"; return 1
        }
        if [[ "$kind" == remote ]]; then
            [[ "$create_tracking" == 1 ]] || { _worktree_manager_error 'tracking creation requires explicit selection'; return 1; }
            local local_name="${name#*/}"
            git -C "$repo_root" show-ref --verify --quiet "refs/heads/$local_name" && {
                _worktree_manager_error 'local branch already exists; select it instead'; return 1
            }
            git -C "$worktree_path" switch --track -c "$local_name" -- "$name"
        else
            git -C "$worktree_path" switch -- "$name"
        fi
    } always {
        rm -f -- "$scratch"
    }
}

rename_worktree() {
    emulate -L zsh
    local repo_root="${1:A}" worktree_path="${2:A}" destination="${3:A}"
    local wm_action_flags wm_action_status
    [[ -n "$3" ]] || { _worktree_manager_error 'destination is empty'; return 1; }
    _worktree_manager_validate "$repo_root" "$worktree_path" || return 1
    [[ ",$wm_action_flags," != *,main,* ]] || { _worktree_manager_error 'main worktree cannot be moved'; return 1; }
    [[ ! -e "$destination" && ! -L "$destination" ]] || { _worktree_manager_error 'destination already exists'; return 1; }
    git -C "$repo_root" worktree move -- "$worktree_path" "$destination"
}

remove_worktree() {
    emulate -L zsh
    local repo_root="${1:A}" worktree_path="${2:A}" force="${3:-0}"
    local wm_action_flags wm_action_status
    [[ "$force" == 0 || "$force" == 1 ]] || { _worktree_manager_error 'force requires the explicit confirmation token 1'; return 1; }
    _worktree_manager_validate "$repo_root" "$worktree_path" || return 1
    [[ ",$wm_action_flags," != *,main,* ]] || { _worktree_manager_error 'main worktree cannot be removed'; return 1; }
    [[ "$wm_action_status" == clean || "$force" == 1 ]] || { _worktree_manager_error 'dirty worktree requires separate force confirmation'; return 1; }
    local -a options
    [[ "$force" == 1 ]] && options+=(--force)
    git -C "$repo_root" worktree remove "${options[@]}" -- "$worktree_path"
}
