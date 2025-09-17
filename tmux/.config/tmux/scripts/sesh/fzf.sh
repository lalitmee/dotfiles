#!/bin/bash
# This script launches the fzf-tmux interface for sesh.

# Detect OS and set appropriate directory exclusions
if [[ "$OSTYPE" == "darwin"* ]]; then
    # macOS: exclude .Trash directories (scattered trash folders)
    DIR_EXCLUDE="-E .Trash"
    FIND_EXCLUDE="-name .Trash"
else
    # Linux/Ubuntu: exclude cache and local directories
    DIR_EXCLUDE="-E .cache -E .local"
    FIND_EXCLUDE="-name .cache -o -name .local"
fi

# Build the directory listing command
if command -v fd &> /dev/null; then
    # Use fd if available (faster)
    DIR_CMD="fd -H -d 2 -t d $DIR_EXCLUDE . ~"
else
    # Fall back to find
    DIR_CMD="find . ~ -maxdepth 2 -type d \( $FIND_EXCLUDE \) -prune -o -type d -print"
fi

sesh connect "$(
    sesh list --icons | fzf \
        --height 80% \
        --no-sort \
        --ansi \
        --border-label ' sesh ' \
        --prompt '⚡  ' \
        --header '  ^a all ^t tmux ^g configs ^x zoxide ^d tmux kill ^f find' \
        --bind 'tab:down,btab:up' \
        --bind 'ctrl-a:change-prompt(⚡  )+reload(sesh list --icons)' \
        --bind 'ctrl-t:change-prompt(🪟  )+reload(sesh list -t --icons)' \
        --bind 'ctrl-g:change-prompt(⚙️  )+reload(sesh list -c --icons)' \
        --bind 'ctrl-x:change-prompt(📁  )+reload(sesh list -z --icons)' \
        --bind "ctrl-f:change-prompt(🔎  )+reload($DIR_CMD)" \
        --bind 'ctrl-d:execute(tmux kill-session -t {2..})+change-prompt(⚡  )+reload(sesh list --icons)' \
        --color='fg:#FFFFFF,bg:#193549,hl:#FFC600,fg+:#FFFFFF,bg+:#185294,hl+:#FF9D00,info:#8fbfdc,prompt:#3AD900,pointer:#00AAFF'
)"
