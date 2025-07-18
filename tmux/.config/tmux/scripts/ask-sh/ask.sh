#!/usr/bin/env zsh

# -------------------------------------------------------------------
# NOTE: Configuration {{{
# -------------------------------------------------------------------
# Commands are now defined as arrays for safer execution.
AI_COMMAND=(llm)
DDG_COMMAND=(ddgr -C)

# The default model to use for interactive chat if none is selected.
DEFAULT_AI_MODEL="gpt-4o-mini"

# The file containing your manually curated list of !bangs.
BANGS_FILE="$HOME/.config/tmux/scripts/ask-sh/.bangs-list"

# Your personal list of websites for the site-search menu.
WEBSITES=(
    "github.com"
    "stackoverflow.com"
    "reddit.com"
    "archwiki.org"
    "developer.mozilla.org"
    "en.wikipedia.org"
)
# }}}
# -------------------------------------------------------------------

# -------------------------------------------------------------------
# NOTE: Script Logic {{{
# -------------------------------------------------------------------
action="$1"

case "$action" in
    "ai")
        query=$(gum input --prompt="Ask AI > " --placeholder="Your question for the AI...")
        if [[ -n $query ]]; then
            gum spin --spinner dot --title "Asking AI..." -- "${AI_COMMAND[@]}" "$query"
            read -r -p "Press Enter to close..." < /dev/tty
        fi
        ;;

    "ai-chat")
        model_list=$($AI_COMMAND models list | sed -E 's/^[^:]+: ([^ ]+).*/\1/')
        selected_model=$(echo "$model_list" | fzf --prompt="Select model (ESC for default: $DEFAULT_AI_MODEL) > ")

        if [[ -n "$selected_model" ]]; then
            model_to_use="$selected_model"
        else
            model_to_use="$DEFAULT_AI_MODEL"
        fi

        "${AI_COMMAND[@]}" chat -m "$model_to_use"
        ;;

    "site")
        selection=$(cat "$BANGS_FILE" | fzf --prompt="Select Bang > ")
        if [[ -z $selection ]]; then exit 0; fi

        bang=$(echo "$selection" | awk -F '=>' '{print $2}' | tr -d ' ')
        query=$(gum input --prompt="Search with '$bang' for > " --placeholder="Your search query...")
        if [[ -n $query ]]; then
            full_search="$bang $query"
            echo "🔎 Searching with '$bang' for '$query' in browser..."
            "${DDG_COMMAND[@]}" --gb "$full_search"
            sleep 1
        fi
        ;;

    "ducky")
        query=$(gum input --prompt="Ducky Search > " --placeholder="Query for the top result...")
        if [[ -n $query ]]; then
            echo "🔎 Opening top result for '$query' in browser..."
            "${DDG_COMMAND[@]}" -j "$query"
            sleep 1
        fi
        ;;

    "bang")
        query=$(gum input --prompt="Browser !bang > " --placeholder="!w wikipedia, !gh tmux, etc...")
        if [[ -n $query ]]; then
            echo "🌐 Opening bang '$query' in browser..."
            "${DDG_COMMAND[@]}" --gb "$query"
            sleep 1
        fi
        ;;

    "search"|*)
        query=$(gum input --prompt="Web Search > " --placeholder="Your search query...")
        if [[ -n $query ]]; then
            echo "🌐 Opening search for '$query' in browser..."
            encoded_query=$(echo "$query" | tr ' ' '+')
            case "$(uname -s)" in
                Darwin) open "https://duckduckgo.com/?q=$encoded_query" ;;
                Linux)  xdg-open "https://duckduckgo.com/?q=$encoded_query" ;;
            esac
            sleep 1
        fi
        ;;
esac
# }}}
# -------------------------------------------------------------------
