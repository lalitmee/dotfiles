#!/usr/bin/env python3
"""Isolated missing/present Omarchy checks; no live server or AI commands."""
import os
from pathlib import Path
import subprocess
import tempfile

repo = Path(__file__).resolve().parents[3]
with tempfile.TemporaryDirectory(dir='/tmp/opencode') as tmp:
    home = Path(tmp)
    theme = home / 'state/omarchy/current/theme'
    env = os.environ | {'HOME': tmp, 'XDG_STATE_HOME': str(home / 'state'), 'REPO': str(repo),
        'BAT_CONFIG_PATH': str(theme / 'bat-config')}

    def shell(code, runtime='zsh'):
        subprocess.run([runtime, '-c', code], env=env, check=True)

    shell('source "$REPO/zsh/.fzf_config"; [[ "$FZF_DEFAULT_OPTS" == *bg:#193549* && -z "${BAT_CONFIG_PATH:-}" ]]')
    for runtime in ['bash', 'zsh']:
        shell('source "$REPO/tmux/.config/tmux/scripts/lib/popup-style.sh"; [[ "${popup_fzf_colors[*]}" == *bg:#193549* && -z "${BAT_CONFIG_PATH:-}" ]]', runtime)
    theme.mkdir(parents=True)
    (theme / 'fzf-colors').write_text('--color=bg:#112233,fg:#abcdef\n')
    (theme / 'bat-config').write_text('--theme=Omarchy\n')
    (theme / 'colors.toml').write_text('accent = "#123456"\n')
    shell('source "$REPO/zsh/.fzf_config"; _fzf_refresh_theme; [[ "$FZF_DEFAULT_OPTS" == *bg:#112233* && "$BAT_CONFIG_PATH" == */bat-config ]]')
    for runtime in ['bash', 'zsh']:
        shell('source "$REPO/tmux/.config/tmux/scripts/lib/popup-style.sh"; [[ "${popup_fzf_colors[*]}" == *bg:#112233* && "$popup_key" == $\'\\033[1;38;2;18;52;86m\' ]]', runtime)

    loader = repo / 'nvim/.config/nvim/lua/core/omarchy_theme.lua'
    lua = '''
local applied
vim = {env={HOME=os.getenv('HOME'), XDG_STATE_HOME=os.getenv('XDG_STATE_HOME')},
    cmd={colorscheme=function(name) applied=name end}, o={},
    notify=function() end, log={levels={WARN=1}}}
local theme=dofile(arg[1]); theme.apply(); assert(applied==arg[2])
'''
    for expected in ['cobalt2', 'fixture']:
        if expected == 'fixture':
            (theme / 'neovim.lua').write_text('return {{"LazyVim/LazyVim", opts={colorscheme="fixture"}}}')
        subprocess.run(['lua', '-', str(loader), expected], input=lua, text=True, env=env, check=True)

    assert '--theme="cobalt2"' in (repo / 'bat/.config/bat/config').read_text()
    git_config = repo / 'git/.config/git/config'
    def delta():
        return subprocess.check_output(['git', 'config', '--file', str(git_config), '--includes', '--get', 'delta.syntax-theme'], env=env, text=True).strip()
    assert delta() == 'cobalt2'
    default_theme = home / '.local/state/omarchy/current/theme'
    default_theme.mkdir(parents=True)
    (default_theme / 'delta.gitconfig').write_text('[delta]\nsyntax-theme = Omarchy\n')
    assert delta() == 'Omarchy'
    tmux = (repo / 'tmux/.config/tmux/tmux.conf').read_text()
    assert tmux.index('themes/cobalt2.conf') < tmux.index('source-file -q ~/.local/state/omarchy/current/theme/tmux.conf')
print('PASS: fzf/popup missing and present palettes, stale bat cleanup, Neovim selection, bat/delta defaults, tmux overlay order')
