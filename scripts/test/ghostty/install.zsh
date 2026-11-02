#!/usr/bin/env zsh
set -eu
root=${0:A:h:h:h:h}
tmp=$(mktemp -d)
trap 'rm -rf "$tmp"' EXIT
mkdir -p "$tmp/bin" "$tmp/home/.local/bin"
export HOME="$tmp/home" TEST_DIR="$tmp" PATH="$tmp/bin:/usr/bin:/bin"
cat > "$tmp/app.c" <<'C'
#include <stdio.h>
int main(void) { puts("Ghostty 1.5.0"); return 0; }
C
cc "$tmp/app.c" -o "$tmp/app"
printf 'AI\002' | dd of="$tmp/app" bs=1 seek=8 conv=notrunc status=none
digest=$(sha256sum "$tmp/app" | cut -d ' ' -f 1)
cat > "$tmp/release.json" <<JSON
{"tag_name":"v1.5.0","assets":[{"name":"Ghostty-1.5.0-x86_64.AppImage","browser_download_url":"https://github.com/pkgforge-dev/ghostty-appimage/releases/download/v1.5.0/Ghostty-1.5.0-x86_64.AppImage","digest":"sha256:$digest"}]}
JSON
cat > "$tmp/bin/curl" <<'SH'
#!/bin/sh
case "$*" in
  *api.github.com*) cat "$TEST_DIR/release.json" ;;
  *) printf '%s\n' "$*" >> "$TEST_DIR/downloads"; while [ "$1" != "-o" ]; do shift; done; cp "$TEST_DIR/app" "$2" ;;
esac
SH
chmod +x "$tmp/bin/curl"
cat > "$tmp/bin/gum_style" <<'SH'
#!/bin/sh
printf '%s\n' "$1" >> "$TEST_DIR/styled.log"
SH
chmod +x "$tmp/bin/gum_style"
cat > "$tmp/bin/tmux" <<'SH'
#!/bin/sh
printf '%s\n' "$@" > "$TEST_DIR/tmux-args"
SH
chmod +x "$tmp/bin/tmux"
TMUX=fixture zsh "$root/bin/.config/bin/install-ghostty"
grep -qx 'new-window' "$tmp/tmux-args" || { print -u2 'FAIL: tmux window not opened'; exit 1; }
grep -q -- '--run' "$tmp/tmux-args" || { print -u2 'FAIL: tmux worker not selected'; exit 1; }
printf 'old' > "$HOME/.local/bin/old"
ln -s old "$HOME/.local/bin/ghostty"
TMUX='' zsh "$root/scripts/install/ghostty-latest" --run >/dev/null
grep -q 'Checking the latest stable' "$tmp/styled.log" || { print -u2 'FAIL: gum_style executable not called'; exit 1; }
[[ $(readlink "$HOME/.local/bin/ghostty") == ghostty-1.5.0 ]] || { print -u2 'FAIL: version not switched'; exit 1; }
[[ $(cat "$HOME/.local/bin/old") == old ]] || { print -u2 'FAIL: old version changed'; exit 1; }
[[ $("$HOME/.local/bin/ghostty" --version) == 'Ghostty 1.5.0' ]] || exit 1
grep -q -- '--progress-bar' "$tmp/downloads" || { print -u2 'FAIL: download progress not enabled'; exit 1; }
TMUX='' zsh "$root/scripts/install/ghostty-latest" --run >/dev/null
[[ $(wc -l < "$tmp/downloads") -eq 1 ]] || { print -u2 'FAIL: current release downloaded again'; exit 1; }
grep -q 'already up to date' "$tmp/styled.log" || { print -u2 'FAIL: missing current release message'; exit 1; }
output=$(printf x | TMUX='' script -q -c "zsh '$root/scripts/install/ghostty-latest' --run" /dev/null)
[[ $output == *'Press any key to exit'* ]] || { print -u2 'FAIL: interactive exit prompt missing'; exit 1; }
sed -i 's/sha256:[0-9a-f]\{64\}/sha256:0000000000000000000000000000000000000000000000000000000000000000/' "$tmp/release.json"
ln -sfn old "$HOME/.local/bin/ghostty"
if TMUX='' zsh "$root/scripts/install/ghostty-latest" --run >/dev/null 2>&1; then
    print -u2 'FAIL: invalid checksum accepted'; exit 1
fi
[[ $(readlink "$HOME/.local/bin/ghostty") == old ]] || { print -u2 'FAIL: failure changed symlink'; exit 1; }
print 'Ghostty updater tests passed.'
