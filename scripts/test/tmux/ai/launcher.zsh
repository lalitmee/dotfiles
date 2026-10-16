#!/usr/bin/env zsh
set -eu

repo=${0:A:h:h:h:h:h}
script="$repo/tmux/.config/tmux/scripts/popup/ai/tool.sh"
[[ -x "$script" ]] || { print -u2 'AI launcher must be executable by tmux'; exit 1; }
tmp=$(mktemp -d /tmp/opencode/ai-launcher.XXXXXX)
trap 'rm -rf "$tmp"' EXIT
mkdir -p "$tmp/bin"
cat > "$tmp/bin/fzf" <<'EOF'
#!/usr/bin/env zsh
print window
EOF
cat > "$tmp/bin/gum" <<'EOF'
#!/usr/bin/env zsh
case "$1" in
    input) print -r -- "$INPUT" ;;
    choose) print -r -- "$ACTION" ;;
    spin) shift; while [[ "$1" != -- ]]; do shift; done; shift; "$@" ;;
esac
EOF
cat > "$tmp/bin/tmux" <<'EOF'
#!/usr/bin/env zsh
print -r -- "$*" >> "$LOG"
EOF
cat > "$tmp/bin/agy" <<'EOF'
#!/usr/bin/env zsh
print -r -- "agy $*" >> "$LOG"
[[ "$NAMER" == agy ]] && print -r -- 'Fix Login Flow' || exit 1
EOF
cat > "$tmp/bin/opencode" <<'EOF'
#!/usr/bin/env zsh
print -r -- "opencode $*" >> "$LOG"
[[ "$NAMER" == opencode ]] && print -r -- 'fix-login-flow' || exit 1
EOF
cat > "$tmp/bin/codex" <<'EOF'
#!/usr/bin/env zsh
print -r -- "codex $*" >> "$LOG"
[[ "$NAMER" == codex ]] && print -r -- 'fix-login-flow' || exit 1
EOF
chmod +x "$tmp/bin/"*
export PATH="$tmp/bin:$PATH" LOG="$tmp/log" INPUT ACTION NAMER

check() {
    : > "$LOG"
    zsh "$script" "$1"
    grep -F -- "$2" "$LOG" >/dev/null || { cat "$LOG"; print -u2 "missing: $2"; exit 1; }
}

INPUT='' ACTION='' NAMER='' check codex 'new-window -n 🧬 codex'
INPUT='Fix Login Flow' ACTION='Use as name' NAMER='' check codex 'new-window -n 🧬 fix-login-flow'
INPUT='Fix Login Flow' ACTION='Generate name' NAMER=agy check codex 'new-window -n 🧬 fix-login-flow'
grep -F 'display-message AI codex: named fix-login-flow via agy' "$LOG" >/dev/null
INPUT='Fix the login flow when the token expires' ACTION='Generate name' NAMER=opencode check pi 'new-window -n 🥧 fix-login-flow'
grep -F 'opencode run --model opencode/beam-free' "$LOG" >/dev/null
INPUT='Fix the login flow when the token expires' ACTION='Generate name and send prompt' NAMER='' check codex 'new-window -n 🧬 codex'
grep -F 'Fix the login flow when the token expires' "$LOG" >/dev/null
grep -F 'display-message AI codex: naming failed; using agent name' "$LOG" >/dev/null
: > "$LOG"
INPUT='Fix login' ACTION='Generate name and send prompt' NAMER=agy zsh "$script" crush && exit 1
grep -F 'does not have a verified initial-prompt invocation' "$LOG" >/dev/null
! grep -F 'new-window' "$LOG" >/dev/null
print 'ai launcher checks passed'
