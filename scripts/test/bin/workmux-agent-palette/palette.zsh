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

# 2. Test agent discovery in an isolated PATH with only our simulated commands
mock_bin="$tmp_dir/bin"
mkdir -p "$mock_bin"
touch "$mock_bin/opencode" "$mock_bin/pi" "$mock_bin/cursor"
chmod +x "$mock_bin"/*

# Include standard system utilities (/bin, /usr/bin) but exclude user paths where real agents live
PATH="$mock_bin:/bin:/usr/bin"
discover_agents

if (( ${#AVAILABLE_IDS[@]} != 3 )); then
    print -u2 "FAIL: expected 3 discovered agents, found ${#AVAILABLE_IDS[@]}"
    exit 1
fi

# Verify ordering adheres to user priority: opencode (1), pi (2), cursor (3 in mock)
if [[ "${AVAILABLE_IDS[1]}" != "opencode" || "${AVAILABLE_INDEX_KEYS[1]}" != "1" || "${AVAILABLE_MNEMONICS[1]}" != "o" ]]; then
    print -u2 "FAIL: opencode metadata mismatch"
    exit 1
fi

if [[ "${AVAILABLE_IDS[2]}" != "pi" || "${AVAILABLE_INDEX_KEYS[2]}" != "2" || "${AVAILABLE_MNEMONICS[2]}" != "p" ]]; then
    print -u2 "FAIL: pi metadata mismatch"
    exit 1
fi

if [[ "${AVAILABLE_IDS[3]}" != "cursor" || "${AVAILABLE_INDEX_KEYS[3]}" != "3" || "${AVAILABLE_MNEMONICS[3]}" != "u" ]]; then
    print -u2 "FAIL: cursor metadata mismatch"
    exit 1
fi

# 3. Test key resolution (both index and mnemonic)
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

idx=$(resolve_key_to_agent_index "2")
if [[ "$idx" != "2" ]]; then
    print -u2 "FAIL: key '2' did not resolve to 2, got $idx"
    exit 1
fi

idx=$(resolve_key_to_agent_index "p")
if [[ "$idx" != "2" ]]; then
    print -u2 "FAIL: mnemonic 'p' did not resolve to 2, got $idx"
    exit 1
fi

idx=$(resolve_key_to_agent_index "u")
if [[ "$idx" != "3" ]]; then
    print -u2 "FAIL: mnemonic 'u' did not resolve to 3, got $idx"
    exit 1
fi

# Unmatched key returns error
if resolve_key_to_agent_index "z" >/dev/null 2>&1; then
    print -u2 "FAIL: unmatched key 'z' unexpectedly resolved"
    exit 1
fi

# 4. Test row formatting output
rows=$(format_plain_filter_rows)
if ! print -r -- "$rows" | grep -q "\[1 / o\]  opencode"; then
    print -u2 "FAIL: row output missing opencode formatting"
    exit 1
fi

if ! print -r -- "$rows" | grep -q "\[3 / u\]  cursor"; then
    print -u2 "FAIL: row output missing cursor formatting"
    exit 1
fi

# 5. Test cursor command resolution
if [[ "${AVAILABLE_CMDS[3]}" != "cursor agent" && "${AVAILABLE_CMDS[3]}" != "$HOME/.local/bin/agent" ]]; then
    print -u2 "FAIL: cursor resolution should be 'cursor agent' or '$HOME/.local/bin/agent', got '${AVAILABLE_CMDS[3]}'"
    exit 1
fi

print "workmux agent palette tests passed successfully"
