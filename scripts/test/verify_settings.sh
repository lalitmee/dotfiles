#!/usr/bin/env bash

# Verification script for gemini-cli settings update
# Following Step 4 of the workflow

SETTINGS_FILE="gemini-cli/.gemini/settings.json"

echo "Running verification tests for $SETTINGS_FILE..."

# 1. JSON Syntax Validation
if jq . "$SETTINGS_FILE" > /dev/null 2>&1; then
    echo "✅ Test 1 Passed: JSON syntax is valid."
else
    echo "❌ Test 1 Failed: JSON syntax is invalid."
    exit 1
fi

# 2. Deprecation Check
if ! grep -q "enablePromptCompletion" "$SETTINGS_FILE" && ! grep -q "previewFeatures" "$SETTINGS_FILE"; then
    echo "✅ Test 2 Passed: Deprecated settings removed."
else
    echo "❌ Test 2 Failed: Deprecated settings still present."
fi

# 3. Redundancy Check
if ! grep -q "\"tools\":" "$SETTINGS_FILE"; then
    echo "✅ Test 3 Passed: Redundant tools block removed."
else
    echo "❌ Test 3 Failed: Redundant tools block still present."
fi

# 4. Preference Preservation (model)
if jq -r '.model.name' "$SETTINGS_FILE" | grep -q "gemini-3-flash-preview"; then
    echo "✅ Test 4 Passed: model.name preserved."
else
    echo "❌ Test 4 Failed: model.name changed or missing."
fi

# 5. Preference Preservation (general)
if [[ "$(jq -r '.general.vimMode' "$SETTINGS_FILE")" == "true" ]] && [[ "$(jq -r '.general.enableAutoUpdate' "$SETTINGS_FILE")" == "false" ]]; then
    echo "✅ Test 5 Passed: general preferences preserved."
else
    echo "❌ Test 5 Failed: general preferences changed or missing."
fi

# 6. Backup Preservation
if jq -r '.inactiveMcpServers' "$SETTINGS_FILE" | grep -q "server-sequential-thinking"; then
    echo "✅ Test 6 Passed: inactiveMcpServers backup preserved."
else
    echo "❌ Test 6 Failed: inactiveMcpServers backup missing or incorrect."
fi

# 7. MCP Check
ACTIVE_SERVERS=$(jq -r '.mcpServers | keys[]' "$SETTINGS_FILE")
EXPECTED_SERVERS=("fetch" "context7" "crash" "chrome-devtools" "playwright")

MISSING=0
for server in "${EXPECTED_SERVERS[@]}"; do
    if ! echo "$ACTIVE_SERVERS" | grep -q "$server"; then
        echo "❌ Test 7 Failed: Active MCP server '$server' missing."
        MISSING=1
    fi
done

if [[ $MISSING -eq 0 ]]; then
    echo "✅ Test 7 Passed: All active MCP servers present."
fi

echo "Verification complete."
