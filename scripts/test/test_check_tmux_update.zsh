#!/usr/bin/env zsh

set -eu

repo_root="${0:A:h:h:h}"
tmp_dir="$(mktemp -d)"
trap 'rm -rf "$tmp_dir"' EXIT
mkdir -p "$tmp_dir/bin"
export PATH="$tmp_dir/bin:/usr/bin:/bin"
export TEST_LOG="$tmp_dir/notifications.log"

cat > "$tmp_dir/bin/tmux" <<'EOF'
#!/bin/sh
echo "tmux ${MOCK_TMUX_VERSION:-3.7c}"
EOF
cat > "$tmp_dir/bin/git" <<'EOF'
#!/bin/sh
if [ "${MOCK_GIT_MODE:-ok}" = fail ]; then
    exit 1
fi
printf '%s\trefs/tags/3.7c\n' "$(printf 'a%.0s' $(seq 1 40))"
EOF
cat > "$tmp_dir/bin/notify-send" <<'EOF'
#!/bin/sh
printf '%s\n' "$*" >> "$TEST_LOG"
EOF
chmod +x "$tmp_dir/bin"/*

checker="$repo_root/bin/.config/bin/check-tmux-update"
assert_status() {
    local expected="$1"
    shift
    local actual=0
    "$@" >/dev/null 2>&1 || actual=$?
    if [[ "$actual" != "$expected" ]]; then
        print -u2 -- "FAIL: expected exit $expected, got $actual: $*"
        exit 1
    fi
}

export MOCK_TMUX_VERSION=3.7c
export MOCK_GIT_MODE=ok
assert_status 0 "$checker"
[[ ! -e "$TEST_LOG" ]] || { print -u2 -- "FAIL: current release must not notify"; exit 1; }

quiet_output=$("$checker" --quiet)
[[ -z "$quiet_output" ]] || { print -u2 -- "FAIL: --quiet must suppress normal output"; exit 1; }

export MOCK_TMUX_VERSION=3.7b
assert_status 0 "$checker"
[[ -s "$TEST_LOG" ]] || { print -u2 -- "FAIL: update must notify when notify-send exists"; exit 1; }

export MOCK_TMUX_VERSION=not-a-version
assert_status 1 "$checker"
export MOCK_TMUX_VERSION=3.7b

export MOCK_GIT_MODE=fail
assert_status 1 "$checker"

rm "$tmp_dir/bin/notify-send"
export MOCK_GIT_MODE=ok
assert_status 0 "$checker"
assert_status 0 "$checker" --quiet
assert_status 2 "$checker" --unknown

print -- "PASS: checker reports update state and handles optional notifications"
