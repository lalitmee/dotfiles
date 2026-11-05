#!/bin/bash

# i3/polybar session PATH doesn't include ~/.local/bin (where zscroll lives)
export PATH="$HOME/.local/bin:$PATH"

# see man zscroll for documentation of the following parameters
zscroll -l 30 \
        --delay 0.1 \
        --scroll-padding "  " \
        --match-command "`dirname $0`/get_spotify_status.sh --status" \
        --match-text "Playing" "--scroll 1" \
        --match-text "Paused" "--scroll 0" \
        --update-check true "`dirname $0`/get_spotify_status.sh" &

wait
