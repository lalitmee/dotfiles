#!/usr/bin/env zsh

# ============================================================================
# GIT-UTILS.SH - Git-Specific Helper Functions
# ============================================================================
# Git repository validation, window naming, and info retrieval

source "$(dirname "$0")/common.sh"

# ============================================================================
# Ensure we are in a git repository
# Exits with status 1 if not in a git repo
# ============================================================================
ensure_git_repo()
                  {
    if ! git rev-parse --is-inside-work-tree > /dev/null 2>&1; then
        log "Script run outside of a git repository."
        gum style --foreground "212" "Not a git repository. Exiting..."
        sleep 2
        exit 1
    fi
}

# ============================================================================
# Generate window name from branch name
# Removes JIRA codes (e.g., NYS-1769) and keeps the rest of the branch name
# Pattern: [A-Z][A-Z0-9]*-[0-9][0-9]*
# ============================================================================
generate_window_name()
                       {
    local branch_name="$1"

    # Handle main/master branches (keep simple)
    if [[ "$branch_name" == "main" || "$branch_name" == "master" ]]; then
        echo "main"
        return
    fi

    # Handle develop branch (keep simple)
    if [[ "$branch_name" == "develop" ]]; then
        echo "develop"
        return
    fi

    # Remove JIRA codes and clean up any double dashes/slashes
    local cleaned_name=$(echo "$branch_name" | sed 's/[A-Z][A-Z0-9]*-[0-9][0-9]*//g' | sed 's/--/-/g' | sed 's/\/\//\//g' | sed 's/-\//\//g' | sed 's/\/-/\//g' | sed 's/^-//' | sed 's/-$//')

    echo "$cleaned_name"
}

# ============================================================================
# Get repository information
# Returns: repo_root|repo_name|worktree_dir
# ============================================================================
get_repo_info()
                {
    local repo_root=$(git rev-parse --show-toplevel)
    local repo_name=$(basename "$repo_root")
    local worktree_dir="$repo_root/../${repo_name}-worktrees"

    echo "$repo_root|$repo_name|$worktree_dir"
}

# vim:fdm=marker
