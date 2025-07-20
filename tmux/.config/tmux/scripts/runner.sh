#!/usr/bin/env zsh -i

# -------------------------------------------------------------------
# NOTE: Prerequisites {{{
# -------------------------------------------------------------------
# This script requires `jq`, `fzf`, and `gum` to be installed.
# brew install jq fzf gum
# }}}
# -------------------------------------------------------------------

# -------------------------------------------------------------------
# NOTE: Configuration {{{
# -------------------------------------------------------------------
LONG_RUNNING_KEYWORDS=("dev" "start" "watch" "test")
# }}}
# -------------------------------------------------------------------

# -------------------------------------------------------------------
# NOTE: Script Logic {{{
# -------------------------------------------------------------------

if [[ ! -f "package.json" ]]; then
    gum style --bold --foreground="red" "❌ Error: package.json not found in the current directory."
    sleep 2
    exit 1
fi

yarn_cmd="jq -r '.scripts | keys[]' package.json | awk '{print \"yarn \" \$0}'"
npm_cmd="jq -r '.scripts | keys[]' package.json | awk '{print \"npm run \" \$0}'"

FZF_HEADER="───────────────────────────────────
 ✨ Project Runner ✨
 Ctrl-Y: Yarn | Ctrl-J: Npm
 Enter: Run | Type & press Enter to run a custom command
───────────────────────────────────"

selection=$(eval "$yarn_cmd" | fzf \
    --prompt="Select a script to run > " \
    --header="$FZF_HEADER" \
    --header-first \
    --height="100%" \
    --layout=reverse \
    --print-query \
    --bind "ctrl-y:reload($yarn_cmd)" \
    --bind "ctrl-j:reload($npm_cmd)")

if [[ -z $selection ]]; then
    exit 0
fi

query=$(echo "$selection" | head -n 1)
command_to_run=$(echo "$selection" | tail -n 1)

if [[ -z $command_to_run && -n $query ]]; then
    command_to_run=$query
fi

is_long_running=false
for keyword in "${LONG_RUNNING_KEYWORDS[@]}"; do
    if [[ "$command_to_run" == *"$keyword"* ]]; then
        is_long_running=true
        break
    fi
done

clear

if $is_long_running; then
    gum style --bold --foreground="212" "🚀 Running (long): $command_to_run"
    echo "───────────────────────────────────"
    # Run the command directly in this popup
    # Allow user to Ctrl-C to stop
    echo "Press Ctrl-C to stop the process."
    echo ""
    eval "$command_to_run"
    echo ""
    gum confirm "Command finished. Close popup?" --affirmative "Close" > /dev/null
    exit 0
else
    gum style --bold --foreground=212 "🚀 Running: $command_to_run"
    echo "───────────────────────────────────"
    script -q /dev/null zsh -c "$command_to_run"
    echo "───────────────────────────────────"
    gum confirm "Command finished. Close popup?" --affirmative "Close" > /dev/null
    exit 0
fi
# }}}
# -------------------------------------------------------------------
