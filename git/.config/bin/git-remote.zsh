#!/bin/zsh
# ============================================================================
# git-remote.zsh - Interactive git remote operations using gum or fzf
# ============================================================================
# Usage:
#   git-remote.zsh                # list and select remotes
#   git-remote.zsh --add         # add a new remote
#   git-remote.zsh --remove     # remove a remote
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
gum_list_remotes() {
    local remote_output
    remote_output=$(git remote -v | awk '{print $1 "\t" $2}' | uniq)

    if [[ -z "$remote_output" ]]; then
        echo "No remotes configured"
        return 0
    fi

    local remote
    remote=$(echo "$remote_output" | \
        gum filter --header "Remotes" --placeholder "Filter remotes...")

    if [[ -z "$remote" ]]; then
        return 1
    fi

    local remote_name
    remote_name=$(echo "$remote" | cut -d$'\t' -f1)

    local action
    action=$(gum choose \
        "Show branches from remote" \
        "Fetch" \
        "Prune" \
        "Remove remote" \
        --header "Remote: $remote_name")

    case "$action" in
        "Show branches from remote")
            git branch -a --color=always | grep "remotes/$remote_name" | less
            ;;
        "Fetch")
            git fetch "$remote_name"
            echo "Fetched: $remote_name"
            ;;
        "Prune")
            git remote prune "$remote_name"
            echo "Pruned: $remote_name"
            ;;
        "Remove remote")
            if gum confirm "Remove remote $remote_name?"; then
                git remote remove "$remote_name"
                echo "Removed: $remote_name"
            fi
            ;;
    esac
}

gum_add_remote() {
    local name
    name=$(gum input --placeholder "Remote name" --header "Add remote")

    if [[ -z "$name" ]]; then
        return 1
    fi

    local url
    url=$(gum input --placeholder "Remote URL" --header "URL for $name")

    if [[ -z "$url" ]]; then
        return 1
    fi

    git remote add "$name" "$url"
    echo "Added remote: $name ($url)"
}

# ---------------------------------------------------------------------------
# FZF paths
# ---------------------------------------------------------------------------
fzf_down() {
    fzf --height 50% "$@" --border
}

fzf_list_remotes() {
    local remote_output
    remote_output=$(git remote -v | awk '{print $1 "\t" $2}' | uniq)

    if [[ -z "$remote_output" ]]; then
        echo "No remotes configured"
        return 0
    fi

    local remote
    remote=$(echo "$remote_output" | \
        fzf_down --header "Select remote" \
            --preview "echo {} | cut -d$'\t' -f1 | xargs -I {} git branch -a | grep {} | head -20")

    if [[ -n "$remote" ]]; then
        echo "$remote" | cut -d$'\t' -f1
    fi
}

# ---------------------------------------------------------------------------
# Main
# ---------------------------------------------------------------------------
mode="${1:---list}"

case "$mode" in
    --list|-l|"")
        case "$TOOL" in
            gum) gum_list_remotes ;;
            fzf) fzf_list_remotes ;;
            *)   echo "Neither gum nor fzf found" >&2; exit 1 ;;
        esac
        ;;
    --add|-a)
        case "$TOOL" in
            gum) gum_add_remote ;;
            *)   echo "Add remote requires gum" >&2; exit 1 ;;
        esac
        ;;
    --remove|-r)
        case "$TOOL" in
            gum) gum_list_remotes ;;
            fzf) fzf_list_remotes | xargs -I {} git remote remove {} ;;
            *)   echo "Neither gum nor fzf found" >&2; exit 1 ;;
        esac
        ;;
    *)
        echo "Usage: git-remote.zsh [--list|--add|--remove]" >&2
        exit 1
        ;;
esac
