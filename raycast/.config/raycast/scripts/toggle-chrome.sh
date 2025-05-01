#!/bin/bash

# Required parameters:
# @raycast.schemaVersion 1
# @raycast.title Toggle Google Chrome
# @raycast.mode silent

# Optional parameters:
# @raycast.icon 🤖
# @raycast.packageName Standard Browser

# Documentation:
# @raycast.description Toggles the Google Chrome
# @raycast.author Lalit Kumar

osascript -e 'set appName to "Google Chrome"
if application appName is running then
    tell application appName to activate
else
    tell application appName to launch
end if'
