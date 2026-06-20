#!/usr/bin/env zsh

# A script to update the AI CLI tools used with the tmux popup.
# It uses 'gum' for styled output and displays a summary of version changes.
# It will automatically run in a tmux popup if launched from within a tmux session.

# --- Self-bootstrap when invoked from tmux without a TTY ---
# If running inside tmux and not already in an update window, re-exec in a new tmux window
# under a login/interactive zsh so PATH (npm/yarn) and other env are loaded properly.
if [[ -n "$TMUX" && -z "$AI_UPDATE_IN_WINDOW" ]]; then
    # Set window name based on update mode
    if [[ "$UPDATE_MODE" == "--non-interactive" ]]; then
        WINDOW_NAME="ai-update-auto"
    elif [[ "$UPDATE_MODE" == "--interactive" ]]; then
        WINDOW_NAME="ai-update-manual"
    else
        WINDOW_NAME="ai-update"
    fi

    # Preserve environment variables and arguments
    tmux new-window -n "$WINDOW_NAME" "zsh -lic \"AI_UPDATE_IN_WINDOW=1 UPDATE_MODE='$UPDATE_MODE' '$0'\""
    exit 0
fi

# --- Main update logic is wrapped in a function ---
run_updates() {
    set -e # Exit immediately if a command exits with a non-zero status.

    # Initialize an array to store summary data for the final table.
    # The first element is the header row. We've added a "Status" column.
    declare -a update_summary=("Tool,Status,Old Version,New Version")

    # --- Helper function to check if a command exists ---
    command_exists() {
        command -v "$1" > /dev/null 2>&1
    }

    # --- Helper to get the installed version of a global npm package ---
    get_npm_version() {
        local package_name=$1
        # `npm list` can fail if the package isn't installed. We catch that.
        local version_info=$(npm list -g --depth=0 "$package_name" 2> /dev/null | grep "$package_name") || true
        if [[ -n "$version_info" ]]; then
            # Parses output like '...@google/gemini-cli@0.4.1' to get '0.4.1'
            echo "$version_info" | awk -F@ '{print $NF}'
        else
            echo "Not Installed"
        fi
    }

    # --- Helper to get version of non-npm tools ---
    get_crush_version() {
        crush --version 2>/dev/null | awk '{print $NF}' || echo "Unknown"
    }

    get_plandex_version() {
        plandex version 2>/dev/null | head -1 || echo "Unknown"
    }

    get_kiro_version() {
        kiro-cli --version 2>/dev/null | awk '{print $NF}' || echo "Unknown"
    }

    get_agy_version() {
        agy --version 2>/dev/null || echo "Unknown"
    }

    get_codex_version() {
        codex --version 2>/dev/null | awk '{print $NF}' || echo "Unknown"
    }

    # 1. Dependency Check
    for cmd in gum gum_style; do
        if ! command_exists "$cmd"; then
            echo "❌ Critical Error: '$cmd' command not found. Please ensure it is installed and in your PATH."
            exit 1
        fi
    done

    for cmd in npm curl; do
        if ! command_exists "$cmd"; then
            gum_style "❌ Critical Error: '$cmd' command not found. Please ensure it is installed."
            exit 1
        fi
    done

    gum_style "🚀 Starting AI CLI Updater..."

    # --- Helper function to update a global npm package ---
    update_npm_package() {
        local package_name_with_tag=$1
        # Extract the base package name by removing the tag (e.g., '@latest').
        # This is crucial for checking the currently installed version.
        local base_package_name=$(echo "$package_name_with_tag" | sed -E 's/@[^@]*$//')

        gum_style "Checking for updates for: $package_name_with_tag..."

        local old_version=$(get_npm_version "$base_package_name")

        # Capture both stdout and stderr to check for errors
        local install_output
        if install_output=$(npm install -g "$package_name_with_tag" 2>&1); then
            local new_version=$(get_npm_version "$base_package_name")
            local status_icon="➡️" # Default: No Change

            if [[ "$old_version" == "Not Installed" ]]; then
                status_icon="✨" # Newly Installed
            elif [[ "$old_version" != "$new_version" ]]; then
                status_icon="⬆️" # Updated
            fi

            gum_style "✅ Success: $package_name_with_tag processed."
            update_summary+=("$base_package_name,$status_icon,$old_version,$new_version")
        else
            # Check for ENOTEMPTY error
            if echo "$install_output" | grep -q "ENOTEMPTY"; then
                gum_style "⚠️  ENOTEMPTY error detected. Attempting to fix..."

                # Try to find the installation path to remove
                # We assume the standard global node_modules location
                local npm_root=$(npm root -g)
                local package_path="$npm_root/$base_package_name"

                if [[ -d "$package_path" ]]; then
                    gum_style "🗑️  Removing corrupted installation at: $package_path"
                    rm -rf "$package_path"

                    gum_style "🔄 Retrying installation..."
                    if npm install -g "$package_name_with_tag"; then
                        local new_version=$(get_npm_version "$base_package_name")
                        gum_style "✅ Success: $package_name_with_tag installed after fix."
                        update_summary+=("$base_package_name,✨,$old_version,$new_version (Fixed)")
                        return 0
                    else
                        gum_style "❌ Error: Retry failed for $package_name_with_tag."
                    fi
                else
                    gum_style "❌ Error: Could not locate package path at $package_path to fix."
                fi
            fi

            gum_style "❌ Error: Failed to update $package_name_with_tag."
            # print the error output for debugging
            echo "$install_output"
            update_summary+=("$base_package_name,❌,$old_version,Update Failed")
        fi
    }

    # Check update mode (prefer environment variable over command line args)
    UPDATE_MODE="${UPDATE_MODE:-${1:-all}}"  # Env var takes precedence, then arg, then 'all'

    # 2. Update NPM Packages (Non-interactive)
    if [[ "$UPDATE_MODE" == "all" || "$UPDATE_MODE" == "--non-interactive" ]]; then
        update_npm_package "@anthropic-ai/claude-code@latest"
        update_npm_package "@github/copilot@latest"
        update_npm_package "opencode-ai@latest"
        update_npm_package "@vibe-kit/grok-cli@latest"
        update_npm_package "@openai/codex@latest"
    fi

    # 2.5 Update Non-NPM Tools
    if [[ "$UPDATE_MODE" == "all" || "$UPDATE_MODE" == "--non-interactive" ]]; then
        gum_style "🔄 Updating non-interactive tools..."

        # Antigravity CLI: Update via built-in updater
        if command_exists agy; then
            old_version=$(get_agy_version)
            gum_style "Updating Antigravity CLI (agy)..."
            if agy update; then
                new_version=$(get_agy_version)
                status_icon="➡️" # Default: No Change

                if [[ "$old_version" != "$new_version" ]]; then
                    status_icon="⬆️" # Updated
                fi

                gum_style "✅ Success: Antigravity CLI updated."
                update_summary+=("agy,$status_icon,$old_version,$new_version")
            else
                gum_style "❌ Error: Failed to update Antigravity CLI."
                update_summary+=("agy,❌,$old_version,Update Failed")
            fi
        else
            gum_style "Antigravity CLI (agy) not installed, skipping update."
        fi

        # Crush: Re-install via go (non-interactive)
        if command_exists crush; then
            old_version=$(get_crush_version)
            gum_style "Updating Crush..."
            if go install github.com/charmbracelet/crush@latest; then
                new_version=$(get_crush_version)
                status_icon="➡️" # Default: No Change

                if [[ "$old_version" != "$new_version" ]]; then
                    status_icon="⬆️" # Updated
                fi

                gum_style "✅ Success: Crush updated."
                update_summary+=("crush,$status_icon,$old_version,$new_version")
            else
                gum_style "❌ Error: Failed to update Crush."
                update_summary+=("crush,❌,$old_version,Update Failed")
            fi
        else
            gum_style "Crush not installed, skipping update."
        fi
    fi

    if [[ "$UPDATE_MODE" == "all" || "$UPDATE_MODE" == "--interactive" ]]; then
        gum_style "🔄 Updating interactive tools (may require user input)..."

        # Plandex: Re-run install script (requires sudo)
        if command_exists plandex; then
            old_version=$(get_plandex_version)
            gum_style "Updating Plandex (may require sudo password)..."

            PLANDEX_URL="https://plandex.ai/install.sh"
            PLANDEX_INSTALLER="/tmp/plandex_installer.sh"

            # Since plandex.ai might be down or unreachable in some environments, we try to download first.
            if curl -fsSL "$PLANDEX_URL" -o "$PLANDEX_INSTALLER"; then
                chmod +x "$PLANDEX_INSTALLER"
                if "$PLANDEX_INSTALLER"; then
                    new_version=$(get_plandex_version)
                    status_icon="➡️" # Default: No Change
                    if [[ "$old_version" == "Unknown" && "$new_version" != "Unknown" ]]; then
                        status_icon="✨" # Newly Installed
                    elif [[ "$old_version" != "$new_version" ]]; then
                        status_icon="⬆️" # Updated
                    fi
                    gum_style "✅ Success: Plandex updated."
                    update_summary+=("plandex,$status_icon,$old_version,$new_version")
                else
                    gum_style "❌ Error: Failed to update Plandex."
                    update_summary+=("plandex,❌,$old_version,Update Failed")
                fi
                rm -f "$PLANDEX_INSTALLER"
            else
                gum_style "❌ Error: Failed to download Plandex installer."
                update_summary+=("plandex,❌,$old_version,Download Failed")
            fi
        else
            gum_style "Plandex not installed, skipping update."
        fi

        # Kiro: Re-run install script (may prompt for confirmation)
        if command_exists kiro-cli; then
            old_version=$(get_kiro_version)
            gum_style "Updating Kiro CLI (may prompt for confirmation)..."

            KIRO_URL="https://cli.kiro.dev/install"
            KIRO_HASH="ea69004b199f7eec758a9f24da14f4ce866f9922d981ce4943ca638e94293e53"
            KIRO_INSTALLER="/tmp/kiro_installer.sh"

            if curl -fsSL "$KIRO_URL" -o "$KIRO_INSTALLER"; then
                actual_hash=$(sha256sum "$KIRO_INSTALLER" | awk '{print $1}')
                if [[ "$actual_hash" == "$KIRO_HASH" ]]; then
                    chmod +x "$KIRO_INSTALLER"
                    if "$KIRO_INSTALLER"; then
                        new_version=$(get_kiro_version)
                        status_icon="➡️" # Default: No Change
                        if [[ "$old_version" == "Unknown" && "$new_version" != "Unknown" ]]; then
                            status_icon="✨" # Newly Installed
                        elif [[ "$old_version" != "$new_version" ]]; then
                            status_icon="⬆️" # Updated
                        fi
                        gum_style "✅ Success: Kiro CLI updated."
                        update_summary+=("kiro-cli,$status_icon,$old_version,$new_version")
                    else
                        gum_style "❌ Error: Failed to update Kiro CLI."
                        update_summary+=("kiro-cli,❌,$old_version,Update Failed")
                    fi
                else
                    gum_style "❌ Error: SHA256 hash mismatch for Kiro installer."
                    update_summary+=("kiro-cli,❌,$old_version,Verification Failed")
                fi
                rm -f "$KIRO_INSTALLER"
            else
                gum_style "❌ Error: Failed to download Kiro installer."
                update_summary+=("kiro-cli,❌,$old_version,Download Failed")
            fi
        else
            gum_style "Kiro CLI not installed, skipping update."
        fi
    fi

    # 3. Display Final Summary Table
    echo
    gum_style "📊 Update Summary"

    # We disable exit-on-error here to ensure the script always waits for input,
    # even if the gum table command fails for some reason.
    set +e

    # Convert the summary array to a newline-separated string for piping to gum table
    local summary_string=""
    for row in "${update_summary[@]}"; do
        summary_string+="$row\n"
    done

    # Display the summary table
    gum_style "📊 Update Summary"
    echo

    if [[ ${#update_summary[@]} -gt 1 ]]; then
        # Use gum table for interactive display
        # The first line of summary_string is the header
        echo -e "$summary_string" | gum table --border rounded --height 10
    else
        gum_style "ℹ️  No updates were processed."
    fi

    gum_style "✨ Update process complete. ✨"

    echo
    # Wait for user input so they can see the results
    echo
    if [[ -n "$AI_UPDATE_IN_WINDOW" ]]; then
        # gum table is interactive and waits for user to close it, so we don't need sleep here.
        # But if gum table wasn't shown (no updates), we might want to pause.
        if [[ ${#update_summary[@]} -le 1 ]]; then
             gum_style "Press any key to close..."
             read -n 1 -s -r 2>/dev/null || true
        fi
    elif [[ -t 0 ]]; then
        # If running in a terminal but not in the special window mode (unlikely given the script logic),
        # we still might want to pause if gum table wasn't shown.
        if [[ ${#update_summary[@]} -le 1 ]]; then
            gum_style "Press any key to close..."
            read -n 1 -s -r 2>/dev/null || true
        fi
    fi
}

# Run the updates
run_updates
