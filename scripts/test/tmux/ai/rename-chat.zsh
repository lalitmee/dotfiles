#!/usr/bin/env zsh
set -eu

ROOT=${0:A:h:h:h:h:h}
SCRIPT="$ROOT/tmux/.config/tmux/scripts/popup/ai/rename-chat.sh"
TMUX_BIN=$(whence -p tmux)
tmp=$(mktemp -d)
trap 'rm -rf "$tmp"' EXIT
mkdir -p "$tmp/bin"

cat > "$tmp/bin/tmux" <<'EOF'
#!/usr/bin/env bash
if [[ "$1" == display-message ]]; then
    case "$5" in
        '#{window_id}')
            count=0
            [[ -f "$WINDOW_COUNT" ]] && count=$(<"$WINDOW_COUNT")
            count=$((count + 1))
            printf '%s\n' "$count" > "$WINDOW_COUNT"
            if [[ "$count" == 1 ]]; then printf '@7\n'; else printf '%s\n' "${CURRENT_WINDOW:-@7}"; fi
            ;;
        '#{pane_current_path}') printf '%s\n' "${PANE_PATH:-/project with spaces}" ;;
        '#{pane_current_command}') printf '%s\n' "${PANE_COMMAND:-opencode}" ;;
    esac
elif [[ "$1" == rename-window ]]; then
    printf '%s\n' "$*" >> "$TMUX_LOG"
elif [[ "$1" == display-message && "$2" != -p ]]; then
    printf '%s\n' "$*" >> "$TMUX_LOG"
fi
EOF
cat > "$tmp/bin/gum" <<'EOF'
#!/usr/bin/env bash
case "$1" in
    filter)
        printf 'filter\n' >> "$GUM_LOG"
        [[ ${CANCEL_PICKER:-0} == 1 ]] && exit 1
        printf '%s\n' "${SELECTED_SESSION:-session-1}"
        ;;
    write) printf '%s\n' "${DESCRIPTION:-implement auth}" ;;
    choose) printf '%s\n' "${SELECTED_PROVIDER:-opencode}" ;;
    spin)
        while [[ "$1" != -- ]]; do shift; done
        shift
        "$@"
        ;;
esac
EOF
cat > "$tmp/bin/python3" <<'EOF'
#!/usr/bin/env bash
if [[ "$1" == */chat-sessions.py ]]; then
    printf '<%s>\n' "$@" >> "$ADAPTER_LOG"
    [[ "$3" == claude ]] && exit 1
    [[ ${ADAPTER_FAIL:-0} == 1 ]] && exit 1
    if [[ "$2" == list ]]; then
        printf '%s\n' '[{"id":"session-1","title":"Implement auth"}]'
    else
        printf '%s\n' "${PROMPT_JSON:-\"implement auth flow\"}"
    fi
else
    command python3 "$@"
fi
EOF
cat > "$tmp/bin/opencode" <<'EOF'
#!/usr/bin/env bash
printf '%s\n' "opencode $*" >> "$CALL_LOG"
if [[ "$1" == run ]]; then printf '%s\n' "${NAME_RESPONSE:-window-title}"; fi
EOF
cat > "$tmp/bin/codex" <<'EOF'
#!/usr/bin/env bash
printf '%s\n' "codex $*" >> "$CALL_LOG"
printf '%s\n' "${NAME_RESPONSE:-window-title}"
EOF
cat > "$tmp/bin/pi" <<'EOF'
#!/usr/bin/env bash
printf '%s\n' "pi $*" >> "$CALL_LOG"
printf '%s\n' "${NAME_RESPONSE:-window-title}"
EOF
cat > "$tmp/bin/agy" <<'EOF'
#!/usr/bin/env bash
printf '%s\n' "agy $*" >> "$CALL_LOG"
printf '%s\n' "${NAME_RESPONSE:-window-title}"
EOF
cat > "$tmp/bin/hold-shell" <<'EOF'
#!/usr/bin/env bash
printf 'interactive result shell retained\n'
EOF
cat > "$tmp/bin/timeout" <<'EOF'
#!/usr/bin/env bash
[[ ${TIMEOUT_FAIL:-0} == 1 ]] && exit 124
exec /usr/bin/timeout "$@"
EOF
chmod +x "$tmp/bin/"*
export PATH="$tmp/bin:$PATH" TMUX_LOG="$tmp/tmux.log" GUM_LOG="$tmp/gum.log" CALL_LOG="$tmp/call.log" ADAPTER_LOG="$tmp/adapter.log" WINDOW_COUNT="$tmp/window.count" SHELL="$tmp/bin/hold-shell"
rehash
[[ "$(whence -p codex)" == "$tmp/bin/codex" ]] || { print -u2 "unexpected codex path: $(whence -p codex)"; exit 1; }

run_script() {
    : > "$TMUX_LOG"
    rm -f "$WINDOW_COUNT"
    ( source "$SCRIPT" '%1' ) >"$tmp/out" 2>"$tmp/err"
}

export ADAPTER_FAIL=1
( source "$SCRIPT" '%1' --window ) >"$tmp/window.out" 2>"$tmp/window.err" || true
grep -F 'session access unavailable for opencode' "$tmp/window.out" >/dev/null \
    || { print -u2 'new-window flow did not print the provider failure'; exit 1; }
grep -F 'interactive result shell retained' "$tmp/window.out" >/dev/null \
    || { print -u2 "new-window flow did not keep its result visible: $(cat "$tmp/window.out") $(cat "$tmp/window.err")"; exit 1; }
