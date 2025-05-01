#!/bin/bash

# Required parameters:
# @raycast.schemaVersion 1
# @raycast.title Toggle Safari
# @raycast.mode silent

# Optional parameters:
# @raycast.icon 🤖
# @raycast.packageName Apple Browser

# Documentation:
# @raycast.description Toggles the Safari
# @raycast.author Lalit Kumar

osascript -e 'set appName to "Safari"
if application appName is running then
	tell application appName to activate
else
	tell application appName to launch
end if'
