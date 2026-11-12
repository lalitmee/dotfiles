#!/usr/bin/env python3
"""Render both palettes with real Gum and hostile inherited backgrounds."""
import os
from pathlib import Path
import re
import subprocess

repo = Path(__file__).resolve().parents[4]
env = os.environ | {
    'TERM': 'xterm-256color', 'COLORTERM': 'truecolor', 'TMUX': '',
    'BACKGROUND': '#008855', 'GUM_STYLE_BACKGROUND': '#008855',
    'BORDER_BACKGROUND': '#880055', 'GUM_STYLE_BORDER_BACKGROUND': '#880055',
    'FOREGROUND': '#ff0000', 'GUM_STYLE_FOREGROUND': '#ff0000',
    'CLICOLOR_FORCE': '1', 'FORCE_COLOR': '1',
}
env.pop('NO_COLOR', None)
cases = [
    ('bin/.config/bin/workmux-agent-palette', '''
        get_terminal_geometry() { print '100 60'; }
        clear_screen_and_scrollback() { :; }
        resolve_agent_cmd() { [[ "$1" == opencode ]] && print opencode; }
        scan_agents
        record_agent_history opencode opencode '#00AAFF' 0 2 '1/o'
        render_palette
    ''', 'Workmux Agent Launcher'),
    ('tmux/.config/tmux/scripts/popup/runner/server-runner.sh', '''
        server_terminal_geometry() { print '100 60'; }
        clear() { :; }
        server_scripts=(dev start)
        render_server_menu 'Node.js project' npm
    ''', 'Workmux Server Launcher'),
]
for script, command, title in cases:
    result = subprocess.run(
        ['zsh', '-f', '-c', 'source "$1"; ' + command, 'test', str(repo / script)],
        env=env, capture_output=True, check=True,
    )
    output = result.stdout.decode()
    assert title in output, script
    sgr = re.findall(r'\x1b\[([0-9;:]*)m', output)
    assert not any(re.search(r'(^|[;:])48[;:](2|5)[;:]', code) for code in sgr), (
        f'{script}: inherited background leaked into rendering'
    )
    assert '\x1b[38;2;0;170;255m' in output, f'{script}: row truecolor lost'
print('PASS: both palettes preserve row RGB colors without inherited backgrounds')
