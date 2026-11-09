#!/usr/bin/env bash
awk '{ minutes = int($1 / 60); printf "%dh %dm", int(minutes / 60), minutes % 60 }' /proc/uptime
