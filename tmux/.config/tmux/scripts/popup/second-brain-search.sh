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

# -------------------------------------------------------------------
# NOTE: Cycle State {{{
# -------------------------------------------------------------------
SB_CYCLE_FILE=$(mktemp /tmp/sb-cycle-XXXXXXXXXX)
SB_CYCLE_HELPER=$(mktemp /tmp/sb-cycle-helper-XXXXXXXXXX)
trap 'rm -f "$SB_CYCLE_FILE" "$SB_CYCLE_HELPER"' EXIT
echo "$CURRENT" > "$SB_CYCLE_FILE"

# Build helper with hardcoded paths (no CLI-arg passing for paths)
{
    cat << 'EOF'
#!/usr/bin/env sh
cycle_file="$1"
mode="$2"
i=$(cat "$cycle_file")
EOF
    echo "next=\$(( (i + 1) % ${#BRAIN_NAMES[@]} ))"
    echo "echo \"\$next\" > \"\$cycle_file\""
    echo "case \"\$next\" in"
    for idx in "${!BRAIN_PATHS[@]}"; do
        echo "    $idx) path='${BRAIN_PATHS[$idx]}' ;;"
    done
    echo "esac"
    echo 'if [ "$mode" = "text" ]; then'
    echo '    exec rg --no-heading --line-number --color=never . "$path"'
    echo 'else'
    echo '    exec fd --type f --color=never . "$path"'
    echo 'fi'
} > "$SB_CYCLE_HELPER"
chmod +x "$SB_CYCLE_HELPER"
# }}}

build_header() {
    local idx=$1
    local parts=()
    parts+=("[ ${BRAIN_NAMES[$idx]} ]")
    for i in "${!BRAIN_NAMES[@]}"; do
        parts+=("alt-$((i+1)):${BRAIN_NAMES[$i],,}")
    done
    parts+=("ctrl-o:cycle")
    local IFS='  '
    echo "${parts[*]}"
}

build_bindings() {
    local current_idx=$1
    local binds=()
    for i in "${!BRAIN_NAMES[@]}"; do
        if [[ $i -ne $current_idx ]]; then
            if [[ "$MODE" == "text" ]]; then
                binds+=("alt-$((i+1)):reload(rg --no-heading --line-number --color=never . \"${BRAIN_PATHS[$i]}\")+execute-silent(echo $i > $SB_CYCLE_FILE)")
            else
                binds+=("alt-$((i+1)):reload(fd --type f --color=never . \"${BRAIN_PATHS[$i]}\")+execute-silent(echo $i > $SB_CYCLE_FILE)")
            fi
        fi
    done
    binds+=("ctrl-o:reload($SB_CYCLE_HELPER $SB_CYCLE_FILE $MODE)")
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
