#!/usr/bin/env zsh

# Script to maintain custom window names when tmux tries to rename them
# Called by tmux hook when window is renamed

WINDOW_ID="$1"
PROCESS_REGISTRY="/tmp/tmux-runner-registry-${USER}"

# Check if this window is in our registry
if [[ -f "$PROCESS_REGISTRY" ]]; then
    # Use pipe as separator to correctly read names that may contain spaces
    while IFS='|' read -r reg_window_id pid script_name intelligent_name start_time; do
        if [[ "$reg_window_id" == "$WINDOW_ID" ]]; then
            # This is one of our managed windows
            current_name=$(tmux display-message -p -t "$WINDOW_ID" '#W' 2>/dev/null)

            # If the current name looks like tmux's automatic naming, restore our name.
            # This checks for names like "1:bash", "zsh", or anything that doesn't look like our "emoji name" format.
            if [[ "$current_name" =~ : || ! "$current_name" =~ ^[^[:space:]]+[[:space:]] ]]; then
                # Determine emoji based on the ORIGINAL script name (e.g., "dev", "test")
                case "$script_name" in
                    "dev"|"start"|"serve"|"watch")
                        emoji="🚀"
                        ;; 
                    "build")
                        emoji="🔨"
                        ;; 
                    "test")
                        emoji="🧪"
                        ;; 
                    "lint")
                        emoji="🔍"
                        ;; 
                    *)
                        emoji="⚙️"
                        ;; 
                esac

                # Construct the proper name using the intelligent name (e.g., "Next.js", "Vite")
                proper_name="$emoji $intelligent_name"
                tmux rename-window -t "$WINDOW_ID" "$proper_name" 2>/dev/null
            fi
            break
        fi
    done < "$PROCESS_REGISTRY"
fi
