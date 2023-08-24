#!/bin/bash

# mapping caps_lock to esc
setxkbmap -option caps:escape

# thunar
thunar --daemon &
