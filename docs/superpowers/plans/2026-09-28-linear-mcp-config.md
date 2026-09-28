# Linear MCP Configuration Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Configure Linear MCP in the tracked Gemini CLI, Zed, and MCPHub settings, and document setup/coverage for the other MCP-capable clients represented by this dotfiles environment.

**Architecture:** Add the official Linear Streamable HTTP endpoint using each selected client's native remote-server schema and OAuth discovery; do not store credentials. Keep protected client configuration untouched and explain client coverage/setup in a concise guide.

**Tech Stack:** JSON, JSONC, Bash, `jq`, Markdown; client-side OAuth handled by each MCP client.

**Spec:** `docs/superpowers/specs/2026-09-28-linear-mcp-config-design.md`

## Global Constraints

- Use `https://mcp.linear.app/mcp` as the default endpoint; `/mcp/readonly` is the optional least-privilege alternative.
- Do not commit API keys, bearer tokens, OAuth secrets, or session data.
- Do not modify `opencode/.config/opencode/opencode.json`, `codex/.codex/config.toml`, `vscode/mcp.json`, or the locally changed `claude/.claude/settings.json`.
- Do not change `.gitignore`, alter the tracking status of protected client configs, or bypass the pending secret/history guard.
- Do not run `./install.sh`; existing configs are already Stowed/live.
- Do not claim authenticated connectivity until OAuth is completed in the user's client.
- Do not auto-commit; repository guidance requires explicit user request before committing.

## Review Focus

- OAuth must be initiated by the client rather than represented as a committed token; verify all three tracked entries contain no Authorization header, API key, or OAuth secret.
- Gemini Streamable HTTP must use `httpUrl` in `settings.json`, and Linear must not be duplicated in `mcp_config.json`.
- Zed uses native remote `context_servers` with `url` so its OAuth flow can start; it must not use deprecated SSE or the older stdio workaround.
- MCPHub must declare `type: "streamable-http"` and the remote URL; its config must not contain credentials.
- The client guide must distinguish tracked integrations from local-only/manual setup and identify the default endpoint as read-write, with readonly as an alternative.

---

## File Structure

- `gemini-cli/.gemini/settings.json` — Gemini CLI's tracked `mcpServers` definitions; add the Linear HTTP endpoint.
- `scripts/test/verify_settings.sh` — extend the existing Gemini validation to assert Linear's exact endpoint and Streamable HTTP key.
- `zed/.config/zed/settings.json` — Zed's tracked JSONC `context_servers`; add native remote Linear server.
- `mcphub/.config/mcphub/servers.json` — MCPHub's tracked JSON `mcpServers`; add Streamable HTTP Linear server.
- `docs/linear-mcp.md` — client coverage inventory and setup notes for configured, protected/local, and unsupported/unverified clients.

### Task 1: Configure and verify Gemini CLI

**Files:**
- Modify: `scripts/test/verify_settings.sh`
- Modify: `gemini-cli/.gemini/settings.json`

**Interfaces:**
- Consumes: Existing `jq`-based Gemini settings checks.
- Produces: `mcpServers.linear` with `httpUrl` exactly `https://mcp.linear.app/mcp`; no secret fields.

- [ ] **Step 1: Add the failing focused assertions**

In `scripts/test/verify_settings.sh`, assert with `jq -e` that `.mcpServers.linear.httpUrl == "https://mcp.linear.app/mcp"` and that the Linear entry has no `headers`, `env`, or `oauth` credential fields. Make failed assertions exit nonzero, matching the script's JSON syntax/MCP checks.

- [ ] **Step 2: Run the focused check and confirm it fails**

Run: `bash scripts/test/verify_settings.sh`
Expected: FAIL because `mcpServers.linear` is not configured yet.

- [ ] **Step 3: Add the Gemini CLI entry**

Add `"linear": {"httpUrl": "https://mcp.linear.app/mcp"}` under top-level `mcpServers` in `gemini-cli/.gemini/settings.json`. Do not set `trust: true` or add a credential; leave `mcp_config.json` unchanged.

- [ ] **Step 4: Run Gemini validation**

Run: `bash scripts/test/verify_settings.sh`
Expected: exit code 0; JSON syntax, existing settings, and Linear endpoint assertions pass.

### Task 2: Configure native Zed and MCPHub integrations

**Files:**
- Modify: `zed/.config/zed/settings.json`
- Modify: `mcphub/.config/mcphub/servers.json`

**Interfaces:**
- Consumes: Existing Zed `context_servers` section and MCPHub `mcpServers` object.
- Produces: Zed `context_servers.linear.url` set to `https://mcp.linear.app/mcp`; MCPHub `mcpServers.linear` with `type: "streamable-http"` and the same URL.

- [ ] **Step 1: Record pre-change structural checks**

