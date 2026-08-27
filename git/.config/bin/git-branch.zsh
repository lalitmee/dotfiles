#!/bin/zsh
# ============================================================================
# git-branch.zsh - Interactive git branch operations using gum or fzf
# ============================================================================
# Usage:
#   git-branch.zsh                # switch branch
#   git-branch.zsh --list        # list branches
#   git-branch.zsh --switch      # switch branch (explicit)
#   git-branch.zsh --delete      # delete branch
#   git-branch.zsh --new         # create new branch from current
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
# Helpers
# ---------------------------------------------------------------------------
current_branch() {
    git branch --show-current
}

# ---------------------------------------------------------------------------
# Gum paths
# ---------------------------------------------------------------------------
gum_switch_branch() {
    local current
    current=$(current_branch)

    local branch
    branch=$(git branch -a --color=always | \
        grep -v "/HEAD\s" | \
        sed "s/*\+//" | \
        sed 's/^\s*//' | \
        gum choose --header "Current: $current — Select branch to switch" \
            --placeholder "Filter branches...")

    if [[ -z "$branch" ]]; then
        return 1
    fi

    # Strip remote prefix for local checkout
    local target="$branch"
    [[ "$branch" == remotes/* ]] && target="${branch#remotes/}"
    [[ "$target" == */* ]] && target="${target#*/}"

    git checkout "$target"
    echo "Switched to: $target"
}

gum_delete_branch() {
    local current
    current=$(current_branch)

    local branch
    branch=$(git branch --color=always | \
        sed "s/*\+//" | \
        sed 's/^\s*//' | \
        grep -v "^${current}$" | \
        gum choose --no-limit --header "Select branches to delete (skip current: $current)" \
            --placeholder "Filter branches...")

    if [[ -z "$branch" ]]; then
        return 1
    fi

    if gum confirm "Delete selected branches?"; then
        while IFS= read -r b; do
            [[ -n "$b" ]] && git branch -D "$b"
        done <<< "$branch"
    fi
}

gum_new_branch() {
    local name
    name=$(gum input --placeholder "New branch name" --header "Create branch from: $(current_branch)")

    if [[ -z "$name" ]]; then
        return 1
    fi

    git checkout -b "$name"
    echo "Created and switched to: $name"
}

gum_list_branches() {
    local current
    current=$(current_branch)

    local branch
    branch=$(git branch -a --color=always | \
        grep -v "/HEAD\s" | \
        sed "s/*\+//" | \
        sed 's/^\s*//' | \
        gum filter --header "Current: $current — Filter branches" --placeholder "Type to filter...")

    if [[ -n "$branch" ]]; then
        echo "$branch"
    fi
}

# ---------------------------------------------------------------------------
# FZF paths
# ---------------------------------------------------------------------------
fzf_down() {
    fzf --height 50% "$@" --border
}

fzf_switch_branch() {
    local current
    current=$(current_branch)

    local branch
    branch=$(git branch -a --color=always | \
        grep -v '/HEAD\s' | sort | \
        fzf_down --ansi --multi --tac \
            --header "Current: $current — Select branch" \
            --preview "git log --oneline --graph --date=short --color=always --pretty=format:'%C(auto)%cd %h%d %s' \$(echo {} | sed 's/^..//' | cut -d' ' -f1 | sed 's#^remotes/##') | head -20" | \
        sed 's/^..//' | cut -d' ' -f1 | head -1)

    if [[ -z "$branch" ]]; then
        return 1
    fi

    local target="$branch"
    [[ "$branch" == remotes/* ]] && target="${branch#remotes/}"
    [[ "$target" == */* ]] && target="${target#*/}"

    git checkout "$target"
    echo "Switched to: $target"
}

fzf_delete_branch() {
    local current
    current=$(current_branch)

    local branch
    branch=$(git branch --color=always | \
        sed "s/*\+//" | sed 's/^\s*//' | \
        grep -v "^${current}$" | \
        fzf_down --multi --header "Select branches to delete" | \
        sed 's/^\s*//')

    if [[ -n "$branch" ]]; then
        while IFS= read -r b; do
            [[ -n "$b" ]] && git branch -D "$b"
        done <<< "$branch"
    fi
}

# ---------------------------------------------------------------------------
# Main
# ---------------------------------------------------------------------------
mode="${1:---switch}"

case "$mode" in
    --list|-l)
        case "$TOOL" in
            gum) gum_list_branches ;;
            fzf) git branch -a ;;
            *)   echo "Neither gum nor fzf found" >&2; exit 1 ;;
        esac
        ;;
    --switch|-s|"")
        case "$TOOL" in
            gum) gum_switch_branch ;;
            fzf) fzf_switch_branch ;;
            *)   echo "Neither gum nor fzf found" >&2; exit 1 ;;
        esac
        ;;
    --delete|-d)
        case "$TOOL" in
            gum) gum_delete_branch ;;
            fzf) fzf_delete_branch ;;
            *)   echo "Neither gum nor fzf found" >&2; exit 1 ;;
        esac
        ;;
    --new|-n)
        case "$TOOL" in
            gum) gum_new_branch ;;
            fzf) echo "New branch requires gum" >&2; exit 1 ;;
            *)   echo "Neither gum nor fzf found" >&2; exit 1 ;;
        esac
        ;;
    *)
        echo "Usage: git-branch.zsh [--list|--switch|--delete|--new]" >&2
        exit 1
        ;;
esac
