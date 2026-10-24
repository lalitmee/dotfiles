#!/usr/bin/env zsh

# A script to select, install, or update predefined AI tools and custom CLI packages.
# Uses fzf for multi-selection, gum for UI styling, and zsh login shell context for paths.

# Ensure stderr is connected to a terminal (fixes ENOTTY for gum under zsh -lic where znap redirected fd 2)
[[ ! -t 2 && -c /dev/tty ]] && exec 2>/dev/tty

readonly SCRIPT_PATH="${0:A}"

# --- Source utilities ---
# {{{
if [[ -f "$HOME/dotfiles/scripts/install/utils.zsh" ]]; then
    source "$HOME/dotfiles/scripts/install/utils.zsh"
fi
set +e  # Ensure script doesn't crash on individual command failures
# }}}

# --- Helper functions ---

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
    if command -v gum >/dev/null 2>&1; then
        pkg_name=$(gum input --placeholder "Enter $manager package/formula name (e.g. typescript)")
    else
        echo -n "Enter $manager package/formula name: "
        read -r pkg_name
    fi
    echo "$pkg_name"
} # }}}

install_npm_global() { # {{{
    local package_name="$1"

    gum_style "Running: npm install -g $package_name --foreground-scripts --loglevel=info --progress=true --no-audit --no-fund"
    NPM_CONFIG_LOGLEVEL=info \
        NPM_CONFIG_PROGRESS=true \
        NPM_CONFIG_AUDIT=false \
        NPM_CONFIG_FUND=false \
        npm install -g "$package_name" --foreground-scripts
} # }}}

get_npm_version_fast() { # {{{
    local pkg="$1"
    local ver
    ver=$(echo "$NPM_JSON" | jq -r ".dependencies[\"$pkg\"].version // \"Not Installed\"")
    echo "$ver"
} # }}}

get_crush_version() { # {{{
    crush --version 2>/dev/null | awk '{print $NF}' || echo "Not Installed"
} # }}}

get_kiro_version() { # {{{
    kiro-cli --version 2>/dev/null | awk '{print $NF}' || echo "Not Installed"
} # }}}

get_agy_version() { # {{{
    agy --version 2>/dev/null || echo "Not Installed"
} # }}}

get_cursor_agent_version() { # {{{
    cursor-agent --version 2>/dev/null || echo "Not Installed"
} # }}}

secure_run_script() { # {{{
    local url="$1"
    local tool_name="$2"
    local tmp_file
    tmp_file=$(mktemp)

    trap "rm -f \"$tmp_file\"" RETURN EXIT

    local dl_status=0
    if command -v gum >/dev/null 2>&1; then
        gum spin --spinner dot --title "Downloading $tool_name installer..." -- curl -fsSL "$url" -o "$tmp_file" || dl_status=$?
    else
        gum_style "Downloading $tool_name installer..."
        curl -fsSL "$url" -o "$tmp_file" || dl_status=$?
    fi

    if [[ $dl_status -ne 0 ]]; then
        gum_style "❌ Error: Failed to download $tool_name installer from $url"
        return 1
    fi

    local checksum
    if command -v sha256sum >/dev/null 2>&1; then
        checksum=$(sha256sum "$tmp_file" | awk '{print $1}')
    elif command -v shasum >/dev/null 2>&1; then
        checksum=$(shasum -a 256 "$tmp_file" | awk '{print $1}')
    else
        checksum="unknown"
    fi
    gum_style "SHA256: $checksum"

    # Accepting the tool selection authorizes running its installer.
    bash "$tmp_file"
    return $?
} # }}}

