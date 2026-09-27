#!/usr/bin/env zsh

# ============================================================================
# DEPS.SH - Dependency Management for Git Worktrees
# ============================================================================
# Package manager detection and dependency installation

source "$SCRIPT_DIR/lib/deps-detect.sh"

# ============================================================================
# Run detected dependency installation and an optional executable
# .worktree-setup hook in a separate tmux window. The hook can cover unsupported
# tools or add project-specific setup and runs on each create/switch.
# ============================================================================
launch_dependency_install()
                            {
    local worktree_path="$1"
    local branch_name="$2"
    local install_cmd="$(get_install_command "$worktree_path")"
    local setup_hook="$worktree_path/.worktree-setup"

    log "Checking for dependency installation needs in $worktree_path"

    # Preserve the existing Node.js fast path while still allowing the hook.
    if [[ -d "$worktree_path/node_modules" && -f "$worktree_path/package.json" ]]; then
        log "node_modules already exists in $worktree_path, skipping Node.js install"
        install_cmd=""
    fi
    if [[ -d "$worktree_path/.venv" && ( -f "$worktree_path/uv.lock" || \
        -f "$worktree_path/poetry.lock" || -f "$worktree_path/Pipfile" || \
        -f "$worktree_path/requirements.txt" || -f "$worktree_path/pyproject.toml" ) ]]; then
        log "Python virtual environment already exists in $worktree_path, skipping install"
        install_cmd=""
    fi

    if [[ -z "$install_cmd" && ! -x "$setup_hook" ]]; then
        log "No dependency setup or executable .worktree-setup hook found in $worktree_path"
        return
    fi

    local dep_window_name="deps-$branch_name"

    log "Launching dependency installation in window '$dep_window_name'"
    [[ -n "$install_cmd" ]] && log "Install command: $install_cmd"
    [[ -x "$setup_hook" ]] && log "Project setup hook: $setup_hook"

    local runner_command
    printf -v runner_command 'zsh %q %q' "$SCRIPT_DIR/workers/worktree-deps-install.sh" "$install_cmd"
    tmux new-window -c "$worktree_path" -n "$dep_window_name" \
        "$runner_command"

    tmux display-message "Running worktree setup in window '$dep_window_name'..."
}

# vim:fdm=marker
