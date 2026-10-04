# OpenCode and Codex Linear MCP Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Add Linear MCP to the tracked OpenCode and Codex configs and update the client guide to reflect repository-managed setup.

**Architecture:** Add one remote server entry to OpenCode's existing `mcp` map and one URL-only server table to Codex TOML. Add a focused validator for both config shapes and update `docs/linear-mcp.md`; preserve all unrelated config values and do not touch VS Code or Claude.

**Tech Stack:** JSON, TOML, Bash, `jq`, Python 3.11+ `tomllib`, Markdown; client-side OAuth.

**Spec:** `docs/superpowers/specs/2026-09-28-linear-mcp-config-design.md`

## Global Constraints

- Use `https://mcp.linear.app/mcp` as the default endpoint; `/mcp/readonly` is the optional least-privilege alternative.
- In OpenCode and Codex, add only the Linear URL-based server entry; preserve unrelated settings and do not add tokens, Authorization headers, or OAuth credentials.
- Do not modify `vscode/mcp.json` or `claude/.claude/settings.json`.
- Do not alter tracking status, ignore rules, or history.
- Do not run `./install.sh`; repo guidance prohibits doing so without explicit confirmation.
- Do not claim authenticated connectivity until OAuth is completed in the user's client.
- Do not auto-commit; repository guidance requires explicit user request before committing.

## Review Focus

- Wrong endpoint or server type prevents discovery; validate OpenCode's exact `type`, `url`, and `enabled` values and Codex's exact table URL.
- A token/header accidentally enters either server entry; assert OpenCode's entry has only its three required keys and Codex's entry has only `url`.
- Existing OpenCode MCP definitions or Codex settings are overwritten; inspect the focused diff and preserve all prior values.
- The client guide still says OpenCode/Codex are excluded or points to duplicate local config; assert both are listed as configured and remove stale instructions.
- Authentication is implied by adding config alone; retain guide language that OAuth must still be completed by the client.

---

## File Structure

- `opencode/.config/opencode/opencode.json` — existing tracked remote MCP map; add `mcp.linear`.
- `codex/.codex/config.toml` — existing tracked MCP server tables; add `[mcp_servers.linear]`.
- `scripts/test/verify_linear_mcp.sh` — focused JSON/TOML assertions and guide consistency checks.
- `docs/linear-mcp.md` — update OpenCode and Codex coverage and remove their now-obsolete local-only config snippets.

### Task 1: Add and verify OpenCode and Codex entries

**Files:**
- Modify: `opencode/.config/opencode/opencode.json`
- Modify: `codex/.codex/config.toml`
- Create: `scripts/test/verify_linear_mcp.sh`

**Interfaces:**
- Consumes: Existing OpenCode top-level `mcp` map; existing Codex TOML `mcp_servers` table.
- Produces: OpenCode `mcp.linear` exactly `{ "type": "remote", "url": "https://mcp.linear.app/mcp", "enabled": true }`; Codex `mcp_servers.linear` exactly `{ "url": "https://mcp.linear.app/mcp" }`.

- [ ] **Step 1: Write the focused failing validator**

Create `scripts/test/verify_linear_mcp.sh` with `set -euo pipefail`. Assert with `jq -e` that OpenCode's `.mcp.linear` has `type == "remote"`, the exact Linear URL, `enabled == true`, and exactly the keys `enabled`, `type`, and `url`. In an embedded Python 3.11+ `tomllib` check, parse Codex config and assert `mcp_servers.linear == {"url": "https://mcp.linear.app/mcp"}`. Print a clear pass line for each client.

- [ ] **Step 2: Run the validator and confirm the expected failure**

Run: `bash scripts/test/verify_linear_mcp.sh`

Expected: FAIL at the OpenCode assertion because `.mcp.linear` is not present yet.

- [ ] **Step 3: Add the OpenCode Linear entry**

Under the existing top-level `mcp` object in `opencode/.config/opencode/opencode.json`, add `linear` with `type: "remote"`, `url: "https://mcp.linear.app/mcp"`, and `enabled: true`. Do not modify any existing server entries or add authentication fields.

