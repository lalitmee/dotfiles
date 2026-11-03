#!/usr/bin/env zsh

set -euo pipefail

repo_root="${0:A:h:h:h:h}"
installer="${INSTALL_ANTIGRAVITY:-$repo_root/bin/.config/bin/install-antigravity}"

tmp_dir="$(mktemp -d)"
trap 'rm -rf "$tmp_dir"' EXIT

mkdir -p "$tmp_dir/bin" "$tmp_dir/home/Downloads" "$tmp_dir/opt/antigravity" "$tmp_dir/usr/local/bin" "$tmp_dir/usr/share/applications" "$tmp_dir/usr/share/icons/hicolor/512x512/apps"

export HOME="$tmp_dir/home"
export TEST_LOG="$tmp_dir/commands.log"
export PATH="$tmp_dir/bin:$PATH"
export ANTIGRAVITY_TEST_MODE=1
export INSTALL_ROOT="$tmp_dir/opt/antigravity"
export COMMAND_LINK="$tmp_dir/usr/local/bin/antigravity"
export DESKTOP_FILE="$tmp_dir/usr/share/applications/antigravity.desktop"
export ICON_FILE="$tmp_dir/usr/share/icons/hicolor/512x512/apps/antigravity.png"

# Create a minimal valid archive builder in Python
python3 - "$tmp_dir" <<'PY'
import json, os, struct, sys, tarfile

tmp_dir = sys.argv[1]
def create_archive(version, out_path):
    stage = os.path.join(tmp_dir, f"stage_{version}")
    app_dir = os.path.join(stage, "Antigravity-x64")
    res_dir = os.path.join(app_dir, "resources")
    os.makedirs(res_dir, exist_ok=True)

    with open(os.path.join(app_dir, "antigravity"), "w") as f:
        f.write("#!/bin/sh\necho antigravity\n")
    os.chmod(os.path.join(app_dir, "antigravity"), 0o755)

    with open(os.path.join(app_dir, "chrome-sandbox"), "w") as f:
        f.write("#!/bin/sh\nexit 0\n")
    os.chmod(os.path.join(app_dir, "chrome-sandbox"), 0o755)

    # Build app.asar containing package.json and icon.png
    pkg_bytes = json.dumps({"name": "antigravity", "version": version}).encode("utf-8")
    icon_bytes = b"\x89PNG\r\n\x1a\nfake_icon_bytes"

    header = {
        "files": {
            "package.json": {"size": len(pkg_bytes), "offset": "0"},
            "icon.png": {"size": len(icon_bytes), "offset": str(len(pkg_bytes))}
        }
    }
    header_json = json.dumps(header).encode("utf-8")
    json_len = len(header_json)
    header_size = json_len + 4

    asar_path = os.path.join(res_dir, "app.asar")
    with open(asar_path, "wb") as f:
        f.write(struct.pack("<I", 4))
        f.write(struct.pack("<I", header_size + 4))
        f.write(struct.pack("<I", header_size))
        f.write(struct.pack("<I", json_len))
        f.write(header_json)
        f.write(pkg_bytes)
        f.write(icon_bytes)

    with tarfile.open(out_path, "w:gz") as tar:
        tar.add(app_dir, arcname="Antigravity-x64")

create_archive("2.28.2", os.path.join(tmp_dir, "Antigravity-2.28.2.tar.gz"))
create_archive("2.28.1", os.path.join(tmp_dir, "Antigravity-2.28.1.tar.gz"))
PY

# Mock curl
cat > "$tmp_dir/bin/curl" <<'EOF'
#!/bin/sh
printf 'curl %s\n' "$*" >> "$TEST_LOG"
for arg do
    case "$arg" in
        *releases)
            printf '[{"version":"2.28.2","execution_id":"999999"}]\n'
            exit 0
            ;;
        *storage.googleapis.com*)
            while [ "$1" != "-o" ]; do shift; done
            cp "$TEST_DIR_ARCHIVE" "$2"
            exit 0
            ;;
    esac
done
exit 0
EOF
chmod +x "$tmp_dir/bin/curl"

# Mock gum_style
cat > "$tmp_dir/bin/gum_style" <<'EOF'
#!/bin/sh
printf '%s\n' "$1" >> "$TEST_LOG"
EOF
chmod +x "$tmp_dir/bin/gum_style"

assert() {
    if ! eval "$1"; then
        print -u2 -- "FAIL: $2"
        exit 1
    fi
}

# 1. Invalid option
if "$installer" --bogus >/dev/null 2>&1; then
    print -u2 -- "FAIL: unknown option should exit non-zero"
    exit 1
fi

# 2. Missing argument for --file
if "$installer" --file >/dev/null 2>&1; then
    print -u2 -- "FAIL: missing --file argument should exit non-zero"
    exit 1
fi

# 3. Help flag
"$installer" --help > "$tmp_dir/help.txt"
assert 'grep -q "Usage: install-antigravity" "$tmp_dir/help.txt"' "help output should include usage"

# 4. Check flag when none installed
"$installer" --check > "$tmp_dir/check_none.txt"
assert 'grep -q "Installed version: none" "$tmp_dir/check_none.txt"' "check should report none when not installed"
assert 'grep -q "Latest version:    2.28.2" "$tmp_dir/check_none.txt"' "check should report latest version from API"

# 5. Install from local file
"$installer" --file "$tmp_dir/Antigravity-2.28.1.tar.gz" >/dev/null
assert '[[ -x "$COMMAND_LINK" ]]' "command link must exist and be executable"
assert '[[ "$(readlink -f "$COMMAND_LINK")" == "$INSTALL_ROOT/Antigravity-x64/antigravity" ]]' "command link points to antigravity"
assert '[[ -f "$DESKTOP_FILE" ]]' "desktop file must exist"
assert 'grep -q "Exec=$COMMAND_LINK %U" "$DESKTOP_FILE"' "desktop file has correct exec link"
assert 'grep -q "MimeType=x-scheme-handler/antigravity;" "$DESKTOP_FILE"' "desktop file has mime handler"
assert '[[ -f "$ICON_FILE" ]]' "icon must be installed"
assert '[[ "$(cat "$INSTALL_ROOT/.version")" == "2.28.1" ]]' "version file recorded"

# 6. Check reports update available
"$installer" --check > "$tmp_dir/check_update.txt"
assert 'grep -q "Status: Update available (2.28.1 -> 2.28.2)" "$tmp_dir/check_update.txt"' "check should detect update"

# 7. Install latest via download flow
export TEST_DIR_ARCHIVE="$tmp_dir/Antigravity-2.28.2.tar.gz"
"$installer" >/dev/null
assert '[[ "$(cat "$INSTALL_ROOT/.version")" == "2.28.2" ]]' "installer upgraded to 2.28.2"
assert '[[ -d "$INSTALL_ROOT.previous" ]]' "previous install was backed up"

# 8. Re-run without force should be no-op (up to date)
rm -f "$TEST_LOG"
"$installer" > "$tmp_dir/noop.txt"
assert 'grep -q "already up to date" "$TEST_LOG" || grep -q "already up to date" "$tmp_dir/noop.txt"' "up to date should be detected"
assert '! grep -q "curl.*storage.googleapis.com" "$TEST_LOG"' "should not download when up to date"

# 9. Force flag reinstalls
"$installer" --force >/dev/null
assert 'grep -q "curl.*storage.googleapis.com" "$TEST_LOG"' "force flag triggers download/install"

print "All install-antigravity tests passed successfully."
