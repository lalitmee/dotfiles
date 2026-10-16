#!/usr/bin/env zsh
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
WORKSPACE_DIR="$(cd "$SCRIPT_DIR/../../../.." && pwd)"
TMP_DIR="$(mktemp -d "$HOME/.sesh-test.XXXXXX")"
trap 'rm -rf "$TMP_DIR"' EXIT

mkdir -p "$TMP_DIR/bin" "$TMP_DIR/project.name with spaces"
export TMUX_LOG="$TMP_DIR/tmux.log"
export SESH_LOG="$TMP_DIR/sesh.log"
export GUM_LOG="$TMP_DIR/gum.log"
export GUM_INPUT_LOG="$TMP_DIR/gum-input.log"
export FOLDER="$TMP_DIR/project.name with spaces"
: > "$TMUX_LOG"
: > "$SESH_LOG"
: > "$GUM_LOG"

cat > "$TMP_DIR/bin/sesh" <<'EOF'
#!/usr/bin/env zsh
if [[ "$1" == list ]]; then
    print -r -- "$SESH_LIST"
elif [[ "$1" == connect ]]; then
    print -r -- "$*" >> "$SESH_LOG"
fi
EOF

cat > "$TMP_DIR/bin/gum" <<'EOF'
#!/usr/bin/env zsh
print -r -- "$*" >> "$GUM_LOG"
cat > "$GUM_INPUT_LOG"
print -r -- "$GUM_SELECTION"
EOF

cat > "$TMP_DIR/bin/tmux" <<'EOF'
#!/usr/bin/env zsh
print -r -- "$*" >> "$TMUX_LOG"
case "$1" in
    has-session) [[ "${SESSION_EXISTS:-0}" == 1 ]] ;;
    display-message) print -r -- mock-client ;;
esac
EOF
chmod +x "$TMP_DIR/bin/"*
export PATH="$TMP_DIR/bin:$PATH"

export SESH_LIST="$(printf '\033[36m\033[39m ~%s' "${FOLDER#$HOME}")"
export GUM_SELECTION="$SESH_LIST"

# A new folder selection starts the two named applications in order.
TMUX=mock-session TMUX_PANE=mock-pane zsh "$WORKSPACE_DIR/tmux/.config/tmux/scripts/sesh/gum.sh"
grep -q 'new-session .* -n nvim .* nvim' "$TMUX_LOG"
grep -q 'new-window .* -n code .* opencode' "$TMUX_LOG"
grep -Fxq 'set-window-option -t project_name with spaces:code automatic-rename off' "$TMUX_LOG"
grep -Fxq 'switch-client -t project_name with spaces' "$TMUX_LOG"
grep -Fq -- '--no-show-help' "$GUM_LOG"
if grep -Eq -- '(^| )--header([ =]|$)' "$GUM_LOG"; then
    print -u2 'Gum command should not include a custom header'
    exit 1
fi
if grep -Eq -- '(^| )--header\.(foreground|background)=' "$GUM_LOG"; then
    print -u2 'Gum command should not include header styling'
    exit 1
fi
grep -Fq -- '--text.foreground=#FFFFFF' "$GUM_LOG"
grep -Fq -- '--cursor-text.foreground=#FFC600' "$GUM_LOG"
grep -Fq -- '--text.background=#193549' "$GUM_LOG"
grep -Fq -- '--cursor-text.background=#0050A4' "$GUM_LOG"
grep -Fq -- '--no-strip-ansi' "$GUM_LOG"
grep -Fq $'\033[36m' "$GUM_INPUT_LOG"
grep -Fq '' "$GUM_INPUT_LOG"
! grep -q 'connect' "$SESH_LOG" 2>/dev/null

# An existing matching session is switched to, not rebuilt.
: > "$TMUX_LOG"
SESSION_EXISTS=1 TMUX=mock-session TMUX_PANE=mock-pane zsh "$WORKSPACE_DIR/tmux/.config/tmux/scripts/sesh/gum.sh"
grep -Fxq 'switch-client -t project_name with spaces' "$TMUX_LOG"
! grep -q 'new-session\|new-window' "$TMUX_LOG"

# Non-folder selections pass the icon without ANSI escapes to Sesh.
: > "$TMUX_LOG"
export SESH_LIST="$(printf '\033[36m\033[39m existing-session')"
export GUM_SELECTION="$SESH_LIST"
TMUX=mock-session zsh "$WORKSPACE_DIR/tmux/.config/tmux/scripts/sesh/gum.sh"
grep -Fxq 'connect  existing-session' "$SESH_LOG"
[[ ! -s "$TMUX_LOG" ]]

print 'Sesh startup tests passed.'
