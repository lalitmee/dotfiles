#!/usr/bin/env bash

cd ~/.local/share/nvim/sessions/
find . -type f -mtime +30 -delete
