#!/usr/bin/env zsh

set -euo pipefail

ROOT="${0:A:h:h:h:h:h}"
TEST_DIR="$(mktemp -d)"
trap 'rm -rf "$TEST_DIR"' EXIT

git init -q -b main "$TEST_DIR"
git -C "$TEST_DIR" config user.name 'Identity Test'
git -C "$TEST_DIR" config user.email 'lalitkumar.meena.lk@gmail.com'
git -C "$TEST_DIR" config core.hooksPath "$ROOT/scripts/hooks"

expect_blocked() {
    local scenario="$1"
    shift

    local output
    if output="$("$@" 2>&1)"; then
        print -u2 "FAIL: $scenario commit was accepted"
        return 1
    fi
    if [[ "$output" != *'Commit blocked:'* ]]; then
        print -u2 "FAIL: $scenario failed for a reason other than the email guard: $output"
        return 1
    fi
}

git -C "$TEST_DIR" commit -q --allow-empty -m 'expected identity'

git -C "$TEST_DIR" config user.email 'wrong@example.invalid'
expect_blocked 'local config' git -C "$TEST_DIR" commit --allow-empty -m 'wrong config'
git -C "$TEST_DIR" config user.email 'lalitkumar.meena.lk@gmail.com'

expect_blocked 'author env' env GIT_AUTHOR_EMAIL=wrong@example.invalid \
    git -C "$TEST_DIR" commit --allow-empty -m 'wrong author env'
expect_blocked 'committer env' env GIT_COMMITTER_EMAIL=wrong@example.invalid \
    git -C "$TEST_DIR" commit --allow-empty -m 'wrong committer env'
expect_blocked 'command-line config' git -C "$TEST_DIR" -c user.email=wrong@example.invalid \
    commit --allow-empty -m 'wrong command-line config'
expect_blocked 'explicit author' git -C "$TEST_DIR" commit --allow-empty \
    --author='Identity Test <wrong@example.invalid>' -m 'wrong explicit author'
expect_blocked 'no-verify' git -C "$TEST_DIR" commit --allow-empty --no-verify \
    --author='Identity Test <wrong@example.invalid>' -m 'wrong no-verify author'

if [[ "$(git -C "$TEST_DIR" rev-list --count HEAD)" != 1 ]]; then
    print -u2 'FAIL: a rejected commit reached history'
    exit 1
fi

print 'PASS: commit email guard rejects unexpected author and committer identities'