build_tool_menu() { # {{{
    local outfile="$1"
    # Fetch all global NPM package versions in one fast call
    local NPM_JSON
    NPM_JSON=$(npm list -g --depth=0 --json 2>/dev/null || echo "{}")

    # Retrieve all versions
    local ver_agy=$(get_agy_version)
    local ver_claude=$(get_npm_version_fast "@anthropic-ai/claude-code")
    local ver_copilot=$(get_npm_version_fast "@github/copilot")
    local ver_opencode=$(opencode --version 2>/dev/null | awk '{print $NF}')
    [[ -n "$ver_opencode" ]] || ver_opencode="Not Installed"
    local ver_grok=$(get_npm_version_fast "@vibe-kit/grok-cli")
    local ver_codex=$(get_npm_version_fast "@openai/codex")
    local ver_crush=$(get_crush_version)
    local ver_kiro=$(get_kiro_version)
    local ver_cursor=$(get_cursor_agent_version)
    local ver_pi=$(get_npm_version_fast "@earendil-works/pi-coding-agent")

    printf "%s\n" \
        "🚀 agy ($ver_agy)" \
        "🟠 claude ($ver_claude)" \
        "  copilot ($ver_copilot)" \
        "🧑‍💻 opencode ($ver_opencode)" \
        "🧠 grok ($ver_grok)" \
        "🧬 codex ($ver_codex)" \
        "💖 crush ($ver_crush)" \
        "🔷 kiro ($ver_kiro)" \
        "🖱️ cursor-agent ($ver_cursor)" \
        "🥧 pi ($ver_pi)" \
        "📦 [npm] Install/update custom global npm package..." \
        "🦀 [cargo] Install/update custom cargo package..." \
        "🐹 [go] Install/update custom go package..." \
        "🍺 [brew] Install/update custom brew formula..." \
        "🐍 [pip] Install/update custom python pip package..." > "$outfile"
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
            install_npm_global "$name_to_install@latest" || install_status=$?
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

run_tool_install() { # {{{
    local tool="$1"
    local install_status=0

    echo ""
    gum_style "🚀 Starting install/update process for $tool..."
    echo ""

    case "$tool" in
        agy)
            agy update || install_status=$?
            ;;
        claude)
            install_npm_global "@anthropic-ai/claude-code@latest" || install_status=$?
            ;;
        copilot)
            install_npm_global "@github/copilot@latest" || install_status=$?
            ;;
        opencode)
            if command -v opencode >/dev/null 2>&1; then
                opencode upgrade || install_status=$?
            else
                gum_style "OpenCode V2 is not installed; use https://opencode.ai/v2/docs/cli to install it."
                install_status=1
            fi
            ;;
        grok)
            install_npm_global "@vibe-kit/grok-cli@latest" || install_status=$?
            ;;
        codex)
            install_npm_global "@openai/codex@latest" || install_status=$?
            ;;
        crush)
            install_npm_global "@charmland/crush@latest" || install_status=$?
            ;;
        kiro)
            secure_run_script "https://cli.kiro.dev/install" "Kiro CLI" || install_status=$?
            ;;
        cursor-agent)
            cursor-agent update || install_status=$?
            ;;
        pi)
            install_npm_global "@earendil-works/pi-coding-agent@latest" || install_status=$?
            ;;
    esac

    echo ""
    if [[ $install_status -eq 0 ]]; then
        gum_style "✅ $tool successfully installed/updated!"
    else
        gum_style "❌ Failed to install/update $tool."
    fi
    echo ""
    return $install_status
} # }}}

# --- Main Logic ---

