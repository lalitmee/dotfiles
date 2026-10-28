#!/usr/bin/env zsh

set -euo pipefail

script_dir="${0:A:h}"
repo_root="${script_dir:h:h:h:h}"
palette_script="$repo_root/bin/.config/bin/workmux-agent-palette"

if [[ ! -x "$palette_script" ]]; then
    print -u2 "FAIL: $palette_script is missing or not executable"
    exit 1
fi

tmp_dir=$(mktemp -d)
trap 'rm -rf "$tmp_dir"' EXIT

source "$palette_script"

# 1. Verify environment setup works cleanly
setup_environment

# 2. Test agent scan with simulated commands in PATH
mock_bin="$tmp_dir/bin"
mkdir -p "$mock_bin"
touch "$mock_bin/opencode" "$mock_bin/pi" "$mock_bin/cursor"
chmod +x "$mock_bin"/*

PATH="$mock_bin:/bin:/usr/bin"
scan_agents

# Static list has 11 entries (grok removed)
if (( ${#ITEM_IDS[@]} != 11 )); then
    print -u2 "FAIL: expected 11 agents in static catalog, found ${#ITEM_IDS[@]}"
    exit 1
fi

# Verify static keys & labels
if [[ "${ITEM_IDS[1]}" != "opencode" || "${ITEM_KEYS[1]}" != "1" || "${ITEM_MNEMONICS[1]}" != "o" || "${ITEM_INSTALLED[1]}" != "1" ]]; then
    print -u2 "FAIL: opencode metadata mismatch"
    exit 1
fi

if [[ "${ITEM_IDS[2]}" != "pi" || "${ITEM_KEYS[2]}" != "2" || "${ITEM_MNEMONICS[2]}" != "p" || "${ITEM_INSTALLED[2]}" != "1" ]]; then
    print -u2 "FAIL: pi metadata mismatch"
    exit 1
fi

# Uninstalled entry (e.g. vibe or omp)
if [[ "${ITEM_IDS[10]}" != "vibe" || "${ITEM_KEYS[10]}" != "0" || "${ITEM_INSTALLED[10]}" != "0" ]]; then
    print -u2 "FAIL: vibe should be marked uninstalled"
    exit 1
fi

# 3. Test key resolution
idx=$(resolve_key_to_agent_index "1")
if [[ "$idx" != "1" ]]; then
    print -u2 "FAIL: key '1' did not resolve to 1, got $idx"
    exit 1
fi

idx=$(resolve_key_to_agent_index "o")
if [[ "$idx" != "1" ]]; then
    print -u2 "FAIL: mnemonic 'o' did not resolve to 1, got $idx"
    exit 1
fi

idx=$(resolve_key_to_agent_index "v")
if [[ "$idx" != "10" ]]; then
    print -u2 "FAIL: mnemonic 'v' did not resolve to 10, got $idx"
    exit 1
fi

# 4. Test row formatting output
rows=$(format_plain_filter_rows)
if ! print -r -- "$rows" | grep -q "\[1 / o\]  opencode"; then
    print -u2 "FAIL: filter output missing opencode formatting"
    exit 1
fi

if ! print -r -- "$rows" | grep -q "\[0 / v\]  vibe"; then
    print -u2 "FAIL: filter output missing vibe formatting"
    exit 1
fi

# 5. Verify grok is not in catalog
for id in "${ITEM_IDS[@]}"; do
    if [[ "$id" == "grok" ]]; then
        print -u2 "FAIL: grok should have been removed from the static catalog"
        exit 1
    fi
done

# 6. Session history formatting
record_agent_history "opencode" "opencode" "#00AAFF" 0 134 "1/o"
record_agent_history "cursor" "cursor" "#FF9A00" 130 5 "5/u"

history_rows=$(format_plain_history_rows)
if ! print -r -- "$history_rows" | grep -q "^ 1  5/u"; then
    print -u2 "FAIL: history missing launch key for newest row"
    exit 1
fi

if ! print -r -- "$history_rows" | grep -q "^ 1  .*  cursor"; then
    print -u2 "FAIL: history missing newest cursor row"
    exit 1
fi

if ! print -r -- "$history_rows" | grep -q "^ 2  .*  opencode"; then
    print -u2 "FAIL: history missing second opencode row"
    exit 1
fi

if ! print -r -- "$history_rows" | grep -q "#   Key"; then
    print -u2 "FAIL: history missing Key column header"
    exit 1
fi

launch_key=$(format_history_launch_key 8 key)
if [[ "$launch_key" != "8/k" ]]; then
    print -u2 "FAIL: expected copilot launch key 8/k, got $launch_key"
    exit 1
fi

print "workmux agent palette tests passed successfully"
