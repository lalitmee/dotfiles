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
fzf_output=$(echo "$sorted_file" | fzf --bind="change:first" --reverse \
  --header 'Enter: new window  C-v: split right  C-s: split bottom' \
  --preview "$preview_cmd" \
  --preview-window=right:60%:wrap \
  --prompt "Review > " \
  --expect=enter,ctrl-v,ctrl-s || true)

if [[ -z "$fzf_output" ]]; then
  exit 0
fi

key=$(printf '%s\n' "$fzf_output" | sed -n '1p')
selected=$(printf '%s\n' "$fzf_output" | sed -n '2p')

if [[ -z "$selected" ]]; then
  exit 0
fi

# -------------------------------------------------------------------
# Derive window name from folder + file
# -------------------------------------------------------------------

# Resolve absolute path for the selected file
absolute_selected="$selected"
if [[ "$absolute_selected" != /* ]]; then
  # Interpret relative paths as relative to the git root
  if command -v realpath >/dev/null 2>&1; then
    absolute_selected=$(cd "$git_root" && realpath -m -- "$absolute_selected")
  else
    absolute_selected="$git_root/$absolute_selected"
  fi
fi

# If the user requested a split, open in a new pane and return early
case "$key" in
  ctrl-v)
    tmux split-window -h nvim "$absolute_selected"
    exit 0
    ;;
  ctrl-s)
    tmux split-window -v nvim "$absolute_selected"
    exit 0
    ;;
esac

# Path relative to git root (used for parent-dir matching and filename)
relative_path=${absolute_selected#"$git_root/"}

# Derive parent directory name (folder containing the file)
parent_dir="${relative_path%/*}"
parent_name="${parent_dir##*/}"

window_prefix=""

# Prefer explicit mapping from AI_DOCS_PREFIXES if available
if [[ ${(P)+AI_DOCS_PREFIXES} -ne 0 ]]; then
  for mapping in "${AI_DOCS_PREFIXES[@]}"; do
    local_key=${mapping%%:*}
    local_prefix=${mapping#*:}
    if [[ "$parent_name" == "$local_key" ]]; then
      window_prefix="$local_prefix"
      break
    fi
  done
fi

# Fallback prefix when no mapping matches
if [[ -z "$window_prefix" ]]; then
  window_prefix="adr"
fi

filename=${relative_path##*/}
filename=${filename%.md}

# Strip leading YYYY-MM-DD- if present to keep only the doc context
clean_filename=${filename#[0-9][0-9][0-9][0-9]-[0-9][0-9]-[0-9][0-9]-}

window_name="$window_prefix:$clean_filename"

# -------------------------------------------------------------------
# Open in new tmux window with nvim
# -------------------------------------------------------------------
tmux new-window -n "$window_name" nvim "$absolute_selected"
