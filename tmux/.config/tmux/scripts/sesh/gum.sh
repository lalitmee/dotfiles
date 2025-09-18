#!/bin/bash
# This script launches an optimized gum-based session picker for sesh in tmux popups.
#
# Performance Optimizations:
# - Uses plain text sesh list (no ANSI processing overhead)
# - Optimized height for popup performance
# - Minimal styling for faster rendering
# - Timeout protection
#
# Previous fzf implementation preserved below for reference.

#  NOTE: Optimized gum implementation with colored icons for better visual distinction
sesh connect "$(
    sesh list --icons | gum filter \
        --limit 1 \
        --no-sort \
        --fuzzy \
        --no-strip-ansi \
        --placeholder 'Pick a sesh' \
        --height 40 \
        --prompt='⚡ ' \
        --timeout=30s \
        --indicator.foreground="#00AAFF" \
        --match.foreground="#FFC600" \
        --text.foreground="#FFFFFF" \
        --prompt.foreground="#3AD900" \
        --placeholder.foreground="#8fbfdc" \
        --cursor-text.foreground="#FFFFFF" \
        --cursor-text.background="#185294"
)" < /dev/null || echo "Failed to connect to sesh session"

#  NOTE: Backup fzf implementation (previously active)
# sesh connect "$(
#   sesh list -i | sed 's/\x1b\[[0-9;]*m//g' | fzf \
#     --height 50 \
#     --prompt='⚡ ' \
#     --color='fg:#FFFFFF,bg:#193549,hl:#FFC600,fg+:#FFFFFF,bg+:#185294,hl+:#FF9D00,info:#8fbfdc,prompt:#3AD900,pointer:#00AAFF' \
#     --no-sort
# )"

#  NOTE: Original gum implementation (commented out due to performance)
# sesh connect "$(
#   sesh list -i | gum filter --limit 1 --no-sort --fuzzy --placeholder 'Pick a sesh' --height 50 --prompt='⚡'
# )"

#  NOTE: Full gum styling (commented out - too slow for tmux popups)
# sesh connect "$(
# sesh list -i | gum filter \
#   --limit 1 \
#   --no-sort \
#   --fuzzy \
#   --placeholder 'Pick a sesh' \
#   --height 50 \
#   --prompt='⚡' \
#   --indicator.foreground="#00AAFF" \
#   --match.foreground="#FFC600" \
#   --text.foreground="#FFFFFF" \
#   --prompt.foreground="#3AD900" \
#   --placeholder.foreground="#8fbfdc" \
#   --cursor-text.foreground="#FFFFFF" \
#   --cursor-text.background="#185294"
# )"
