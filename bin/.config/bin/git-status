#!/usr/bin/env zsh

set -euo pipefail

# Interactive git status viewer using gum or fzf
# Shows changed files with preview

is_in_git_repo() {
    git rev-parse HEAD > /dev/null 2>&1
}

status_gum() {
    local mode="${1:-view}"

    if [[ "$mode" == "stage" ]]; then
        git status --short |
            gum filter --placeholder "Select files to stage..."
    elif [[ "$mode" == "diff" ]]; then
        git status --short |
            gum filter --placeholder "Select files to diff..."
    else
        git status --short |
            gum filter --placeholder "Filter changed files..."
    fi
}

status_fzf() {
    local mode="${1:-view}"

    if [[ "$mode" == "stage" ]]; then
        git status --short |
            fzf --height 50% --border --multi --prompt="Select files to stage: " \
                --preview 'git diff --color=always -- {-1}' |
            awk '{print $NF}'
    elif [[ "$mode" == "diff" ]]; then
        git status --short |
            fzf --height 50% --border --multi --prompt="Select files to diff: " \
                --preview 'git diff --color=always -- {-1}' |
            awk '{print $NF}'
    else
        git status --short |
            fzf --height 50% --border --prompt="Filter changed files: " \
                --preview 'git diff --color=always -- {-1}'
    fi
}

main() {
    local mode="${1:-view}"
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

    local files
    if $has_gum; then
        files=$(status_gum "$mode")
    else
        files=$(status_fzf "$mode")
    fi

    if [[ -z "$files" ]]; then
        echo "No files selected." >&2
        exit 0
    fi

    case "$mode" in
        stage)
            echo "$files" | while read -r file; do
                [[ -n "$file" ]] && git add "$file"
            done
            echo "Staged $(echo "$files" | wc -l | tr -d ' ') files"
            ;;
        diff)
            echo "$files" | while read -r file; do
                [[ -n "$file" ]] && git diff -- "$file"
            done
            ;;
        *)
            echo "$files"
            ;;
    esac
}

main "$@"
