#!/usr/bin/env zsh

# ============================================================================
# GIT-UTILS.SH - Git-Specific Helper Functions
# ============================================================================
# Git repository validation, window naming, and info retrieval

source "$(dirname "$0")/common.sh"

# ============================================================================
# Ensure we are in a git repository
# Exits with status 1 if not in a git repo
# ============================================================================
ensure_git_repo()
                  {
    if ! git rev-parse --is-inside-work-tree > /dev/null 2>&1; then
        log "Script run outside of a git repository."
        gum style --foreground "212" "Not a git repository. Exiting..."
        sleep 2
        exit 1
    fi
}

# ============================================================================
# Generate window name from branch name
# Removes JIRA codes (e.g., NYS-1769) and keeps rest of branch name
# Pattern: NYS-[0-9]+ (specific to NYS project codes)
# ============================================================================
generate_window_name()
                       {
    local branch_name="$1"

    # Handle main/master branches (keep simple)
    if [[ "$branch_name" == "main" || "$branch_name" == "master" ]]; then
        echo "main"
        return
    fi

    # Handle develop branch (keep simple)
    if [[ "$branch_name" == "develop" ]]; then
        echo "develop"
        return
    fi

    # Remove NYS JIRA codes specifically
    local cleaned_name=$(echo "$branch_name" | sed -E 's/NYS-[0-9]+//g')
    
    # Clean up stray dashes left after JIRA removal
    # Use multiple simple sed commands to avoid complex regex
    cleaned_name=$(echo "$cleaned_name" | sed 's/-\//-/g')
    cleaned_name=$(echo "$cleaned_name" | sed 's/\/-/-/g')
    
    # Replace multiple dashes with single dash
    cleaned_name=$(echo "$cleaned_name" | sed 's/--/-/g')
    
    # Replace multiple slashes with single slash
    cleaned_name=$(echo "$cleaned_name" | sed 's/\/\//\//g')
    
    # Remove leading/trailing dashes and slashes
    cleaned_name=$(echo "$cleaned_name" | sed 's/^[\/-]*//' | sed 's/[\/-]*$//')

    echo "$cleaned_name"
}

