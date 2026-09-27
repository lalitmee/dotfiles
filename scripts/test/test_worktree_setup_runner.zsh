#!/usr/bin/env zsh

set -euo pipefail

SCRIPT_DIR="${0:A:h}"
WORKSPACE_DIR="${SCRIPT_DIR:h:h}"
RUNNER="$WORKSPACE_DIR/tmux/.config/tmux/scripts/git/workers/worktree-deps-install.sh"
TEST_DIR=$(mktemp -d)
trap 'rm -rf "$TEST_DIR"' EXIT

if [[ ! -f "$RUNNER" ]]; then
    print -u2 "FAIL: worktree setup runner is missing"
    exit 1
fi

PROJECT="$TEST_DIR/project"
TEST_HOME="$TEST_DIR/home"
mkdir -p "$PROJECT" "$TEST_HOME"
print -r -- 'cd "$HOME"' > "$TEST_HOME/.zshrc"
print -r -- '#!/usr/bin/env zsh' > "$PROJECT/.worktree-setup"
print -r -- '[[ -f .installed ]] || exit 23' >> "$PROJECT/.worktree-setup"
print -r -- ': > .hook-ran' >> "$PROJECT/.worktree-setup"
chmod +x "$PROJECT/.worktree-setup"

(
    cd "$PROJECT"
    HOME="$TEST_HOME" zsh "$RUNNER" 'touch .installed' <<< ""
)

if [[ ! -f "$PROJECT/.hook-ran" ]]; then
    print -u2 "FAIL: setup hook did not run after dependency installation"
    exit 1
fi

rm "$PROJECT/.hook-ran"
if (
    cd "$PROJECT"
    HOME="$TEST_HOME" zsh "$RUNNER" 'false' <<< ""
); then
    print -u2 "FAIL: runner returned success after install failure"
    exit 1
fi

if [[ -f "$PROJECT/.hook-ran" ]]; then
    print -u2 "FAIL: setup hook ran after dependency installation failed"
    exit 1
fi

print "PASS: worktree setup runner"
