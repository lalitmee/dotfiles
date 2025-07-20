#!/usr/bin/env zsh

# Source the user's Zsh profile to ensure a full environment is loaded.
[[ -f ~/.zprofile ]] && source ~/.zprofile

# -------------------------------------------------------------------
# NOTE: Script Logic {{{
# -------------------------------------------------------------------

# --- Step 1: Generate a combined list of MAN and TLDR pages ---
# We run `apropos` for man pages and `tldr -l` for tldr pages,
# prefixing each line to identify its source.
generate_sources() {
    (apropos . 2>/dev/null | sed 's/^/[MAN]  /')
    (tldr -l 2>/dev/null | sed 's/^/[TLDR] /')
}

# --- Step 2: Define the FZF preview command ---
# This complex command is passed to fzf to generate the live preview.
# It parses the selected line, identifies the source, and runs the
# appropriate command (man or tldr) to display the content.
preview_command='
    # Parse the line given by fzf (e.g., "[MAN]  git-commit (1) - ...")
    source=$(echo {} | awk "{print \$1}")
    page=$(echo {} | awk "{print \$2}")
    # Clean the page name, removing section numbers like (1)
    page_clean=$(echo "$page" | sed "s/(.*)//")

    # Display the correct preview based on the source
    if [[ "$source" == "[MAN]" ]]; then
        # Use `batman` for colored man pages if available, otherwise fall back to `man`
        (command -v bat &>/dev/null && batman "$page_clean") || man "$page_clean"
    elif [[ "$source" == "[TLDR]" ]]; then
        tldr "$page_clean"
    fi
'

# --- Step 3: Run FZF to get user selection ---
# We pipe the generated sources into fzf with our preview command.
selection=$(generate_sources | fzf --prompt="Search Docs > " \
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
case "$source" in
    "[MAN]")
        # Create a new window with the man page.
        tmux new-window -n "$page_clean" "man '$page_clean'"
        # If a search term was provided, send the keys to search for it.
        if [[ -n "$search_term" ]]; then
            tmux send-keys -t "{end}" "/$search_term" C-m
        fi
        ;;
    "[TLDR]")
        # For tldr, pipe to `less` to keep the window open.
        tmux new-window -n "$page_clean" "tldr '$page_clean' | less -R"
        ;;
esac
# }}}
# -------------------------------------------------------------------
