#!/usr/bin/env zsh

# Source the user's Zsh profile to ensure a full environment is loaded.
[[ -f ~/.zprofile ]] && source ~/.zprofile

# -------------------------------------------------------------------
# NOTE: Script Logic {{{
# -------------------------------------------------------------------

# --- Step 1: Generate a combined list of MAN and TLDR pages ---
generate_sources() {
    (apropos . 2>/dev/null | sed 's/^/[MAN]  /')
    (tldr -l 2>/dev/null | sed 's/^/[TLDR] /')
}

# --- Step 2: Define the FZF preview command ---
preview_command='
    # Parse the line given by fzf (e.g., "[MAN]  git-commit (1) - ...")
    source=$(echo {} | awk "{print \$1}")
    page=$(echo {} | awk "{print \$2}")
    page_clean=$(echo "$page" | sed "s/(.*)//")

    # Display the correct preview based on the source
    if [[ "$source" == "[MAN]" ]]; then
        # Redirect stderr to /dev/null to hide rendering warnings from tbl
        if command -v batman &>/dev/null; then
            batman "$page_clean" 2>/dev/null
        else
            man "$page_clean" 2>/dev/null
        fi
    elif [[ "$source" == "[TLDR]" ]]; then
        tldr --color=always "$page_clean"
    fi
'

# --- Step 3: Run FZF to get user selection ---
selection=$(generate_sources | fzf --prompt="Search Docs > " -e \
    --preview="$preview_command" \
    --preview-window=right:60%:wrap)

# Exit if the user cancelled fzf.
if [[ -z $selection ]]; then
    exit 0
fi

# --- Step 4: Parse the final selection ---
source=$(echo "$selection" | awk '{print $1}')
page=$(echo "$selection" | awk '{print $2}')
page_clean=$(echo "$page" | sed "s/(.*)//")

# --- Step 5: Ask for an optional search term (only for man pages) ---
search_term=""
if [[ "$source" == "[MAN]" ]]; then
    search_term=$(gum input --prompt="Search '$page_clean' for (optional) > " --placeholder="Leave blank to just open...")
fi

# --- Step 6: Open the documentation in a new tmux window ---
man_viewer_cmd="man"
if command -v batman &>/dev/null; then
    man_viewer_cmd="batman"
fi

case "$source" in
    "[MAN]")
        # FIX: Pipe the output to `less -R` to keep the window open.
        tmux new-window -n "$page_clean" "$man_viewer_cmd '$page_clean' | less -R"

        # If a search term was provided, send the keys to search for it in `less`.
        if [[ -n "$search_term" ]]; then
            tmux send-keys -t "{end}" "/$search_term" C-m
        fi
        ;;
    "[TLDR]")
        # For tldr, pipe to `less` to keep the window open and preserve colors.
        tmux new-window -n "$page_clean" "tldr '$page_clean' | less -R"
        ;;
esac
# }}}
# -------------------------------------------------------------------
