#!/usr/bin/env zsh

set -euo pipefail

# Interactive git commit utility using gum or fzf
# Modes: browse (select commit hash), commit (create commit message), amend (amend last commit)

is_in_git_repo() {
    git rev-parse HEAD > /dev/null 2>&1
}

browse_commits_gum() {
    git log --oneline -n 50 |
        gum filter --placeholder "Filter commits..."
}

browse_commits_fzf() {
    git log --oneline -n 50 |
        fzf --height 50% --border --prompt="Select commit: " \
            --preview 'git show --color=always {} | head -200'
}

write_commit_gum() {
    local summary details

    summary=$(gum input --width 50 --placeholder "Summary of changes")
    if [[ -n "$summary" ]]; then
        details=$(gum write --width 80 --placeholder "Details of changes (optional)")
        if [[ -n "$details" ]]; then
            git commit -m "$summary" -m "$details"
        else
            git commit -m "$summary"
        fi
    else
        echo "No summary provided. Aborting." >&2
        exit 1
    fi
}

write_commit_fzf() {
    local summary

    summary=$(echo "" | fzf --height 50% --border --prompt="Commit summary: " \
        --print-query --header="Type summary and press Enter")
    if [[ -n "$summary" ]]; then
        git commit -m "$summary"
    else
        echo "No summary provided. Aborting." >&2
        exit 1
    fi
}

commit_conventional_gum() {
    local commit_types=("feat" "fix" "docs" "style" "refactor" "test" "chore" "revert" "perf" "ci" "build")
    local commit_type scope summary

    commit_type=$(printf '%s\n' "${commit_types[@]}" |
        gum choose --header "Select commit type:")

    if [[ -n "$commit_type" ]]; then
        scope=$(gum input --width 30 --placeholder "scope (optional)")
        summary=$(gum input --width 50 --placeholder "Short description")
        if [[ -n "$summary" ]]; then
            local full_msg
            if [[ -n "$scope" ]]; then
                full_msg="${commit_type}(${scope}): ${summary}"
            else
                full_msg="${commit_type}: ${summary}"
            fi
            local body
            body=$(gum write --width 80 --placeholder "Body (optional)")
            if [[ -n "$body" ]]; then
                git commit -m "$full_msg" -m "$body"
            else
                git commit -m "$full_msg"
            fi
        else
            echo "No summary provided. Aborting." >&2
            exit 1
        fi
    fi
}

commit_conventional_fzf() {
    local commit_types=("feat" "fix" "docs" "style" "refactor" "test" "chore" "revert" "perf" "ci" "build")
    local commit_type scope summary

    commit_type=$(printf '%s\n' "${commit_types[@]}" |
        fzf --height 50% --border --prompt="Select commit type: ")

    if [[ -n "$commit_type" ]]; then
        scope=$(echo "" | fzf --height 50% --border --prompt="Scope (optional): " --print-query --header="Press Enter to skip scope")
        summary=$(echo "" | fzf --height 50% --border --prompt="Description: " --print-query --header="Type description and press Enter")
        if [[ -n "$summary" ]]; then
            local full_msg
            if [[ -n "$scope" ]]; then
                full_msg="${commit_type}(${scope}): ${summary}"
            else
                full_msg="${commit_type}: ${summary}"
            fi
            git commit -m "$full_msg"
        else
            echo "No summary provided. Aborting." >&2
            exit 1
        fi
    fi
}

amend_commit_gum() {
    if gum confirm "Amend last commit?"; then
        git commit --amend --no-edit
    fi
}

amend_commit_fzf() {
    read "CONFIRM?Amend last commit? [y/N] "
    if [[ "$CONFIRM" =~ ^[Yy]$ ]]; then
        git commit --amend --no-edit
    fi
}

main() {
    local mode="${1:-browse}"

    is_in_git_repo || {
        echo "Error: Not inside a git repository." >&2
        exit 1
    }

    local has_gum=false has_fzf=false
    command -v gum &> /dev/null && has_gum=true
    command -v fzf &> /dev/null && has_fzf=true

    if ! $has_gum && ! $has_fzf; then
        echo "Error: neither gum nor fzf found." >&2
        exit 1
    fi

    case "$mode" in
        browse)
            if $has_gum; then
                browse_commits_gum
            else
                browse_commits_fzf
            fi
            ;;
        commit)
            if $has_gum; then
                write_commit_gum
            else
                write_commit_fzf
            fi
            ;;
        conventional)
            if $has_gum; then
                commit_conventional_gum
            else
                commit_conventional_fzf
            fi
            ;;
        amend)
            if $has_gum; then
                amend_commit_gum
            else
                amend_commit_fzf
            fi
            ;;
        *)
            echo "Usage: git-commit.zsh [browse|commit|conventional|amend]"
            echo "  browse        - filter and select a commit hash (default)"
            echo "  commit        - write a commit message interactively"
            echo "  conventional  - write a conventional commit (type(scope): desc)"
            echo "  amend         - amend the last commit"
            exit 1
            ;;
    esac
}

main "$@"
