#!/usr/bin/env zsh

set -euo pipefail

# Interactive git stash utility using gum or fzf

is_in_git_repo() {
    git rev-parse HEAD > /dev/null 2>&1
}

stash_preview() {
    git stash show -p "$1" 2>/dev/null | head -200
}

stash_list_gum() {
    git stash list |
        gum choose --header "Select stash:"
}

stash_list_fzf() {
    git stash list |
        fzf --height 50% --border --prompt="Select stash: " \
            --preview 'git stash show -p {} | head -200'
}

apply_stash_gum() {
    local stash
    stash=$(stash_list_gum)
    if [[ -n "$stash" ]]; then
        local stash_ref
        stash_ref=$(echo "$stash" | cut -d: -f1)
        if gum confirm "Apply stash ${stash_ref}?"; then
            git stash pop "$stash_ref"
        fi
    fi
}

apply_stash_fzf() {
    local stash
    stash=$(stash_list_fzf)
    if [[ -n "$stash" ]]; then
        local stash_ref
        stash_ref=$(echo "$stash" | cut -d: -f1)
        read "CONFIRM?Apply stash ${stash_ref}? [y/N] "
        if [[ "$CONFIRM" =~ ^[Yy]$ ]]; then
            git stash pop "$stash_ref"
        fi
    fi
}

drop_stash_gum() {
    local stash
    stash=$(stash_list_gum)
    if [[ -n "$stash" ]]; then
        local stash_ref
        stash_ref=$(echo "$stash" | cut -d: -f1)
        if gum confirm "Drop stash ${stash_ref}?"; then
            git stash drop "$stash_ref"
        fi
    fi
}

drop_stash_fzf() {
    local stash
    stash=$(stash_list_fzf)
    if [[ -n "$stash" ]]; then
        local stash_ref
        stash_ref=$(echo "$stash" | cut -d: -f1)
        read "CONFIRM?Drop stash ${stash_ref}? [y/N] "
        if [[ "$CONFIRM" =~ ^[Yy]$ ]]; then
            git stash drop "$stash_ref"
        fi
    fi
}

main() {
    local mode="${1:-list}"
    local has_gum=false has_fzf=false
    command -v gum &> /dev/null && has_gum=true
    command -v fzf &> /dev/null && has_fzf=true

    if ! $has_gum && ! $has_fzf; then
        echo "Error: neither gum nor fzf found." >&2
        exit 1
    fi

    is_in_git_repo || {
        echo "Error: Not inside a git repository." >&2
        exit 1
    }

    case "$mode" in
        list)
            if $has_gum; then
                stash_list_gum
            else
                stash_list_fzf
            fi
            ;;
        apply)
            if $has_gum; then
                apply_stash_gum
            else
                apply_stash_fzf
            fi
            ;;
        drop)
            if $has_gum; then
                drop_stash_gum
            else
                drop_stash_fzf
            fi
            ;;
        *)
            echo "Usage: git-stash.zsh [list|apply|drop]"
            echo "  list   - list stashes (default)"
            echo "  apply  - apply a stash"
            echo "  drop   - drop a stash"
            exit 1
            ;;
    esac
}

main "$@"
