#!/bin/bash

# Required parameters:
# @raycast.schemaVersion 1
# @raycast.title Toggle Arc Browser
# @raycast.mode silent

# Optional parameters:
# @raycast.icon 🤖
# @raycast.packageName Modern Browser

# Documentation:
# @raycast.description Toggles the Arc Browser
# @raycast.author Lalit Kumar

osascript -e 'set appName to "Arc"
if application appName is running then
	tell application appName to activate
else
	tell application appName to launch
end if'
