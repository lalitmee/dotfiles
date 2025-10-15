#!/usr/bin/env zsh

# A script to update the AI CLI tools used with the tmux popup.
# It uses 'gum' for styled output and displays a summary of version changes.
# It will automatically run in a tmux popup if launched from within a tmux session.

# --- Self-bootstrap when invoked from tmux without a TTY ---
# If running inside tmux and not already in an update window, re-exec in a new tmux window
# under a login/interactive zsh so PATH (npm/yarn) and other env are loaded properly.
if [[ -n "$TMUX" && -z "$AI_UPDATE_IN_WINDOW" ]]; then
    tmux new-window -n 'ai-update' "zsh -lic 'AI_UPDATE_IN_WINDOW=1 \"$0\"'"
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
        local package_name=$1
        gum_style "Checking for updates for: $package_name..."

        local old_version=$(get_npm_version "$package_name")

        if npm install -g "$package_name@latest"; then
            local new_version=$(get_npm_version "$package_name")
            local status_icon="➡️" # Default: No Change

            if [[ "$old_version" == "Not Installed" ]]; then
                status_icon="✨" # Newly Installed
            elif [[ "$old_version" != "$new_version" ]]; then
                status_icon="⬆️" # Updated
            fi

            gum_style "✅ Success: $package_name processed."
            update_summary+=("$package_name,$status_icon,$old_version,$new_version")
        else
            gum_style "❌ Error: Failed to update $package_name. Check the output above."
            update_summary+=("$package_name,❌,$old_version,Update Failed")
        fi
    }

    # 2. Update NPM Packages
    update_npm_package "@google/gemini-cli"
    update_npm_package "@anthropic-ai/claude-code"
    update_npm_package "@github/copilot"
    update_npm_package "opencode-ai"

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

    # Pipe the CSV data into gum table. Removed the --widths flag for compatibility.
    if ! echo -e "$summary_string" | gum table; then
        gum_style "⚠️  Warning: Could not display summary table."
        echo
        gum_style "Debug Info: The following data caused the error:"
        echo "----------------------------------------------------"
        echo -e "$summary_string"
        echo "----------------------------------------------------"
        gum_style "Check for extra commas or special characters in the data above."
    fi

    gum_style "✨ Update process complete. ✨"

    echo
    read -n 1 -s -r -p "Press any key to close..."
}

# Run the updates
run_updates
