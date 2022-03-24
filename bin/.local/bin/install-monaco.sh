#!/bin/bash
# Install Monaco font in Linux
# Version from nullvideo https://gist.github.com/rogerleite/99819#gistcomment-2799386

sudo mkdir -p /usr/share/fonts/truetype/ttf-monaco && \
sudo wget https://gist.github.com/rogerleite/b50866eb7f7b5950da01ae8927c5bd61/raw/862b6c9437f534d5899e4e68d60f9bf22f356312/mfont.ttf -O - > \
/usr/share/fonts/truetype/ttf-monaco/Monaco_Linux.ttf && \
sudo fc-cache
