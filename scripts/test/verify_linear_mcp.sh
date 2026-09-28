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

python3 - "$CODEX_CONFIG" "$LINEAR_URL" <<'PY'
import sys
import tomllib
from pathlib import Path

config_path, expected_url = sys.argv[1:]
config = tomllib.loads(Path(config_path).read_text())
linear_server = config.get("mcp_servers", {}).get("linear")

if linear_server != {"url": expected_url}:
    raise SystemExit("Codex Linear MCP entry is missing, malformed, or contains unexpected fields.")

print("Codex Linear MCP entry is valid and credential-free.")
PY

for expected in \
    '| OpenCode | Configured in' \
    '| Codex CLI / IDE extension | Configured in' \
    'opencode mcp auth linear' \
    'codex mcp login linear'; do
    if ! grep -Fq "$expected" "$GUIDE"; then
        echo "Linear MCP guide is missing expected coverage or login guidance: $expected" >&2
        exit 1
    fi
done

for stale in \
    '| OpenCode | MCP-capable; its repository config is tracked but intentionally excluded' \
    '| Codex CLI / IDE extension | MCP-capable; `codex/.codex/config.toml` is tracked but intentionally excluded' \
    '### OpenCode' \
    '### Codex CLI / IDE extension' \
    "Do not edit the repository's tracked OpenCode/Codex/ VS Code files"; do
    if grep -Fq "$stale" "$GUIDE"; then
        echo "Linear MCP guide still contains stale client setup guidance: $stale" >&2
        exit 1
    fi
done

echo "Linear MCP guide correctly distinguishes configured clients from local setup."