unset ADAPTER_FAIL
: > "$CALL_LOG"
rm -f "$WINDOW_COUNT"
export NAME_RESPONSE='one-two-three'
( source "$SCRIPT" '%1' --window ) >"$tmp/window-success.out" 2>"$tmp/window-success.err"
grep -F 'Chat renamed to one-two-three via opencode' "$tmp/window-success.out" >/dev/null \
    || { print -u2 'new-window flow did not print the rename result'; exit 1; }
! grep -F 'interactive result shell retained' "$tmp/window-success.out" >/dev/null \
    || { print -u2 'successful new-window flow did not close automatically'; exit 1; }
unset NAME_RESPONSE

if run_script; then
    print -r -- "$(cat "$tmp/tmux.log")" | grep -F 'rename-window -t @7 window-title' >/dev/null
    grep -Fx '</project with spaces>' "$ADAPTER_LOG" >/dev/null || { print -u2 'pane project path was split'; exit 1; }
else
    print -u2 "rename flow failed: $(cat "$tmp/err") $(cat "$tmp/out")"
    exit 1
fi

export CANCEL_PICKER=1
run_script || true
[[ ! -s "$TMUX_LOG" ]] || { print -u2 'cancelled picker renamed the window'; exit 1; }
unset CANCEL_PICKER

export NAME_RESPONSE='one-two-three-four'
if run_script; then
    print -u2 "invalid names unexpectedly renamed the window: $(cat "$TMUX_LOG"); $(cat "$CALL_LOG"); $(tail -10 "$tmp/err")"
    exit 1
fi
[[ ! -s "$TMUX_LOG" ]] || { print -u2 'invalid name renamed the window'; exit 1; }
unset NAME_RESPONSE

export PROMPT_JSON='""'
: > "$CALL_LOG"
if run_script; then
    print -u2 'empty prompt unexpectedly renamed the window'
    exit 1
fi
[[ ! -s "$TMUX_LOG" && ! -s "$CALL_LOG" ]] || { print -u2 'empty prompt invoked naming or renamed the window'; exit 1; }
unset PROMPT_JSON

export TIMEOUT_FAIL=1
if run_script; then
    print -u2 'timed-out name generation unexpectedly renamed the window'
    exit 1
fi
[[ ! -s "$TMUX_LOG" ]] || { print -u2 'timed-out name generation renamed the window'; exit 1; }
unset TIMEOUT_FAIL

export CURRENT_WINDOW=@8
if run_script; then
    print -u2 'changed pane target unexpectedly renamed a window'
    exit 1
fi
[[ ! -s "$TMUX_LOG" ]] || { print -u2 'changed pane target renamed a window'; exit 1; }
unset CURRENT_WINDOW

export PANE_COMMAND=bash SELECTED_PROVIDER=claude
if run_script; then
    print -u2 'unsupported Claude session access unexpectedly succeeded'
    exit 1
fi
[[ ! -s "$TMUX_LOG" ]] || { print -u2 'unsupported Claude provider renamed a window'; exit 1; }
unset SELECTED_PROVIDER
unset PANE_COMMAND

export PROMPT_JSON='"$(touch '"$tmp"'/marker)"'
run_script
[[ ! -e "$tmp/marker" ]] || { print -u2 'prompt text was executed as shell code'; exit 1; }
grep -F '$(touch ' "$CALL_LOG" >/dev/null || { print -u2 'prompt was not forwarded as data'; exit 1; }
unset PROMPT_JSON

export CURRENT_WINDOW=@7
export PANE_COMMAND=agy
: > "$CALL_LOG"
run_script
print -r -- "$(cat "$tmp/tmux.log")" | grep -F 'rename-window -t @7 window-title' >/dev/null
grep -F 'Chat'\''s first user prompt: implement auth' "$CALL_LOG" >/dev/null \
    || { print -u2 'AGY description was not sent to the namer'; exit 1; }
unset PANE_COMMAND

socket="chat-name-$$"
binding_file="$tmp/ai-tools.conf"
awk '/^bind-key -T ai-tools n /' "$ROOT/tmux/.config/tmux/tmux.conf.local" > "$binding_file"
SHELL=/bin/zsh TMUX_TMPDIR="$tmp" "$TMUX_BIN" -L "$socket" -f /dev/null new-session -d -s ai-chat-test
SHELL=/bin/zsh TMUX_TMPDIR="$tmp" "$TMUX_BIN" -L "$socket" source-file "$binding_file"
binding=$(SHELL=/bin/zsh TMUX_TMPDIR="$tmp" "$TMUX_BIN" -L "$socket" list-keys -T ai-tools n)
[[ "$binding" == *new-window* && "$binding" == *rename-chat.sh* && "$binding" == *--window* && "$binding" == *'#{pane_id}'* ]] \
    || { print -u2 "tmux chat rename binding does not start a retained window with the source pane: $binding"; exit 1; }
grep -Fx $'n\tName the current agent chat window' \
    "$ROOT/tmux/.config/tmux/scripts/popup/help/tables/ai-tools.txt" >/dev/null \
    || { print -u2 'AI-tools help table is missing the chat rename shortcut'; exit 1; }
SHELL=/bin/zsh TMUX_TMPDIR="$tmp" "$TMUX_BIN" -L "$socket" kill-server
print 'chat rename checks passed'
