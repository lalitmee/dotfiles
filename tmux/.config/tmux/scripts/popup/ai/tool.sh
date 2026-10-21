#!/usr/bin/env zsh

# Launch an AI tool in a named tmux window from the AI tools popup.
set -e

TOOL=$1
case "$TOOL" in
    agy) ICON='🚀'; DEFAULT_NAME='antigravity'; COMMAND=(agy) ;;
    opencode) ICON='🧑‍💻'; DEFAULT_NAME='openCode'; COMMAND=(opencode); export NODE_TLS_REJECT_UNAUTHORIZED=0 ;;
    claude) ICON='🟠'; DEFAULT_NAME='claude-code'; COMMAND=(claude) ;;
    codex) ICON='🧬'; DEFAULT_NAME='codex'; COMMAND=(codex) ;;
    copilot) ICON=' '; DEFAULT_NAME='copilot'; COMMAND=(copilot --banner) ;;
    crush) ICON='💖'; DEFAULT_NAME='crush'; COMMAND=(crush) ;;
    kiro) ICON='🔷'; DEFAULT_NAME='kiro'; COMMAND=(kiro-cli) ;;
    grok) ICON='🧠'; DEFAULT_NAME='grok-cli'; COMMAND=(grok-cli) ;;
    cursor-agent) ICON='🖱️'; DEFAULT_NAME='cursor-agent'; COMMAND=(cursor-agent) ;;
    pi) ICON='🥧'; DEFAULT_NAME='pi'; COMMAND=(pi) ;;
    *) tmux display-message "❌ Unknown AI tool: $TOOL"; exit 1 ;;
esac

if ! command -v gum >/dev/null 2>&1; then
    tmux display-message '❌ gum is not installed'
    exit 1
fi

description=$(gum write --header='Task description or window name (Ctrl+D to submit; empty to skip)' --placeholder='Enter your prompt...' --height=6 --char-limit=0) || exit 0
title="$ICON $DEFAULT_NAME"
naming_status='default name'
action=''

if [[ -n ${description//[[:space:]]/} ]]; then
    action=$(gum filter --header='How should this text be used?' \
        '✏️ Use as name' '✨ Generate name' '💬 Generate name and send prompt') || exit 0

    if [[ "$action" == '💬 Generate name and send prompt' ]]; then
        case "$TOOL" in
            agy) COMMAND+=(--prompt-interactive "$description") ;;
            opencode) COMMAND+=(--prompt "$description") ;;
            codex|pi|claude) COMMAND+=("$description") ;;
            *) tmux display-message "❌ $TOOL does not have a verified initial-prompt invocation"; exit 1 ;;
        esac
    fi

    if [[ "$action" == '✏️ Use as name' ]]; then
        slug=$(print -r -- "$description" | tr '[:upper:]' '[:lower:]' | sed -E 's/[^a-z0-9]+/-/g; s/^-+|-+$//g')
        if [[ -n "$slug" ]]; then
            title="$ICON $slug"
            naming_status="named $slug"
        fi
    else
        naming_prompt="Return ONLY a lowercase, hyphen-separated window name of 2 or 3 English words, using a-z and 0-9 only. No explanation. Task: $description"
        for namer in agy opencode codex; do
            command -v "$namer" >/dev/null 2>&1 || continue
            case "$namer" in
                agy) naming_command=(agy --mode plan "--print=$naming_prompt") ;;
                opencode) naming_command=(opencode run --model opencode/beam-free --agent plan "$naming_prompt") ;;
                codex) naming_command=(codex exec --ephemeral --sandbox read-only "$naming_prompt") ;;
            esac
            spinner_title="Naming with $namer..."
            rows=$(tput lines 2>/dev/null) || rows=0
            cols=$(tput cols 2>/dev/null) || cols=0
            top=$(( rows > 1 ? (rows - 1) / 2 : 0 ))
            left=$(( cols > ${#spinner_title} + 2 ? (cols - ${#spinner_title} - 2) / 2 : 0 ))
            response=$(gum spin --spinner dot --title="$spinner_title" --padding="$top 0 0 $left" --show-stdout -- timeout --kill-after=1s 10s "${naming_command[@]}") || continue
            slug=$(print -r -- "$response" | tr '[:upper:]' '[:lower:]' | sed -E 's/[^a-z0-9]+/-/g; s/^-+|-+$//g')
            words=(${(s:-:)slug})
            if [[ ${#words} -ge 2 && ${#words} -le 3 && ${#slug} -le 48 ]]; then
                title="$ICON $slug"
                naming_status="named $slug via $namer"
                break
            fi
        done
        [[ "$naming_status" == 'default name' ]] && naming_status='naming failed; using agent name'
    fi

fi

# Quote each argument for the interactive shell rather than evaluating input as code.
command_line="${(j: :)${(@q)COMMAND}}"
tmux new-window -n "$title" -c '#{pane_current_path}' "$SHELL" -i -c "$command_line"
tmux display-message "AI $TOOL: $naming_status"
