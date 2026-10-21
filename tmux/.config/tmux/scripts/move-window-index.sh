#!/usr/bin/env zsh
# move-window-index.sh <session> <source-index> <target-index>
# Reorder windows so <source-index> lands on <target-index> and every window it
# passes shifts one slot. Indices stay contiguous (no holes), and any pre-existing
# gap is compacted first so the typed index means the position you see.

set -u

session=$1
source=$2
target=$3

[[ $target == <-> ]] || { tmux display-message "Not a window index: $target"; exit 1; }
[[ $target == "$source" ]] && exit 0

indices() {
    tmux list-windows -t "$session" -F '#{window_index}'
}

index_of() {  # index_of <window-id>
    tmux list-windows -t "$session" -F '#{window_id} #{window_index}' \
        | awk -v id="$1" '$1 == id { print $2 }'
}

src_id=$(tmux display-message -p -t "$session:$source" '#{window_id}') || exit 1

# Compact existing gaps, then resolve the source again (its index may have moved).
tmux move-window -r -t "$session" || exit 1
source=$(index_of "$src_id")

first=$(indices | sort -n | head -1)
last=$(( first + $(indices | wc -l) - 1 ))
if (( target < first || target > last )); then
    tmux display-message "Window index must be between $first and $last"
    exit 1
fi

if (( source < target )); then
    while (( source < target )); do
        tmux swap-window -s "$session:$source" -t "$session:$(( source + 1 ))" || exit 1
        (( source++ ))
    done
else
    while (( source > target )); do
        tmux swap-window -s "$session:$source" -t "$session:$(( source - 1 ))" || exit 1
        (( source-- ))
    done
fi

tmux select-window -t "$session:$target"
