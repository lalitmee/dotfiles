#!/usr/bin/env python3
"""Exercise the real switcher, fzf, and tmux on an isolated socket."""
import os
import fcntl
from pathlib import Path
import pty
import shlex
import subprocess
import struct
import tempfile
import termios
import time


root = Path(__file__).resolve().parents[3]
switcher = root / "tmux/.config/tmux/scripts/window-switcher.sh"
assert switcher.is_file(), "window switcher has not been implemented"


def wait_for(check):
    deadline = time.monotonic() + 8
    while time.monotonic() < deadline:
        if check():
            return
        time.sleep(0.05)
    raise AssertionError("timed out waiting for tmux/fzf")


with tempfile.TemporaryDirectory(
    prefix="window-switcher-", dir="/tmp/opencode" if Path("/tmp/opencode").is_dir() else None
) as directory:
    socket = str(Path(directory) / "socket")

    def tmux(*args):
        return subprocess.check_output(
            ["tmux", "-S", socket, *args], text=True
        ).strip()

    master, slave = pty.openpty()
    fcntl.ioctl(slave, termios.TIOCSWINSZ, struct.pack("HHHH", 50, 160, 0, 0))
    client = None
    try:
        tmux("-f", "/dev/null", "new-session", "-d", "-s", "alpha", "-x", "160", "-y", "50")
        tmux("set-option", "-g", "status", "off")
        tmux("rename-window", "-t", "alpha:0", "shared window")
        tmux("send-keys", "-t", "alpha:0", "printf 'PREVIEW-CONTENT-CHECK\\n'", "Enter")
        tmux("new-session", "-d", "-s", "beta")
        tmux("link-window", "-s", "alpha:0", "-t", "beta:7")
        tmux("new-window", "-d", "-t", "alpha:1", "-n", "a-window-name-that-is-longer-than-the-column", "sleep 30")
        env = dict(os.environ, TERM="xterm-256color", FZF_DEFAULT_OPTS="", FZF_DEFAULT_OPTS_FILE="/dev/null")
        env.pop("TMUX", None)
        client = subprocess.Popen(
            ["tmux", "-S", socket, "attach-session", "-t", "alpha"],
            stdin=slave, stdout=slave, stderr=slave, env=env,
        )
        wait_for(lambda: bool(tmux("list-clients")))
        env["TMUX"] = f"{socket},{tmux('display-message', '-p', '#{pid}')},0"

        # A window ID alone would lose the selected session for linked windows.
        env["FZF_DEFAULT_OPTS"] = "--filter=beta:7"
        subprocess.run(["zsh", "-f", str(switcher)], env=env, check=True, timeout=10)
        assert tmux("list-clients", "-F", "#{session_name}:#{window_index}") == "beta:7"

        env["FZF_DEFAULT_OPTS"] = "--filter=no-such-window-unique"
        subprocess.run(["zsh", "-f", str(switcher)], env=env, check=True, timeout=10)
        assert tmux("list-clients", "-F", "#{session_name}:#{window_index}") == "beta:7"

        # Run interactively in a real pane: check labels, preview, and Escape.
        result = Path(directory) / "exit-code"
        command = (
            f"FZF_DEFAULT_OPTS='' FZF_DEFAULT_OPTS_FILE=/dev/null zsh -f {shlex.quote(str(switcher))}; "
            f"printf '%s' $? > {shlex.quote(str(result))}; sleep 30"
        )
        pane = tmux("new-window", "-P", "-F", "#{pane_id}", "-t", "beta:", "-n", "picker", command)
        wait_for(lambda: "SESSION:INDEX" in tmux("capture-pane", "-p", "-t", pane))
        screen = tmux("capture-pane", "-p", "-t", pane)
        assert "WINDOW NAME" in screen and "COMMAND" in screen, screen
        heading = next(line for line in screen.splitlines() if "SESSION:INDEX" in line)
        long_row = next(line for line in screen.splitlines() if "alpha:1" in line)
        assert long_row.index("sleep") == heading.index("COMMAND"), screen
        styled = tmux("capture-pane", "-ep", "-t", pane)
        import re
        session_styles = {}
        number_styles = {}
        for name in ("alpha:0", "alpha:1", "beta:0", "beta:7"):
            session, index = name.split(":")
            line = next(line for line in styled.splitlines() if name in re.sub(r"\x1b\[[0-9;]*m", "", line))
            codes = re.findall(r"\x1b\[([0-9;]*)m", line.split(session)[0])
            colors = [code for code in codes if "38;2;" in code]
            assert colors, f"missing session foreground: {line!r}"
            assert any("1" in code.split(";") for code in codes), f"missing bold: {line!r}"
            session_styles[name] = colors[-1].split("38;2;")[-1]
            number = re.search(r":((?:\x1b\[[0-9;]*m)*)" + index, line)
            assert number, f"missing index: {line!r}"
            number_colors = re.findall(r"38;2;([0-9;]+)m", number.group(1))
            number_styles[name] = number_colors[-1] if number_colors else session_styles[name]
        assert session_styles["alpha:0"] == session_styles["alpha:1"]
        assert session_styles["beta:0"] == session_styles["beta:7"]
        assert session_styles["alpha:0"] != session_styles["beta:0"]
        assert number_styles["alpha:0"] == number_styles["beta:0"]
        assert number_styles["alpha:0"] != number_styles["alpha:1"]
        wait_for(lambda: "PREVIEW-CONTENT-CHECK" in tmux("capture-pane", "-p", "-t", pane))
        def preview_on_right():
            lines = tmux("capture-pane", "-p", "-t", pane).splitlines()
            return any(line.find("PREVIEW-CONTENT-CHECK") >= 80 for line in lines)

        tmux("resize-window", "-t", pane, "-x", "240", "-y", "50")
        wait_for(preview_on_right)
        preview_lines = tmux("capture-pane", "-p", "-t", pane).splitlines()
        assert any(80 <= line.find("PREVIEW-CONTENT-CHECK") < 110 for line in preview_lines), "preview should occupy 60% of the width"
        tmux("resize-window", "-t", pane, "-x", "160", "-y", "50")
        wait_for(lambda: not preview_on_right() and "PREVIEW-CONTENT-CHECK" in tmux("capture-pane", "-p", "-t", pane))
        tmux("send-keys", "-t", pane, "M-p")
        wait_for(lambda: "SESSION:INDEX" not in tmux("capture-pane", "-p", "-t", pane))
        assert "PREVIEW-CONTENT-CHECK" in tmux("capture-pane", "-p", "-t", pane)
        tmux("send-keys", "-t", pane, "M-p")
        wait_for(lambda: "SESSION:INDEX" in tmux("capture-pane", "-p", "-t", pane))
        tmux("send-keys", "-t", pane, "Escape")
        wait_for(result.exists)
        assert result.read_text() == "0", "Escape should close cleanly"
        print("PASS: linked-window session targeting, no match, labels, pane preview, and Escape")
    finally:
        subprocess.run(["tmux", "-S", socket, "kill-server"], capture_output=True)
        if client is not None:
            client.kill()
            client.wait(timeout=5)
        os.close(master)
        os.close(slave)
