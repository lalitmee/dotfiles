#!/usr/bin/env zsh

# A script to select, install, or update predefined AI tools and custom CLI packages.
# Uses fzf for multi-selection, gum for UI styling, and zsh login shell context for paths.

set +e  # Ensure script doesn't crash on individual command failures

# --- Source utilities ---
# {{{
if [[ -f "$HOME/dotfiles/scripts/install/utils.zsh" ]]; then
    source "$HOME/dotfiles/scripts/install/utils.zsh"
fi
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

confirm_action() { # {{{
    local prompt="$1"
    if command -v gum >/dev/null 2>&1; then
        gum confirm "$prompt"
    else
        echo -n "$prompt [y/N]: "
        read -r reply
        [[ "$reply" =~ ^[Yy]$ ]]
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

get_plandex_version() { # {{{
    plandex version 2>/dev/null | head -1 || echo "Not Installed"
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

    gum_style "Downloading $tool_name installer..."
    if ! curl -fsSL "$url" -o "$tmp_file"; then
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

    if confirm_action "Do you want to execute the $tool_name installer?"; then
        bash "$tmp_file"
        return $?
    else
        gum_style "⚠️  Skipping execution of $tool_name installer."
        return 1
    fi
} # }}}

# --- Main Logic ---

main() { # {{{
    # 1. Dependency checks
    if ! command -v fzf >/dev/null 2>&1; then
        tmux display-message "❌ Error: fzf is not installed."
        exit 1
    fi

    echo "🔍 Fetching tool versions... Please wait."

    # Fetch all global NPM package versions in one fast call
    local NPM_JSON
    NPM_JSON=$(npm list -g --depth=0 --json 2>/dev/null || echo "{}")

    # Retrieve all versions
    local ver_agy=$(get_agy_version)
    local ver_claude=$(get_npm_version_fast "@anthropic-ai/claude-code")
    local ver_copilot=$(get_npm_version_fast "@github/copilot")
    local ver_opencode=$(get_npm_version_fast "opencode-ai")
    local ver_grok=$(get_npm_version_fast "@vibe-kit/grok-cli")
    local ver_codex=$(get_npm_version_fast "@openai/codex")
    local ver_crush=$(get_crush_version)
    local ver_plandex=$(get_plandex_version)
    local ver_kiro=$(get_kiro_version)
    local ver_cursor=$(get_cursor_agent_version)

    # 2. Present interactive selection list via fzf
    local selections
    selections=$(printf "%s\n" \
        "✨ agy ($ver_agy)" \
        "✨ claude ($ver_claude)" \
        "  copilot ($ver_copilot)" \
        "🧑‍💻 opencode ($ver_opencode)" \
        "🧠 grok ($ver_grok)" \
        "🚀 codex ($ver_codex)" \
        "💖 crush ($ver_crush)" \
        "📋 plandex ($ver_plandex)" \
        "🤖 kiro ($ver_kiro)" \
        "🧭 cursor-agent ($ver_cursor)" \
        "📦 [npm] Install/update custom global npm package..." \
        "🦀 [cargo] Install/update custom cargo package..." \
        "🐹 [go] Install/update custom go package..." \
        "🍺 [brew] Install/update custom brew formula..." \
        "🐍 [pip] Install/update custom python pip package..." \
        | fzf --header="Select tool(s) to install/update (TAB to multi-select, ENTER to run):" --multi --ansi --height=18)

    if [[ -z "$selections" ]]; then
        # User pressed ESC, exit clean
        exit 0
    fi

    # Process each selected line using zsh newline splitting to keep stdin intact for TTY input/output
    local -a lines
    lines=("${(f)selections}")

    local line
    for line in "${lines[@]}"; do
        [[ -z "$line" ]] && continue
        
        local tool=""
        local manager=""
        
        # Identify tool or package manager
        if [[ "$line" == "✨"* || "$line" == ""* || "$line" == "🧑‍💻"* || "$line" == "🧠"* || "$line" == "🚀"* || "$line" == "📋"* || "$line" == "🤖"* || "$line" == "💖"* || "$line" == "🧭"* ]]; then
            tool=$(echo "$line" | awk '{print $2}')
        elif [[ "$line" == "📦"* ]]; then
            manager="npm"
        elif [[ "$line" == "🦀"* ]]; then
            manager="cargo"
        elif [[ "$line" == "🐹"* ]]; then
            manager="go"
        elif [[ "$line" == "🍺"* ]]; then
            manager="brew"
        elif [[ "$line" == "🐍"* ]]; then
            manager="pip"
        fi

        local name_to_install=""
        if [[ -n "$manager" ]]; then
            name_to_install=$(get_custom_input "$manager")
            if [[ -z "$name_to_install" ]]; then
                gum_style "⚠️  Skipping empty custom $manager installation."
                continue
            fi
            tool="$name_to_install"
        fi

        echo ""
        if ! confirm_action "Install or update $tool?"; then
            gum_style "⚠️  Skipped $tool."
            continue
        fi

        echo ""
        gum_style "🚀 Starting install/update process for $tool..."
        echo ""

        local install_status=0
        if [[ -n "$manager" ]]; then
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
        else
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
                    install_npm_global "opencode-ai@latest" || install_status=$?
                    ;;
                grok)
                    install_npm_global "@vibe-kit/grok-cli@latest" || install_status=$?
                    ;;
                codex)
                    install_npm_global "@openai/codex@latest" || install_status=$?
                    ;;
                crush)
                    go install github.com/charmbracelet/crush@latest || install_status=$?
                    ;;
                plandex)
                    secure_run_script "https://plandex.ai/install.sh" "Plandex" || install_status=$?
                    ;;
                kiro)
                    secure_run_script "https://cli.kiro.dev/install" "Kiro CLI" || install_status=$?
                    ;;
                cursor-agent)
                    cursor-agent update || install_status=$?
                    ;;
            esac
        fi

        echo ""
        if [[ $install_status -eq 0 ]]; then
            gum_style "✅ $tool successfully installed/updated!"
        else
            gum_style "❌ Failed to install/update $tool."
        fi
        echo ""
    done

    gum_style "Press any key to close..."
    read -k 1 -s -r 2>/dev/null || true
} # }}}

main "$@"
