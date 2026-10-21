#!/usr/bin/env zsh
set -euo pipefail

TMP_DIR="/tmp/tmux"
TMP_KEYS_FILE="$TMP_DIR/keybindings_all.txt"

# Ensure tmp dir exists
mkdir -p "$TMP_DIR"

# --- Dump all keybindings to file ---
# Each line is tab separated:
#   1 rendered row (table + key columns padded to the widest entry, command truncated)
#   2 plain table name (used by the Tab reload bind)
#   3 plain key  4 raw `list-keys` line (logging only)
rm -f "$TMP_DIR"/keys-*.txt(N)

# Popup is 90% wide; keep a few cells for the border and the fzf pointer/scrollbar.
cols=$(tmux display -p '#{client_width}' 2>/dev/null || echo 120)
[[ $cols =~ ^[0-9]+$ ]] || cols=120
cols=$(( cols * 9 / 10 ))

tmux list-keys 2>/dev/null | awk -v cols="$cols" -v all="$TMP_KEYS_FILE" '
    {
        raw = $0
        table = "root"
        i = 2
        while (i < NF && substr($i, 1, 1) == "-") {
            if ($i == "-T") { table = $(i + 1); i += 2 } else { i++ }
        }
        key = $i
        cmd = ""
        for (j = i + 1; j <= NF; j++) cmd = (cmd == "" ? $j : cmd " " $j)
        gsub(/\\/, "", key)                       # \; -> ;  (display only)

        n++
        T[n] = table; K[n] = key; C[n] = cmd; R[n] = raw
        if (length(table) > wt) wt = length(table)
        if (length(key) > wk) wk = length(key)
    }
    END {
        wc = cols - wt - wk - 12
        if (wc < 20) wc = 20

        # root and prefix first, everything else in list-keys order
        m = 0
        for (i = 1; i <= n; i++) if (T[i] == "root") ord[++m] = i
        for (i = 1; i <= n; i++) if (T[i] == "prefix") ord[++m] = i
        for (i = 1; i <= n; i++) if (T[i] != "root" && T[i] != "prefix") ord[++m] = i

        for (j = 1; j <= m; j++) {
            i = ord[j]
            cmd = C[i]
            if (length(cmd) > wc) cmd = substr(cmd, 1, wc - 3) "..."
            row = sprintf("\033[38;5;39m%-*s\033[0m  \033[1;33m%-*s\033[0m  %s", wt, T[i], wk, K[i], cmd)
            print row "\t" T[i] "\t" K[i] "\t" R[i] > all
            print row "\t" T[i] "\t" K[i] "\t" R[i] > ("/tmp/tmux/keys-" T[i] ".txt")
        }
    }'

# --- Open FZF in tmux popup ---
# Tab drills into the highlighted table, Shift-Tab goes back to all bindings.
tmux display-popup -E -w 90% -h 90% "
    selected=\$(fzf --ansi \
        --delimiter='\t' \
        --with-nth=1 \
        --prompt='🔍 Search tmux keybindings: ' \
        --exact \
        --no-sort \
        --layout=reverse \
        --info=inline \
        --cycle \
        --height=100% \
        --header='Tab: drill into a table   Enter: open in config' \
        --bind='tab:reload(cat $TMP_DIR/keys-{2}.txt)+change-header(TABLE: {2}   Shift-Tab: all tables)' \
        --bind='btab:reload(cat $TMP_KEYS_FILE)+change-header(ALL TABLES   Tab: drill into a table)' \
        < \"$TMP_KEYS_FILE\")

    code=\$?

    if [ \$code -eq 130 ] || [ -z \"\$selected\" ]; then
        exit 0
    fi

    # Create log file for this search
    ts=\$(date +%s)
    LOG_FILE=\"$TMP_DIR/search-log-\$ts.txt\"

    # Field 2 = table, 3 = key, 4 = raw list-keys line (logging only)
    key_table=\$(echo \"\$selected\" | cut -f2)
    key=\$(echo \"\$selected\" | cut -f3)
    raw=\$(echo \"\$selected\" | cut -f4)

    echo \"=== Keybinding Search Debug Log ===\" > \"\$LOG_FILE\"
    echo \"\" >> \"\$LOG_FILE\"
    echo \"Selected line:\" >> \"\$LOG_FILE\"
    echo \"\$selected\" >> \"\$LOG_FILE\"
    echo \"\" >> \"\$LOG_FILE\"
    echo \"Raw binding:\" >> \"\$LOG_FILE\"
    echo \"\$raw\" >> \"\$LOG_FILE\"
    echo \"\" >> \"\$LOG_FILE\"

    echo \"Extracted key table: \$key_table\" >> \"\$LOG_FILE\"
    echo \"Extracted key: \$key\" >> \"\$LOG_FILE\"
    echo \"\" >> \"\$LOG_FILE\"

    echo \"\" >> \"\$LOG_FILE\"
    echo \"--- Search Attempt ---\" >> \"\$LOG_FILE\"

    # Search in config files
    # Literal table/key comparison avoids matching another binding or its command.
    match=\$(awk -v wanted_table=\"\$key_table\" -v wanted_key=\"\$key\" '
        function unquote(value, quote) {
            quote = substr(value, 1, 1)
            if (quote == sprintf(\"%c\", 39) || quote == sprintf(\"%c\", 34))
                value = substr(value, 2, length(value) - 2)
            if (substr(value, 1, 1) == sprintf(\"%c\", 92)) value = substr(value, 2)
            return value
        }
        \$1 == \"bind\" || \$1 == \"bind-key\" {
            table = \"prefix\"
            i = 2
            while (i < NF) {
                if (\$i == \"-T\") { table = unquote(\$(i + 1)); i += 2 }
                else if (\$i == \"-n\") { table = \"root\"; i++ }
                else if (\$i == \"-r\") i++
                else break
            }
            if (table == wanted_table && unquote(\$i) == wanted_key) {
                print FILENAME \":\" FNR
                exit
            }
        }
    ' \"\$HOME/.config/tmux/tmux.conf.local\" \"\$HOME/.config/tmux/tmux.conf\" 2>/dev/null || true)

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
