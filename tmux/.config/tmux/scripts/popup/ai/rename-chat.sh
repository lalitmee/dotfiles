#!/usr/bin/env zsh
set -e

pane_id=$1
window_id=$(tmux display-message -p -t "$pane_id" '#{window_id}')
directory=$(tmux display-message -p -t "$pane_id" '#{pane_current_path}')
pane_command=$(tmux display-message -p -t "$pane_id" '#{pane_current_command}')
if [[ -z "$window_id" || -z "$directory" ]]; then
    tmux display-message 'Chat rename: could not identify the originating window'
    exit 1
fi

case "$pane_command" in
    opencode) provider=opencode ;;
    codex) provider=codex ;;
    pi) provider=pi ;;
    claude) provider=claude ;;
    agy) provider=agy ;;
    *)
        provider=$(gum choose --header='Select the agent running in this pane' opencode codex pi claude agy) || exit 0
        ;;
esac

if [[ "$provider" == agy ]]; then
    prompt=$(gum write --header='Describe this chat briefly; this text is sent to the naming model' --placeholder='Task description...' --width=0 --height=5 --char-limit=0) || exit 0
else
    adapter="${0:A:h}/chat-sessions.py"
    sessions=$(python3 "$adapter" list "$provider" "$directory") || {
        tmux display-message "Chat rename: session access unavailable for $provider"
        exit 1
    }
    choices=$(print -r -- "$sessions" | jq -r '.[] | [.id, (.title | gsub("[\\u0000-\\u001f\\u007f]"; ""))] | @tsv') || exit 1
    [[ -n "$choices" ]] || {
        tmux display-message "Chat rename: no $provider sessions found for this directory"
        exit 1
    }
    selected=$(print -r -- "$choices" | gum filter --header='Select a chat; its first prompt is sent to the naming model' --placeholder='Search sessions...') || exit 0
    session_id=${selected%%$'\t'*}
    [[ -n "$session_id" ]] || exit 0
    prompt_json=$(python3 "$adapter" prompt "$provider" "$directory" "$session_id") || {
        tmux display-message "Chat rename: could not read the selected $provider prompt"
        exit 1
    }
    prompt=$(print -r -- "$prompt_json" | jq -er 'select(type == "string")') || exit 1
fi

[[ -n ${prompt//[[:space:]]/} ]] || {
    tmux display-message 'Chat rename: no prompt or description available'
    exit 1
}

naming_prompt="Return ONLY a lowercase, hyphen-separated window name of 2 or 3 English words using a-z and 0-9 only. No explanation. Chat's first user prompt: $prompt"
for namer in opencode codex pi agy; do
    command -v "$namer" >/dev/null 2>&1 || continue
    case "$namer" in
        opencode) naming_command=(opencode run --model openai/gpt-6-luna#high --agent plan "$naming_prompt") ;;
        codex) naming_command=(codex exec --ephemeral --sandbox read-only --model gpt-6-luna --config 'model_reasoning_effort="high"' "$naming_prompt") ;;
        pi) naming_command=(pi --model openai/gpt-6-luna:high --no-session --no-tools --no-extensions --print "$naming_prompt") ;;
        agy) naming_command=(agy --mode plan --model gemini-3.8-flash-medium --effort medium "--print=$naming_prompt") ;;
    esac
    response=$(gum spin --spinner dot --title="Naming with $namer..." --show-stdout -- timeout --kill-after=1s 20s "${naming_command[@]}") || continue
    slug=$(print -r -- "$response" | tr '[:upper:]' '[:lower:]' | sed -E 's/[^a-z0-9]+/-/g; s/^-+|-+$//g')
    words=(${(s:-:)slug})
    if [[ ${#words} -ge 2 && ${#words} -le 3 && ${#slug} -le 48 ]]; then
        # The pane may have moved or closed while the naming backend was running.
        current_window=$(tmux display-message -p -t "$pane_id" '#{window_id}' 2>/dev/null) || current_window=''
        if [[ "$current_window" != "$window_id" ]]; then
            tmux display-message 'Chat rename: original window is no longer available'
            exit 1
        fi
        tmux rename-window -t "$window_id" "$slug"
        tmux display-message "Chat renamed to $slug via $namer"
        exit 0
    fi
done

tmux display-message 'Chat rename: naming failed; window name unchanged'
exit 1
