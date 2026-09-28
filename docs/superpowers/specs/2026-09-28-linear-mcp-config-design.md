# Linear MCP Client Configuration — Design

**Date:** 2026-09-28
**Status:** Revised design pending written-spec review

## Goal

Make Linear MCP available in the MCP-capable editors and agent CLIs represented by this dotfiles setup, while documenting client coverage and preserving existing credential/history safeguards.

## User Intent and Success Criteria

- Inventory the relevant editor/CLI clients and identify which can use Linear MCP.
- Add Linear to the tracked MCP configurations selected by the user: Gemini CLI, Zed, MCPHub, OpenCode, and Codex.
- Provide accurate setup instructions for capable clients whose configurations are protected from this change, absent, or managed outside this repository.
- Use the official Linear MCP endpoint and OAuth flow; add only URL-based server entries, without credentials, bearer headers, or OAuth secrets.
- Preserve all unrelated settings in existing client configurations.

## Current State

### Existing MCP configuration

- `gemini-cli/.gemini/settings.json` and `gemini-cli/.gemini/mcp_config.json` are tracked and currently contain MCP server definitions.
- `zed/.config/zed/settings.json` is tracked and has a `context_servers` section.
- `mcphub/.config/mcphub/servers.json` is tracked and contains remote and local server definitions.
- `opencode/.config/opencode/opencode.json`, `codex/.codex/config.toml`, and `vscode/mcp.json` are tracked in the repository at the implementation base, despite the pending secret-guard design describing them as ignored/local-only copies. The user has explicitly approved adding only the Linear MCP URL entries to the OpenCode and Codex files; leave every unrelated setting untouched. VS Code remains outside the selected scope.
- `claude/.claude/settings.json` is tracked and currently has user changes. Claude Code's MCP registration is separate from this settings file; do not edit or overwrite it for this work.
- Cursor CLI config, Antigravity CLI settings, and other client packages exist, but this repository has no corresponding tracked generic MCP config for them. Windsurf and Jules are officially documented by Linear but are not represented by dedicated config packages here.

### Linear MCP

Linear documents Streamable HTTP at `https://mcp.linear.app/mcp`, authenticated through OAuth. It provides read-write access by default. Linear also provides `https://mcp.linear.app/mcp/readonly`. For clients that need stdio, Linear documents `npx -y mcp-remote https://mcp.linear.app/mcp` as a compatibility bridge. The SSE `/sse` endpoint is deprecated and is not the default.

Official setup documentation: <https://linear.app/docs/mcp>.

## Options Considered

### 1. Add URL-only entries to the selected tracked MCP configs (selected)

Add Linear to tracked Gemini CLI, Zed, MCPHub, OpenCode, and Codex configurations using each client's supported remote/custom-server schema. Provide setup and coverage notes for the remaining clients; do not modify VS Code or the locally changed Claude settings.

**Pros:** Delivers tracked, reproducible integrations while adding no credentials and preserving unrelated user settings. Clear documentation closes the gap for unmanaged clients.

**Cons:** VS Code and other unmanaged client integrations still require a one-time local command or manual configuration rather than being provisioned by Stow.

### 2. Change every remaining client config, including VS Code and Claude settings

Edit all available client configuration files, including VS Code and the modified Claude settings.

**Rejected:** It exceeds the user's selected scope and would modify VS Code and existing Claude user settings.

### 3. Document only

Create a client inventory and instructions without editing existing tracked MCP configs.

**Rejected:** It does not meet the request to add Linear MCP to the selected repository-managed clients.

## Selected Design

### Client scope

The implementation scope is tracked MCP configurations selected by the user: Gemini CLI, Zed, MCPHub, OpenCode, and Codex. Maintain a client inventory that also records other relevant clients and their setup state:

- OpenCode and Codex: add URL-only Linear entries to their existing tracked MCP maps. Preserve all other values and do not add tokens, Authorization headers, or OAuth credentials.
- VS Code: MCP-capable, but its tracked config remains unchanged in this scope; retain its local setup instructions.
- Claude Code: MCP-capable; document its `claude mcp add --transport http linear-server https://mcp.linear.app/mcp` command and OAuth completion. Do not alter the changed `claude/.claude/settings.json`.
- Cursor: Linear documents a native installation/deep link. Include the official setup path; do not create a Cursor MCP config without an existing repository pattern.
- Windsurf and Zed: Linear documents client-specific instructions. Zed is configured in the tracked `context_servers` section; Windsurf is not represented by a dedicated repo package, so document its official snippet rather than creating a new package.
- Jules: document the official API-key setup as a client-specific exception; do not place the key in dotfiles.
- Antigravity CLI, Crush, Copilot, Plandex, Kiro, Grok, or any other client: include only if its actual MCP support and a suitable configuration path can be verified during implementation; do not infer support solely from the presence of a directory or launch-menu entry.