# ============================================================================
# Validate custom folder name
# Ensures folder name is safe for file system and prevents path traversal
# ============================================================================
validate_folder_name()
                      {
    local folder_name="$1"
    
    # Check if empty
    if [[ -z "$folder_name" ]]; then
        echo "Error: Folder name cannot be empty" >&2
        return 1
    fi
    
    # Check for path traversal attempts
    if [[ "$folder_name" == *"../"* ]]; then
        echo "Error: Folder name cannot contain path traversal (../)" >&2
        return 1
    fi
    
    # Check for invalid filesystem characters using simple string matching
    if [[ "$folder_name" == *"<"* || "$folder_name" == *">"* || "$folder_name" == *"\""* || "$folder_name" == *"|"* || "$folder_name" == *"?"* ]]; then
        echo "Error: Folder name contains invalid characters" >&2
        return 1
    fi
    
    # Check length (max 255 characters)
    if [[ ${#folder_name} -gt 255 ]]; then
        echo "Error: Folder name too long (max 255 characters)" >&2
        return 1
    fi
    
    # Check if starts with alphanumeric using case statement
    case "$folder_name" in
        [a-zA-Z0-9]*)
            # Valid start
            ;;
        *)
            echo "Error: Folder name must start with letter or number" >&2
            return 1
            ;;
    esac
    
    return 0
}

# ============================================================================
# Sanitize folder name by replacing problematic characters with underscores
# ============================================================================
sanitize_folder_name()
                       {
    local folder_name="$1"
    
    # Replace spaces, slashes, and other problematic chars with underscores
    local sanitized=$(echo "$folder_name" | sed 's/[[:space:]\/\\]/_/g' | sed 's/__/_/g')
    
    echo "$sanitized"
}

# ============================================================================
# Check if folder conflicts with existing worktree
# Returns: conflict|no-conflict and prompts user for resolution if needed
# ============================================================================
check_folder_conflict()
                        {
    local worktree_dir="$1"
    local folder_name="$2"
    local branch_name="$3"
    local target_path="$worktree_dir/$folder_name"
    
    # Check if directory exists
    if [[ -d "$target_path" ]]; then
        # Check if it's a git worktree
        if git worktree list | grep -q "$target_path"; then
            local existing_branch=$(git worktree list | grep "$target_path" | awk '{print $2}' | sed 's/[[]//g' | sed 's/[]]//g')
            
            if [[ "$existing_branch" == "$branch_name" ]]; then
                gum style --foreground "196" "Worktree for branch '$branch_name' already exists at '$folder_name'"
                echo "same-branch"
                return 1
            else
                gum style --foreground "208" "Folder '$folder_name' already exists for branch '$existing_branch'"
                local action=$(gum choose "Choose different name" "Overwrite existing worktree" "Cancel" \
                    --header="How would you like to handle this conflict?")
                
                case "$action" in
                    "Choose different name")
                        echo "retry"
                        return 1
                        ;;
                    "Overwrite existing worktree")
                        echo "overwrite"
                        return 0
                        ;;
                    "Cancel")
                        echo "cancel"
                        return 1
                        ;;
                esac
            fi
        else
            gum style --foreground "208" "Folder '$folder_name' already exists but is not a git worktree"
            local action=$(gum choose "Choose different name" "Remove folder and continue" "Cancel" \
                --header="How would you like to handle this folder?")
            
            case "$action" in
                "Choose different name")
                    echo "retry"
                    return 1
                    ;;
                "Remove folder and continue")
                    if gum confirm "Remove existing folder '$folder_name'?" --affirmative="Remove" --negative="Keep"; then
                        rm -rf "$target_path"
                        echo "continue"
                        return 0
                    else
                        echo "cancel"
                        return 1
                    fi
                    ;;
                "Cancel")
                    echo "cancel"
                    return 1
                    ;;
            esac
        fi
    else
        echo "no-conflict"
        return 0
    fi
}

# ============================================================================
# Prompt user for folder name choice
# Returns: chosen_folder_name
# ============================================================================
prompt_folder_name()
                       {
    local branch_name="$1"
    local worktree_dir="$2"
    
    # Let user choose between default and custom
    local choice=$(gum choose "Use branch name ($branch_name)" "Enter custom folder name" \
        --header="Choose folder name for worktree")
    
    if [[ "$choice" == "Enter custom folder name" ]]; then
        while true; do
            local custom_name=$(gum input --placeholder="Enter custom folder name" --value="$branch_name")
            
            # Sanitize the input
            local sanitized_name=$(sanitize_folder_name "$custom_name")
            
            # Validate the sanitized name
            local validation_result=$(validate_folder_name "$sanitized_name")
            if [[ $? -ne 0 ]]; then
                gum style --foreground "196" "$validation_result"
                continue
            fi
            
            # Check for conflicts
            local conflict_result=$(check_folder_conflict "$worktree_dir" "$sanitized_name" "$branch_name")
            case "$conflict_result" in
                "no-conflict"|"continue"|"overwrite")
                    echo "$sanitized_name"
                    return 0
                    ;;
                "retry")
                    continue
                    ;;
                "cancel"|"same-branch")
                    return 1
                    ;;
            esac
        done
    else
        # Use branch name (default)
        echo "$branch_name"
        return 0
    fi
}

# ============================================================================
# Get repository information
# Returns: repo_root|repo_name|worktree_dir
# ============================================================================
get_repo_info()
                {
    local repo_root=$(git rev-parse --show-toplevel)
    local repo_name=$(basename "$repo_root")
    local worktree_dir="$repo_root/../${repo_name}-worktrees"

    echo "$repo_root|$repo_name|$worktree_dir"
}

# vim:fdm=marker
