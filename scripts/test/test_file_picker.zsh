#!/usr/bin/env zsh
# Test runner for tmux-file-picker

set -euo pipefail

# Define paths
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
WORKSPACE_DIR="$(cd "$SCRIPT_DIR/../.." && pwd)"
MOCK_DIR="$SCRIPT_DIR/tmp_mock_bin"

# Cleanup mock dir on exit
cleanup() {
    rm -rf "$MOCK_DIR"
}
trap cleanup EXIT

mkdir -p "$MOCK_DIR"

# 1. Create mock tmux
cat << 'EOF' > "$MOCK_DIR/tmux"
#!/usr/bin/env zsh
case "$*" in
    *pane_id*)
        echo "%1"
        ;;
    *pane_current_path*)
        echo "$(cd "$(dirname "$0")/../.." && pwd)"
        ;;
    *pane_pid*)
        echo "12345"
        ;;
    *send-keys*)
        echo "sent-keys: $*"
        ;;
    *)
        exit 0
        ;;
esac
EOF
chmod +x "$MOCK_DIR/tmux"

# 2. Create mock fzf that just forwards input
cat << 'EOF' > "$MOCK_DIR/fzf"
#!/usr/bin/env zsh
cat
EOF
chmod +x "$MOCK_DIR/fzf"

# Add mock bin to PATH
export PATH="$MOCK_DIR:$PATH"
export TMUX="mock-session"

echo "Running tmux-file-picker test..."

# Run the script and capture stderr
STDERR_FILE="$SCRIPT_DIR/test_stderr.log"
stdout=$(zsh "$WORKSPACE_DIR/bin/.config/bin/tmux-file-picker" 2>"$STDERR_FILE" || true)
stderr=$(cat "$STDERR_FILE")
rm -f "$STDERR_FILE"

echo "Stdout: $stdout"
echo "Stderr: $stderr"

# Assertions
if echo "$stderr" | grep -q "unexpected argument"; then
    echo "FAIL: Unexpected argument error detected in stderr!"
    exit 1
else
    echo "SUCCESS: No unexpected argument error found!"
    exit 0
fi
