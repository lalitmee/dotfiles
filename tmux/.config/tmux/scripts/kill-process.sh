#!/usr/bin/env bash
# This script lists user processes, allows for multi-selection via fzf,
# kills the selected processes, and displays a confirmation table using gum.

uid=$(id -u)
process_list=$(ps -f -u $uid | sed 1d)

# Let the user select processes with fzf, storing the full lines
selection=$(echo "$process_list" | fzf -m)

# If the user made a selection (selection is not empty)
if [[ -n "$selection" ]]; then
    # Extract PIDs to be killed
    pids_to_kill=$(echo "$selection" | awk '{print $2}')

    # Kill the processes
    echo "$pids_to_kill" | xargs kill -9

    # --- Confirmation Message ---

    # Create a temporary file to store formatted data for gum table
    temp_file=$(mktemp)

    # Prepare data for gum table: Header
    echo -e "PID\tCOMMAND" > "$temp_file"

    # Prepare data for gum table: Body
    echo "$selection" | awk '
    {
        pid = $2;
        cmd = "";
        for (i=8; i<=NF; i++) {
            cmd = cmd $i " ";
        }
        # Strip trailing space from cmd
        gsub(/ $/, "", cmd);
        print pid "\t" cmd;
    }' >> "$temp_file"

    # Display the confirmation message and the table
    echo "Killed the following process(es):"
    echo

    # Use cat to pipe the file content to gum table, styled like the help system
    # Using printf for the separator is the most robust way to handle the tab character
    cat "$temp_file" | gum table \
        --separator="$(printf '\t')" \
        --header.foreground="#FFC600" \
        --header.background="#0d3a58" \
        --cell.foreground="#e4e4e4" \
        --cell.background="#193549" \
        --border.foreground="#0050a4" \
        --border="rounded" \
        --print

    # Clean up the temporary file
    rm "$temp_file"

    echo
    read -n 1 -s -r -p "Press any key to close..."
else
    # If no process was selected, just exit
    exit 0
fi
