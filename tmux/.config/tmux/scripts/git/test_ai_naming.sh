#!/bin/bash

# Test the exact AI naming logic from the script
source git-worktree.sh

echo "Testing AI Window Naming for Branch: NYS-1232-multi-language"
echo "=========================================================="

BRANCH_NAME="NYS-1232-multi-language"

echo "Branch: $BRANCH_NAME"
echo "Testing cache lookup first..."

# Test cache lookup (should be empty now)
cached_name=$(get_cached_window_name "$BRANCH_NAME")
if [[ -n "$cached_name" ]]; then
    echo "✅ Found cached name: '$cached_name'"
    echo "Result: $cached_name"
    exit 0
else
    echo "❌ No cached name found (good - cache was cleared)"
fi

echo ""
echo "Testing AI generation..."

# Test the AI generation (exact same logic as in the script)
if command -v gemini &> /dev/null; then
    log "Using Gemini AI to generate window name for branch: $BRANCH_NAME"
    local ai_response ai_name exit_code

    # Add 10-second timeout to prevent delays in window creation (cross-platform)
    log "Making AI request with 10-second timeout..."
    start_time=$(date +%s)
    ai_response=$(timeout_seconds 10 gemini "Generate a concise tmux window name (max 15 chars) for this git branch: $BRANCH_NAME. Return only the name, no explanation." --output-format json 2>&1)
    exit_code=$?
    end_time=$(date +%s)

    log "AI command exit code: $exit_code"
    log "AI raw response: '$ai_response'"
    log "Time taken: $((end_time - start_time))s"

    echo "Exit code: $exit_code"
    echo "Time taken: $((end_time - start_time))s"
    echo "Raw response: '$ai_response'"

    if [[ $exit_code -eq 124 ]]; then
        log "AI request timed out after 10 seconds"
        echo "❌ AI request timed out"
    elif [[ $exit_code -ne 0 ]]; then
        log "AI command failed with exit code $exit_code"
        echo "❌ AI command failed"
    else
        # Try to extract the response from JSON
        ai_name=$(echo "$ai_response" | jq -r '.response' 2>/dev/null | tr -d '\n' | sed 's/^[[:space:]]*//;s/[[:space:]]*$//' | cut -c1-15)
        log "Extracted AI name from JSON: '$ai_name'"
        echo "Extracted name: '$ai_name'"

        # Validate the AI-generated name
        if [[ -n "$ai_name" && "$ai_name" != "null" && ${#ai_name} -le 15 ]]; then
            # Remove any special characters that might break tmux
            ai_name=$(echo "$ai_name" | sed 's/[^a-zA-Z0-9_-]//g')
            log "Sanitized AI name: '$ai_name'"
            echo "Sanitized name: '$ai_name'"

            if [[ -n "$ai_name" ]]; then
                log "AI successfully generated window name: $ai_name"
                # Cache the successful AI-generated name
                cache_window_name "$BRANCH_NAME" "$ai_name"
                echo "✅ SUCCESS: AI generated name '$ai_name'"
                echo "Result: $ai_name"
                exit 0
            else
                log "AI name became empty after sanitization"
                echo "❌ AI name became empty after sanitization"
            fi
        else
            log "AI name validation failed - name: '$ai_name', length: ${#ai_name}"
            echo "❌ AI name validation failed"
        fi
    fi
else
    log "Gemini CLI not found, falling back to simple naming"
    echo "❌ Gemini CLI not found"
fi

echo ""
echo "Falling back to simple naming..."
result=$(generate_window_name "$BRANCH_NAME")
echo "Fallback result: '$result'"

echo ""
echo "Check logs at: ~/.local/share/tmux/logs/git-worktree.log"
echo "✅ Test completed!"