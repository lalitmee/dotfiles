#!/bin/bash

# Required parameters:
# @raycast.schemaVersion 1
# @raycast.title Flameshot Cursor Focus
# @raycast.mode silent

# Optional parameters:
# @raycast.icon 🤖
# @raycast.packageName Developer Utils

# Documentation:
# @raycast.description Opens the Flameshot on the screen where the focus is
# @raycast.author Lalit Kumar

nohup /Applications/Flameshot.app/Contents/MacOS/flameshot gui >/dev/null 2>&1 &
