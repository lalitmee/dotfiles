#!/usr/bin/env zsh
# Fail if tracked Cursor CLI config contains identity, cache, or model-picker keys.

set -euo pipefail

readonly CONFIG_PATH="cursor/.config/cursor/cli-config.json"
readonly FORBIDDEN_KEYS=(
    authInfo
    privacyCache
    autoReviewAvailabilityCache
    serverConfigCache
    model
    selectedModel
    modelParameters
    modelSelectionHistory
    hasChangedDefaultModel
    runEverythingSettingsPromptStreak
)

if [[ ! -f "${CONFIG_PATH}" ]]; then
    exit 0
fi

if ! command -v python3 >/dev/null 2>&1; then
    print -u2 "check-cursor-cli-config: python3 is required"
    exit 1
fi

python3 - "${CONFIG_PATH}" "${FORBIDDEN_KEYS[@]}" <<'PY'
import json
import sys

path = sys.argv[1]
forbidden = set(sys.argv[2:])

with open(path, encoding="utf-8") as f:
    data = json.load(f)

if not isinstance(data, dict):
    print(f"check-cursor-cli-config: {path} must be a JSON object", file=sys.stderr)
    sys.exit(1)

found = sorted(k for k in data if k in forbidden)
if found:
    print(
        f"check-cursor-cli-config: forbidden keys in {path}: {', '.join(found)}",
        file=sys.stderr,
    )
    print(
        "Remove identity/cache/model-picker fields before committing.",
        file=sys.stderr,
    )
    sys.exit(1)
PY
