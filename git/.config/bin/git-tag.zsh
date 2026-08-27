#!/bin/zsh
# ============================================================================
# git-tag.zsh - Interactive git tag operations using gum or fzf
# ============================================================================
# Usage:
#   git-tag.zsh                # list and select tags
#   git-tag.zsh --create      # create a new tag
#   git-tag.zsh --delete      # delete a tag
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
gum_list_tags() {
    local tag_output
    tag_output=$(git tag --sort=-version:refname)

    if [[ -z "$tag_output" ]]; then
        echo "No tags found"
        return 0
    fi

    local tag
    tag=$(echo "$tag_output" | \
        gum filter --header "Tags" --placeholder "Filter tags...")

    if [[ -z "$tag" ]]; then
        return 1
    fi

    local action
    action=$(gum choose \
        "Show tag details" \
        "Copy tag name" \
        "Delete tag" \
        --header "Tag: $tag")

    case "$action" in
        "Show tag details")
            git show "$tag" | less
            ;;
        "Copy tag name")
            echo -n "$tag" | pbcopy
            echo "Copied: $tag"
            ;;
        "Delete tag")
            if gum confirm "Delete tag $tag?"; then
                git tag -d "$tag"
                echo "Deleted: $tag"
            fi
            ;;
    esac
}

gum_create_tag() {
    local name
    name=$(gum input --placeholder "Tag name" --header "Create tag")

    if [[ -z "$name" ]]; then
        return 1
    fi

    local msg
    msg=$(gum input --placeholder "Tag message (optional)")

    if [[ -n "$msg" ]]; then
        git tag -a "$name" -m "$msg"
    else
        git tag "$name"
    fi

    echo "Created tag: $name"
}

# ---------------------------------------------------------------------------
# FZF paths
# ---------------------------------------------------------------------------
fzf_down() {
    fzf --height 50% "$@" --border
}

fzf_list_tags() {
    local tag_output
    tag_output=$(git tag --sort=-version:refname)

    if [[ -z "$tag_output" ]]; then
        echo "No tags found"
        return 0
    fi

    local tag
    tag=$(echo "$tag_output" | \
        fzf_down --header "Select tag" \
            --preview "git show --color=always {} | head -30" | \
        head -1)

    if [[ -n "$tag" ]]; then
        echo "$tag"
    fi
}

# ---------------------------------------------------------------------------
# Main
# ---------------------------------------------------------------------------
mode="${1:---list}"

case "$mode" in
    --list|-l|"")
        case "$TOOL" in
            gum) gum_list_tags ;;
            fzf) fzf_list_tags ;;
            *)   echo "Neither gum nor fzf found" >&2; exit 1 ;;
        esac
        ;;
    --create|-c)
        case "$TOOL" in
            gum) gum_create_tag ;;
            *)   echo "Create tag requires gum" >&2; exit 1 ;;
        esac
        ;;
    --delete|-d)
        case "$TOOL" in
            gum) gum_list_tags ;;
            fzf) fzf_list_tags | xargs -I {} git tag -d {} ;;
            *)   echo "Neither gum nor fzf found" >&2; exit 1 ;;
        esac
        ;;
    *)
        echo "Usage: git-tag.zsh [--list|--create|--delete]" >&2
        exit 1
        ;;
esac