- [ ] **Step 4: Add the Codex Linear table**

Add `[mcp_servers.linear]` to `codex/.codex/config.toml` with only `url = "https://mcp.linear.app/mcp"`. Preserve all existing top-level configuration, plugins, and MCP server entries.

- [ ] **Step 5: Run the validator and confirm both assertions pass**

Run: `bash scripts/test/verify_linear_mcp.sh`

Expected: exit code 0; OpenCode JSON shape and Codex TOML table assertions pass without printing config contents or credentials.

### Task 2: Update client guide and validate the complete change

**Files:**
- Modify: `docs/linear-mcp.md`
- Modify: `scripts/test/verify_linear_mcp.sh`
- Review: `opencode/.config/opencode/opencode.json`, `codex/.codex/config.toml`

**Interfaces:**
- Consumes: OpenCode and Codex entries produced by Task 1.
- Produces: Guide rows showing both clients as repository-configured, with client OAuth steps and no obsolete local-only config instructions.

- [ ] **Step 1: Extend the validator with guide consistency assertions**

Assert that `docs/linear-mcp.md` has OpenCode and Codex rows marked configured, mentions `opencode mcp auth linear` and `codex mcp login linear`, and no longer contains the old excluded-status rows, `### OpenCode` / `### Codex CLI / IDE extension` local-only subsections, or the warning `Do not edit the repository's tracked OpenCode/Codex/ VS Code files`. Run `bash scripts/test/verify_linear_mcp.sh` and confirm it fails on the stale guide assertions before editing the guide.

- [ ] **Step 2: Update the guide**

Update the OpenCode and Codex coverage rows to point to their tracked config paths and note that OAuth is client-managed (including the documented manual login commands). Remove the OpenCode and Codex snippets from “Local setup examples” and revise that section's warning so it applies only to clients still configured locally, such as VS Code. Keep VS Code and Claude setup guidance, the default read-write/optional read-only disclosures, and the statement that configuration does not mean authenticated.

- [ ] **Step 3: Run focused validation**

Run:
```bash
bash scripts/test/verify_linear_mcp.sh
bash scripts/test/verify_settings.sh
jq . opencode/.config/opencode/opencode.json >/dev/null
python3 - <<'PY'
import tomllib
from pathlib import Path
tomllib.loads(Path("codex/.codex/config.toml").read_text())
print("Codex TOML syntax is valid.")
PY
git diff --check
pre-commit run --all-files
```

Expected: all commands exit 0; both Linear entries, Gemini regression checks, JSON/TOML syntax, guide assertions, whitespace checks, and repository hooks pass.

- [ ] **Step 4: Review scope and preserved settings**

Run: `git status --short && git diff -- opencode/.config/opencode/opencode.json codex/.codex/config.toml docs/linear-mcp.md && sed -n '1,200p' scripts/test/verify_linear_mcp.sh`

Expected: only the intended OpenCode/Codex entries, focused validator, and guide updates appear for this plan. Confirm existing MCP definitions are preserved, no credential values are added, and `vscode/mcp.json` and `claude/.claude/settings.json` are unchanged.

## Self-Review

- **Spec coverage:** Task 1 adds the two URL-only remote entries; Task 2 updates the client inventory/setup guidance and checks OAuth is not represented as complete; focused checks assert schemas and absence of extra credential fields; final review confirms VS Code and Claude are untouched.
- **Step scan:** The config validator is observed failing before config edits and passing after both entries are added; its extended guide assertions are observed failing before the guide edit and passing afterward. Final validation covers both parsers and the prior Gemini validator.
- **Config consistency:** OpenCode's produced map matches the `mcp.linear` schema; Codex uses `mcp_servers.linear` and TOML `url`; guide labels and client login commands match those entries.
- **Review focus:** All five risks are covered by focused assertions, guide consistency checks, or explicit diff inspection.
- **Proportion:** Two tasks change only the two selected configs, one small verifier, and the relevant guide entries; no generic config tooling or authentication automation is introduced.
