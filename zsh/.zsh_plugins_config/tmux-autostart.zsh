# Auto-start tmux on interactive terminals, skipping agentic apps and nested sessions.

_not_inside_tmux() { [[ -z "$TMUX" ]]; }

_inside_herdr() {
    [[ -n "${HERDR_ENV:-}" || \
       -n "${HERDR_PANE_ID:-}" || \
       -n "${HERDR_SOCKET_PATH:-}" || \
       -n "${HERDR_SESSION:-}" || \
       -n "${HERDR_WORKSPACE_ID:-}" || \
       -n "${HERDR_TAB_ID:-}" || \
       -n "${HC_TERMINAL_ID:-}" || \
       -n "${HC_TERMINAL_SOCKET:-}" || \
       -n "${HC_SCOPE:-}" || \
       "${__CFBundleIdentifier:-}" == "dev.herdr.app" || \
       "${XPC_SERVICE_NAME:-}" == application.dev.herdr.app* || \
       "${TERM_PROGRAM:-}" == *herdr* ]]
}

_inside_agentic_app_env() {
    local term_program="${(L)TERM_PROGRAM:-}"
    case "$term_program" in
        *antigravity*|*chatgpt*|*t3code*|*t3-code*|*claude*|*codex*|*opencode*|*cursor*|*windsurf*|*vscode*|*zed*|*herdr*|*rex*)
            return 0
            ;;
    esac

    [[ -n "${ANTIGRAVITY_AGENT:-}" || \
       -n "${ANTIGRAVITY_CLI_ALIAS:-}" || \
       -n "${ANTIGRAVITY_CONVERSATION_ID:-}" || \
       -n "${ANTIGRAVITY_TRAJECTORY_ID:-}" || \
       -n "${VSCODE_INJECTION:-}" || \
       -n "${VSCODE_IPC_HOOK_CLI:-}" || \
       -n "${VSCODE_GIT_IPC_HANDLE:-}" || \
       -n "${CURSOR_TRACE_ID:-}" || \
       -n "${CLAUDECODE:-}" || \
       -n "${CLAUDE_CODE_ENTRYPOINT:-}" || \
       -n "${CODEX_THREAD_ID:-}" || \
       -n "${CODEX_SANDBOX:-}" || \
       -n "${OPENCODE:-}" || \
       -n "${OPENCODE_CLIENT:-}" ]]
}

_is_agentic_process_name() {
    local name="${(L)1:-}"
    case "$name" in
        *antigravity*|*chatgpt*|*t3code*|*t3-code*|*claude*|*codex*|*opencode*|*cursor*|*windsurf*|*herdr*|*rex*|pi|pi-coding-agent)
            return 0
            ;;
    esac
    return 1
}

_inside_agentic_app_ancestry() {
    local proc_root="${ZSH_PROC_ROOT:-/proc}"
    local pid="${ZSH_START_PID:-$$}"
    local depth=0
    local stat comm rest ppid

    while (( pid > 1 && depth < 16 )); do
        if [[ -r "$proc_root/$pid/stat" && -r "$proc_root/$pid/comm" ]]; then
            stat=$(<"$proc_root/$pid/stat")
            comm=$(<"$proc_root/$pid/comm")
            rest=${stat##*\) }
            ppid=${${=rest}[2]}
        elif [[ "$proc_root" == "/proc" ]] && command -v ps &>/dev/null; then
            comm=$(ps -o comm= -p "$pid" 2>/dev/null)
            ppid=$(ps -o ppid= -p "$pid" 2>/dev/null)
            ppid=${ppid//[[:space:]]/}
        else
            break
        fi

        if _is_agentic_process_name "$comm"; then
            return 0
        fi

        [[ "$ppid" == <-> ]] || break
        pid=$ppid
        (( depth++ ))
    done
    return 1
}

_skip_tmux_autostart() {
    [[ -n "${REX_SESSION:-}" ]] || _inside_herdr || _inside_agentic_app_env || _inside_agentic_app_ancestry
}

ensure_tmux_is_running() {
    ZSH_TMUX_AUTOSTART=1
    local autostart="${ZSH_TMUX_AUTOSTART:-1}"
    if [[ -r /usr/share/omarchy/default/bash/env-bootstrap ]]; then
        autostart="${ZSH_TMUX_AUTOSTART:-0}"
    fi
    if [[ "$autostart" == 1 && -t 0 && -t 1 ]] && command -v tmux &>/dev/null && [[ -x ~/.tat ]] && _not_inside_tmux && ! _skip_tmux_autostart; then
        ~/.tat
    fi
}

[[ "${ZSH_TMUX_AUTOSTART_FUNCTIONS_ONLY:-0}" == 1 ]] || ensure_tmux_is_running
