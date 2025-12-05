#!/bin/bash

# Simple test of AI naming without TTY issues
echo "Testing AI Window Naming - NYS-1232-multi-language"
echo "=================================================="

BRANCH_NAME="NYS-1232-multi-language"

# Check if gemini is available
if ! command -v gemini &> /dev/null; then
    echo "❌ Gemini CLI not found"
    exit 1
fi

echo "✅ Gemini CLI found"
echo "Branch: $BRANCH_NAME"

# Cross-platform timeout function
timeout_seconds() {
    local timeout_duration="$1"
    shift

    # Use timeout command if available (Linux)
    if command -v timeout &> /dev/null; then
        timeout "$timeout_duration" "$@"
        return $?
    fi

    # Fallback for macOS and other systems without timeout
    local pid
    ("$@") &
    pid=$!

    # Wait for the process with timeout
    local count=0
    while kill -0 "$pid" 2>/dev/null && [ $count -lt $timeout_duration ]; do
        sleep 1
        ((count++))
    done

    # If process is still running, kill it
    if kill -0 "$pid" 2>/dev/null; then
        kill "$pid" 2>/dev/null
        wait "$pid" 2>/dev/null
        return 124  # Same exit code as GNU timeout
    else
        wait "$pid" 2>/dev/null
        return $?
    fi
}

# Test direct AI call with timeout
echo "Testing AI call with 10-second timeout..."

start_time=$(date +%s)
ai_response=$(timeout_seconds 10 gemini "Generate a concise tmux window name (max 15 chars) for this git branch: $BRANCH_NAME. Return only the name, no explanation." --output-format json 2>&1)
exit_code=$?
end_time=$(date +%s)

echo "Exit code: $exit_code"
echo "Time taken: $((end_time - start_time))s"

if [[ $exit_code -eq 124 ]]; then
    echo "❌ Timed out after 10 seconds"
    exit 1
elif [[ $exit_code -ne 0 ]]; then
    echo "❌ Command failed with exit code $exit_code"
    echo "Response: $ai_response"
    exit 1
fi

echo "Raw response: '$ai_response'"

# Extract and validate
ai_name=$(echo "$ai_response" | jq -r '.response' 2>/dev/null | tr -d '\n' | sed 's/^[[:space:]]*//;s/[[:space:]]*$//' | cut -c1-15)
echo "Extracted name: '$ai_name'"

if [[ -n "$ai_name" && "$ai_name" != "null" && ${#ai_name} -le 15 ]]; then
    ai_name=$(echo "$ai_name" | sed 's/[^a-zA-Z0-9_-]//g')
    echo "✅ Sanitized AI name: '$ai_name'"
    echo "Length: ${#ai_name} chars"
    echo ""
    echo "🎉 SUCCESS! AI generated window name: '$ai_name'"
else
    echo "❌ Validation failed"
    exit 1
fi