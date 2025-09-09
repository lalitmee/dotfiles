#!/usr/bin/env bash
# Tmux Help System - Modular popup help using gum tables
# Usage: ./help.sh <table-name>
# Example: ./help.sh ai-tools

set -e

# Configuration
HELP_DIR="$HOME/.config/tmux/scripts/help"
TABLES_DIR="$HELP_DIR/tables"
SCRIPT_NAME=$(basename "$0")

# Colors matching tmux cobalt2 theme (from tmux config and cobalt2.conf)
HEADER_FG="#FFC600"    # Yellow (tmux_conf_theme_colour_5)
HEADER_BG="#0d3a58"    # Dark blue (tmux_conf_theme_colour_15)
BODY_FG="#e4e4e4"      # White (tmux_conf_theme_colour_7)
BODY_BG="#193549"      # Cobalt2 background (thm_bg)
BORDER_FG="#00AAFF"    # Cobalt2 blue (thm_blue)

# Function to display usage
show_usage() {
    echo "Usage: $SCRIPT_NAME <table-name>"
    echo ""
    echo "Available help tables:"
    ls -1 "$TABLES_DIR"/*.txt 2>/dev/null | sed 's|.*/||' | sed 's|\.txt$||' | sed 's/^/  - /'
    echo ""
    echo "Example: $SCRIPT_NAME ai-tools"
}

# Function to display help table
show_help_table() {
    local table_name="$1"
    local table_file="$TABLES_DIR/${table_name}.txt"

    if [[ ! -f "$table_file" ]]; then
        echo "❌ Help table '$table_name' not found in $TABLES_DIR" >&2
        echo "Available tables:" >&2
        ls -1 "$TABLES_DIR"/*.txt 2>/dev/null | sed 's|.*/||' | sed 's|\.txt$||' | sed 's/^/  - /' >&2
        exit 1
    fi

    # Check if gum is available
    if ! command -v gum &> /dev/null; then
        echo "❌ gum is not installed. Please install it first:" >&2
        echo "  - macOS: brew install gum" >&2
        echo "  - Linux: Check your package manager or https://github.com/charmbracelet/gum" >&2
        exit 1
    fi

    # Display the table with styling (removed --padding which isn't supported in all gum versions)
    cat "$table_file" | gum table \
        --separator=$'\t' \
        --header.foreground="$HEADER_FG" \
        --header.background="$HEADER_BG" \
        --cell.foreground="$BODY_FG" \
        --cell.background="$BODY_BG" \
        --border.foreground="$BORDER_FG" \
        --border="rounded" \
        --print

    # Wait for user to press any key to close
    echo ""
    gum style --foreground="$HEADER_FG" --background="$BODY_BG" "Press any key to close..."
    read -n 1 -s
}

# Main logic
main() {
    local table_name="$1"

    if [[ -z "$table_name" ]]; then
        show_usage
        exit 1
    fi

    case "$table_name" in
        --help|-h)
            show_usage
            exit 0
            ;;
        --list)
            echo "Available help tables:"
            ls -1 "$TABLES_DIR"/*.txt 2>/dev/null | sed 's|.*/||' | sed 's|\.txt$||' | sed 's/^/  - /'
            exit 0
            ;;
        *)
            show_help_table "$table_name"
            ;;
    esac
}

main "$@"
