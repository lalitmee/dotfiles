#!/usr/bin/env python3
"""Exercise quote/helper colors without a terminal or network."""
import json
import os
from pathlib import Path
import subprocess
import tempfile

repo = Path(__file__).resolve().parents[4]
with tempfile.TemporaryDirectory(dir='/tmp/opencode') as tmp:
    root = Path(tmp)
    stub = root / 'gum'
    stub.write_text('#!/usr/bin/env python3\nimport json,os,sys\nfrom pathlib import Path\nPath(os.environ["ARGS"]).write_text(json.dumps(sys.argv[1:]))\n')
    stub.chmod(0o755)
    env = os.environ | {'HOME': tmp, 'XDG_STATE_HOME': str(root / 'state'),
        'PATH': f'{root}:{repo}/bin/.config/bin:/usr/bin:/bin', 'ARGS': str(root / 'args'),
        'BACKGROUND': '#008855', 'GUM_STYLE_BACKGROUND': '#008855', 'TMUX': ''}

    def run(command):
        subprocess.run(command, env=env, check=True, capture_output=True)
        return json.loads((root / 'args').read_text())

    args = run([str(repo / 'bin/.config/bin/gum_style'), 'hello'])
    assert args[args.index('--background') + 1] == ''
    assert args[args.index('--foreground') + 1] == '#FFC600'
    theme = root / 'state/omarchy/current/theme'
    theme.mkdir(parents=True)
    (theme / 'colors.toml').write_text('background = "#112233"\naccent = "#abcdef"\nyellow = "#fedcba"\n')
    args = run([str(repo / 'bin/.config/bin/gum_style'), 'hello', '#123456', '40'])
    assert args[args.index('--background') + 1] == '#112233'
    assert args[args.index('--foreground') + 1] == '#123456'
    args = run([str(repo / 'bin/.config/bin/quote'), 'programming'])
    assert args[args.index('--foreground') + 1] == '#fedcba'
    assert args[args.index('--width') + 1] != '213'
    # Both shells accept the shared palette; invalid values never execute.
    palette = repo / 'bin/.config/bin/gum-theme.sh'
    for shell in ['bash', 'zsh']:
        subprocess.run([shell, '-c', 'source "$1"; [[ "$GUM_FILTER_MATCH_FOREGROUND" == "#fedcba" && "$GUM_SPIN_SPINNER_BACKGROUND" == "#112233" ]]', 'test', str(palette)], env=env, check=True)
    (theme / 'colors.toml').unlink()
    subprocess.run(['zsh', '-c', 'source "$1"; [[ -z "$GUM_INPUT_HEADER_BACKGROUND" && "$GUM_FILTER_MATCH_FOREGROUND" == "#FFC600" ]]', 'test', str(palette)], env=env, check=True)
print('PASS: quote/helper fallback, current palette, explicit color, and inherited background')
