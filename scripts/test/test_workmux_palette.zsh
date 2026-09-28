#!/usr/bin/env zsh

set -euo pipefail

script_dir="${0:A:h}"
repo_root="${script_dir:h:h}"
palette="$repo_root/tmux/.config/tmux/scripts/popup/workmux-palette.sh"
tmp_dir=$(mktemp -d)
trap 'rm -rf "$tmp_dir"' EXIT

source "$palette"

captured_rows="$tmp_dir/rows"
gum() {
    cat > "$captured_rows"
    print -r -- "$(head -n 1 "$captured_rows")"
}
fzf() {
    cat > "$captured_rows"
    print -r -- "$(head -n 1 "$captured_rows")"
}

PALETTE_UI=gum
[[ "$(pick_action)" == add ]]
[[ "$(awk '{print $1}' "$captured_rows" | sort -u | wc -l | tr -d ' ')" == 9 ]]
[[ "$(awk '{print index($0, $2)}' "$captured_rows" | sort -u | wc -l | tr -d ' ')" == 1 ]]

PALETTE_UI=fzf
[[ "$(pick_action)" == add ]]

print "workmux palette tests passed"
