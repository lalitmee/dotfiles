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

    # Exit cleanly on ESC or empty input
    if [ \$code -eq 130 ] || [ -z \"\$selected\" ]; then
        exit 0
    fi

    # Write selected line to a temp file
    ts=\$(date +%s)
    SELECTED_FILE=\"$TMP_DIR/selected-\$ts.txt\"
    echo \"\$selected\" > \"\$SELECTED_FILE\"

    # Open in editor (fallback to vim)
    \${EDITOR:-vim} \"\$SELECTED_FILE\"
"
