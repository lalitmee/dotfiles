#!/bin/bash

# Required parameters:
# @raycast.schemaVersion 1
# @raycast.title Toggle Google Meet
# @raycast.mode silent

# Optional parameters:
# @raycast.icon 🤖
# @raycast.packageName Standard Meet

# Documentation:
# @raycast.description Toggles the Google Meet
# @raycast.author Lalit Kumar

osascript -e 'set appName to "Google Meet"
if application appName is running then
    tell application appName to activate
else
    tell application appName to launch
end if'
