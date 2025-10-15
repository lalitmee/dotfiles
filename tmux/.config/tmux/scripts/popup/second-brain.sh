#!/usr/bin/env zsh

# -------------------------------------------------------------------
# NOTE: Configuration {{{
# -------------------------------------------------------------------
# Map each context name to its specific repository path.
declare -A CONTEXT_PATHS
CONTEXT_PATHS=(
    ["Work"]="$HOME/Projects/Work/Github/second-brain"
    ["Personal"]="$HOME/Projects/Personal/Github/second-brain"
)
# The list of contexts for fzf is now generated automatically from the map keys.
CONTEXTS=("${(@k)CONTEXT_PATHS}")

# A list of core scratchpad types.
CORE_SCRATCH_TYPES=("general" "code" "commands")

# The file containing your list of programming languages for cht.sh.
LANGUAGES_FILE="$HOME/.config/tmux/scripts/cht-sh/.cht-languages"

# Words for the random name generator.
ADJECTIVES=(
    "Golden" "Silent" "Red" "Cosmic" "Witty" "Quantum" "Swift" "Iron"
    "Lunar" "Solar" "Magic" "Clever" "Hidden" "Lost" "Wild" "Agile"
)
NOUNS=(
    "Leopard" "River" "Monad" "Socket" "Kernel" "Matrix" "Phoenix" "Cobra"
    "Vector" "Void" "Abyss" "Spire" "Oracle" "Golem" "Cipher" "Jester"
)
# }}}
# -------------------------------------------------------------------

# -------------------------------------------------------------------
# NOTE: Helper Functions {{{
# -------------------------------------------------------------------
# A reusable function to launch the tmux popup.
function launch_popup() {
    local session_name="$1"
    local start_dir="$2"
    local startup_command="$3"

    cd "$start_dir"

    if tmux has-session -t "$session_name" 2>/dev/null; then
        tmux attach-session -t "$session_name"
    else
        tmux new-session -s "$session_name" $startup_command
    fi
}
# }}}
# -------------------------------------------------------------------

# -------------------------------------------------------------------
# NOTE: Script Logic {{{
# -------------------------------------------------------------------
# Check if $EDITOR is set
if [[ -z "$EDITOR" ]]; then
    echo "ERROR: \$EDITOR is not set. Please set your preferred editor." >&2
    exit 1
fi

# The first argument is the mode, the second is the optional context.
mode="$1"
context_arg="$2"
context=""

# --- Step 1: Determine the Context (Work or Personal) ---
context_is_valid=false
# Check if a valid context was passed as the second argument (case-insensitive).
if [[ -n "$context_arg" ]]; then
    for c in "${CONTEXTS[@]}"; do
        if [[ "${(L)c}" == "${(L)context_arg}" ]]; then
            context="$c" # Use the correctly cased key from the array
            context_is_valid=true
            break
        fi
    done
fi

# If no valid context was passed, prompt the user with fzf.
if ! $context_is_valid; then
    context=$(printf "%s\n" "${CONTEXTS[@]}" | fzf --prompt="Select Context > ")
    if [[ -z $context ]]; then exit 0; fi
fi

# Get the correct base path from our map based on the determined context.
context_path="${CONTEXT_PATHS[$context]}"

# --- Step 2: Route to the Correct Mode Logic ---
case "$mode" in
    "notes")
        notes_dir="$context_path/notes"
        mkdir -p "$notes_dir"

        # Portable way to list .org files without -printf (works on macOS and Linux)
        note_list=$(find "$notes_dir" -maxdepth 1 -name "*.org" | xargs -n 1 basename 2>/dev/null | sed 's/\.org$//')
        selection=$(echo "$note_list" | fzf --prompt="Find or Create Note > ")
        # If no selection and directory is empty, allow user to type a name
        if [[ -z $selection ]]; then
            selection=$(echo "" | fzf --prompt="No notes found. Type a note name to create > " --print-query --query="" | head -1)
            if [[ -z $selection ]]; then exit 0; fi
        fi

        note_file="$notes_dir/$selection.org"
        touch "$note_file"

        session_name="notes-${(L)context}-${(L)selection}"
        startup_command="$EDITOR '$note_file'"

        launch_popup "$session_name" "$notes_dir" "$startup_command"
        ;;

    "todos")
        date=$(date +%F)
        todos_dir="$context_path/agenda/daily"
        todo_file="$todos_dir/$date.org"

        mkdir -p "$todos_dir"
        touch "$todo_file"

        session_name="todos-${(L)context}-${date}"
        startup_command="$EDITOR '$todo_file'"

        launch_popup "$session_name" "$todos_dir" "$startup_command"
        ;;

    "scratch")
        # Combine core scratch types and languages
        full_scratch_list=("${CORE_SCRATCH_TYPES[@]}")
        if [[ -f "$LANGUAGES_FILE" ]]; then
            while IFS= read -r lang; do
                full_scratch_list+=("$lang")
            done < "$LANGUAGES_FILE"
        fi

        scratch_type=$(printf "%s\n" "${full_scratch_list[@]}" | fzf --prompt="Select Scratchpad Type > ")
        if [[ -z $scratch_type ]]; then exit 0; fi

        # Generate a unique scratchpad file name
        for try in {1..10}; do
            adjective=${ADJECTIVES[$((RANDOM % ${#ADJECTIVES[@]}))]}
            noun=${NOUNS[$((RANDOM % ${#NOUNS[@]}))]}
            file_name="${adjective}-${noun}"
            ext="md"
            case "$scratch_type" in
                "commands") ext="sh" ;;
                "python")   ext="py" ;;
                "go")       ext="go" ;;
                "javascript"|"typescript") ext="js" ;;
                "html")     ext="html" ;;
                "css")      ext="css" ;;
            esac
            scratch_dir="$context_path/scratch/$scratch_type"
            scratch_file="$scratch_dir/$file_name.$ext"
            [[ ! -e "$scratch_file" ]] && break
            file_name="${file_name}-$try"
        done

        session_name="scratch-${(L)context}-${(L)scratch_type}"

        mkdir -p "$scratch_dir"
        touch "$scratch_file"

        startup_command="$EDITOR '$scratch_file'"

        launch_popup "$session_name" "$scratch_dir" "$startup_command"
        ;;
esac
# }}}
# -------------------------------------------------------------------
