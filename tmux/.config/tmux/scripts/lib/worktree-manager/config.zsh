#!/usr/bin/env zsh

worktree_manager_config_path() {
    print -r -- "${XDG_CONFIG_HOME:-$HOME/.config}/worktree-manager/roots"
}

load_worktree_roots() {
    emulate -L zsh
    local config_path="${1:-$(worktree_manager_config_path)}" root canonical line
    local -A seen

    if [[ ! -e "$config_path" ]]; then
        root="$HOME/Projects"
        if [[ -d "$root" && -r "$root" && -x "$root" ]]; then
            printf '%s\0' "${root:A}"
        else
            print -u2 -r -- "worktree-manager: $root: default root is missing or unreadable"
        fi
        return 0
    fi
    if [[ ! -f "$config_path" || ! -r "$config_path" ]]; then
        print -u2 -r -- "worktree-manager: $config_path: config is not a readable file"
        return 0
    fi

    while IFS= read -r line || [[ -n "$line" ]]; do
        line="${line##[[:space:]]#}"
        line="${line%%[[:space:]]#}"
        [[ -z "$line" || "$line" == \#* ]] && continue
        case "$line" in
            '~') root="$HOME" ;;
            '~/'*) root="$HOME/${line#\~/}" ;;
            /*) root="$line" ;;
            *) root="$HOME/$line" ;;
        esac
        if [[ ! -d "$root" || ! -r "$root" || ! -x "$root" ]]; then
            print -u2 -r -- "worktree-manager: $root: scan root is missing or unreadable"
            continue
        fi
        canonical="${root:A}"
        [[ -n "${seen[$canonical]:-}" ]] && continue
        seen[$canonical]=1
        printf '%s\0' "$canonical"
    done < "$config_path"
}
