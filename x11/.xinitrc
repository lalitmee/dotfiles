#!/bin/bash

# mapping caps_lock to esc
setxkbmap -option caps:escape

# keyboard repeat keys delay
xset r rate 350 30

# enabling tap on the touchpad
xinput set-prop "DELL08A6:00 06CB:7E92 Touchpad" "libinput Tapping Enabled" 1

# autostarting some important programs
feh -FD3600 --randomize --bg-fill "$HOME/Desktop/Github/nord-wallpapers/*"
picom --experiment-backends --config "$HOME/.config/picom.conf"
ulauncher
nm-applet
cbatticon -l 40 -r 20
