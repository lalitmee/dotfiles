#!/bin/zsh
# ============================================================================
# git-status.zsh - Interactive git status viewer using gum or fzf
# ============================================================================
# Usage:
#   git-status.zsh                # browse changed files
#   git-status.zsh --staged      # browse staged files
#   git-status.zsh --unstaged    # browse unstaged files
#   git-status.zsh --all         # browse all (default)
# ============================================================================

set -euo pipefail

if ! git rev-parse HEAD > /dev/null 2>&1; then
    echo "Not a git repository" >&2
    exit 1
fi

if ! [[ -t 1 ]]; then
    echo "Interactive script — run in a terminal" >&2
    exit 1
fi

detect_tool() {
    if command -v gum > /dev/null 2>&1; then
        echo "gum"
    elif command -v fzf > /dev/null 2>&1; then
        echo "fzf"
    else
        echo "none"
    fi
}

TOOL=$(detect_tool)

# ---------------------------------------------------------------------------
# Gum paths
# ---------------------------------------------------------------------------
gum_status() {
    local status_output
    status_output=$(git status --short)

    if [[ -z "$status_output" ]]; then
        echo "Working tree clean — nothing to show"
        return 0
    fi

    local file
    file=$(echo "$status_output" | \
        gum filter --header "Changed files" --placeholder "Filter files...")

    if [[ -z "$file" ]]; then
        return 1
    fi

    local action
    action=$(gum choose \
        "Show diff" \
        "Stage file" \
        "Unstage file" \
        "Discard changes" \
        "Open in editor" \
        --header "File: $file")

    local filepath
    filepath=$(echo "$file" | awk '{print $NF}')

    case "$action" in
        "Show diff")
            git diff "$filepath" | less
            ;;
        "Stage file")
            git add "$filepath"
            echo "Staged: $filepath"
            ;;
        "Unstage file")
            git reset HEAD "$filepath"
            echo "Unstaged: $filepath"
            ;;
        "Discard changes")
            if gum confirm "Discard changes to $filepath?"; then
                git checkout -- "$filepath"
                echo "Discarded: $filepath"
            fi
            ;;
        "Open in editor")
            ${EDITOR:-vim} "$filepath"
            ;;
    esac
}

# ---------------------------------------------------------------------------
# FZF paths
# ---------------------------------------------------------------------------
fzf_down() {
    fzf --height 50% "$@" --border
}

fzf_status() {
    local status_output
    status_output=$(git status --short)

    if [[ -z "$status_output" ]]; then
        echo "Working tree clean — nothing to show"
        return 0
    fi

    local file
    file=$(echo "$status_output" | \
        fzf_down -m --ansi --nth 2..,.. \
            --header "Changed files (TAB to select)" \
            --preview "echo {} | awk '{print \$NF}' | xargs git diff --color=always | head -50" | \
        awk '{print $NF}' | head -1)

    if [[ -z "$file" ]]; then
        return 1
    fi

    echo "$file"
}

# ---------------------------------------------------------------------------
# Main
# ---------------------------------------------------------------------------
mode="${1:---all}"

case "$mode" in
    --staged|-s)
        case "$TOOL" in
            gum) git diff --cached --name-only | gum filter --header "Staged files" ;;
            fzf) git diff --cached --name-only | fzf_down ;;
            *)   echo "Neither gum nor fzf found" >&2; exit 1 ;;
        esac
        ;;
    --unstaged|-u)
        case "$TOOL" in
            gum) git diff --name-only | gum filter --header "Unstaged files" ;;
            fzf) git diff --name-only | fzf_down ;;
            *)   echo "Neither gum nor fzf found" >&2; exit 1 ;;
        esac
        ;;
    --all|-a|"")
        case "$TOOL" in
            gum) gum_status ;;
            fzf) fzf_status ;;
            *)   echo "Neither gum nor fzf found" >&2; exit 1 ;;
        esac
        ;;
    *)
        echo "Usage: git-status.zsh [--staged|--unstaged|--all]" >&2
        exit 1
        ;;
esac
