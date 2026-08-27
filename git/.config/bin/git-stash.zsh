#!/bin/zsh
# ============================================================================
# git-stash.zsh - Interactive git stash operations using gum or fzf
# ============================================================================
# Usage:
#   git-stash.zsh                # list and select stash
#   git-stash.zsh --save        # create new stash with message
#   git-stash.zsh --apply       # apply selected stash
#   git-stash.zsh --pop         # pop selected stash
#   git-stash.zsh --drop        # drop selected stash
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
gum_save_stash() {
    local msg
    msg=$(gum input --placeholder "Stash message (optional)")

    if [[ -n "$msg" ]]; then
        git stash push -m "$msg"
        echo "Stash created: $msg"
    else
        git stash push
        echo "Stash created"
    fi
}

gum_list_stash() {
    local stash_output
    stash_output=$(git stash list)

    if [[ -z "$stash_output" ]]; then
        echo "No stashes found"
        return 0
    fi

    local stash
    stash=$(echo "$stash_output" | \
        gum filter --header "Stashes" --placeholder "Filter stashes...")

    if [[ -z "$stash" ]]; then
        return 1
    fi

    local stash_ref
    stash_ref=$(echo "$stash" | cut -d: -f1)

    local action
    action=$(gum choose \
        "Apply stash" \
        "Pop stash (apply + delete)" \
        "Show diff" \
        "Drop stash" \
        --header "Stash: $stash")

    case "$action" in
        "Apply stash")
            git stash apply "$stash_ref"
            echo "Applied: $stash_ref"
            ;;
        "Pop stash (apply + delete)")
            git stash pop "$stash_ref"
            echo "Popped: $stash_ref"
            ;;
        "Show diff")
            git stash show -p "$stash_ref" | less
            ;;
        "Drop stash")
            if gum confirm "Drop stash $stash_ref?"; then
                git stash drop "$stash_ref"
                echo "Dropped: $stash_ref"
            fi
            ;;
    esac
}

# ---------------------------------------------------------------------------
# FZF paths
# ---------------------------------------------------------------------------
fzf_down() {
    fzf --height 50% "$@" --border
}

fzf_list_stash() {
    local stash_output
    stash_output=$(git stash list)

    if [[ -z "$stash_output" ]]; then
        echo "No stashes found"
        return 0
    fi

    local stash
    stash=$(echo "$stash_output" | \
        fzf_down --header "Select stash" \
            --preview "echo {} | cut -d: -f1 | xargs git stash show -p | head -50")

    if [[ -z "$stash" ]]; then
        return 1
    fi

    echo "$stash" | cut -d: -f1
}

# ---------------------------------------------------------------------------
# Main
# ---------------------------------------------------------------------------
mode="${1:---list}"

case "$mode" in
    --save|-s)
        case "$TOOL" in
            gum) gum_save_stash ;;
            fzf) echo "Save stash requires gum" >&2; exit 1 ;;
            *)   echo "Neither gum nor fzf found" >&2; exit 1 ;;
        esac
        ;;
    --apply|-a)
        case "$TOOL" in
            gum) gum_list_stash ;;
            fzf) fzf_list_stash | xargs -I {} git stash apply {} ;;
            *)   echo "Neither gum nor fzf found" >&2; exit 1 ;;
        esac
        ;;
    --pop|-p)
        case "$TOOL" in
            gum) gum_list_stash ;;
            fzf) fzf_list_stash | xargs -I {} git stash pop {} ;;
            *)   echo "Neither gum nor fzf found" >&2; exit 1 ;;
        esac
        ;;
    --drop|-d)
        case "$TOOL" in
            gum) gum_list_stash ;;
            fzf) fzf_list_stash | xargs -I {} git stash drop {} ;;
            *)   echo "Neither gum nor fzf found" >&2; exit 1 ;;
        esac
        ;;
    --list|-l|"")
        case "$TOOL" in
            gum) gum_list_stash ;;
            fzf) fzf_list_stash ;;
            *)   echo "Neither gum nor fzf found" >&2; exit 1 ;;
        esac
        ;;
    *)
        echo "Usage: git-stash.zsh [--save|--apply|--pop|--drop|--list]" >&2
        exit 1
        ;;
esac
