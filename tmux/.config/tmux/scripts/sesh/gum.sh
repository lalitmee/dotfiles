#!/bin/bash
# This script launches a session picker for sesh, designed to run in a tmux popup.
#
# Why fzf over gum?
# - fzf is chosen for its speed and interactive performance, especially with large lists.
# - gum popups are noticeably slower to load and close in tmux, making the user experience less smooth.
# - fzf provides instant filtering and selection, while gum can lag with bigger datasets.
#
# Note: gum does not support using fzf as a backend; it implements its own filtering UI.
#
# For best performance in tmux popups, fzf is recommended.

#  NOTE: Using fzf instead of gum for better performance with large lists
sesh connect "$(
  sesh list -i | sed 's/\x1b\[[0-9;]*m//g' | fzf \
    --height 50 \
    --prompt='⚡ ' \
    --color='fg:#FFFFFF,bg:#193549,hl:#FFC600,fg+:#FFFFFF,bg+:#185294,hl+:#FF9D00,info:#8fbfdc,prompt:#3AD900,pointer:#00AAFF' \
    --no-sort
)"

#  NOTE: Using gum to filter and select a sesh
# sesh connect "$(
#   sesh list -i | gum filter --limit 1 --no-sort --fuzzy --placeholder 'Pick a sesh' --height 50 --prompt='⚡'
# )"


# # NOTE: Customized colors for gum
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
