#!/bin/bash

# Required parameters:
# @raycast.schemaVersion 1
# @raycast.title Toggle Notion
# @raycast.mode silent

# Optional parameters:
# @raycast.icon 🤖
# @raycast.packageName Modern Notebook

# Documentation:
# @raycast.description Toggles the Notion
# @raycast.author Lalit Kumar

osascript -e 'set appName to "Notion"
if application appName is running then
    tell application appName to activate
else
    tell application appName to launch
end if'

# Wait a moment for the app to activate
sleep 0.3

# Move mouse to center of focused window (approximate)
cliclick m:500,500  # You can adjust this or make it dynamic
