#!/bin/bash
# This script launches the gum interface for sesh, designed to run in a popup.

sesh connect "$(
  sesh list -i | gum filter --limit 1 --no-sort --fuzzy --placeholder 'Pick a sesh' --height 50 --prompt='⚡'
)"
