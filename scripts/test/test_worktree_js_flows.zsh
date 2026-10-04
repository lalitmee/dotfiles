#!/usr/bin/env zsh

set -euo pipefail

SCRIPT_DIR="${0:A:h}"
WORKSPACE_DIR="${SCRIPT_DIR:h:h}"
WORKERS="$WORKSPACE_DIR/tmux/.config/tmux/scripts/git/workers"
MANAGER="$WORKSPACE_DIR/tmux/.config/tmux/scripts/git/git-worktree.sh"
TEST_DIR=$(mktemp -d)
trap 'rm -rf "$TEST_DIR"' EXIT

REAL_ZSH=$(whence -p zsh)
HOME="$TEST_DIR/home"
BIN="$HOME/.local/bin"
REPO="$TEST_DIR/repo"
WORKTREES="$TEST_DIR/worktrees"
SETUP_LOG="$TEST_DIR/setup.log"
CONFIRM_LOG="$TEST_DIR/confirm.log"
EXTRA_PICKER_LOG="$TEST_DIR/extra-picker.log"
mkdir -p "$BIN" "$HOME" "$WORKTREES"
export HOME WORKTREE_TEST_REAL_ZSH="$REAL_ZSH" WORKTREE_TEST_SETUP_LOG="$SETUP_LOG"
export WORKTREE_TEST_CONFIRM_LOG="$CONFIRM_LOG" WORKTREE_TEST_EXTRA_PICKER_LOG="$EXTRA_PICKER_LOG"

cat > "$BIN/gum" <<'SH'
#!/bin/sh
case "$1" in
    confirm)
        printf 'confirm\n' >> "$WORKTREE_TEST_CONFIRM_LOG"
        exit 1
        ;;
    input)
        printf '%s' "${WORKTREE_TEST_BRANCH_NAME:-}"
        ;;
    choose)
        printf '%s\n' "$2"
        ;;
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

cat > "$BIN/fzf" <<'SH'
#!/bin/sh
expect_copy=0
multi=0
while [ "$#" -gt 0 ]; do
    case "$1" in
        --expect=ctrl-y) expect_copy=1 ;;
        --multi) multi=1 ;;
    esac
    shift
done

input=$(cat)
if [ "$multi" -eq 1 ]; then
    printf '%s\n' "$PWD" >> "$WORKTREE_TEST_EXTRA_PICKER_LOG"
    exit 0
fi

selected=$(printf '%s\n' "$input" | awk -v wanted="${WORKTREE_TEST_FZF_SELECTION:-}" '
    $0 == wanted || $1 == wanted { print; exit }
    {
        item = $0
        sub(/^[* + -]+/, "", item)
        if (item == wanted) { print; exit }
    }
')
if [ -z "$selected" ]; then
    selected=$(printf '%s\n' "$input" | sed -n '1p')
fi

if [ "$expect_copy" -eq 1 ]; then
    if [ "${WORKTREE_TEST_FZF_KEY:-}" = "ctrl-y" ]; then
        printf 'ctrl-y\n%s\n' "$selected"
    else
        printf '\n%s\n' "$selected"
    fi
else
    printf '%s\n' "$selected"
fi
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
    *worktree-deps-install.sh|*worktree-create.sh|*worktree-switch.sh)
        exec "$WORKTREE_TEST_REAL_ZSH" "$@"
        ;;
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

for repo_path in "$REPO" "$CREATE_WORKTREE" "$SWITCH_WORKTREE"; do
    if [[ "$(git -C "$repo_path" config user.email)" != 'worktree-test@example.invalid' ]]; then
        print -u2 "FAIL: worktree setup overrode the repository email in $repo_path"
        exit 1
    fi
done

if [[ -s "$CONFIRM_LOG" || -s "$EXTRA_PICKER_LOG" ]]; then
    print -u2 'FAIL: default create/switch worker opened the extra-file prompt'
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

