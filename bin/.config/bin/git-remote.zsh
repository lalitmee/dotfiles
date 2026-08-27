#!/usr/bin/env zsh

set -euo pipefail

# Interactive git remote browser using gum or fzf

is_in_git_repo() {
    git rev-parse HEAD > /dev/null 2>&1
}

remote_list_gum() {
    git remote -v | awk '{print $1 "\t" $2}' | uniq |
        gum filter --placeholder "Filter remotes..."
}

remote_list_fzf() {
    git remote -v | awk '{print $1 "\t" $2}' | uniq |
        fzf --height 50% --border --prompt="Select remote: " \
            --preview 'git log --oneline --graph --date=short --pretty="format:%C(auto)%cd %h%d %s" {1} | head -200' |
        cut -f1
}

show_remote_gum() {
    local remote
    remote=$(remote_list_gum)
    if [[ -n "$remote" ]]; then
        local remote_name
        remote_name=$(echo "$remote" | cut -f1)
        echo "Remote: $remote_name"
        echo "URL: $(git remote get-url "$remote_name" 2>/dev/null || echo 'not set')"
        echo ""
        echo "Recent commits from $remote_name/main:"
        git log --oneline --graph "$remote_name/main" 2>/dev/null | head -20 || echo "No commits found"
    fi
}

show_remote_fzf() {
    local remote
    remote=$(remote_list_fzf)
    if [[ -n "$remote" ]]; then
        echo "Remote: $remote"
        echo "URL: $(git remote get-url "$remote" 2>/dev/null || echo 'not set')"
        echo ""
        echo "Recent commits from $remote/main:"
        git log --oneline --graph "$remote/main" 2>/dev/null | head -20 || echo "No commits found"
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
                remote_list_gum
            else
                remote_list_fzf
            fi
            ;;
        show)
            if $has_gum; then
                show_remote_gum
            else
                show_remote_fzf
            fi
            ;;
        *)
            echo "Usage: git-remote.zsh [list|show]"
            echo "  list  - select a remote (default)"
            echo "  show  - show remote details"
            exit 1
            ;;
    esac
}

main "$@"