The inventory is a repository-level coverage guide, not a claim that Linear supports only these clients or that every installed client is enabled.

### Transport and authentication

- Prefer Linear's native remote Streamable HTTP endpoint when supported by the tracked client's schema.
- Use the official `mcp-remote` stdio bridge only when the client does not support remote Streamable HTTP or its documented configuration requires stdio. Current Zed docs support native remote MCP with OAuth, so use that instead of the older Linear-specific stdio example.
- Do not use deprecated SSE by default.
- Use OAuth/device-browser flow wherever the client supports it. Do not store API keys, bearer tokens, OAuth secrets, or session data in tracked files.
- Configure the read-write endpoint by default, matching the approved request and Linear documentation. Clearly disclose this behavior and mention the `/readonly` endpoint as the least-privilege alternative.

### Files and boundaries

Expected tracked changes:

- `gemini-cli/.gemini/settings.json` (the Gemini CLI docs identify its `mcpServers` object as the server configuration source; do not duplicate this server in `mcp_config.json`, which is used for standard MCP client/remote-skill configuration).
- `zed/.config/zed/settings.json`.
- `mcphub/.config/mcphub/servers.json`.
- `opencode/.config/opencode/opencode.json`.
- `codex/.codex/config.toml`.
- `docs/linear-mcp.md`, updated to match the newly configured clients and remaining local setup paths.
- Tests or validation updates only if the existing checks can meaningfully validate the added schemas without introducing fragile client-version assumptions.

Do not modify `vscode/mcp.json` or `claude/.claude/settings.json`. In OpenCode and Codex, add only the Linear URL-based server entry; preserve unrelated settings and do not alter tracking status, ignore rules, or history. Do not run `./install.sh`; repo guidance prohibits doing so without explicit confirmation. Configs are stowed/live where already linked.

## Failure Behavior

- If a client schema does not support the documented remote transport, use a documented stdio bridge or leave a clear local setup instruction; do not silently invent fields.
- If OAuth cannot be initiated from a config, document the client-specific login command/action.
- If adding the URL-only entry would require changing unrelated auth contents or other existing settings, stop and report it rather than broadening the edit.

## Validation

- Validate edited JSON files with a JSON parser; validate Zed JSONC with an appropriate parser or targeted structural checks; parse Codex TOML with a TOML parser.
- Run the repository's relevant settings validation (`scripts/test/verify_settings.sh`) and any focused MCP config checks it supports.
- Review `git diff` to confirm only intended config/docs changes and that VS Code and the pre-existing Claude edit remain unchanged.
- Confirm no secrets, bearer headers, or auth caches were added.
- Do not run `./install.sh` without explicit user confirmation.
- Do not claim authenticated connectivity without completing OAuth in the user's client; this implementation configures discoverability and records the required login step.

## Out of Scope

- Editing VS Code or Claude settings, altering tracking status, changing `.gitignore`, or performing history scans/rewrites. These remain outside this scope.
- Adding MCP configurations for clients with no existing repo configuration unless the client is verified and a safe, maintainable package path is established.
- Authenticating to the user's Linear workspace, creating Linear data, or storing credentials.
- Switching to read-only access by default; users may choose the documented readonly endpoint separately.

## Resolved Implementation Details

- Gemini CLI supports remote Streamable HTTP using `httpUrl` and dynamic OAuth discovery; place the endpoint in `settings.json` and leave existing `mcp_config.json` untouched.
- Current Zed documentation supports a remote `context_servers` entry with a `url` and standard MCP OAuth, so use native HTTP rather than the stdio bridge example on Linear's page.
- MCPHub supports `type: "streamable-http"` with a URL and automatic OAuth discovery; do not put OAuth credentials in the tracked config.
- OpenCode remote MCP uses `mcp.linear` with `type: "remote"`, `url: "https://mcp.linear.app/mcp"`, and `enabled: true`; OAuth is handled by the client.
- Codex remote MCP uses `[mcp_servers.linear]` with `url = "https://mcp.linear.app/mcp"`; OAuth is handled by the client. Neither config requires a credential field for this endpoint.
