#!/usr/bin/env zsh
set -euo pipefail

repo_root="${0:A:h:h:h:h:h}"
script="$repo_root/bin/.config/bin/kill-process"
tmpdir="$(mktemp -d)"
trap 'rm -rf "$tmpdir"' EXIT

fail() {
    print -u2 -- "FAIL: $1"
    exit 1
}

[[ -x "$script" ]] || fail "expected executable script at $script"

mockbin="$tmpdir/bin"
mkdir -p "$mockbin"

cat > "$mockbin/ps" <<'PS'
#!/usr/bin/env zsh
if [[ "$*" == "-axo pid=,user=,pcpu=,pmem=,etime=,command=" ]]; then
    cat <<'ROWS'
  101 alice  1.0  0.5  01:00  /usr/bin/node server.js
  202 bob    0.2  0.1  02:00  /Applications/Safari.app/Contents/MacOS/Safari
  303 root   0.0  0.0  10:00  /sbin/launchd
ROWS
    exit 0
fi
if [[ "$*" == *"ppid="* ]]; then
    print 1
    exit 0
fi
exec /bin/ps "$@"
PS

cat > "$mockbin/lsof" <<'LSOF'
#!/usr/bin/env zsh
cat <<'ROWS'
p101
cnode
n*:3000
p101
cnode
n127.0.0.1:5173
p202
cSafari
n*:8080
ROWS
LSOF

chmod +x "$mockbin/ps" "$mockbin/lsof"

PATH="$mockbin:$PATH" "$script" --list > "$tmpdir/list"

grep -Eq '^101 +3000,5173 +alice ' "$tmpdir/list" ||
    fail "node row missing merged ports or owner"
grep -Eq '^202 +8080 +bob ' "$tmpdir/list" || fail "Safari row missing port or owner"
grep -Eq '^303 +- +root ' "$tmpdir/list" || fail "portless row missing"
[[ $(grep -c '^101 ' "$tmpdir/list") -eq 1 ]] || fail "PID 101 listed more than once"
grep -Eq '^1 ' "$tmpdir/list" && fail "own process tree ancestor (init) should be excluded"

"$script" --details $$ < /dev/null > "$tmpdir/details"
grep -q "PID $$" "$tmpdir/details" || fail "details header missing PID"
grep -q 'Owner' "$tmpdir/details" || fail "details missing owner"
grep -q 'Directory' "$tmpdir/details" || fail "details missing directory"
grep -q 'Command' "$tmpdir/details" || fail "details missing command"

sleep 30 &
pid=$!
"$script" --kill "$pid" --yes --grace 1 >/dev/null
exit_code=0
wait "$pid" || exit_code=$?
[[ $exit_code -eq 143 ]] || fail "expected SIGTERM exit 143, got $exit_code"

zsh -c 'trap "" TERM; while true; do sleep 0.1; done' &
pid=$!
sleep 0.3
"$script" --kill "$pid" --yes --grace 1 >/dev/null
exit_code=0
wait "$pid" || exit_code=$?
pkill -P "$pid" 2>/dev/null || true
[[ $exit_code -eq 137 ]] || fail "expected SIGKILL exit 137 for TERM-ignoring process, got $exit_code"

if "$script" --kill 1 --yes >/dev/null 2>"$tmpdir/err1"; then
    fail "PID 1 should be refused"
fi
grep -q 'PID 1' "$tmpdir/err1" || fail "PID 1 refusal reason missing"

if "$script" --kill $$ --yes >/dev/null 2>"$tmpdir/err2"; then
    fail "own shell should be refused"
fi
grep -q 'this shell' "$tmpdir/err2" || fail "own-shell refusal reason missing"

if "$script" --kill 999999 --yes >/dev/null 2>"$tmpdir/err3"; then
    fail "missing PID should be refused"
fi
grep -q 'not running' "$tmpdir/err3" || fail "missing-PID refusal reason missing"

print "kill-process test passed"
