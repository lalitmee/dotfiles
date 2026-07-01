#!/usr/bin/env zsh

# Source the user's Zsh profile for PATH/environment
[[ -f ~/.zprofile ]] && source ~/.zprofile

# -------------------------------------------------------------------
# Config
# -------------------------------------------------------------------
CONFIG_FILE="$HOME/.config/tmux/ai-docs-picker.conf"

# -------------------------------------------------------------------
# Check dependencies
# -------------------------------------------------------------------
if ! command -v fd >/dev/null 2>&1; then
  tmux display-message "Error: 'fd' not found. Please install it."
  exit 1
fi

if ! command -v fzf >/dev/null 2>&1; then
  tmux display-message "Error: 'fzf' not found. Please install it."
  exit 1
fi

# -------------------------------------------------------------------
# Source config
# -------------------------------------------------------------------
AI_DOCS_FOLDERS=()
if [[ -f "$CONFIG_FILE" ]]; then
  source "$CONFIG_FILE"
else
  tmux display-message "Warning: $CONFIG_FILE not found. Create it with AI_DOCS_FOLDERS array."
  exit 0
fi

if [[ ${#AI_DOCS_FOLDERS[@]} -eq 0 ]]; then
  tmux display-message "Warning: AI_DOCS_FOLDERS is empty in $CONFIG_FILE."
  exit 0
fi

# -------------------------------------------------------------------
# Resolve git root
# -------------------------------------------------------------------
pane_dir=$(tmux display-message -p '#{pane_current_path}')
git_root=$(git -C "$pane_dir" rev-parse --show-toplevel 2>/dev/null || true)

if [[ -z "$git_root" ]]; then
  tmux display-message "Error: Not inside a git repository."
  exit 0
fi

# -------------------------------------------------------------------
# Build fd search for each configured folder
# -------------------------------------------------------------------
fd_cmd="fd"
preview_cmd="cat {}"
if command -v bat >/dev/null 2>&1; then
  preview_cmd="bat --style=numbers --color=always {}"
elif command -v batcat >/dev/null 2>&1; then
  preview_cmd="batcat --style=numbers --color=always {}"
fi

results_file=$(mktemp)
trap "rm -f '$results_file'" EXIT

for folder in "${AI_DOCS_FOLDERS[@]}"; do
  target_dir="$git_root/$folder"
  if [[ -d "$target_dir" ]]; then
    "$fd_cmd" --type f --extension md . "$target_dir" >> "$results_file" 2>/dev/null
  fi
done

# -------------------------------------------------------------------
# Sort and deduplicate
# -------------------------------------------------------------------
sorted_file=$(sort -u "$results_file" 2>/dev/null || true)
if [[ -z "$sorted_file" ]]; then
  tmux display-message "No .md files found in configured folders."
  exit 0
fi

# -------------------------------------------------------------------
# FZF picker
# -------------------------------------------------------------------
selected=$(echo "$sorted_file" | fzf --bind="change:first" --reverse \
  --preview "$preview_cmd" \
  --prompt "AI Docs > " || true)

if [[ -z "$selected" ]]; then
  exit 0
fi

# -------------------------------------------------------------------
# Open in new tmux window with nvim
# -------------------------------------------------------------------
tmux new-window -n "docs" nvim "$selected"