Run:
```bash
jq -e '.mcpServers.linear == null' mcphub/.config/mcphub/servers.json
grep -n '"context_servers"' zed/.config/zed/settings.json
```
Expected: MCPHub has no Linear entry and Zed's existing context-server section is present.

- [ ] **Step 2: Add both native remote entries**

Add `linear: { url: "https://mcp.linear.app/mcp" }` to Zed's existing `context_servers` object. Add `"linear": {"type":"streamable-http","url":"https://mcp.linear.app/mcp"}` to MCPHub's `mcpServers`. Keep Zed's JSONC conventions and add no auth headers/secrets.

- [ ] **Step 3: Validate the JSON and JSONC structures**

Run:
```bash
jq -e '.mcpServers.linear.type == "streamable-http" and .mcpServers.linear.url == "https://mcp.linear.app/mcp" and (.mcpServers.linear | has("headers") | not)' mcphub/.config/mcphub/servers.json
grep -A3 -B1 '"linear"' zed/.config/zed/settings.json
```
Expected: MCPHub assertions pass; the Zed snippet shows one `linear` server with the correct `url`, no headers, and valid surrounding JSONC syntax. Review the complete diff to confirm no unrelated settings changed.

### Task 3: Document client coverage and setup

**Files:**
- Create: `docs/linear-mcp.md`

**Interfaces:**
- Consumes: Approved client inventory and security boundaries in the spec; the endpoint and config names produced by Tasks 1–2.
- Produces: A concise user-facing guide that identifies the tracked clients, local/manual clients, and unverified clients, with official setup references.

- [ ] **Step 1: Draft the coverage inventory**

Include Gemini CLI, Zed, and MCPHub as configured by this repository; OpenCode, Codex, and VS Code as MCP-capable with protected tracked configs; Claude Code and Cursor as supported clients with local setup; Windsurf and Jules as Linear-documented clients; and Antigravity/other candidates only with verified support or explicitly labeled unverified. Preserve the Claude settings and secret-guard boundaries.

- [ ] **Step 2: Add setup and security guidance**

Document the default read-write endpoint `https://mcp.linear.app/mcp`, optional readonly endpoint `https://mcp.linear.app/mcp/readonly`, OAuth/login completion, and links to Linear's official MCP page and each relevant client's official setup documentation. Include exact `claude mcp add --transport http linear-server https://mcp.linear.app/mcp` command. Explain that protected tracked configs must remain unchanged pending secret-guard review and Jules API-key setup must keep the key out of dotfiles. Do not imply that configuration alone authenticates a client.

- [ ] **Step 3: Review documentation against the inventory and spec**

Run: `git diff --check`
Expected: no whitespace errors. Manually verify every client row distinguishes repo-tracked status from support, and no undocumented client capability or credential handling is asserted.

### Task 4: Full change validation and safety review

**Files:**
- Review: all files above.

**Interfaces:**
- Consumes: Completed Tasks 1–3.
- Produces: A verified, narrowly scoped change ready for user review; no generated auth state, installer execution, or unrelated config changes.

- [ ] **Step 1: Run focused repository validation**

Run:
```bash
bash scripts/test/verify_settings.sh
jq . gemini-cli/.gemini/settings.json >/dev/null
jq . mcphub/.config/mcphub/servers.json >/dev/null
git diff --check
```
Expected: all commands exit 0. For Zed's JSONC, validate the edited block with a JSONC-aware parser if available; otherwise perform the targeted structural check from Task 2 and inspect the diff.

- [ ] **Step 2: Inspect scope and secrets**

Run: `git status --short && git diff -- gemini-cli/.gemini/settings.json scripts/test/verify_settings.sh zed/.config/zed/settings.json mcphub/.config/mcphub/servers.json docs/linear-mcp.md`
Expected: only intended config, test, guide, plan, and spec changes appear; protected OpenCode/Codex/VS Code configs and the existing Claude modification remain untouched. Confirm no auth values or cached tokens are present.

## Self-Review

- **Spec coverage:** Tasks 1–2 add the three selected integrations and validate endpoint schemas; Task 3 covers client inventory, local/manual instructions, OAuth, read-write disclosure and readonly alternative; Task 4 checks safety, scope, and no-auth claims. No protected configs or Claude file are edited, and no installer is run.
- **Step scan:** Each task has a test/check before and after implementation; no product-code tests are needed because deliverables are configuration and documentation.
- **Type/config consistency:** Gemini `httpUrl`, Zed `context_servers.linear.url`, and MCPHub `mcpServers.linear.type/url` match the verified client schemas.
- **Review focus:** All five listed risks have a focused assertion, documented explicit constraint, or final safety review.
- **Proportion:** Four tasks cover three config files, one existing validator, one guide, and final verification; the plan avoids introducing generic config tooling.
