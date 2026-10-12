#!/usr/bin/env zsh

worktree_create_picker() {
    emulate -L zsh
    local root field output id selected create_script name_width
    local -a roots fields repositories repository_names repository_paths repository_flags rows

    if (( $# )); then
        roots=("$@")
    else
        while IFS= read -r -d '' root; do roots+=("$root"); done < <(load_worktree_roots)
    fi
    (( ${#roots} )) || return 0
    while IFS= read -r -d '' field; do fields+=("$field"); done < <(discover_worktrees "${roots[@]}")
    local i
    for ((i=1; i+5<=${#fields}; i+=6)); do
        [[ ",${fields[i+5]}," == *,main,* && ",${fields[i+5]}," != *,prunable,* ]] || continue
        repositories+=("${fields[i]}")
        repository_names+=("$(manager_display "${fields[i+2]}")")
        repository_paths+=("$(manager_display "${fields[i]}")")
        repository_flags+=("${fields[i+5]}")
    done
    (( ${#repositories} )) || return 0
    name_width=$(printf '%s\n' "${repository_names[@]}" | wc -L)
    for ((i=1; i<=${#repositories}; i++)); do
        rows+=("$i"$'\t'"$(printf '%-*s  %s' "$name_width" "${repository_names[i]}" "${repository_paths[i]}")")
    done
    output=$(printf '%s\n' "${rows[@]}" | fzf --delimiter=$'\t' --with-nth=2.. \
        --header='Select a main worktree to create from' --no-multi) || return 0
    id="${output%%$'\t'*}"
    [[ "$id" == <-> ]] && (( id >= 1 && id <= ${#repositories} )) || return 0
    selected="${repositories[id]}"
    [[ ",${repository_flags[id]}," == *,main,* ]] || return 0
    local top_level common_dir git_dir
    top_level=$(git -C "$selected" rev-parse --show-toplevel 2>/dev/null) || return 0
    [[ "${top_level:A}" == "${selected:A}" ]] || return 0
    common_dir=$(git -C "$selected" rev-parse --path-format=absolute --git-common-dir 2>/dev/null) || return 0
    git_dir=$(git -C "$selected" rev-parse --absolute-git-dir 2>/dev/null) || return 0
    [[ "${common_dir:A}" == "${git_dir:A}" ]] || return 0
    create_script="${WORKTREE_MANAGER_CREATE_SCRIPT:-${WM_SELF:h}/git/git-worktree.sh}"
    cd -- "$selected" || return 1
    exec zsh "$create_script" create
}

manager_launch_create() {
    emulate -L zsh
    tmux new-window -n worktree-create -c "$HOME" "zsh ${(q)WM_SELF} __create"
}
