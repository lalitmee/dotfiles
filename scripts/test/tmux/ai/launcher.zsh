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
    input) print -u2 'expected multiline gum write'; exit 1 ;;
    write) print -r -- "write $*" >> "$LOG"; print -r -- "$INPUT" ;;
    choose) print -u2 'unexpected gum choose'; exit 1 ;;
    filter) [[ "$*" == *'✏️ Use as name'* && "$*" == *'✨ Generate name'* && "$*" == *'💬 Generate name and send prompt'* ]] || exit 1; print -r -- "$ACTION" ;;
    spin) print -r -- "spin $*" >> "$LOG"; print -u2 'Naming spinner visible'; shift; while [[ "$1" != -- ]]; do shift; done; shift; "$@" ;;
esac
EOF
cat > "$tmp/bin/tmux" <<'EOF'
#!/usr/bin/env zsh
print -r -- "$*" >> "$LOG"
EOF
cat > "$tmp/bin/tput" <<'EOF'
#!/usr/bin/env zsh
[[ "$1" == lines ]] && print 20 || print 80
EOF
cat > "$tmp/bin/agy" <<'EOF'
#!/usr/bin/env zsh
print -r -- "agy $*" >> "$LOG"
[[ "$*" == *'--model gemini-3.8-flash-medium --effort medium'* && "$*" == *'--print='* ]] || { print -u2 'invalid agy naming arguments'; exit 1; }
[[ "$NAMER" == agy ]] && print -r -- 'Fix Login Flow' || exit 1
EOF
cat > "$tmp/bin/opencode" <<'EOF'
#!/usr/bin/env zsh
print -r -- "opencode $*" >> "$LOG"
[[ "$*" == *'--model openai/gpt-6-luna#high --agent plan'* ]] || { print -u2 'invalid OpenCode naming arguments'; exit 1; }
[[ "$NAMER" == invalid ]] && { print 'this output has too many words'; exit 0; }
[[ "$NAMER" == opencode ]] && print -r -- 'fix-login-flow' || exit 1
EOF
cat > "$tmp/bin/codex" <<'EOF'
#!/usr/bin/env zsh
print -r -- "codex $*" >> "$LOG"
[[ "$*" == *'--model gpt-6-luna'* && "$*" == *'model_reasoning_effort="high"'* ]] || { print -u2 'invalid Codex naming arguments'; exit 1; }
[[ "$NAMER" == codex ]] && print -r -- 'fix-login-flow' || exit 1
EOF
cat > "$tmp/bin/pi" <<'EOF'
#!/usr/bin/env zsh
print -r -- "pi $*" >> "$LOG"
[[ "$*" == *'--model openai/gpt-6-luna:high'* && "$*" == *'--no-session --no-tools --no-extensions --print'* ]] || { print -u2 'invalid Pi naming arguments'; exit 1; }
[[ "$NAMER" == pi ]] && print -r -- 'fix-login-flow' || exit 1
EOF
cat > "$tmp/bin/timeout" <<'EOF'
#!/usr/bin/env zsh
print -r -- "timeout $*" >> "$LOG"
[[ "$NAMER" == slow ]] && exit 124
shift 2
"$@"
EOF
chmod +x "$tmp/bin/"*
export HOME="$tmp" XDG_STATE_HOME="$tmp/state" SHELL=/bin/zsh
export PATH="$tmp/bin:$repo/bin/.config/bin:/usr/bin:/bin" LOG="$tmp/log" INPUT ACTION NAMER

check() {
    : > "$LOG"
    zsh "$script" "$1"
    grep -F -- "$2" "$LOG" >/dev/null || { cat "$LOG"; print -u2 "missing: $2"; exit 1; }
}

INPUT='' ACTION='' NAMER='' check codex 'new-window -n 🧬 codex'
grep -F 'write write --' "$LOG" >/dev/null
INPUT='Fix Login Flow' ACTION='✏️ Use as name' NAMER='' check codex 'new-window -n 🧬 fix-login-flow'
INPUT='Fix Login Flow' ACTION='✨ Generate name' NAMER=agy check codex 'new-window -n 🧬 fix-login-flow'
grep -F 'display-message AI codex: named fix-login-flow via agy' "$LOG" >/dev/null
grep -F 'opencode run --model openai/gpt-6-luna#high --agent plan' "$LOG" >/dev/null
grep -F 'codex exec --ephemeral --sandbox read-only --model gpt-6-luna --config model_reasoning_effort="high"' "$LOG" >/dev/null
grep -F 'pi --model openai/gpt-6-luna:high --no-session --no-tools --no-extensions --print' "$LOG" >/dev/null
grep -F 'agy --mode plan --model gemini-3.8-flash-medium --effort medium' "$LOG" >/dev/null
[[ "$(grep -E '^(opencode|codex|pi|agy) ' "$LOG" | awk '{print $1}' | tr '\n' ' ')" == 'opencode codex pi agy ' ]]
grep -F -- '--padding=9 0 0 30' "$LOG" >/dev/null
INPUT='Fix Login Flow' ACTION='✨ Generate name' NAMER=agy zsh "$script" codex 2> "$tmp/spinner"
grep -F 'Naming spinner visible' "$tmp/spinner" >/dev/null
INPUT='Fix the login flow when the token expires' ACTION='✨ Generate name' NAMER=opencode check pi 'new-window -n 🥧 fix-login-flow'
grep -F 'timeout --kill-after=1s 20s opencode run' "$LOG" >/dev/null
INPUT='Fix Login Flow' ACTION='✨ Generate name' NAMER=codex check pi 'new-window -n 🥧 fix-login-flow'
grep -F 'display-message AI naming: opencode failed (exit 1); trying next backend' "$LOG" >/dev/null
[[ "$(grep -E '^(opencode|codex) ' "$LOG" | awk '{print $1}' | tr '\n' ' ')" == 'opencode codex ' ]]
INPUT='Fix Login Flow' ACTION='✨ Generate name' NAMER=pi check pi 'new-window -n 🥧 fix-login-flow'
[[ "$(grep -E '^(opencode|codex|pi) ' "$LOG" | awk '{print $1}' | tr '\n' ' ')" == 'opencode codex pi ' ]]
INPUT=$'Long prompt\nwith another line' ACTION='✨ Generate name' NAMER=slow check pi 'new-window -n 🥧 pi'
grep -F -- 'timeout --kill-after=1s 20s opencode run' "$LOG" >/dev/null
grep -F 'display-message AI pi: naming failed; using agent name' "$LOG" >/dev/null
grep -F 'display-message AI naming: opencode timed out or was killed (exit 124); trying next backend' "$LOG" >/dev/null
INPUT='Private task description' ACTION='✨ Generate name' NAMER=invalid check pi 'new-window -n 🥧 pi'
grep -F 'display-message AI naming: opencode returned an invalid name; trying next backend' "$LOG" >/dev/null
! grep '^display-message AI naming:' "$LOG" | grep -E 'Private task description|this output has too many words'
INPUT='Fix the login flow when the token expires' ACTION='💬 Generate name and send prompt' NAMER='' check codex 'new-window -n 🧬 codex'
grep -F 'Fix the login flow when the token expires' "$LOG" >/dev/null
grep -F 'display-message AI codex: naming failed; using agent name' "$LOG" >/dev/null
: > "$LOG"
INPUT='Fix login' ACTION='💬 Generate name and send prompt' NAMER=agy zsh "$script" crush && exit 1
grep -F 'does not have a verified initial-prompt invocation' "$LOG" >/dev/null
! grep -F 'new-window' "$LOG" >/dev/null
print 'ai launcher checks passed'
