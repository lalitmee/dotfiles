#!/usr/bin/env zsh

emulate -LR zsh
setopt errexit nounset pipefail

repo_root="${0:A:h}/../../.."
move_script="$repo_root/tmux/.config/tmux/scripts/move-window-index.sh"

fail() {
    print -u2 -- "FAIL: $*"
    exit 1
}

tmp_dir="$(mktemp -d)"
cleanup() {
    tmux kill-server 2>/dev/null || true
    rm -rf "$tmp_dir"
}
trap cleanup EXIT

unset TMUX
export TMUX_TMPDIR="$tmp_dir"

tmux new-session -d -s doors -x 80 -y 24 -n one
tmux new-window -t doors -n two
tmux new-window -t doors -n three
tmux new-window -t doors -n four

layout() {
    tmux list-windows -t doors -F '#{window_index}:#{window_name}' | tr '\n' ' '
}
active() {
    tmux display-message -p -t doors '#{window_index}:#{window_name}'
}

[[ "$(layout)" == "1:one 2:two 3:three 4:four " ]] || fail "unexpected baseline: $(layout)"

# Move down to the first slot: the windows passed shift one to the right.
"$move_script" doors 4 1
[[ "$(layout)" == "1:four 2:one 3:two 4:three " ]] || fail "move 4->1: $(layout)"
[[ "$(active)" == "1:four" ]] || fail "move 4->1 did not follow the window: $(active)"

# Move back up: the passed window shifts one to the left, indices stay 1..N.
"$move_script" doors 1 3
[[ "$(layout)" == "1:one 2:two 3:four 4:three " ]] || fail "move 1->3: $(layout)"
[[ "$(active)" == "3:four" ]] || fail "move 1->3 did not follow the window: $(active)"

# Same index is a no-op.
"$move_script" doors 2 2
[[ "$(layout)" == "1:one 2:two 3:four 4:three " ]] || fail "no-op changed layout: $(layout)"

# Non-numeric and out-of-range indices are rejected without touching windows.
if "$move_script" doors 2 nine 2>/dev/null; then
    fail "non-numeric index was accepted"
fi
if "$move_script" doors 2 9 2>/dev/null; then
    fail "out-of-range index was accepted"
fi
[[ "$(layout)" == "1:one 2:two 3:four 4:three " ]] || fail "invalid input changed layout: $(layout)"

# Pre-existing gaps are compacted before moving, so the typed index is the slot seen.
tmux set-option -t doors renumber-windows off
tmux move-window -s doors:4 -t doors:7
[[ "$(layout)" == "1:one 2:two 3:four 7:three " ]] || fail "gap setup failed: $(layout)"
"$move_script" doors 7 2
[[ "$(layout)" == "1:one 2:three 3:two 4:four " ]] || fail "gap repair: $(layout)"

print "PASS: move-window-index"
