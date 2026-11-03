#!/usr/bin/env python3
"""The updater must restore stderr after interactive-shell prompt setup."""

import os
from pathlib import Path
import subprocess
import tempfile


ROOT = Path(__file__).resolve().parents[4]
UPDATER = ROOT / "tmux/.config/tmux/scripts/popup/ai/update.sh"

with tempfile.TemporaryDirectory(prefix="ai-update-") as directory:
    fixture = Path(directory)
    mock_bin = fixture / "bin"
    mock_bin.mkdir()
    tmux = mock_bin / "tmux"
    tmux.write_text('#!/bin/sh\nprintf "%s" "$4" > "$CAPTURE"\n')
    tmux.chmod(0o755)
    # Znap restores this at precmd, which never runs in a zsh -lic command.
    (fixture / ".zshrc").write_text('exec 2> "$ZDOTDIR/startup-stderr"\n')
    probe = fixture / "probe"
    probe.write_text(
        '#!/bin/sh\n'
        'printf "launched:%s:%s\\n" "$AI_UPDATE_IN_WINDOW" "$UPDATE_MODE"\n'
        'printf "updater-stderr\\n" >&2\n'
    )
    probe.chmod(0o755)
    env = {
        **os.environ,
        "PATH": f"{mock_bin}:{os.environ['PATH']}",
        "HOME": directory,
        "ZDOTDIR": directory,
        "TMUX": "test",
        "AI_UPDATE_IN_WINDOW": "",
        "CAPTURE": str(fixture / "launch"),
    }
    for mode in ("--non-interactive", "--interactive", ""):
        env["UPDATE_MODE"] = mode
        subprocess.run(["zsh", str(UPDATER)], env=env, check=True, timeout=10)
        # Execute the actual generated launch command, substituting only the
        # installer entrypoint so this regression test cannot update packages.
        launch = (fixture / "launch").read_text().replace(str(UPDATER), str(probe))
        result = subprocess.run(
            ["zsh", "-f", "-c", launch], env=env, capture_output=True,
            text=True, check=True, timeout=10,
        )
        assert f"launched:1:{mode}\n" in result.stdout, result
        assert "updater-stderr\n" in result.stdout + result.stderr, (
            f"{mode or 'all'}: updater stderr remained trapped by prompt setup"
        )
    print("PASS: all update launch modes restore stderr after prompt setup")