(
    cd "$REPO"
    WORKTREE_TEST_FZF_SELECTION="$SWITCH_WORKTREE" WORKTREE_TEST_FZF_KEY=enter \
        "$REAL_ZSH" "$MANAGER" switch
)
if [[ -s "$EXTRA_PICKER_LOG" || -s "$CONFIRM_LOG" ]]; then
    print -u2 'FAIL: Enter on the switch picker did not keep the extra-file prompt disabled'
    exit 1
fi

(
    cd "$REPO"
    WORKTREE_TEST_FZF_SELECTION="$SWITCH_WORKTREE" WORKTREE_TEST_FZF_KEY=ctrl-y \
        "$REAL_ZSH" "$MANAGER" switch
)
if [[ ! -s "$EXTRA_PICKER_LOG" || -s "$CONFIRM_LOG" ]]; then
    print -u2 'FAIL: Ctrl-Y on the switch picker did not open the extra-file picker directly'
    exit 1
fi

(
    cd "$REPO"
    WORKTREE_TEST_FZF_SELECTION='Create new branch' WORKTREE_TEST_FZF_KEY=enter \
        WORKTREE_TEST_BRANCH_NAME=create-enter-flow "$REAL_ZSH" "$MANAGER" create
)
if [[ "$(wc -l < "$EXTRA_PICKER_LOG" | tr -d '[:space:]')" != 1 || -s "$CONFIRM_LOG" ]]; then
    print -u2 'FAIL: Enter on the create picker unexpectedly opened the extra-file picker'
    exit 1
fi

(
    cd "$REPO"
    WORKTREE_TEST_FZF_SELECTION='Create new branch' WORKTREE_TEST_FZF_KEY=ctrl-y \
        WORKTREE_TEST_BRANCH_NAME=create-copy-flow "$REAL_ZSH" "$MANAGER" create
)
if [[ "$(wc -l < "$EXTRA_PICKER_LOG" | tr -d '[:space:]')" != 2 || -s "$CONFIRM_LOG" ]]; then
    print -u2 'FAIL: Ctrl-Y on the create picker did not open the extra-file picker directly'
    exit 1
fi

git -C "$REPO" config --unset user.email
git -C "$REPO" config dotfiles.worktreeEmail 'fallback@example.invalid'
FALLBACK_WORKTREE="$WORKTREES/fallback-flow"
git -C "$REPO" worktree add -q -b fallback-flow "$FALLBACK_WORKTREE" main
"$REAL_ZSH" -c 'source "$1"; setup_environment; set_git_user "$2"' zsh \
    "$WORKERS/../lib/common.sh" "$FALLBACK_WORKTREE"

if git -C "$REPO" config --local --get user.email > /dev/null; then
    print -u2 'FAIL: fallback worktree email leaked into the shared repository config'
    exit 1
fi
if [[ "$(git -C "$FALLBACK_WORKTREE" config --show-scope --get user.email)" != $'worktree\tfallback@example.invalid' ]]; then
    print -u2 'FAIL: fallback email was not scoped to the worktree'
    exit 1
fi

git -C "$REPO" config --unset dotfiles.worktreeEmail
NO_FALLBACK_WORKTREE="$WORKTREES/no-fallback-flow"
git -C "$REPO" worktree add -q -b no-fallback-flow "$NO_FALLBACK_WORKTREE" main
"$REAL_ZSH" -c 'source "$1"; setup_environment; set_git_user "$2"' zsh \
    "$WORKERS/../lib/common.sh" "$NO_FALLBACK_WORKTREE"
if git -C "$NO_FALLBACK_WORKTREE" config --worktree --get user.email > /dev/null; then
    print -u2 'FAIL: worktree email was set without a repo-specific fallback'
    exit 1
fi

print 'PASS: worktree create/switch flows preserve Git identity, launch npm ci, and gate extra-file selection on Ctrl-Y'
