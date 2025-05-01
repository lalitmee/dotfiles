#!/bin/bash

# Required parameters:
# @raycast.schemaVersion 1
# @raycast.title Toggle Postman
# @raycast.mode silent

# Optional parameters:
# @raycast.icon 🤖
# @raycast.packageName Standard API Client

# Documentation:
# @raycast.description Toggles the Postman
# @raycast.author Lalit Kumar

osascript -e 'set appName to "Postman"
if application appName is running then
	tell application appName to activate
else
	tell application appName to launch
end if'

# # Wait a moment for the app to activate
# sleep 0.3
#
# # Move mouse to center of focused window (approximate)
# cliclick m:500,500  # You can adjust this or make it dynamic
