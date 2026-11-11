#!/usr/bin/env python3
"""Check full-width message/prompt styling on an isolated tmux socket."""
from pathlib import Path
import os
import re
import subprocess
import tempfile

repo = Path(__file__).resolve().parents[3]
with tempfile.TemporaryDirectory() as tmp:
    socket = str(Path(tmp) / 'tmux.sock')
    env = os.environ | {'TMUX': ''}

    def tmux(*args):
        return subprocess.check_output(['tmux', '-S', socket, *args], env=env, text=True).strip()

    tmux('-f', '/dev/null', 'new-session', '-d', '-s', 'message-test', 'sleep 60')
    try:
        tmux('source-file', str(repo / 'tmux/.config/tmux/themes/cobalt2.conf'))
        for name, accent, background in [('Cobalt2', '#ffc600', '#1C1C1C'), ('overlay', '#abcdef', '#123456')]:
            if name == 'overlay':
                lines = []
                for filename in ['tmux.conf.tpl', 'tmux-personal.conf.tpl']:
                    source = (repo / 'omarchy/.config/omarchy/themed' / filename).read_text()
                    for line in source.splitlines():
                        if line.startswith('set -g message'):
                            lines.append(re.sub(r'{{\s*(\w+)\s*}}', lambda m: {'accent': accent, 'background': background}[m[1]], line))
                config = Path(tmp) / 'overlay.conf'
                config.write_text('\n'.join(lines) + '\n')
                tmux('source-file', str(config))
            normal = tmux('show-option', '-gqv', 'message-style')
            command = tmux('show-option', '-gqv', 'message-command-style')
            fmt = tmux('show-option', '-gqv', 'message-format')
            assert f'fill={accent}' in normal, (name, normal)
            assert f'fill={background}' in command, (name, command)
            assert 'bold' in normal.split(','), (name, normal)
            assert 'bold' in command.split(','), (name, command)
            assert '#[width=100%]' in fmt, (name, fmt)
            assert 'command_prompt' in fmt and 'message-command-style' in fmt, (name, fmt)
    finally:
        tmux('kill-server')
print('PASS: full-width message and vi command bars, Cobalt2 baseline and Omarchy overlay')
