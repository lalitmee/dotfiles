#!/usr/bin/env zsh
set -euo pipefail

folder_path="$(cd -- "$1" && pwd -P)"
git_common_dir="$(git -C "$folder_path" rev-parse --git-common-dir 2>/dev/null || true)"
git_root="$(git -C "$folder_path" rev-parse --show-toplevel 2>/dev/null || true)"

if [[ "$git_common_dir" == */.bare ]]; then
    git_root="${git_common_dir%/.bare}"
    if [[ "$git_root" != /* ]]; then
        git_root="$(cd -- "$folder_path/$git_root" && pwd -P)"
    fi
    session_name="${git_root:t}${folder_path#"$git_root"}"
elif [[ -n "$git_root" ]]; then
    git_root="$(cd -- "$git_root" && pwd -P)"
    session_name="${git_root:t}${folder_path#"$git_root"}"
else
    session_name="${folder_path:t}"
fi

session_name="${session_name//./_}"
session_name="${session_name//:/_}"

if ! tmux has-session -t "=$session_name" 2>/dev/null; then
    tmux new-session -d -s "$session_name" -n nvim -c "$folder_path" nvim
    tmux new-window -d -t "$session_name" -n code -c "$folder_path" opencode
    tmux set-window-option -t "$session_name:nvim" automatic-rename off
    tmux set-window-option -t "$session_name:nvim" allow-rename off
    tmux set-window-option -t "${session_name}:code" automatic-rename off
    tmux set-window-option -t "${session_name}:code" allow-rename off
fi

if [[ -n "${TMUX:-}" ]]; then
    tmux switch-client -t "$session_name"
else
    tmux attach-session -t "$session_name"
fi
