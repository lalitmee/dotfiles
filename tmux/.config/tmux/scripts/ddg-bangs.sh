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
echo "🔎 Fetching the bang list from DuckDuckGo's JSON source..."
scraped_data=$(curl -s "$BANG_URL" | jq -r '.[] | "\(.t)\t!\(.s)"')

if [[ -z "$scraped_data" ]]; then
    echo "❌ Error: Failed to fetch or parse the JSON data."
    exit 1
fi

echo "🧹 Filtering for Latin-based script entries..."

# This robust perl command keeps a line unless it contains a character
# that is NOT in the Latin, Common (punctuation, digits, etc.), or Symbol scripts.
# This correctly removes entries in Cyrillic, Arabic, Hebrew, Greek, CJK, etc.
# while preserving all desired entries.
filtered_data=$(echo "$scraped_data" | perl -CS -ne 'print unless /[^\p{Latin}\p{Common}\p{Symbol}]/')

# Save the formatted and filtered data to the output file.
echo "$filtered_data" > "$OUTPUT_FILE"

echo "✅ Success! Filtered bang list saved to $OUTPUT_FILE"
original_count=$(echo "$scraped_data" | wc -l | tr -d ' ')
filtered_count=$(echo "$filtered_data" | wc -l | tr -d ' ')
echo "Removed $(($original_count - $filtered_count)) entries. Kept $filtered_count bangs."
# }}}
# -------------------------------------------------------------------
