#!/usr/bin/env bash

# -------------------------------------------------------------------
# NOTE: Brain Detection {{{
# -------------------------------------------------------------------
declare -a BRAIN_NAMES BRAIN_PATHS
BRAIN_NAMES=()
BRAIN_PATHS=()

register_brain() {
    local name="$1" path="$2"
    if [[ -d "$path" ]]; then
        BRAIN_NAMES+=("$name")
        BRAIN_PATHS+=("$path")
    fi
}

register_brain "Personal" "$HOME/Projects/Personal/Github/second-brain"
register_brain "Work"     "$HOME/Projects/Work/Github/second-brain"
register_brain "AI"       "$HOME/Projects/Personal/Github/ai-brain"
register_brain "Cursor"   "$HOME/Projects/Work/Github/cursor-brain"

if [[ ${#BRAIN_NAMES[@]} -eq 0 ]]; then
    echo "No second brain directories found."
    exit 1
fi
# }}}

MODE="${1:-text}"
BRAIN_FILTER="${2:-}"

# Determine initial brain index
CURRENT=0
if [[ -n "$BRAIN_FILTER" ]]; then
    for i in "${!BRAIN_NAMES[@]}"; do
        if [[ "${BRAIN_NAMES[$i],,}" == "${BRAIN_FILTER,,}" ]]; then
            CURRENT=$i
            break
        fi
    done
fi

build_header() {
    local idx=$1
    local parts=()
    parts+=("[ ${BRAIN_NAMES[$idx]} ]")
    for i in "${!BRAIN_NAMES[@]}"; do
        parts+=("alt-$((i+1)):${BRAIN_NAMES[$i],,}")
    done
    parts+=("alt-Tab:next")
    local IFS='  '
    echo "${parts[*]}"
}

build_bindings() {
    local current_idx=$1
    local binds=()
    for i in "${!BRAIN_NAMES[@]}"; do
        if [[ $i -ne $current_idx ]]; then
            if [[ "$MODE" == "text" ]]; then
                binds+=("alt-$((i+1)):reload(rg --no-heading --line-number --color=never . \"${BRAIN_PATHS[$i]}\")")
            else
                binds+=("alt-$((i+1)):reload(fd --type f --color=never . \"${BRAIN_PATHS[$i]}\")")
            fi
        fi
    done
    # Compute next index for alt-Tab cycling
    local next_idx=$(( (current_idx + 1) % ${#BRAIN_NAMES[@]} ))
    if [[ "$MODE" == "text" ]]; then
        binds+=("alt-Tab:reload(rg --no-heading --line-number --color=never . \"${BRAIN_PATHS[$next_idx]}\")")
    else
        binds+=("alt-Tab:reload(fd --type f --color=never . \"${BRAIN_PATHS[$next_idx]}\")")
    fi
    local IFS=','
    echo "${binds[*]}"
}

IS_TMUX=false
[[ -n "$TMUX" ]] && IS_TMUX=true

if [[ "$MODE" == "text" ]]; then
    SOURCE_CMD="rg --no-heading --line-number --color=never . \"${BRAIN_PATHS[$CURRENT]}\""
    PREVIEW_CMD="bat --style=numbers --color=always --highlight-line {2} {1} 2>/dev/null || head -n \$FZF_PREVIEW_LINES {1}"
else
    SOURCE_CMD="fd --type f --color=never . \"${BRAIN_PATHS[$CURRENT]}\""
    PREVIEW_CMD="bat --color=always {1} 2>/dev/null || head -n \$FZF_PREVIEW_LINES {1}"
fi

HEADER=$(build_header $CURRENT)
BINDS=$(build_bindings $CURRENT)

SELECTION=$(eval "$SOURCE_CMD" | fzf \
    --bind="change:first" \
    --bind="$BINDS" \
    --header="$HEADER" \
    --preview="$PREVIEW_CMD" \
    --preview-window="right:60%:wrap" \
    --delimiter=":" \
    --with-nth="1,2,3")

if [[ -z "$SELECTION" ]]; then
    exit 0
fi

NEOVIDE_CMD="neovide --x11-wm-class floating-nvim"

if [[ "$MODE" == "text" ]]; then
    FILE=$(echo "$SELECTION" | awk -F: '{print $1}')
    LINE=$(echo "$SELECTION" | awk -F: '{print $2}')
    if $IS_TMUX; then
        tmux new-window "nvim +$LINE '$FILE'"
    else
        $NEOVIDE_CMD "+$LINE" "$FILE"
    fi
else
    FILE="$SELECTION"
    if $IS_TMUX; then
        tmux new-window "nvim '$FILE'"
    else
        $NEOVIDE_CMD "$FILE"
    fi
fi
