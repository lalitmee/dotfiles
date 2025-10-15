#!/usr/bin/env zsh

# A function to handle cancellation gracefully
abort() {
    clear
    echo "🚫 $1"
    sleep 0.8
    exit 0
}

# --- Configuration ---
REPO_DIRS=(
    "$HOME/Projects/Personal/Github/"
    "$HOME/Projects/Work/Github/"
)

# --- Main Logic ---

# 1. Find all git repos
repo_list=$(find "${REPO_DIRS[@]}" -maxdepth 3 -name ".git" -type d -prune 2>/dev/null | sed 's#/\.git##')
[ -z "$repo_list" ] && abort "No Git repositories found. Check REPO_DIRS."

# 2. Select a Repository
selected_repo=$(echo -e "$repo_list" | fzf --prompt="Select Repository > ")
[ -z "$selected_repo" ] && abort "No repository selected. Aborting."

cd "$selected_repo" || exit

# 3. Select a Local Branch
local_branches=$(git branch --format='%(refname:short)')
target_branch=$(echo "$local_branches" | fzf --prompt="Checkout branch in '$(basename "$selected_repo")' > ")
[ -z "$target_branch" ] && abort "No branch selected. Aborting."

git checkout "$target_branch" &> /dev/null

# 4. Select an Action (with updated merge icon)
actions="↓ Pull latest for '$target_branch'\n⇅ Merge another branch into '$target_branch'"
chosen_action=$(echo -e "$actions" | fzf --prompt="Select action > ")
[ -z "$chosen_action" ] && abort "No action selected. Aborting."

# 5. Execute the chosen action
clear
echo "Executing in: $selected_repo"
echo "-----------------------------------"

if [[ "$chosen_action" == *"Pull"* ]]; then
    echo "Running: git pull origin $target_branch"
    git pull origin "$target_branch"
    echo "-----------------------------------"
    read -n 1 -s -r -p "✅ Pull complete. Press any key to close..."

elif [[ "$chosen_action" == *"Merge"* ]]; then
    echo "Fetching latest branches before merge..."
    git fetch --all --prune &> /dev/null

    all_branches=$(git branch -a --format='%(refname:short)' | sed 's|remotes/origin/||' | sort -u)
    merge_branch=$(echo "$all_branches" | fzf --prompt="Merge which branch into '$target_branch'? > ")

    if [ -n "$merge_branch" ]; then
        echo "Running: git merge $merge_branch"
        git merge "$merge_branch"
        echo "-----------------------------------"
        read -n 1 -s -r -p "✅ Merge complete. Press any key to close..."
    else
        echo "No branch selected for merge. No action taken."
        echo "-----------------------------------"
        read -n 1 -s -r -p "Press any key to close..."
    fi
fi
