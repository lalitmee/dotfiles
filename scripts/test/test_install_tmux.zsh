#!/usr/bin/env zsh

set -eu

repo_root="${0:A:h:h:h}"
installer="${INSTALL_TMUX:-$repo_root/bin/.config/bin/install-tmux}"
tmp_dir="$(mktemp -d)"
trap 'rm -rf "$tmp_dir"' EXIT

mkdir -p "$tmp_dir/bin" "$tmp_dir/home/.cache"
touch "$tmp_dir/home/.cache/tmux-deps-installed"
export HOME="$tmp_dir/home"
export TEST_LOG="$tmp_dir/commands.log"
export PATH="$tmp_dir/bin:/usr/bin:/bin"

cat > "$tmp_dir/bin/tmux" <<'EOF'
#!/bin/sh
echo "tmux 3.7c"
EOF

cat > "$tmp_dir/bin/gum_style" <<'EOF'
#!/bin/sh
:
EOF

cat > "$tmp_dir/bin/git" <<'EOF'
#!/bin/sh
printf 'git %s\n' "$*" >> "$TEST_LOG"
if [ "$1" = ls-remote ] && [ "${TEST_GIT_MODE:-}" = tag ]; then
    printf '%s\trefs/tags/9.9\n' "$(printf 'a%.0s' $(seq 1 40))"
    exit 0
fi
if [ "$1" = clone ] && [ "${TEST_GIT_MODE:-}" = tag ]; then
    for arg do destination="$arg"; done
    mkdir -p "$destination"
    printf 'exit 0\n' > "$destination/autogen.sh"
    printf '#!/bin/sh\nexit 0\n' > "$destination/configure"
    chmod +x "$destination/configure"
    exit 0
fi
exit 1
EOF

cat > "$tmp_dir/bin/sudo" <<'EOF'
#!/bin/sh
printf 'sudo %s\n' "$*" >> "$TEST_LOG"
if [ "$1" = apt-get ]; then
    exit 0
fi
exit 1
EOF

cat > "$tmp_dir/bin/apt-get" <<'EOF'
#!/bin/sh
if [ "$1" = -s ]; then
    case "${MOCK_APT_MODE:-ok}" in
        fail) exit 1 ;;
        extra) printf 'Remv tmux [3.4]\nRemv libextra [1.0]\n' ;;
        *) printf 'Remv tmux [3.4]\n' ;;
    esac
    exit 0
fi
printf 'apt-get %s\n' "$*" >> "$TEST_LOG"
exit 0
EOF

cat > "$tmp_dir/bin/make" <<'EOF'
#!/bin/sh
printf 'make %s\n' "$*" >> "$TEST_LOG"
exit 1
EOF

cat > "$tmp_dir/bin/dpkg-query" <<'EOF'
#!/bin/sh
case "$1" in
    -W) printf 'install ok installed\n' ;;
    -S) printf 'tmux: /usr/bin/tmux\n' ;;
    *) exit 2 ;;
esac
EOF

