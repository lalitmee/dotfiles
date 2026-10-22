#!/usr/bin/env zsh
# -------------------------------------------------------------------
# NOTE: Description {{{
# -------------------------------------------------------------------
# This script scrapes the DuckDuckGo bangs page to create a clean,
# tab-separated list of all !bangs and their descriptions for use with fzf.
# It uses a robust Unicode-based filter to keep only Latin-based script entries.
# }}}
# -------------------------------------------------------------------

# -------------------------------------------------------------------
# NOTE: Configuration {{{
# -------------------------------------------------------------------
# The URL of the DuckDuckGo bangs JSON data.
BANG_URL="https://duckduckgo.com/bang.js"

# The location to save the final, formatted list.
OUTPUT_FILE="$HOME/.config/tmux/scripts/ask-sh/.scraped-bangs-list"
# }}}
# -------------------------------------------------------------------

# -------------------------------------------------------------------
# NOTE: Script Logic {{{
# -------------------------------------------------------------------
tmp_raw=$(mktemp)
trap 'rm -f "$tmp_raw"' EXIT

if command -v gum >/dev/null 2>&1; then
    gum spin --spinner dot --title "Fetching bang list from DuckDuckGo..." -- \
        sh -c 'curl -s "$1" | jq -r ".[] | \"\\(.t)\\t!\\(.s)\"" > "$2"' _ "$BANG_URL" "$tmp_raw"
else
    echo "🔎 Fetching the bang list from DuckDuckGo's JSON source..."
    curl -s "$BANG_URL" | jq -r '.[] | "\(.t)\t!\(.s)"' > "$tmp_raw"
fi

if [[ ! -s "$tmp_raw" ]]; then
    echo "❌ Error: Failed to fetch or parse the JSON data."
    exit 1
fi

# This robust perl command keeps a line unless it contains a character
# that is NOT in the Latin, Common (punctuation, digits, etc.), or Symbol scripts.
# This correctly removes entries in Cyrillic, Arabic, Hebrew, Greek, CJK, etc.
# while preserving all desired entries.
if command -v gum >/dev/null 2>&1; then
    gum spin --spinner dot --title "Filtering Latin-based script entries..." -- \
        sh -c 'perl -CS -ne "print unless /[^\p{Latin}\p{Common}\p{Symbol}]/" "$1" > "$2"' _ "$tmp_raw" "$OUTPUT_FILE"
else
    echo "🧹 Filtering for Latin-based script entries..."
    perl -CS -ne 'print unless /[^\p{Latin}\p{Common}\p{Symbol}]/' "$tmp_raw" > "$OUTPUT_FILE"
fi

echo "✅ Success! Filtered bang list saved to $OUTPUT_FILE"
original_count=$(wc -l < "$tmp_raw" | tr -d ' ')
filtered_count=$(wc -l < "$OUTPUT_FILE" | tr -d ' ')
echo "Removed $(($original_count - $filtered_count)) entries. Kept $filtered_count bangs."
# }}}
# -------------------------------------------------------------------