main() { # {{{
    if [[ "$1" == "__fetch_versions" ]]; then
        build_tool_menu "$2"
        exit $?
    fi

    # Stage 0: Bootstrap the centered popup
    if [[ "$1" == "--bootstrap" ]]; then
        local current_path="${CURRENT_PANE_PATH:-$PWD}"
        tmux display-popup -w 60% -h 30% -b rounded -T " AI Tools Manager " -d "$current_path" -E \
            "$SCRIPT_PATH --popup '$current_path'"
        exit 0
    fi

    # Stage 1: Render centered spinner + full fzf inside the popup
    if [[ "$1" == "--popup" ]]; then
        local target_path="$2"
        local menu_file
        menu_file=$(mktemp /tmp/ai_manage_menu.XXXXXX)
        trap "rm -f \"$menu_file\"" EXIT

        local spinner_title="Fetching AI tool versions..."
        local rows=$(tput lines 2>/dev/null || echo 0)
        local cols=$(tput cols 2>/dev/null || echo 0)
        local top=$(( rows > 1 ? (rows - 1) / 2 : 0 ))
        local left=$(( cols > ${#spinner_title} + 2 ? (cols - ${#spinner_title} - 2) / 2 : 0 ))

        if command -v gum >/dev/null 2>&1; then
            gum spin --spinner dot --title "$spinner_title" --padding "$top 0 0 $left" -- \
                zsh "$SCRIPT_PATH" __fetch_versions "$menu_file"
        else
            build_tool_menu "$menu_file"
        fi

        [[ ! -s "$menu_file" ]] && build_tool_menu "$menu_file"

        clear
        local selections
        selections=$(cat "$menu_file" | fzf --header="Select tool(s) to install/update (TAB to multi-select, ENTER to run):" --multi --ansi --height=100%)

        if [[ -z "$selections" ]]; then
            exit 0
        fi

        # Parse selections and create install execution plan
        local plan_file
        plan_file=$(mktemp /tmp/ai_manage_plan.XXXXXX)
        local -a selected_labels=()

        local -a lines=("${(f)selections}")
        local line
        for line in "${lines[@]}"; do
            [[ -z "$line" ]] && continue
            local tool="" manager=""
            if [[ "$line" == "🚀"* || "$line" == ""* || "$line" == "🟠"* || "$line" == "🧑‍💻"* || "$line" == "🧬"* || "$line" == "💖"* || "$line" == "🔷"* || "$line" == "🧠"* || "$line" == "🖱️"* || "$line" == "🥧"* ]]; then
                tool=$(echo "$line" | awk '{print $2}')
                selected_labels+=("$tool")
                echo "tool\t$tool" >> "$plan_file"
            elif [[ "$line" == "📦"* ]]; then manager="npm"
            elif [[ "$line" == "🦀"* ]]; then manager="cargo"
            elif [[ "$line" == "🐹"* ]]; then manager="go"
            elif [[ "$line" == "🍺"* ]]; then manager="brew"
            elif [[ "$line" == "🐍"* ]]; then manager="pip"
            fi

            if [[ -n "$manager" ]]; then
                local pkg_name=$(get_custom_input "$manager")
                if [[ -n "$pkg_name" ]]; then
                    selected_labels+=("${manager}-${pkg_name}")
                    echo "custom\t$manager\t$pkg_name" >> "$plan_file"
                fi
            fi
        done

        if [[ ! -s "$plan_file" ]]; then
            rm -f "$plan_file"
            exit 0
        fi

        # Construct semantic window title
        local win_name="ai-manage"
        local count=${#selected_labels}
        if (( count == 1 )); then
            win_name="ai-manage:${selected_labels[1]}"
        elif (( count == 2 )); then
            win_name="ai-manage:${selected_labels[1]}+${selected_labels[2]}"
        elif (( count > 2 )); then
            win_name="ai-manage:${count}-tools"
        fi

        tmux new-window -c "$target_path" -n "$win_name" "zsh -lic '$SCRIPT_PATH --execute $plan_file'"
        exit 0
    fi

    # Stage 2: Execution in new window
    if [[ "$1" == "--execute" && -f "$2" ]]; then
        local plan_file="$2"
        trap "rm -f \"$plan_file\"" EXIT
        clear
        local -a lines=("${(f)$(< "$plan_file")}")
        local line
        for line in "${lines[@]}"; do
            [[ -z "$line" ]] && continue
            local type=$(echo "$line" | cut -f1)
            if [[ "$type" == "tool" ]]; then
                local tool=$(echo "$line" | cut -f2)
                run_tool_install "$tool"
            elif [[ "$type" == "custom" ]]; then
                local manager=$(echo "$line" | cut -f2)
                local pkg_name=$(echo "$line" | cut -f3)
                run_custom_install "$manager" "$pkg_name"
            fi
        done

        echo ""
        gum_style "Press any key to close..."
        read -k 1 -s -r 2>/dev/null || true
        exit 0
    fi

    # Standalone fallback if run directly without tmux or without arguments
    if ! command -v fzf >/dev/null 2>&1; then
        echo "❌ Error: fzf is not installed."
        exit 1
    fi

    local menu_file
    menu_file=$(mktemp)
    trap "rm -f \"$menu_file\"" EXIT
    build_tool_menu "$menu_file"

    local selections
    selections=$(cat "$menu_file" | fzf --header="Select tool(s) to install/update (TAB to multi-select, ENTER to run):" --multi --ansi --height=100%)
    [[ -z "$selections" ]] && exit 0

    local -a lines=("${(f)selections}")
    local line
    for line in "${lines[@]}"; do
        [[ -z "$line" ]] && continue
        local tool="" manager=""
        if [[ "$line" == "🚀"* || "$line" == ""* || "$line" == "🟠"* || "$line" == "🧑‍💻"* || "$line" == "🧬"* || "$line" == "💖"* || "$line" == "🔷"* || "$line" == "🧠"* || "$line" == "🖱️"* || "$line" == "🥧"* ]]; then
            tool=$(echo "$line" | awk '{print $2}')
            run_tool_install "$tool"
        elif [[ "$line" == "📦"* ]]; then manager="npm"
        elif [[ "$line" == "🦀"* ]]; then manager="cargo"
        elif [[ "$line" == "🐹"* ]]; then manager="go"
        elif [[ "$line" == "🍺"* ]]; then manager="brew"
        elif [[ "$line" == "🐍"* ]]; then manager="pip"
        fi

        if [[ -n "$manager" ]]; then
            local pkg_name=$(get_custom_input "$manager")
            [[ -n "$pkg_name" ]] && run_custom_install "$manager" "$pkg_name"
        fi
    done
} # }}}

main "$@"
