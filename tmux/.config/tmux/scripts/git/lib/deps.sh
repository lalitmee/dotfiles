#!/usr/bin/env zsh

# ============================================================================
# DEPS.SH - Dependency Management for Git Worktrees
# ============================================================================
# Package manager detection and dependency installation

source "$(dirname "$0")/common.sh"

# ============================================================================
# Detect package manager and return appropriate install command
# Checks for yarn.lock, package-lock.json, or defaults to npm
# ============================================================================
get_install_command()
                      {
    local worktree_path="$1"

    # If package.json doesn't exist, return empty
    if [ ! -f "$worktree_path/package.json" ]; then
        echo ""
        return
    fi

    # Check for yarn
    if [ -f "$worktree_path/yarn.lock" ]; then
        local yarn_version=$(yarn --version 2> /dev/null | cut -d. -f1)
        if [ "$yarn_version" = "1" ]; then
            echo "yarn install --frozen-lockfile"
        else
            echo "yarn install --immutable"
        fi
    # Check for npm
    elif [ -f "$worktree_path/package-lock.json" ]; then
        echo "npm ci"
    # Default to npm
    else
        echo "npm install"
    fi
}

# ============================================================================
# Launch dependency installation in separate tmux window
# Only installs if:
#   1. package.json exists
#   2. node_modules directory doesn't exist
# ============================================================================
launch_dependency_install()
                            {
    local worktree_path="$1"
    local branch_name="$2"

    log "Checking for dependency installation needs in $worktree_path"

    # Only install if package.json exists
    if [ ! -f "$worktree_path/package.json" ]; then
        log "No package.json found in $worktree_path"
        return
    fi

    # Skip if node_modules already exists
    if [ -d "$worktree_path/node_modules" ]; then
        log "node_modules already exists in $worktree_path, skipping install"
        return
    fi

    # Get install command
    local install_cmd=$(get_install_command "$worktree_path")

    # If no install command determined, skip
    if [ -z "$install_cmd" ]; then
        log "Could not determine package manager for $worktree_path"
        return
    fi

    local dep_window_name="deps-$branch_name"

    log "Launching dependency installation in window '$dep_window_name'"
    log "Install command: $install_cmd"

    tmux new-window -c "$worktree_path" -n "$dep_window_name" \
        "zsh -c 'source ~/.zshrc; cd \"$worktree_path\"; $install_cmd; echo \"Press Enter to close...\"; read'"

    tmux display-message "Installing dependencies in window '$dep_window_name'..."
}

# vim:fdm=marker
