#!/usr/bin/env bash

set -euo pipefail

OPENCODE_CONFIG="opencode/.config/opencode/opencode.json"
CODEX_CONFIG="codex/.codex/config.toml"
GUIDE="docs/linear-mcp.md"
LINEAR_URL="https://mcp.linear.app/mcp"

python3 - "$OPENCODE_CONFIG" "$LINEAR_URL" <<'PY'
import json
import re
import sys
from pathlib import Path

config_path, expected_url = sys.argv[1:]
text = Path(config_path).read_text()
text = re.sub(r",(?=\s*[}\]])", "", text)
config = json.loads(text)
linear_server = config.get("mcp", {}).get("linear")

if linear_server != {
    "type": "remote",
    "url": expected_url,
    "enabled": True,
}:
    raise SystemExit("OpenCode Linear MCP entry is missing, malformed, or contains unexpected fields.")

print("OpenCode Linear MCP entry is valid and credential-free.")
PY

python3 - "$CODEX_CONFIG" <<'PY'
import sys
import tomllib
from pathlib import Path

config_path = Path(sys.argv[1])
if not config_path.is_file():
    raise SystemExit("A sanitized Codex config snapshot must remain in dotfiles.")

text = config_path.read_text()
config = tomllib.loads(text)
if config.get("tui", {}).get("theme") != "cobalt2":
    raise SystemExit("The tracked Codex config snapshot must preserve the Cobalt2 theme.")
if config.get("mcp_servers") or config.get("projects"):
    raise SystemExit("Work MCP servers and project paths must stay out of tracked Codex config.")
per_path = config.get("desktop", {}).get("open-in-target-preferences", {}).get("perPath")
if per_path:
    raise SystemExit("Machine-specific project associations must stay out of tracked Codex config.")
text_lower = text.casefold()
for forbidden in (
    "/users/",
    "/home/",
    str(Path.home()).casefold(),
    "bearer ",
    "authorization",
    "api_key",
    "access_token",
    "client_secret",
):
    if forbidden and forbidden in text_lower:
        raise SystemExit("Tracked Codex config contains a machine identity, path, or credential-like value.")

print("Tracked Codex config snapshot is portable, credential-free, and preserves Cobalt2.")
PY

if ! git ls-files --error-unmatch "$CODEX_CONFIG" >/dev/null 2>&1; then
    echo "The sanitized Codex base config must remain tracked." >&2
    exit 1
fi

if git check-ignore --no-index -q "$CODEX_CONFIG"; then
    echo "The sanitized Codex base config must not be ignored." >&2
    exit 1
fi

if ! grep -Fqx '^/\.codex(?:/|$)' "codex/.stow-local-ignore"; then
    echo "Codex config and themes must remain excluded from Stow." >&2
    exit 1
fi

for expected in \
    '| OpenCode | Configured in' \
    '| Codex CLI / IDE extension | Sanitized preference snapshot is tracked; live runtime config is local-only and not stowed' \
    'codex/.codex/config.toml' \
    'opencode mcp auth linear' \
    'codex mcp login linear'; do
    if ! grep -Fq "$expected" "$GUIDE"; then
        echo "Linear MCP guide is missing expected coverage or login guidance: $expected" >&2
        exit 1
    fi
done

for stale in \
    '| OpenCode | MCP-capable; its repository config is tracked but intentionally excluded' \
    '| Codex CLI / IDE extension | Supported; configuration is local-only and not tracked here' \
    '### OpenCode' \
    '### Codex CLI / IDE extension' \
    "Do not edit the repository's tracked OpenCode/Codex/ VS Code files"; do
    if grep -Fq "$stale" "$GUIDE"; then
        echo "Linear MCP guide still contains stale client setup guidance: $stale" >&2
        exit 1
    fi
done

echo "Linear MCP guide correctly distinguishes configured clients from local setup."
