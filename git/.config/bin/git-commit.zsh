#!/bin/zsh
# ============================================================================
# git-commit.zsh - Interactive git commit using gum or fzf
# ============================================================================
# Two modes:
#   --browse    Browse commit history (gum filter or fzf)
#   --write     Write a new commit message interactively
#   (default)   Write new commit
#
# Usage:
#   git-commit.zsh                # interactive commit
#   git-commit.zsh --browse       # browse commits, select one
#   git-commit.zsh --write        # interactive commit (explicit)
#   git-commit.zsh --amend        # amend last commit message
# ============================================================================

set -euo pipefail

# ---------------------------------------------------------------------------
# Guards
# ---------------------------------------------------------------------------
if ! git rev-parse HEAD > /dev/null 2>&1; then
    echo "Not a git repository" >&2
    exit 1
fi

if ! [[ -t 1 ]]; then
    echo "Interactive script — run in a terminal" >&2
    exit 1
fi

# ---------------------------------------------------------------------------
# Detect UI tool
# ---------------------------------------------------------------------------
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
gum_browse_commits() {
    local hash
    hash=$(git log --oneline --color=always | gum filter --placeholder "Filter commits..." | cut -d' ' -f1)

    if [[ -z "$hash" ]]; then
        return 1
    fi

    local action
    action=$(gum choose \
        "Show details" \
        "Copy hash" \
        "Reset --soft to this" \
        "Cherry-pick" \
        "Cancel" \
        --header "Commit: $hash")

    case "$action" in
        "Show details")
            git show "$hash" | less
            ;;
        "Copy hash")
            echo -n "$hash" | pbcopy
            echo "Copied: $hash"
            ;;
        "Reset --soft to this")
            if gum confirm "Reset --soft to $hash?"; then
                git reset --soft "$hash"
                echo "Reset soft to $hash"
            fi
            ;;
        "Cherry-pick")
            git cherry-pick "$hash"
            ;;
        *)
            return 1
            ;;
    esac
}

gum_write_commit() {
    local summary
    summary=$(gum input --width 72 --placeholder "Commit summary")

    if [[ -z "$summary" ]]; then
        echo "Empty summary — aborted" >&2
        return 1
    fi

    local details=""
    if gum confirm "Add a longer description?"; then
        details=$(gum write --width 72 --placeholder "Commit details (optional)")
    fi

    if [[ -n "$details" ]]; then
        git commit -m "$summary" -m "$details"
    else
        git commit -m "$summary"
    fi
}

gum_amend_commit() {
    local msg
    msg=$(gum input --width 72 --placeholder "Amend commit message" \
        --value "$(git log -1 --format=%B)")

    if [[ -n "$msg" ]]; then
        git commit --amend -m "$msg"
    fi
}

# ---------------------------------------------------------------------------
# FZF paths
# ---------------------------------------------------------------------------
fzf_down() {
    fzf --height 50% "$@" --border
}

fzf_browse_commits() {
    local hash
    hash=$(git log --oneline --color=always | \
        fzf_down --ansi --no-sort --reverse --multi \
            --header "Browse commits (TAB to select)" \
            --preview 'grep -o "[a-f0-9]\{7,\}" <<< {} | xargs git show --color=always | head -50' | \
        grep -o "[a-f0-9]\{7,\}" | head -1)

    if [[ -z "$hash" ]]; then
        return 1
    fi

    echo "$hash"
}

fzf_write_commit() {
    echo "Commit summary:"
    read -r summary

    if [[ -z "$summary" ]]; then
        echo "Empty summary — aborted" >&2
        return 1
    fi

    echo "Commit details (empty line to finish):"
    local details=""
    local line
    while IFS= read -r line; do
        [[ -z "$line" ]] && break
        details="${details}${details:+$'\n'}${line}"
    done

    if [[ -n "$details" ]]; then
        git commit -m "$summary" -m "$details"
    else
        git commit -m "$summary"
    fi
}

# ---------------------------------------------------------------------------
# Main
# ---------------------------------------------------------------------------
mode="${1:---write}"

case "$mode" in
    --browse|-b)
        case "$TOOL" in
            gum) gum_browse_commits ;;
            fzf) fzf_browse_commits ;;
            *)   echo "Neither gum nor fzf found — install one to use this" >&2; exit 1 ;;
        esac
        ;;
    --write|-w|"")
        case "$TOOL" in
            gum) gum_write_commit ;;
            fzf) fzf_write_commit ;;
            *)   echo "Neither gum nor fzf found — install one to use this" >&2; exit 1 ;;
        esac
        ;;
    --amend|-a)
        case "$TOOL" in
            gum) gum_amend_commit ;;
            *)   echo "Amend mode requires gum" >&2; exit 1 ;;
        esac
        ;;
    *)
        echo "Usage: git-commit.zsh [--browse|--write|--amend]" >&2
        exit 1
        ;;
esac
