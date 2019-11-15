#!/bin/sh
DEFAULTPROF=`dconf read /org/gnome/terminal/legacy/profiles:/default`
DEFAULTPROF=`echo "$DEFAULTPROF" | sed -e "s/^'/:/" -e "s/'$//"`
dconf write /org/gnome/terminal/legacy/profiles:/$DEFAULTPROF/cursor-shape "'$1'"
