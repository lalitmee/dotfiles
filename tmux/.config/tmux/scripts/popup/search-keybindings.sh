#!/usr/bin/env zsh
set -euo pipefail

TMP_DIR="/tmp/tmux"
TMP_KEYS_FILE="$TMP_DIR/keybindings_all.txt"

# Ensure tmp dir exists
mkdir -p "$TMP_DIR"

# --- Discover key tables from the running server (no stale hardcoded list) ---
tables=(${(f)"$(tmux list-keys 2>/dev/null | awk '
    {
        for (i = 1; i < NF; i++) {
            if ($i == "-T") { print $(i + 1); next }
            if ($i == "-n") { print "root"; next }
        }
    }' | sort -u)"})
# root and prefix are the ones people actually use; keep them on top
others=(${tables:#root})
others=(${others:#prefix})
tables=(root prefix $others)

# --- Dump all keybindings to file ---
# Line format (tab separated):
#   1 table (padded, coloured)  2 key (padded, coloured)  3 command
#   4 table (plain, for reload)  5 raw `list-keys` line (for edit-in-config)
> "$TMP_KEYS_FILE"

for table in "${tables[@]}"; do
    bindings=$(tmux list-keys -T "$table" 2>/dev/null | awk -v t="$table" '
        {
            raw = $0
            line = raw
            sub(/^bind-key[ \t]+/, "", line)
            sub(/^-T[ \t]+[^ \t]+[ \t]+/, "", line)
            sub(/^-n[ \t]+/, "", line)
            key = line
            sub(/[ \t].*$/, "", key)
            cmd = line
            sub(/^[^ \t]+[ \t]+/, "", cmd)
            disp = key
            gsub(/\\/, "", disp)
            printf "\033[38;5;39m%-17s\033[0m\t\033[1;33m%-14s\033[0m\t%s\t%s\t%s\n", t, disp, cmd, t, raw
        }') || bindings=""

    printf '%s\n' "$bindings" > "$TMP_DIR/keys-$table.txt"
    printf '%s\n' "$bindings" >> "$TMP_KEYS_FILE"
done

# --- Open FZF in tmux popup ---
# Tab drills into the highlighted table, Shift-Tab goes back to all bindings.
tmux display-popup -E -w 90% -h 90% "
    selected=\$(fzf --ansi \
        --delimiter='\t' \
        --with-nth=1,2,3 \
        --prompt='🔍 Search tmux keybindings: ' \
        --exact \
        --no-sort \
        --layout=reverse \
        --info=inline \
        --cycle \
        --height=100% \
        --border=rounded \
        --border-label=' tmux keybindings ' \
        --header='TABLE              KEY            COMMAND            Tab: drill into table' \
        --bind='tab:reload(cat $TMP_DIR/keys-{4}.txt)+change-header(TABLE: {4}   Shift-Tab: all tables)' \
        --bind='btab:reload(cat $TMP_KEYS_FILE)+change-header(ALL TABLES   Tab: drill into a table)' \
        < \"$TMP_KEYS_FILE\")

    code=\$?

    if [ \$code -eq 130 ] || [ -z \"\$selected\" ]; then
        exit 0
    fi

    # Create log file for this search
    ts=\$(date +%s)
    LOG_FILE=\"$TMP_DIR/search-log-\$ts.txt\"

    # Field 5 is the raw list-keys line: bind-key -T <table> <key> <command...>
    raw=\$(echo \"\$selected\" | cut -f5)

    echo \"=== Keybinding Search Debug Log ===\" > \"\$LOG_FILE\"
    echo \"\" >> \"\$LOG_FILE\"
    echo \"Selected line:\" >> \"\$LOG_FILE\"
    echo \"\$selected\" >> \"\$LOG_FILE\"
    echo \"\" >> \"\$LOG_FILE\"
    echo \"Raw binding:\" >> \"\$LOG_FILE\"
    echo \"\$raw\" >> \"\$LOG_FILE\"
    echo \"\" >> \"\$LOG_FILE\"

    # Extract key table and key from the selected line
    # Format: bind-key    -T table    key    command...
    key_table=\$(echo \"\$raw\" | awk '{print \$3}')
    key=\$(echo \"\$raw\" | awk '{print \$4}')

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
    match=\$(grep -n \"\$search_pattern\" \"\$HOME/.config/tmux/tmux.conf.local\" \"\$HOME/.config/tmux/tmux.conf\" 2>/dev/null | head -1 || true)

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

    match=\$(grep -n \"bind.*\$clean_key\" \"\$HOME/.config/tmux/tmux.conf.local\" \"\$HOME/.config/tmux/tmux.conf\" 2>/dev/null | head -1 || true)

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
    echo \"  - \$HOME/.config/tmux/tmux.conf.local\" >> \"\$LOG_FILE\"
    echo \"  - \$HOME/.config/tmux/tmux.conf\" >> \"\$LOG_FILE\"
    echo \"\" >> \"\$LOG_FILE\"
    echo \"Tip: The keybinding might be defined in a plugin or\" >> \"\$LOG_FILE\"
    echo \"      using a different syntax than expected.\" >> \"\$LOG_FILE\"
    echo \"\" >> \"\$LOG_FILE\"
    echo \"Press any key to close...\" >> \"\$LOG_FILE\"

    \${EDITOR:-vim} \"\$LOG_FILE\"
"
