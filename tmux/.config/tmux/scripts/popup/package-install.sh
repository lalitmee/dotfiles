#!/usr/bin/env zsh

# A standalone script to interactively install packages using npm, cargo, go, brew, or pip.

[[ ! -t 2 && -c /dev/tty ]] && exec 2>/dev/tty
readonly SCRIPT_PATH="${0:A}"

# --- Source utilities ---
# {{{
if [[ -f "$HOME/dotfiles/scripts/install/utils.zsh" ]]; then
    source "$HOME/dotfiles/scripts/install/utils.zsh"
fi
set +e
# }}}

gum_style() { # {{{
    local message="$1"
    if command -v gum_style >/dev/null 2>&1; then
        command gum_style "$message"
    elif command -v gum >/dev/null 2>&1; then
        echo "$message" | gum style --foreground 39
    else
        echo "$message"
    fi
} # }}}

get_custom_input() { # {{{
    local manager="$1"
    local pkg_name=""
    if command -v gum-input >/dev/null 2>&1; then
        pkg_name=$(gum-input input --placeholder "Enter $manager package/formula name (e.g. typescript)")
    elif command -v gum >/dev/null 2>&1; then
        pkg_name=$(gum input --placeholder "Enter $manager package/formula name (e.g. typescript)")
    else
        echo -n "Enter $manager package/formula name: "
        read -r pkg_name
    fi
    echo "$pkg_name"
} # }}}

run_custom_install() { # {{{
    local manager="$1"
    local name_to_install="$2"
    local install_status=0

    echo ""
    gum_style "🚀 Starting install/update process for $name_to_install ($manager)..."
    echo ""

    case "$manager" in
        npm)
            gum_style "Running: npm install -g $name_to_install@latest"
            NPM_CONFIG_LOGLEVEL=info \
                NPM_CONFIG_PROGRESS=true \
                NPM_CONFIG_AUDIT=false \
                NPM_CONFIG_FUND=false \
                npm install -g "$name_to_install@latest" --foreground-scripts || install_status=$?
            ;;
        cargo)
            cargo install "$name_to_install" || install_status=$?
            ;;
        go)
            go install "$name_to_install@latest" || install_status=$?
            ;;
        brew)
            if brew list "$name_to_install" &>/dev/null; then
                brew upgrade "$name_to_install" || install_status=$?
            else
                brew install "$name_to_install" || install_status=$?
            fi
            ;;
        pip)
            pip3 install --upgrade "$name_to_install" || install_status=$?
            ;;
    esac

    echo ""
    if [[ $install_status -eq 0 ]]; then
        gum_style "✅ $name_to_install successfully installed/updated!"
    else
        gum_style "❌ Failed to install/update $name_to_install."
    fi
    echo ""
    return $install_status
} # }}}

main() { # {{{
    # Stage 0: Bootstrap popup
    if [[ "$1" == "--bootstrap" || -z "$1" ]]; then
        local current_path="${CURRENT_PANE_PATH:-$PWD}"
        tmux display-popup -w 55% -h 40% -b rounded -T " Package Installer " -d "$current_path" -E \
            "$SCRIPT_PATH --popup '$current_path'"
        exit 0
    fi

    # Stage 1: Choose manager and package name inside popup
    if [[ "$1" == "--popup" ]]; then
        local target_path="$2"
        clear

        local -a managers=(
            "📦 npm\tNode.js global package"
            "🦀 cargo\tRust crate binary"
            "🐹 go\tGo binary"
            "🍺 brew\tHomebrew formula"
            "🐍 pip\tPython package"
        )

        local choice
        choice=$(printf "%b\n" "${managers[@]}" | fzf \
            --delimiter=$'\t' --tabstop=12 \
            --prompt="Manager > " \
            --header="Select Package Manager:" \
            --height="100%" \
            --layout=reverse \
            --no-multi) || exit 0
        [[ -z "$choice" ]] && exit 0

        local manager=$(echo "$choice" | cut -f1 | awk '{print $2}')
        local pkg_name=$(get_custom_input "$manager")
        [[ -z "$pkg_name" ]] && exit 0

        local win_name="install:${manager}-${pkg_name}"
        tmux new-window -c "$target_path" -n "$win_name" \
            "zsh -lic '$SCRIPT_PATH --execute $manager $pkg_name'"
        exit 0
    fi

    # Stage 2: Execution in new tmux window
    if [[ "$1" == "--execute" ]]; then
        clear
        run_custom_install "$2" "$3"
        echo ""
        gum_style "Press any key to close..."
        read -k 1 -s -r 2>/dev/null || true
        exit 0
    fi
} # }}}

main "$@"
