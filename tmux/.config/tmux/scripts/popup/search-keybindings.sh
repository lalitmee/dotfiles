#!/usr/bin/env zsh
set -euo pipefail

TMP_DIR="/tmp/tmux"
TMP_KEYS_FILE="$TMP_DIR/keybindings_all.txt"

# Ensure tmp dir exists
mkdir -p "$TMP_DIR"

# --- List of known/default key tables ---
tables=(
    root
    prefix
    copy-mode
    copy-mode-vi
    choose-buffer
    choose-client
    choose-tree
    command-prompt
    confirm
    mode-tree
    resize-pane
    split-full-w
    layout-mode
    ask-tools
    ai-tools
    second-brain
)

# --- Dump all keybindings to file ---
> "$TMP_KEYS_FILE"

for table in "${tables[@]}"; do
    {
        echo "### Key Table: $table"
        tmux list-keys -T "$table" 2>/dev/null || echo "(No bindings)"
        echo ""
    } >> "$TMP_KEYS_FILE"
done

# --- Open FZF in tmux popup ---
tmux display-popup -E -w 90% -h 90% "
    selected=\$(fzf --ansi \
        --prompt='🔍 Search tmux keybindings: ' \
        --exact \
        --no-sort \
        --layout=reverse \
        --info=inline \
        --cycle \
        --height=100% \
        < \"$TMP_KEYS_FILE\")

    code=\$?

    if [ \$code -eq 130 ] || [ -z \"\$selected\" ]; then
        exit 0
    fi

    # Create log file for this search
    ts=\$(date +%s)
    LOG_FILE=\"$TMP_DIR/search-log-\$ts.txt\"

    echo \"=== Keybinding Search Debug Log ===\" > \"\$LOG_FILE\"
    echo \"\" >> \"\$LOG_FILE\"
    echo \"Selected line:\" >> \"\$LOG_FILE\"
    echo \"\$selected\" >> \"\$LOG_FILE\"
    echo \"\" >> \"\$LOG_FILE\"

    # Extract key table and key from the selected line
    # Format: bind-key    -T table    key    command...
    key_table=\$(echo \"\$selected\" | awk '{print \$3}')
    key=\$(echo \"\$selected\" | awk '{print \$4}')

    echo \"Extracted key table: \$key_table\" >> \"\$LOG_FILE\"
    echo \"Extracted key: \$key\" >> \"\$LOG_FILE\"
    echo \"\" >> \"\$LOG_FILE\"

    # Build search patterns based on the key table and key
    search_pattern=\"\"

    # Normalize the key for searching (remove quotes if present)
    clean_key=\$(echo \"\$key\" | tr -d \"'\\\"\")

    echo \"--- Search Strategy ---\" >> \"\$LOG_FILE\"

    # Different search strategies based on key table
    if [ \"\$key_table\" = \"root\" ]; then
        # For root table, search for: bind -n 'key' or bind-key -n 'key'
        echo \"Root table binding - searching for: bind.*-n.*\$clean_key\" >> \"\$LOG_FILE\"
        search_pattern=\"bind.*-n.*\$clean_key\"
    elif [ \"\$key_table\" = \"prefix\" ]; then
        # For prefix table, search for: bind 'key' or bind-key 'key' (without -T or -n)
        echo \"Prefix table binding - searching for: bind.*[^-T].*\$clean_key\" >> \"\$LOG_FILE\"
        search_pattern=\"bind.*\$clean_key\"
    else
        # For other tables, search for: bind -T table_name 'key'
        echo \"Named table binding - searching for: bind.*-T.*\$key_table.*\$clean_key\" >> \"\$LOG_FILE\"
        search_pattern=\"bind.*-T.*\$key_table.*\$clean_key\"
    fi

    echo \"\" >> \"\$LOG_FILE\"
    echo \"--- Search Attempt ---\" >> \"\$LOG_FILE\"

    # Search in config files
    match=\$(grep -n \"\$search_pattern\" \"\$HOME/.tmux.conf.local\" \"\$HOME/.tmux/.tmux.conf\" 2>/dev/null | head -1 || true)

    if [ -n \"\$match\" ]; then
        echo \"✓ Found match: \$match\" >> \"\$LOG_FILE\"
        file_path=\$(echo \"\$match\" | cut -d: -f1)
        line_number=\$(echo \"\$match\" | cut -d: -f2)
        tmux new-window \"nvim +\$line_number \$file_path\"
        exit 0
    else
        echo \"✗ No match found with pattern: \$search_pattern\" >> \"\$LOG_FILE\"
    fi

    # Fallback: Try simpler key-only search
    echo \"\" >> \"\$LOG_FILE\"
    echo \"--- Fallback: Simple key search ---\" >> \"\$LOG_FILE\"

    match=\$(grep -n \"bind.*\$clean_key\" \"\$HOME/.tmux.conf.local\" \"\$HOME/.tmux/.tmux.conf\" 2>/dev/null | head -1 || true)

    if [ -n \"\$match\" ]; then
        echo \"✓ Found match: \$match\" >> \"\$LOG_FILE\"
        file_path=\$(echo \"\$match\" | cut -d: -f1)
        line_number=\$(echo \"\$match\" | cut -d: -f2)
        tmux new-window \"nvim +\$line_number \$file_path\"
        exit 0
    else
        echo \"✗ No match found\" >> \"\$LOG_FILE\"
    fi

    # No match found - show debug log
    echo \"\" >> \"\$LOG_FILE\"
    echo \"=== No match found ===\" >> \"\$LOG_FILE\"
    echo \"\" >> \"\$LOG_FILE\"
    echo \"Searched in:\" >> \"\$LOG_FILE\"
    echo \"  - \$HOME/.tmux.conf.local\" >> \"\$LOG_FILE\"
    echo \"  - \$HOME/.tmux/.tmux.conf\" >> \"\$LOG_FILE\"
    echo \"\" >> \"\$LOG_FILE\"
    echo \"Tip: The keybinding might be defined in a plugin or\" >> \"\$LOG_FILE\"
    echo \"      using a different syntax than expected.\" >> \"\$LOG_FILE\"
    echo \"\" >> \"\$LOG_FILE\"
    echo \"Press any key to close...\" >> \"\$LOG_FILE\"

    \${EDITOR:-vim} \"\$LOG_FILE\"
"
