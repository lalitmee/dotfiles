#!/bin/bash

# Required parameters:
# @raycast.schemaVersion 1
# @raycast.title Toggle Spotify
# @raycast.mode silent

# Optional parameters:
# @raycast.icon 🤖
# @raycast.packageName Standard Music

# Documentation:
# @raycast.description Toggles the Spotify
# @raycast.author Lalit Kumar

osascript -e 'set appName to "Spotify"
if application appName is running then
	tell application appName to activate
else
	tell application appName to launch
end if'

# Wait a moment for the app to activate
sleep 0.3

# Move mouse to center of focused window (approximate)
cliclick m:500,500  # You can adjust this or make it dynamic
