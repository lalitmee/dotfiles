#!/usr/bin/env zsh

set -euo pipefail

repo_root="${0:A:h:h:h:h}"
zshrc_path="$repo_root/zsh/.zshrc"
autostart_path="$repo_root/zsh/.zsh_plugins_config/tmux-autostart.zsh"
tmp_root="$(mktemp -d)"
trap 'rm -rf "$tmp_root"' EXIT

if ! grep -q 'tmux-autostart\.zsh' "$zshrc_path"; then
    print -u2 "FAIL: $zshrc_path does not source tmux-autostart.zsh"
    exit 1
fi

if [[ ! -r "$autostart_path" ]]; then
    print -u2 "FAIL: missing $autostart_path"
    exit 1
fi

typeset -i failures=0

make_proc_chain() {
    local chain_dir="$1"
    shift
    rm -rf "$chain_dir"
    mkdir -p "$chain_dir"

    local entry pid ppid comm
    for entry in "$@"; do
        pid="${entry%%:*}"
        local rest="${entry#*:}"
        ppid="${rest%%:*}"
        comm="${rest#*:}"
        mkdir -p "$chain_dir/$pid"
        print -r -- "$comm" > "$chain_dir/$pid/comm"
        print -r -- "$pid ($comm) S $ppid 0 0 0 0 0 0" > "$chain_dir/$pid/stat"
    done
}

run_case() {
    local expected="$1"
    local label="$2"
    local start_pid="$3"
    local proc_dir="$4"
    shift 4

    local actual=1
    if env -i PATH="$PATH" HOME="$HOME" ZSH_TMUX_AUTOSTART_FUNCTIONS_ONLY=1 ZSH_PROC_ROOT="$proc_dir" ZSH_START_PID="$start_pid" "$@" \
        zsh -fc 'source "$1"; _skip_tmux_autostart' _ "$autostart_path" 2>/dev/null; then
        actual=0
    fi

    if (( actual != expected )); then
        print -u2 "FAIL: $label (expected=$expected actual=$actual)"
        (( failures++ ))
    else
        print -r -- "PASS: $label"
    fi
}

normal_proc="$tmp_root/normal"
make_proc_chain "$normal_proc" "100:50:zsh" "50:10:ghostty" "10:1:Hyprland"

# Negative cases (should autostart tmux -> _skip_tmux_autostart returns 1)
run_case 1 "normal ghostty terminal" 100 "$normal_proc"
run_case 1 "normal kitty TERM_PROGRAM" 100 "$normal_proc" TERM_PROGRAM=kitty

pipewire_proc="$tmp_root/pipewire"
make_proc_chain "$pipewire_proc" "100:50:zsh" "50:1:pipewire"
run_case 1 "pipewire does not false-match pi" 100 "$pipewire_proc"

# Positive env-var cases (should skip tmux -> _skip_tmux_autostart returns 0)
run_case 0 "REX_SESSION skips" 100 "$normal_proc" REX_SESSION=1
run_case 0 "HERDR_ENV skips" 100 "$normal_proc" HERDR_ENV=1
run_case 0 "ANTIGRAVITY_AGENT skips" 100 "$normal_proc" ANTIGRAVITY_AGENT=1
run_case 0 "ANTIGRAVITY_CONVERSATION_ID skips" 100 "$normal_proc" ANTIGRAVITY_CONVERSATION_ID=abc
run_case 0 "TERM_PROGRAM=antigravity skips" 100 "$normal_proc" TERM_PROGRAM=antigravity
run_case 0 "TERM_PROGRAM=vscode skips" 100 "$normal_proc" TERM_PROGRAM=vscode
run_case 0 "TERM_PROGRAM=t3code skips" 100 "$normal_proc" TERM_PROGRAM=t3code
run_case 0 "VSCODE_INJECTION skips" 100 "$normal_proc" VSCODE_INJECTION=1
run_case 0 "CLAUDECODE skips" 100 "$normal_proc" CLAUDECODE=1
run_case 0 "CODEX_THREAD_ID skips" 100 "$normal_proc" CODEX_THREAD_ID=thread-1
run_case 0 "OPENCODE skips" 100 "$normal_proc" OPENCODE=1

# Positive process-ancestry cases (no env vars set)
for app_spec in \
    "antigravity:100:50:zsh|50:20:language_server|20:1:antigravity" \
    "chatgpt:100:50:zsh|50:1:ChatGPT" \
    "t3code-appimage:100:50:zsh|50:1:T3-Code.AppImag" \
    "t3code-bin:100:50:zsh|50:1:t3code" \
    "claude-desktop:100:50:zsh|50:1:claude-desktop" \
    "opencode-pty:100:50:zsh|50:20:opencode-pty|20:1:opencode.exe" \
    "codex:100:50:zsh|50:1:codex" \
    "cursor:100:50:zsh|50:1:cursor" \
    "windsurf:100:50:zsh|50:1:windsurf" \
    "pi:100:50:zsh|50:1:pi"
do
    label="${app_spec%%:*}"
    chain_str="${app_spec#*:}"
    proc_dir="$tmp_root/$label"
    make_proc_chain "$proc_dir" "${(@s:|:)chain_str}"
    run_case 0 "ancestry $label skips" 100 "$proc_dir"
done

if (( failures > 0 )); then
    print -u2 "$failures test(s) failed"
    exit 1
fi

print -r -- "All tmux autostart tests passed."
