#!/usr/bin/env zsh
set -euo pipefail

TMP_DIR="/tmp/tmux"
TMP_KEYS_FILE="$TMP_DIR/keybindings_all.txt"
TMP_TABLES_FILE="$TMP_DIR/keytables.txt"

# Ensure tmp dir exists
mkdir -p "$TMP_DIR"

# --- Dump all keybindings to file ---
# Each line is tab separated:
#   1 rendered row (table + key columns padded to the widest entry, command truncated)
#   2 plain table name (used by the Tab reload bind)
#   3 plain key  4 raw `list-keys` line (logging only)
rm -f "$TMP_DIR"/keys-*.txt(N)
: > "$TMP_TABLES_FILE"

# Popup is 90% wide; keep a few cells for the border and the fzf pointer/scrollbar.
cols=$(tmux display -p '#{client_width}' 2>/dev/null || echo 120)
[[ $cols =~ ^[0-9]+$ ]] || cols=120
cols=$(( cols * 9 / 10 ))
prefix=$(tmux show-option -gv prefix)

tmux list-keys 2>/dev/null | awk -v cols="$cols" -v prefix="$prefix" -v all="$TMP_KEYS_FILE" -v tables="$TMP_TABLES_FILE" '
    BEGIN {
        split("255;198;0 0;170;255 58;217;0 255;98;140 255;157;0 150;126;251 128;252;255 238;128;225 242;237;127 187;255;221 66;133;244 234;67;53 251;188;5 52;168;83", palette, " ")
        for (p in palette) used[palette[p]] = 1
        wt = 5
        entry["prefix"] = prefix
    }
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
        count[table]++
        for (j = i + 1; j + 2 <= NF; j++) {
            if ($j != "switch-client" || $(j + 1) != "-T") continue
            target = $(j + 2)
            gsub(/^["\047]|["\047]$/, "", target)
            trigger = (table == "prefix" ? prefix " → " : table == "root" ? "" : table " → ") key
            if (!trigger_seen[target SUBSEP trigger]++)
                entry[target] = entry[target] (entry[target] == "" ? "" : ", ") trigger
        }
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

        we = 10
        for (table in count) if (length(entry[table]) > we) we = length(entry[table])
        printf "%-*s  %-*s  %s\n", wt, "TABLE", we, "ENTRY KEYS", "BINDINGS" > (tables "-header")

        for (j = 1; j <= m; j++) {
            i = ord[j]
            table = T[i]
            if (!seen[table]++) {
                color = palette[++nc]
                # Reuse the window-switcher palette, generating unique overflow colors.
                while (color == "" || (nc > 14 && color in used)) {
                    rgb = (8421504 + ++extra * 7919) % 16777216
                    color = int(rgb / 65536) ";" int(rgb / 256) % 256 ";" rgb % 256
                }
                used[color] = 1
                colors[table] = color
                row = sprintf("\033[1;38;2;%sm%-*s\033[0m  %-*s  %d", color, wt, table, we, entry[table] == "" ? "—" : entry[table], count[table])
                print row "\t" table "\t__table__" > tables
            }
            cmd = C[i]
            if (length(cmd) > wc) cmd = substr(cmd, 1, wc - 3) "..."
            row = sprintf("\033[1;38;2;%sm%-*s\033[0m  \033[1;33m%-*s\033[0m  %s", colors[table], wt, T[i], wk, K[i], cmd)
            print row "\t" T[i] "\t" K[i] "\t" R[i] > all
            print row "\t" T[i] "\t" K[i] "\t" R[i] > ("/tmp/tmux/keys-" T[i] ".txt")
        }
    }'
table_header=$(cat "$TMP_TABLES_FILE-header")

# --- Open FZF in tmux popup ---
# Ctrl-T lists tables; Enter opens a table or its binding in config.
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
        --header='Ctrl-T: list tables   Tab: drill into a table   Enter: open in config' \
        --bind='ctrl-t:reload(cat $TMP_TABLES_FILE)+clear-query+change-prompt(Tables> )+change-header(Enter: browse table   Shift-Tab: all bindings
$table_header)' \
        --bind='enter:transform:if [ {3} = __table__ ]; then printf \"reload(cat $TMP_DIR/keys-%s.txt)+clear-query+change-prompt(Bindings> )+change-header(Ctrl-T: list tables   Shift-Tab: all bindings   Enter: open in config)\" {2}; else echo accept; fi' \
        --bind='tab:reload(cat $TMP_DIR/keys-{2}.txt)+clear-query+change-prompt(Bindings> )+change-header(Ctrl-T: list tables   Shift-Tab: all bindings   Enter: open in config)' \
        --bind='btab:reload(cat $TMP_KEYS_FILE)+clear-query+change-prompt(🔍 Search tmux keybindings: )+change-header(Ctrl-T: list tables   Tab: drill into a table   Enter: open in config)' \
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
