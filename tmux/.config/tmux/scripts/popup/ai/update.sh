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

        if npm install -g "$package_name_with_tag"; then
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
            gum_style "❌ Error: Failed to update $package_name_with_tag. Check the output above."
            update_summary+=("$base_package_name,❌,$old_version,Update Failed")
        fi
    }

    # Check update mode (prefer environment variable over command line args)
    UPDATE_MODE="${UPDATE_MODE:-${1:-all}}"  # Env var takes precedence, then arg, then 'all'

    # 2. Update NPM Packages (Non-interactive)
    if [[ "$UPDATE_MODE" == "all" || "$UPDATE_MODE" == "--non-interactive" ]]; then
        update_npm_package "@google/gemini-cli@preview"
        update_npm_package "@anthropic-ai/claude-code@latest"
        update_npm_package "@github/copilot@latest"
        update_npm_package "opencode-ai@latest"
        update_npm_package "@vibe-kit/grok-cli@latest"
    fi

    # 2.5 Update Non-NPM Tools
    if [[ "$UPDATE_MODE" == "all" || "$UPDATE_MODE" == "--non-interactive" ]]; then
        gum_style "🔄 Updating non-interactive tools..."

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
            if curl -sL https://plandex.ai/install.sh | bash; then
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
        else
            gum_style "Plandex not installed, skipping update."
        fi

        # Kiro: Re-run install script (may prompt for confirmation)
        if command_exists kiro-cli; then
            old_version=$(get_kiro_version)
            gum_style "Updating Kiro CLI (may prompt for confirmation)..."
            if curl -fsSL https://cli.kiro.dev/install | bash; then
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
        # Always show text table format (more reliable in tmux)
        echo "┌─────────────────────────────────────────────────────────────┐"
        printf "│ %-20s │ %-6s │ %-12s │ %-12s │\n" "Tool" "Status" "Old Version" "New Version"
        echo "├─────────────────────────────────────────────────────────────┤"

        for row in "${update_summary[@]}"; do
            if [[ "$row" != "Tool,Status,Old Version,New Version" ]]; then
                IFS=',' read -r tool update_status old_ver new_ver <<< "$row"
                printf "│ %-20s │ %-6s │ %-12s │ %-12s │\n" "$tool" "$update_status" "$old_ver" "$new_ver"
            fi
        done

        echo "└─────────────────────────────────────────────────────────────┘"
    else
        gum_style "ℹ️  No updates were processed."
    fi

    gum_style "✨ Update process complete. ✨"

    echo
    # Wait for user input so they can see the results
    echo
    if [[ -n "$AI_UPDATE_IN_WINDOW" ]]; then
        gum_style "Results displayed above. Window will auto-close in 30 seconds."
        gum_style "Use Ctrl+C or tmux commands to close immediately if needed."
        sleep 30
    elif [[ -t 0 ]]; then
        gum_style "Press any key to close..."
        read -n 1 -s -r 2>/dev/null || true
    fi
}

# Run the updates
run_updates
