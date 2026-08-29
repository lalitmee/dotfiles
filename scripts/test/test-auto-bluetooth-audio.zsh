#!/usr/bin/env zsh
set -euo pipefail

repo_root="${0:A:h:h:h}"
script="$repo_root/bin/.config/bin/auto-bluetooth-audio"
tmpdir="$(mktemp -d)"
trap 'rm -rf "$tmpdir"' EXIT

mockbin="$tmpdir/bin"
mkdir -p "$mockbin"

export PACTL_LOG="$tmpdir/pactl.log"

cat > "$mockbin/pactl" <<'PACTL'
#!/usr/bin/env zsh
print -r -- "$*" >> "$PACTL_LOG"

if [[ "$*" == "list short sinks" ]]; then
    cat <<'SINKS'
81	alsa_output.pci-0000_00_1f.3.analog-stereo.2	PipeWire	s32le 2ch 48000Hz	SUSPENDED
3526	bluez_output.11_22_33_44_55_66.1	PipeWire	s16le 2ch 48000Hz	SUSPENDED
3527	bluez_output.AA_BB_CC_DD_EE_FF.1	PipeWire	s16le 2ch 48000Hz	SUSPENDED
SINKS
    exit 0
fi

if [[ "$1" == "set-default-sink" ]]; then
    exit 0
fi

exit 1
PACTL

chmod +x "$mockbin/pactl"

if [[ ! -x "$script" ]]; then
    print -u2 "Expected executable script at $script"
    exit 1
fi

PATH="$mockbin:$PATH" "$script" --once

if ! grep -qx 'set-default-sink bluez_output.AA_BB_CC_DD_EE_FF.1' "$PACTL_LOG"; then
    print -u2 "Expected newest Bluetooth sink to be selected"
    print -u2 "pactl calls:"
    cat "$PACTL_LOG" >&2
    exit 1
fi

print "auto-bluetooth-audio test passed"
