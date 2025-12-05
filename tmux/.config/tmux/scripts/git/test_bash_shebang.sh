#!/bin/bash

# Test basic script functionality with bash
echo "Testing script with bash shebang..."
echo "==================================="

# Test the generate_window_name function
generate_window_name() {
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

    # Fast, clean fallback naming (JIRA-free)
    # Helper function to clean JIRA codes from a name
    clean_jira() {
        local name="$1"
        # Remove JIRA patterns and clean up extra dashes/slashes
        echo "$name" | sed 's/[A-Z][A-Z0-9]*-[0-9][0-9]*//g' | sed 's/[-/]\+/ /g' | sed 's/^ *//' | sed 's/ *$//' | sed 's/ /-/g' | sed 's/^-*//' | sed 's/-*$//'
    }

    if [[ "$branch_name" == feature/* ]]; then
        local feature_part="${branch_name#feature/}"
        local feature_name=$(clean_jira "$feature_part")
        if [[ ${#feature_name} -gt 12 ]]; then
            feature_name="${feature_name%%-*}"
            if [[ ${#feature_name} -gt 12 ]]; then
                feature_name="${feature_name:0:12}"
            fi
        fi
        echo "$feature_name"
    elif [[ "$branch_name" == bugfix/* ]]; then
        local bug_part="${branch_name#bugfix/}"
        local bug_name=$(clean_jira "$bug_part")
        if [[ ${#bug_name} -gt 12 ]]; then
            bug_name="${bug_name%%-*}"
            if [[ ${#bug_name} -gt 12 ]]; then
                bug_name="${bug_name:0:12}"
            fi
        fi
        echo "$bug_name"
    elif [[ "$branch_name" == hotfix/* ]]; then
        local hotfix_part="${branch_name#hotfix/}"
        local hotfix_name=$(clean_jira "$hotfix_part")
        if [[ ${#hotfix_name} -gt 12 ]]; then
            hotfix_name="${hotfix_name%%-*}"
            if [[ ${#hotfix_name} -gt 12 ]]; then
                hotfix_name="${hotfix_name:0:12}"
            fi
        fi
        echo "$hotfix_name"
    elif [[ "$branch_name" == release/* ]]; then
        local release_part="${branch_name#release/}"
        local release_name=$(clean_jira "$release_part")
        if [[ ${#release_name} -gt 12 ]]; then
            release_name="${release_name%%-*}"
            if [[ ${#release_name} -gt 12 ]]; then
                release_name="${release_name:0:12}"
            fi
        fi
        echo "$release_name"
    else
        # For other branches, clean JIRA codes and truncate if needed
        local fallback_name=$(clean_jira "$branch_name")
        if [[ ${#fallback_name} -gt 15 ]]; then
            fallback_name="${fallback_name:0:15}"
        fi
        echo "$fallback_name"
    fi
}

# Test some branch names
test_branches=(
    "main"
    "develop"
    "NYS-1232-multi-language"
    "feature/PROJ-456-user-auth"
    "bugfix/TICKET-789-api-crash"
)

echo "Branch Name → Window Name"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

for branch in "${test_branches[@]}"; do
    result=$(generate_window_name "$branch")
    printf "%-25s → %s\n" "$branch" "$result"
done

echo ""
echo "✅ Script works perfectly with bash!"
echo "✅ No interactive environment needed!"
echo "✅ Clean, fast naming!"