chmod +x "$tmp_dir/bin"/*

assert() {
    if ! eval "$1"; then
        print -u2 -- "FAIL: $2"
        exit 1
    fi
}

if "$installer" --bogus >/dev/null 2>&1; then
    print -u2 -- "FAIL: unknown option must fail"
    exit 1
fi
assert '[[ ! -e "$TEST_LOG" ]]' 'invalid options must fail before external commands'

if "$installer" --next extra >/dev/null 2>&1; then
    print -u2 -- "FAIL: extra arguments must fail"
    exit 1
fi
assert '[[ ! -e "$TEST_LOG" ]]' 'extra arguments must fail before external commands'

if "$installer" >/dev/null 2>&1; then
    print -u2 -- "FAIL: unavailable latest-tag lookup must fail"
    exit 1
fi
assert '[[ ! -e "$HOME/Projects/Personal/Github/tmux" ]]' \
    'failed tag lookup must not create a checkout'
assert '[[ ! -e "$TEST_LOG" ]] || ! grep -Eq "git (clone|checkout)|make|sudo" "$TEST_LOG"' \
    'failed tag lookup must stop before clone, build, or privileged install'

mkdir -p "$HOME/Projects/Personal/Github/tmux"
print -r -- "keep me" > "$HOME/Projects/Personal/Github/tmux/sentinel"
: > "$TEST_LOG"
export TEST_GIT_MODE=tag
if "$installer" >/dev/null 2>&1; then
    print -u2 -- "FAIL: failed clone must fail installation"
    exit 1
fi
assert '[[ "$(<"$HOME/Projects/Personal/Github/tmux/sentinel")" == "keep me" ]]' \
    'installer must preserve an existing checkout path and its contents'
assert 'grep -Eq "git clone" "$TEST_LOG"' 'installer should attempt the isolated clone after a valid release lookup'
assert 'grep -Eq "make[[:space:]]*$" "$TEST_LOG"' 'test fixture must fail during the unprivileged build'
assert '! grep -Eq "sudo install|sudo make" "$TEST_LOG"' \
    'failed build must not invoke privileged install or make'
assert '! grep -Eq "sudo apt-get remove" "$TEST_LOG"' \
    'normal installation must never remove the distro package'

cat > "$tmp_dir/bin/mock-tmux" <<'EOF'
#!/bin/sh
echo "tmux 3.7c"
EOF
chmod +x "$tmp_dir/bin/mock-tmux"
TMUX_INSTALL_SOURCE_ONLY=1 zsh -c 'source "$1"; verify_installed_version "$2" 3.7c' _ \
    "$repo_root/bin/.config/bin/install-tmux" "$tmp_dir/bin/mock-tmux"
if TMUX_INSTALL_SOURCE_ONLY=1 zsh -c 'source "$1"; verify_installed_version "$2" 3.7b' _ \
    "$repo_root/bin/.config/bin/install-tmux" "$tmp_dir/bin/mock-tmux"; then
    print -u2 -- "FAIL: version verification must reject a mismatched build"
    exit 1
fi

run_cleanup() {
    MOCK_CURRENT_VERSION="$1" MOCK_APT_MODE="$2" TMUX_INSTALL_SOURCE_ONLY=1 \
        zsh -c 'source "$1"; get_current_version() { print -r -- "$MOCK_CURRENT_VERSION"; }; get_latest_version() { print -r -- 3.7c; }; cleanup_distro_package' _ \
        "$repo_root/bin/.config/bin/install-tmux"
}

: > "$TEST_LOG"
if run_cleanup 3.7b ok >/dev/null 2>&1; then
    print -u2 -- "FAIL: cleanup must reject an outdated /usr/local tmux"
    exit 1
fi
assert '! grep -Eq "sudo apt-get remove" "$TEST_LOG"' 'invalid replacement must not remove the distro package'

if run_cleanup 3.7c fail >/dev/null 2>&1; then
    print -u2 -- "FAIL: cleanup must reject a failed apt simulation"
    exit 1
fi
assert '! grep -Eq "sudo apt-get remove" "$TEST_LOG"' 'failed apt simulation must not remove the distro package'

if run_cleanup 3.7c extra >/dev/null 2>&1; then
    print -u2 -- "FAIL: cleanup must reject additional package removals"
    exit 1
fi
assert '! grep -Eq "sudo apt-get remove" "$TEST_LOG"' 'extra apt removals must not be applied'

if MOCK_CURRENT_VERSION=3.7c MOCK_APT_MODE=ok TMUX_INSTALL_SOURCE_ONLY=1 \
    setsid -w zsh -c 'source "$1"; get_current_version() { print -r -- 3.7c; }; get_latest_version() { print -r -- 3.7c; }; cleanup_distro_package' _ \
    "$repo_root/bin/.config/bin/install-tmux" >/dev/null 2>&1; then
    print -u2 -- "FAIL: non-interactive cleanup must refuse package removal"
    exit 1
fi
assert '! grep -Eq "sudo apt-get remove" "$TEST_LOG"' 'non-interactive cleanup must not remove the distro package'

cat > "$tmp_dir/run-cleanup" <<EOF
#!/usr/bin/env zsh
TMUX_INSTALL_SOURCE_ONLY=1 source "$repo_root/bin/.config/bin/install-tmux"
get_current_version() { print -r -- 3.7c; }
get_latest_version() { print -r -- 3.7c; }
cleanup_distro_package
EOF
chmod +x "$tmp_dir/run-cleanup"
printf 'n\n' | script -qec "$tmp_dir/run-cleanup" /dev/null >/dev/null 2>&1
assert '! grep -Eq "sudo apt-get remove" "$TEST_LOG"' 'cancelling confirmation must not remove the distro package'

print -- "PASS: installer validates arguments and fails closed on release lookup"
