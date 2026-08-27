#!/usr/bin/env zsh
set -euo pipefail

# Interactive git utilities launcher
# Usage: git-utils.zsh [utility] [mode]
# Without args: interactive menu

BIN_DIR="${0:A:h}"

utilities=(
    "branch:Branch Operations:Switch, delete, create branches"
    "commit:Commit Operations:Browse, create, amend commits"
    "status:Status Viewer:View, stage, diff changes"
    "stash:Stash Operations:List, apply, drop stashes"
    "tag:Tag Operations:List, show tags"
    "remote:Remote Operations:List, show remotes"
)

# --- gum style ---
gum_style() {
    local border="${1:-rounded}"
    shift
    gum style \
        --border "$border" \
        --border-foreground 212 \
        --align center \
        --width 50 \
        --margin "1 2" \
        --padding "1 2" \
        "$@"
}

# --- build menu items ---
build_items() {
    local items=()
    for util in "${utilities[@]}"; do
        IFS=':' read -r name title desc <<< "$util"
        items+=("$title — $desc")
    done
    printf '%s\n' "${items[@]}"
}

# --- extract utility name from menu choice ---
extract_name() {
    local choice="$1"
    for util in "${utilities[@]}"; do
        IFS=':' read -r name title desc <<< "$util"
        if [[ "$choice" == "$title — $desc" ]]; then
            echo "$name"
            return
        fi
    done
}

# --- run utility ---
run_utility() {
    local util_name="$1"
    local mode="${2:-}"

    case "$util_name" in
        branch)
            zsh "$BIN_DIR/git-branch.zsh" ${mode:-switch}
            ;;
        commit)
            zsh "$BIN_DIR/git-commit.zsh" ${mode:-browse}
            ;;
        status)
            zsh "$BIN_DIR/git-status.zsh" ${mode:-view}
            ;;
        stash)
            zsh "$BIN_DIR/git-stash.zsh" ${mode:-list}
            ;;
        tag)
            zsh "$BIN_DIR/git-tag.zsh" ${mode:-list}
            ;;
        remote)
            zsh "$BIN_DIR/git-remote.zsh" ${mode:-list}
            ;;
    esac
}

# --- main ---
main() {
    if [[ $# -ge 1 ]]; then
        # Direct: git-utils.zsh branch switch
        run_utility "$@"
        return
    fi

    # Interactive menu
    local items
    items=$(build_items)

    local choice
    if command -v gum &>/dev/null; then
        choice=$(echo "$items" | gum choose \
            --header "Git Utilities" \
            --height 10)
    elif command -v fzf &>/dev/null; then
        choice=$(echo "$items" | fzf \
            --prompt="Git Utilities > " \
            --height=40% \
            --reverse)
    else
        echo "Install gum or fzf for interactive mode" >&2
        echo "Usage: $0 [utility] [mode]" >&2
        echo "Utilities: branch, commit, status, stash, tag, remote" >&2
        return 1
    fi

    [[ -z "$choice" ]] && return 0

    local util_name
    util_name=$(extract_name "$choice")
    run_utility "$util_name"
}

main "$@"
