"""Catch wrong-table and punctuation matches in Enter-to-source lookup."""
import os
from pathlib import Path
import subprocess
import tempfile


root = Path(__file__).resolve().parents[3]
source = root / "tmux/.config/tmux/scripts/popup/search-keybindings.sh"
with tempfile.TemporaryDirectory(prefix="keybindings-") as directory:
    home = Path(directory)
    config = home / ".config/tmux"
    config.mkdir(parents=True)
    (config / "tmux.conf.local").write_text(
        "bind -T other x display-message wrong\n"
        "bind -r 'x' display-message correct\n"
        "bind -T special a display-message wrong\n"
        "bind -T special '?' display-message correct\n"
    )
    (config / "tmux.conf").write_text("")
    script = home / "picker.zsh"
    script.write_text(source.read_text().replace("/tmp/tmux", str(home / "tmp")))
    tmux = home / "tmux"
    tmux.write_text("""#!/bin/sh
case "$1" in
    list-keys) printf '%s\n' 'bind-key -r -T prefix x display-message correct' 'bind-key -T special ? display-message correct' ;;
    display) echo 120 ;;
    display-popup) for arg do command=$arg; done; zsh -c "$command" ;;
    new-window) printf '%s\n' "$2" > "$HOME/jump" ;;
esac
""")
    tmux.chmod(0o755)
    fzf = home / "fzf"
    fzf.write_text("#!/bin/sh\nawk -F '\t' -v key=\"$KEY\" '$3 == key {print; exit}'\n")
    fzf.chmod(0o755)
    env = dict(os.environ, HOME=str(home), PATH=f"{home}:{os.environ['PATH']}", EDITOR="true")
    for key, line in [("x", 2), ("?", 4)]:
        subprocess.run(["zsh", str(script)], env=dict(env, KEY=key), check=True)
        assert (home / "jump").read_text().strip() == f"nvim +{line} {config}/tmux.conf.local", key
    (home / "jump").unlink()
    (config / "tmux.conf.local").write_text("bind -T other x display-message wrong\n")
    subprocess.run(["zsh", str(script)], env=dict(env, KEY="x"), check=True)
    assert not (home / "jump").exists(), "missing binding must not jump to another table"
print("PASS: repeatable, quoted, punctuation, and table-specific source lookup")
