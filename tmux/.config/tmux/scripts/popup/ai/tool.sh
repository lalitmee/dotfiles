#!/usr/bin/env zsh

# Launch an AI tool in a named tmux window from the AI tools popup.
set -e

TOOL=$1
case "$TOOL" in
    agy) ICON='🚀'; DEFAULT_NAME='antigravity'; COMMAND=(agy --dangerously-skip-permissions) ;;
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
source "${commands[gum-input]:A:h}/gum-theme.sh"

description=$(gum-input write --header='Task description or window name (submit empty to skip)' --placeholder='Enter your prompt...' --height=6 --char-limit=0) || exit 0
title="$ICON $DEFAULT_NAME"
naming_status='default name'
action=''

if [[ -n ${description//[[:space:]]/} ]]; then
    source "${0:A:h}/../../lib/popup-style.sh"
    action=$(gum filter --header=$'How should this text be used?\n'"$(popup_hints 'Enter:select' 'Esc:cancel')" \
        --no-show-help --header.foreground="$gum_label" \
        --text.foreground="$gum_foreground" --cursor-text.foreground="$gum_value" \
        --cursor-text.background="$gum_selection" --indicator.foreground="$gum_accent" \
        --prompt.foreground="$gum_accent" --placeholder.foreground="$gum_muted" \
        --match.foreground="$gum_value" \
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
        for namer in opencode codex pi agy; do
            command -v "$namer" >/dev/null 2>&1 || continue
            case "$namer" in
                opencode) naming_command=(opencode run --model openai/gpt-6-luna#high --agent plan "$naming_prompt") ;;
                codex) naming_command=(codex exec --ephemeral --sandbox read-only --model gpt-6-luna --config 'model_reasoning_effort="high"' "$naming_prompt") ;;
                pi) naming_command=(pi --model openai/gpt-6-luna:high --no-session --no-tools --no-extensions --print "$naming_prompt") ;;
                agy) naming_command=(agy --mode plan --model gemini-3.8-flash-medium --effort medium "--print=$naming_prompt") ;;
            esac
            spinner_title="Naming with $namer..."
            rows=$(tput lines 2>/dev/null) || rows=0
            cols=$(tput cols 2>/dev/null) || cols=0
            top=$(( rows > 1 ? (rows - 1) / 2 : 0 ))
            left=$(( cols > ${#spinner_title} + 2 ? (cols - ${#spinner_title} - 2) / 2 : 0 ))
            response=$(gum spin --spinner dot \
                --title="$spinner_title" \
                --padding="$top 0 0 $left" \
                --show-stdout -- timeout --kill-after=1s 20s \
                "${naming_command[@]}") || {
                naming_exit=$?
                case "$naming_exit" in
                    124|137) naming_failure="timed out or was killed (exit $naming_exit)" ;;
                    *) naming_failure="failed (exit $naming_exit)" ;;
                esac
                tmux display-message "AI naming: $namer $naming_failure; trying next backend" || true
                continue
            }
            slug=$(print -r -- "$response" | tr '[:upper:]' '[:lower:]' | sed -E 's/[^a-z0-9]+/-/g; s/^-+|-+$//g')
            words=(${(s:-:)slug})
            if [[ ${#words} -ge 2 && ${#words} -le 3 && ${#slug} -le 48 ]]; then
                title="$ICON $slug"
                naming_status="named $slug via $namer"
                break
            fi
            tmux display-message "AI naming: $namer returned an invalid name; trying next backend" || true
        done
        [[ "$naming_status" == 'default name' ]] && naming_status='naming failed; using agent name'
    fi

fi

# Quote each argument for the interactive shell rather than evaluating input as code.
command_line="${(j: :)${(@q)COMMAND}}"
tmux new-window -n "$title" -c '#{pane_current_path}' "$SHELL" -i -c "$command_line"
tmux display-message "AI $TOOL: $naming_status"
