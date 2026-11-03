#!/usr/bin/env zsh
set -e
root=${0:A:h:h:h:h:h}
script="$root/tmux/.config/tmux/scripts/popup/ai/update.sh"
source <(sed '/^# Run the updates/,$d' "$script")
output=$(ai_update_spinner 'Testing progress' sh -c 'exit 7' 2>&1) && rc=0 || rc=$?
[[ $rc == 7 ]] || { print -u2 "expected exit 7, got $rc"; exit 1; }
[[ "$output" == *'Testing progress'* ]] || { print -u2 'missing progress box'; exit 1; }
[[ "$output" == *'╭'* && "$output" == *'╯'* ]] || { print -u2 'missing rounded border'; exit 1; }
python3 - "$script" <<'PY'
import os, pty, re, select, struct, subprocess, sys, termios, fcntl

master, slave = pty.openpty()
fcntl.ioctl(slave, termios.TIOCSWINSZ, struct.pack('HHHH', 30, 100, 0, 0))
command = 'source <(sed "/^# Run the updates/,$ d" "$1"); print BEFORE; ai_update_spinner "Testing progress" sh -c "sleep 0.2; exit 7"; print "AFTER:$?"'
env = {**os.environ, 'TMUX': '', 'TERM': 'xterm-256color'}
process = subprocess.Popen(['zsh', '-c', command, '_', sys.argv[1]], stdin=slave, stdout=slave, stderr=slave, env=env)
os.close(slave)
data = b''
while select.select([master], [], [], 5)[0]:
    try:
        chunk = os.read(master, 65536)
    except OSError:
        break
    if not chunk:
        break
    data += chunk
os.close(master)
assert process.wait(timeout=5) == 0
text = data.decode()
plain = re.sub(r'\x1b\[[0-9;?]*[A-Za-z]', '', text)
top = next(line for line in plain.splitlines() if '╭' in line)
assert len(top.strip()) == 98, f'progress box width is {len(top.strip())}, expected 98'
assert re.search(r'\x1b\[\d+A\r\x1b\[J', text), 'completed progress box was not cleared'
assert 'BEFORE' in text and 'AFTER:7' in text, 'earlier output or exit status lost'
PY
print 'PASS: boxed progress preserves command status'
