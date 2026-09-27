#!/usr/bin/env zsh

worktree_path="$PWD"
SCRIPT_DIR="$(cd "$(dirname "$0")/.." && pwd)"
source "$SCRIPT_DIR/lib/common.sh"
setup_environment

if [[ -f "$HOME/.zshrc" ]]; then
    source "$HOME/.zshrc"
fi

cd "$worktree_path" || exit 1
install_command="${1:-}"
hook="$worktree_path/.worktree-setup"

if [[ -n "$install_command" ]]; then
    log "Running dependency installation in $worktree_path: $install_command"
    if eval "$install_command"; then
        :
    else
        setup_status=$?
        error_log "Dependency installation failed in $worktree_path (exit $setup_status)"
        print "Setup failed (exit $setup_status). Press Enter to close..."
        read
        exit "$setup_status"
    fi
fi

if [[ -x "$hook" ]]; then
    log "Running worktree setup hook in $worktree_path"
    if "$hook"; then
        :
    else
        setup_status=$?
        error_log "Worktree setup hook failed in $worktree_path (exit $setup_status)"
        print "Setup failed (exit $setup_status). Press Enter to close..."
        read
        exit "$setup_status"
    fi
fi

log "Worktree setup completed in $worktree_path"
print "Setup complete. Press Enter to close..."
read
