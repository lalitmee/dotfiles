#!/usr/bin/env python3
"""Check real Gum output with Foot/Ghostty terminal types on private tmux sockets."""
import os
from pathlib import Path
import pty
import select
import shlex
import subprocess
import tempfile
import time

repo = Path(__file__).resolve().parents[3]
config = repo / 'tmux/.config/tmux/tmux.conf'
env = os.environ.copy()
for key in ('TMUX', 'TMUX_PANE', 'NO_COLOR', 'CLICOLOR', 'CLICOLOR_FORCE', 'FORCE_COLOR'):
    env.pop(key, None)
env['COLORTERM'] = 'truecolor'
gum = ['gum', 'style', '--background', '#193549', '--foreground', '#00AAFF', 'TRUECOLOR']

with tempfile.TemporaryDirectory(dir='/tmp/opencode') as tmp:
    root = Path(tmp)
    home = root / 'home'
    tmux_home = home / '.config/tmux'
    (tmux_home / 'plugins/tpm').mkdir(parents=True)
    (tmux_home / 'themes').mkdir()
    # Isolate unrelated personal bindings, plugins, and theme overlays.
    (tmux_home / 'tmux.conf.local').touch()
    (tmux_home / 'themes/cobalt2.conf').touch()
    tpm = tmux_home / 'plugins/tpm/tpm'
    tpm.write_text('#!/bin/sh\nexit 0\n')
    tpm.chmod(0o755)
    env.update(HOME=str(home), XDG_STATE_HOME=str(root / 'state'))

    for terminal in ('xterm-256color', 'xterm-ghostty'):
        socket = root / terminal
        tmux = ['tmux', '-S', str(socket)]
        terminal_env = env | {'TERM': terminal}
        master, slave = pty.openpty()
        command = (f'{shlex.join(gum)}; '
                   f'{shlex.join(gum)} > {shlex.quote(str(root / "redirected"))}; '
                   f'touch {shlex.quote(str(root / "done"))}; '
                   'sleep 30')
        client = subprocess.Popen(tmux + ['-f', str(config), 'new-session', command],
                                  env=terminal_env, stdin=slave, stdout=slave, stderr=slave,
                                  start_new_session=True)
        os.close(slave)
        try:
            output = b''
            deadline = time.monotonic() + 10
            while time.monotonic() < deadline:
                if select.select([master], [], [], 0.1)[0]:
                    output += os.read(master, 65536)
                if (root / 'done').exists():
                    break
            else:
                raise AssertionError(f'{terminal}: Gum did not finish: {output!r}')
            pane = subprocess.check_output(tmux + ['capture-pane', '-p', '-e'], env=terminal_env)
            assert b'48;2;25;53;73' in pane, f'{terminal}: background was downgraded: {pane!r}'
            assert b'38;2;0;170;255' in pane, f'{terminal}: foreground was downgraded: {pane!r}'
            redirected = (root / 'redirected').read_bytes()
            assert redirected == b'TRUECOLOR\n', f'redirected output contains ANSI: {redirected!r}'
            print(f'PASS: {terminal} inside tmux preserves RGB and plain redirected output')
        finally:
            subprocess.run(tmux + ['kill-server'], env=terminal_env, capture_output=True)
            client.wait(timeout=5)
            os.close(master)
            (root / 'redirected').unlink(missing_ok=True)
            (root / 'done').unlink(missing_ok=True)

        master, slave = pty.openpty()
        client = subprocess.Popen(gum, env=terminal_env, stdout=slave, stderr=slave)
        os.close(slave)
        output = b''
        try:
            while True:
                try:
                    output += os.read(master, 65536)
                except OSError:
                    break
            assert client.wait(timeout=5) == 0
        finally:
            os.close(master)
        assert b'48;2;25;53;73' in output, f'{terminal}: direct RGB output changed'
        assert subprocess.check_output(gum, env=terminal_env) == b'TRUECOLOR\n'
        print(f'PASS: {terminal} outside tmux preserves RGB and plain redirected output')
