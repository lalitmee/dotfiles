#!/bin/bash

# Required parameters:
# @raycast.schemaVersion 1
# @raycast.title Toggle Google Chat
# @raycast.mode silent

# Optional parameters:
# @raycast.icon 🤖
# @raycast.packageName Standard Chat

# Documentation:
# @raycast.description Toggles the Google Chat
# @raycast.author Lalit Kumar

osascript -e 'set appName to "Google Chat"
if application appName is running then
    tell application appName to activate
else
    tell application appName to launch
end if'
