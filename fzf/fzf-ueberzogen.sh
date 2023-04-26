#!/usr/bin/env bash
set -e
[ -n "$PYENV_DEBUG" ] && set -x

program="${0##*/}"

export PYENV_ROOT="/home/lalitmee/.pyenv"
exec "/home/lalitmee/.pyenv/libexec/pyenv" exec "$program" "$@"
