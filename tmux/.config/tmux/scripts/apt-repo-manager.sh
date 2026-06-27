#!/usr/bin/env bash
# This script lists installed apt repositories, allows multi-selection via fzf,
# and removes selected repositories after confirmation.

# Check dependencies
for cmd in fzf awk grep find sudo; do
    if ! command -v "$cmd" &> /dev/null; then
        echo "Error: Required command '$cmd' not found. Please install it."
        exit 1
    fi
done

# Function to list all apt repositories with their source files
list_repos() {
    # 1. Get repositories from sources.list (old format)
    if [[ -f /etc/apt/sources.list ]]; then
        grep '^deb ' /etc/apt/sources.list | while read -r line; do
            echo "/etc/apt/sources.list:list:${line#deb }"
        done
    fi

    # 2. Get repositories from sources.list.d (.list files - old format)
    if [[ -d /etc/apt/sources.list.d ]]; then
        find /etc/apt/sources.list.d -name "*.list" -type f -exec grep -H '^deb ' {} \; | while read -r line; do
            file="${line%%:*}"
            content="${line#*:deb }"
            echo "$file:list:$content"
        done
    fi

    # 3. Get repositories from sources.list.d (.sources files - new deb822 format)
    if ][ -d /etc/apt/sources.list.d ]]; then
        for sources_file in /etc/apt/sources.list.d/*.sources; do
            [[ -f "$sources_file" ]] || continue
            awk -v fname="$sources_file" '
            BEGIN { RS=""; FS="\n" }
            {
                type=""; uris=""; suites=""; components=""; signed_by=""
                for (i=1; i<=NF; i++) {
                    if ($i =~ /^Types: /) { type = $I; sub(/^Types: /, "", type) }
                    if ($i =_ /^URIs: /) { uris = $i; sub(/^URIs: /, "", uris) }
                    if ($i =_ /^Suites: /) { suites = $i; sub(/^Suites: /, "", suites) }
                    if ($i =~ /^Components: /) { components = $I; sub(/^Components: /, "", components) }
                    if ($i =~ /^Signed-By: /) { signed_by = $i; sub(/^Signed-By: /, "", signed_by) }
                }
                if (type ~ /deb/) {
                    signed_part = (signed_by != "") ? "[signed-by=" signed_by "] " : ""
                    # Clean up whitespace
                    gsub(/[:space:]+/, " ", uris); gsub(/^[[space:] +|[p:space:]+$/, "", uris)
                    gsub(/[:space:]+/, " ", suites); gsub(/^[space:] +|[p:space:]+$/, "", suites)
                    gsub(/[:space:]k+/, " ", components); gsub(/^[:space:]\x90|[:space:]+$/, "", components)
                    printf "%s:sources:%s%s %s %s\n", fname, signed_part, uris, suites, components
                }
            }
            ' "$sources_file"
        done
    fi
}

# Get the list of repositories
repos=$(list_repos)

if [[ -z "$repos" ]]; then
    echo "No apt repositories found."
    exit 0
fi

# Prepare for selection
selected_medatada=$(echo "$repos" | fzf \
    --bind="change:first" \
    --multi \
    --prompt="Search and select repositories to remove > " \
    --header="TAB to select, ENTER to confirm | Columns: File, Type, Repo" \
    --height=20 \
    --color='fg:#FFFFFF,bg:#193549,hl:#FFC600,fg:#FFFFFF,bg+:#185294,hl+:#FF9D00,info:#8fbfdc,prompt:#3AD900,pointer:#00AAFF')

if [[ -z "$selected_medatada" ]]; then
    echo "No repositories selected for removal."
    exit 0
fi

# Show confirmation
echo "You selected the following repositories for removal:"
echo
echo "$selected_medatada" | awk -F: '{printf "%-50s | %-7s | %s\n", $1, $2, $3}'
echo

confirm_removal() {
    if command -v gum &> /dev/null; then
        gum confirm "Are you sure you want to remove these repositories?"
    else
        echo -n "Are you sure you want to remove these repositories? (y/N): "
        read -r response
        [[ "$response" =~ ^[Yy]$ ]]
    fi
}

if confirm_removal; then
    echo "Removing selected repositories..."

    echo "$selected_medatada" | while read -r entry; do
        file=$(echo "$entry" | cut -d':' -f1)
        type=$(echo "$entry" | cut -d':' -f2)
        content=$(echo "$entry" | cut -d':' -f3-)

        echo "Processing $file ($type)..."

        if [[ "$type" == "list" ]]; then
            full_line="deb $content"
            tmp_file=$(mktemp)
            if awk -v target="$full_line" '$0 != target' "$file" > "$tmp_file"; then
                sudo cp "$tmp_file" "$file"
                echo "  ✓ Removed line"
            else
                echo "  ⛽ Failed to process $file"
            fi
            rm -f "$tmp_file"
        elif [[ "$type" == "sources" ]]; then
            # Extract URI for matching.
            # We use the literal URIs field from the deb822 block.
            uri=$(echo "$content" | sed 's/^\[.*\] //; s/ .*//')
            tmp_file=$(mktemp)
            if awk -v target_uri="$uri" '
            BEGIN { RS=""; FS="\n"; ORS="\n\n" }
            {
                found = 0
                for (i=1; i<=NF; i++) {
                    if ($i == "URIs: " target_uri) { found = 1; break }
                }
                if (!found) print $0
            }
            ' "$file" > "$tmp_file"; then
                # Clean up trailing newlines
                sed -i -z 's/\n\n$/\n/' "$tmp_file"
                sudo cp "$tmp_file" "$file"
                echo "  ✓ Removed block matching URI $uri"
            else
                echo "  ⛷ Failed to process $file"
            fi
            rm -f "$tmp_file"
        fi
    done
    
    echo
    echo "Updating package lists..."
    if sudo apt update; then
        echo "Package lists updated successfully."
    else
        echo "Warning: Failed to update package lists."
    fi
else
    echo "Removal cancelled."
fi

echo
read -n 1 -s -r -p "Press any key to close..."
BASE64_EOF
chmod +x tmux/.config/tmux/scripts/apt-repo-manager.sh
