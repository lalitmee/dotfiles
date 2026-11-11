#!/usr/bin/env python3
"""Catch lost fallback, theme overrides, argument boundaries and exit status."""
import os
from pathlib import Path
import subprocess
import tempfile
import shutil
import tomllib
import plistlib

repo = Path(__file__).resolve().parents[3]
plugin = repo / "zsh/.zsh_plugins_config/tuicr.zsh"
assert plugin.is_file(), "tuicr theme selection is not implemented"
with tempfile.TemporaryDirectory(prefix="tuicr-theme-") as tmp:
    home = Path(tmp)
    binary = home / "bin/tuicr"
    binary.parent.mkdir()
    binary.write_text('#!/bin/sh\nprintf "%s\\n" "$@"\nexit 7\n')
    binary.chmod(0o755)
    env = dict(os.environ, HOME=tmp, XDG_CONFIG_HOME=f"{tmp}/config",
               XDG_STATE_HOME=f"{tmp}/state", PATH=f"{binary.parent}:{os.environ['PATH']}")

    def run(args):
        result = subprocess.run(
            ["zsh", "-fc", 'source "$1"; shift; tuicr "$@"', "zsh", str(plugin), *args],
            env=env, text=True, capture_output=True,
        )
        assert result.returncode == 7, result.stderr
        return result.stdout.splitlines()

    assert run(["--file", "a b.py"]) == ["--file", "a b.py"]
    theme = home / "config/tuicr/themes/omarchy.toml"
    theme.parent.mkdir(parents=True)
    theme.write_text('panel_bg = "#123456"\n')
    assert run(["--file", "a b.py"]) == ["--theme", "omarchy", "--file", "a b.py"]
    for args in [["--theme", "light"], ["--theme=light"], ["--file", "--", "--theme"]]:
        expected = args if args[0].startswith("--theme") else ["--theme", "omarchy", *args]
        assert run(args) == expected
    theme.unlink()
    theme.symlink_to(home / "missing")
    assert run(["--help"]) == ["--help"]
    theme.unlink()
    state = home / "state/omarchy/current/theme"
    state.mkdir(parents=True)
    hook = repo / "omarchy/.config/omarchy/hooks/theme-set.d/tuicr"
    subprocess.run(["bash", str(hook)], env=env, check=True)
    assert not theme.exists()
    (state / "tuicr.toml").write_text('panel_bg = "#123456"\n')
    (state / "Omarchy.tmTheme").write_text("syntax fixture")
    for _ in range(2):
        subprocess.run(["bash", str(hook)], env=env, check=True)
    assert theme.resolve() == state / "tuicr.toml"
    assert (theme.parent / "Omarchy.tmTheme").resolve() == state / "Omarchy.tmTheme"
    theme.unlink()
    theme.write_text("private config")
    result = subprocess.run(["bash", str(hook)], env=env, capture_output=True)
    assert result.returncode != 0
    assert theme.read_text() == "private config"

    renderer = Path("/usr/share/omarchy/bin/omarchy-theme-set-templates")
    if renderer.exists():
        templates = home / ".config/omarchy/themed"
        templates.mkdir(parents=True)
        for name in ["tuicr.toml.tpl", "Omarchy.tmTheme.tpl"]:
            shutil.copy(repo / "omarchy/.config/omarchy/themed" / name, templates)
        next_theme = home / ".local/state/omarchy/current/next-theme"
        next_theme.mkdir(parents=True)
        (next_theme / "colors.toml").write_text('''background = "#102030"
foreground = "#eeeeee"
accent = "#aabbcc"
selection = "#304050"
muted = "#778899"
green = "#00cc66"
red = "#ee3344"
blue = "#4488ff"
yellow = "#ffcc00"
magenta = "#cc66ff"
cyan = "#33dddd"
orange = "#ff9900"
''')
        subprocess.run(["bash", str(renderer)], env=dict(env, OMARCHY_PATH="/usr/share/omarchy"), check=True, capture_output=True)
        generated = tomllib.loads((next_theme / "tuicr.toml").read_text())
        fallback = tomllib.loads((repo / "tuicr/.config/tuicr/themes/cobalt2.toml").read_text())
        assert generated.keys() == fallback.keys()
        assert all(v.startswith("#") and len(v) == 7 for k, v in generated.items() if k != "syntax_theme")
        with (next_theme / generated["syntax_theme"]).open("rb") as f:
            assert plistlib.load(f)["settings"]
print("PASS: tuicr fallback, Omarchy selection, explicit overrides, arguments and exit status")
