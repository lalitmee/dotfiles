#!/usr/bin/env zsh

set -euo pipefail

SCRIPT_DIR="${0:A:h}"
WORKSPACE_DIR="${SCRIPT_DIR:h:h}"
WORKERS="$WORKSPACE_DIR/tmux/.config/tmux/scripts/git/workers"
TEST_DIR=$(mktemp -d)
trap 'rm -rf "$TEST_DIR"' EXIT

REAL_ZSH=$(whence -p zsh)
HOME="$TEST_DIR/home"
BIN="$HOME/.local/bin"
REPO="$TEST_DIR/repo"
WORKTREES="$TEST_DIR/worktrees"
SETUP_LOG="$TEST_DIR/setup.log"
mkdir -p "$BIN" "$HOME" "$WORKTREES"
export HOME WORKTREE_TEST_REAL_ZSH="$REAL_ZSH" WORKTREE_TEST_SETUP_LOG="$SETUP_LOG"

cat > "$BIN/gum" <<'SH'
#!/bin/sh
case "$1" in
    confirm) exit 1 ;;
    spin)
        shift
        while [ "$#" -gt 0 ]; do
            if [ "$1" = -- ]; then
                shift
                exec "$@"
            fi
            shift
        done
        ;;
esac
exit 0
SH

cat > "$BIN/tmux" <<'SH'
#!/bin/sh
case "$1" in
    display-message) exit 0 ;;
    new-window) shift ;;
    *) exit 2 ;;
esac
worktree=
while [ "$#" -gt 0 ]; do
    case "$1" in
        -c) worktree=$2; shift 2 ;;
        -n) shift 2 ;;
        *) command=$1; shift ;;
    esac
done
(cd "$worktree" && eval "$command")
SH

cat > "$BIN/zsh" <<'SH'
#!/bin/sh
case "$1" in
    *worktree-deps-install.sh) exec "$WORKTREE_TEST_REAL_ZSH" "$@" ;;
esac
exit 0
SH

cat > "$BIN/npm" <<'SH'
#!/bin/sh
printf '%s|%s\n' "$PWD" "$*" >> "$WORKTREE_TEST_SETUP_LOG"
SH

chmod +x "$BIN"/*
export PATH="$BIN:$PATH"

git init -q -b main "$REPO"
git -C "$REPO" config user.name 'Worktree Test'
git -C "$REPO" config user.email 'worktree-test@example.invalid'
mkdir -p "$REPO/.vscode" "$REPO/src"
print -r -- '{"name":"worktree-fixture","version":"1.0.0"}' > "$REPO/package.json"
print -r -- '{}' > "$REPO/package-lock.json"
print -r -- '{"compilerOptions":{"strict":true}}' > "$REPO/tsconfig.json"
print -r -- 'export const answer: number = 42;' > "$REPO/src/index.ts"
print -r -- '{}' > "$REPO/.vscode/tasks.json"
git -C "$REPO" add package.json package-lock.json tsconfig.json src/index.ts .vscode/tasks.json
git -C "$REPO" commit -q -m initial

CREATE_WORKTREE="$WORKTREES/create-flow"
"$REAL_ZSH" "$WORKERS/worktree-create.sh" "$REPO" "$WORKTREES" create-flow main <<< ""

SWITCH_WORKTREE="$WORKTREES/switch-flow"
git -C "$REPO" worktree add -q -b switch-flow "$SWITCH_WORKTREE" main
"$REAL_ZSH" "$WORKERS/worktree-switch.sh" "$SWITCH_WORKTREE" switch-flow "$REPO" <<< ""

if [[ ! -e "$CREATE_WORKTREE/.git" || ! -e "$SWITCH_WORKTREE/.git" ]]; then
    print -u2 'FAIL: create or switch worker did not leave its worktree available'
    exit 1
fi

actual_lines=()
while IFS= read -r line; do
    actual_lines+=("$line")
done < "$SETUP_LOG"
if (( ${#actual_lines} != 2 )) || \
    [[ "${actual_lines[1]}" != "$CREATE_WORKTREE|ci" ]] || \
    [[ "${actual_lines[2]}" != "$SWITCH_WORKTREE|ci" ]]; then
    print -u2 'FAIL: npm ci was not launched from both worktree flows'
    print -u2 "Observed: ${(j:; :)actual_lines}"
    exit 1
fi

print 'PASS: JavaScript create and switch flows launch npm ci in their worktrees'
