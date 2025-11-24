#!/usr/bin/env zsh
# This script lists installed apt repositories, allows multi-selection via gum,
# and removes selected repositories after confirmation.

# Function to list all apt repositories
list_repos() {
    # Get repositories from sources.list (old format)
    local sources_list_repos=""
    if [[ -f /etc/apt/sources.list ]]; then
        sources_list_repos=$(grep '^deb ' /etc/apt/sources.list | sed 's/^deb //')
    fi

    # Get repositories from sources.list.d (.list files - old format)
    local sources_list_d_repos=""
    if [[ -d /etc/apt/sources.list.d ]]; then
        sources_list_d_repos=$(find /etc/apt/sources.list.d -name "*.list" -exec grep '^deb ' {} \; | sed 's/^deb //')
    fi

    # Get repositories from sources.list.d (.sources files - new deb822 format)
    local sources_deb822_repos=""
    if [[ -d /etc/apt/sources.list.d ]]; then
        # Process each .sources file
        for sources_file in /etc/apt/sources.list.d/*.sources; do
            if [[ -f "$sources_file" ]]; then
                # Parse deb822 format - extract deb repositories
                awk '
                BEGIN { in_block=0; types=""; uris=""; suites=""; components=""; signed_by="" }
                /^Types: deb$/ { in_block=1; types="deb" }
                /^URIs: / { if(in_block) uris=$2 }
                /^Suites: / { if(in_block) suites=$2 }
                /^Components: / { if(in_block) components=$2 }
                /^Signed-By: / { if(in_block) signed_by=$2 }
                /^$/ {
                    if(in_block && types=="deb" && uris!="" && suites!="") {
                        signed_part = (signed_by!="") ? "[signed-by=" signed_by "] " : ""
                        print signed_part uris " " suites " " components
                    }
                    in_block=0; types=""; uris=""; suites=""; components=""; signed_by=""
                }
                END {
                    if(in_block && types=="deb" && uris!="" && suites!="") {
                        signed_part = (signed_by!="") ? "[signed-by=" signed_by "] " : ""
                        print signed_part uris " " suites " " components
                    }
                }
                ' "$sources_file" >> /tmp/deb822_repos.tmp
            fi
        done
        if [[ -f /tmp/deb822_repos.tmp ]]; then
            sources_deb822_repos=$(cat /tmp/deb822_repos.tmp)
            rm -f /tmp/deb822_repos.tmp
        fi
    fi

    # Combine and format
    {
        echo "$sources_list_repos"
        echo "$sources_list_d_repos"
        echo "$sources_deb822_repos"
    } | sort | uniq
}

# Get the list of repositories
repos=$(list_repos)

if [[ -z "$repos" ]]; then
    echo "No apt repositories found."
    exit 1
fi

# Format for gum selection (show URL and components)
formatted_repos=$(echo "$repos" | awk '{
    url=$1
    components=""
    for(i=2; i<=NF; i++) components = components " " $i
    print url components
}')

# Let user select repositories to remove using fzf with fuzzy matching
selected=$(echo "$formatted_repos" | fzf \
    --multi \
    --prompt="Search and select repositories to remove > " \
    --header="Use TAB to select/deselect, ENTER to confirm" \
    --height=20 \
    --color='fg:#FFFFFF,bg:#193549,hl:#FFC600,fg+:#FFFFFF,bg+:#185294,hl+:#FF9D00,info:#8fbfdc,prompt:#3AD900,pointer:#00AAFF')

# If no selection made, exit
if [[ -z "$selected" ]]; then
    echo "No repositories selected for removal."
    exit 0
fi

# Show confirmation with gum
echo "You selected the following repositories for removal:"
echo
echo "$selected" | gum table \
    --header.foreground="#FFC600" \
    --header.background="#0d3a58" \
    --cell.foreground="#e4e4e4" \
    --cell.background="#193549" \
    --border.foreground="#0050a4" \
    --border="rounded" \
    --print

echo
if gum confirm "Are you sure you want to remove these repositories?"; then
    echo "Removing selected repositories..."
    
    # For each selected repository, find and remove it
    echo "$selected" | while read -r repo; do
        url=$(echo "$repo" | awk '{print $1}')
        components=$(echo "$repo" | cut -d' ' -f2-)

        echo "Removing repository: $url $components"

        # Escape special characters for sed (URLs contain / which is special in regex)
        escaped_url=$(printf '%s\n' "$url" | sed 's/[[\.*^$()+?{|]/\\&/g')
        escaped_components=$(printf '%s\n' "$components" | sed 's/[[\.*^$()+?{|]/\\&/g')

        # Remove from sources.list if present (old format)
        if [[ -f /etc/apt/sources.list ]]; then
            sudo sed -i "\|^deb $escaped_url $escaped_components$|d" /etc/apt/sources.list
        fi

        # Remove from sources.list.d .list files (old format)
        if [[ -d /etc/apt/sources.list.d ]]; then
            find /etc/apt/sources.list.d -name "*.list" -exec sudo sed -i "\|^deb $escaped_url $escaped_components$|d" {} \;
        fi

        # Note: .sources files (deb822 format) are not modified automatically
        # as they require more complex block-level editing. Ubuntu official repositories
        # in .sources format should typically not be removed manually.
        # Only third-party .list format repositories are removed.
    done
    
    echo "Repository removal complete. Updating package lists..."
    if sudo apt update; then
        echo "Package lists updated successfully."
    else
        echo "Warning: Failed to update package lists. You may need to run 'sudo apt update' manually."
    fi
else
    echo "Repository removal cancelled."
fi

echo
read -n 1 -s -r -p "Press any key to close..."
