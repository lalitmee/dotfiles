"""Check source lookup and table navigation with real fzf in a terminal."""
import os
import fcntl
from pathlib import Path
import pty
import re
import select
import shutil
import subprocess
import struct
import tempfile
import termios
import time


root = Path(__file__).resolve().parents[3]
source = root / "tmux/.config/tmux/scripts/popup/search-keybindings.sh"
with tempfile.TemporaryDirectory(
    prefix="keybindings-", dir="/tmp/opencode" if Path("/tmp/opencode").is_dir() else None
) as directory:
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
    list-keys) printf '%s\n' 'bind-key -r -T prefix x display-message correct' 'bind-key -T prefix y display-message another' 'bind-key -T prefix g switch-client -T special' 'bind-key -T root F2 switch-client -T special' 'bind-key -T special ? display-message correct' ;;
    show-option) echo C-a ;;
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
    original_config = (config / "tmux.conf.local").read_text()
    (config / "tmux.conf.local").write_text("bind -T other x display-message wrong\n")
    subprocess.run(["zsh", str(script)], env=dict(env, KEY="x"), check=True)
    assert not (home / "jump").exists(), "missing binding must not jump to another table"
    (config / "tmux.conf.local").write_text(original_config)

    # Exercise the real fzf bindings, not an imitation of its reload actions.
    real_fzf = shutil.which("fzf")
    assert real_fzf, "fzf is required"
    fzf.write_text(f'#!/bin/sh\nexec "{real_fzf}" "$@"\n')
    pid, master = pty.fork()
    if pid == 0:
        fcntl.ioctl(0, termios.TIOCSWINSZ, struct.pack("HHHH", 30, 120, 0, 0))
        os.execvpe("zsh", ["zsh", "-f", str(script)], dict(
            env, TERM="xterm-256color", FZF_DEFAULT_OPTS="", FZF_DEFAULT_OPTS_FILE="/dev/null"
        ))

    def wait_for(text):
        output = b""
        deadline = time.monotonic() + 5
        while time.monotonic() < deadline:
            if select.select([master], [], [], 0.1)[0]:
                try:
                    output += os.read(master, 65536)
                except OSError as error:
                    raise AssertionError(f"picker exited waiting for {text!r}: {output!r}") from error
                if text.encode() in output:
                    time.sleep(0.2)  # Prompt changes can precede completion of fzf reload.
                    return
        raise AssertionError(f"missing {text!r}: {output!r}")

    reaped = False
    try:
        wait_for("Search tmux keybindings")
        os.write(master, b"\x14")  # Ctrl-T
        wait_for("Tables>")
        tables = (home / "tmp/keytables.txt").read_text().splitlines()
        rows = {row.split("\t")[1]: row.split("\t")[0] for row in tables}
        assert list(rows) == ["root", "prefix", "special"]
        plain = {table: re.sub(r"\x1b\[[0-9;]*m", "", row) for table, row in rows.items()}
        assert re.split(r"\s{2,}", plain["special"].strip()) == ["special", "C-a → g, F2", "1"]
        assert re.split(r"\s{2,}", plain["prefix"].strip()) == ["prefix", "C-a", "3"]
        assert re.split(r"\s{2,}", plain["root"].strip()) == ["root", "—", "1"]
        assert plain["root"].index("—") == plain["prefix"].index("C-a") == plain["special"].index("C-a")
        assert len({row.rindex("  ") for row in plain.values()}) == 1, plain
        colors = {table: re.search(r"\x1b\[(?:1;)?38;[25];[0-9;]+m", row)[0] for table, row in rows.items()}
        assert len(set(colors.values())) == 3
        for row in (home / "tmp/keybindings_all.txt").read_text().splitlines():
            display, table = row.split("\t")[:2]
            assert colors[table] in display, "table color must match in both views"
        os.write(master, b"special")
        time.sleep(0.1)
        os.write(master, b"\r")
        wait_for("Bindings>")
        os.write(master, b"\x1b[Z")  # Shift-Tab
        wait_for("Search tmux keybindings")
        os.write(master, b"\x14")
        wait_for("Tables>")
        os.write(master, b"special")
        time.sleep(0.1)
        os.write(master, b"\r")
        wait_for("Bindings>")
        os.write(master, b"\r")
        deadline = time.monotonic() + 5
        while time.monotonic() < deadline:
            done, status = os.waitpid(pid, os.WNOHANG)
            if done:
                reaped = True
                break
            time.sleep(0.05)
        else:
            raise AssertionError("Enter did not finish source selection")
        assert os.waitstatus_to_exitcode(status) == 0
        assert (home / "jump").read_text().strip() == f"nvim +4 {config}/tmux.conf.local"
    finally:
        if not reaped:
            os.killpg(pid, 9)
            os.waitpid(pid, 0)
        os.close(master)
print("PASS: literal source lookup and real-fzf table browsing, drill-down, and return")
