# Linear MCP

This repository configures Linear's hosted MCP server for the clients whose MCP settings are tracked here. Other clients can connect locally without adding credentials or machine-specific configuration to this repository.

## Client coverage

| Client | Repository status | Setup |
| --- | --- | --- |
| Gemini CLI | Configured in `gemini-cli/.gemini/settings.json` (`mcpServers.linear.httpUrl`) | Restart Gemini CLI and complete its OAuth flow when prompted. |
| Zed | Configured in `zed/.config/zed/settings.json` (`context_servers.linear.url`) | Restart/reload MCP servers and authenticate when prompted. |
| MCPHub for Neovim | Configured in `mcphub/.config/mcphub/servers.json` (`type: "streamable-http"`) | Start the server and complete MCPHub's OAuth flow. |
| OpenCode | Configured in `opencode/.config/opencode/opencode.json` (`mcp.linear`) | Restart OpenCode and complete OAuth when prompted; if needed, run `opencode mcp auth linear`. |
| Codex CLI / IDE extension | Sanitized preference snapshot is tracked; live runtime config is local-only and not stowed | Configure MCP servers, project trust, and authentication in Codex's local settings; if needed, run `codex mcp login linear`. |
| VS Code | MCP-capable; `vscode/mcp.json` is tracked but intentionally excluded from this change | Add the server through VS Code's user MCP configuration command, not the tracked repository file. |
| Claude Code | Supported by Linear; local settings are not changed by this setup | Use the command below, or follow Linear's client-specific setup. |
| Cursor | Supported by Linear; no Cursor config is tracked here | Follow Linear's Cursor setup instructions. |
| Windsurf | Listed in Linear's setup guide; no Windsurf config is tracked here | Follow Linear's Windsurf setup instructions and the current Windsurf client documentation. |
| Jules | Listed in Linear's setup guide; no Jules config is tracked here | Follow Linear's Jules instructions. Keep any API key in Jules' credential flow, never in dotfiles. |
| Antigravity and other MCP clients | Not configured; support/configuration not verified here | Check the client's current MCP documentation and Linear's setup guide before adding it. |

“Configured” means the endpoint is present in a tracked settings file; it does **not** mean the client has completed authentication.

The repository keeps a sanitized Codex preference snapshot in `codex/.codex/config.toml`; it is not stowed into `~/.codex`. The writable `~/.codex/config.toml` remains a detached local file, so Codex's MCP servers, project trust, and other machine-specific changes do not flow back into dotfiles.

## Endpoint and authentication

- Default endpoint: `https://mcp.linear.app/mcp` (read-write).
- Optional read-only endpoint: `https://mcp.linear.app/mcp/readonly`.
- Linear uses OAuth for supported MCP clients. Start/reload the client and complete its browser-based authorization when requested. The authorization grants access under the Linear account and permissions you choose.
- Do not add access tokens, API keys, OAuth client secrets, or authorization headers to tracked dotfiles. Never commit local-only configuration or Jules API keys.

## Local setup examples

These examples are for clients that still need local setup. Do not add credentials to Git. Prefer user-level configuration for personal setups rather than workspace configuration.

### Claude Code

```sh
claude mcp add --transport http linear-server https://mcp.linear.app/mcp
```

### VS Code

Run **MCP: Open User Configuration** and add this entry inside the top-level `servers` object:

```json
"linear": {
  "type": "http",
  "url": "https://mcp.linear.app/mcp"
}
```

VS Code will prompt you to authorize the remote server when needed. Prefer user configuration over a workspace file if the setup is personal.

### Cursor, Windsurf, and Jules

Use the client-specific instructions maintained on [Linear's MCP setup page](https://linear.app/docs/mcp). Those instructions may change with client releases; do not copy credentials into this repository.

## Official references

- [Linear MCP setup and client instructions](https://linear.app/docs/mcp)
- [Gemini CLI MCP servers](https://geminicli.com/docs/tools/mcp-server/)
- [Zed MCP](https://zed.dev/docs/ai/mcp)
- [MCPHub server configuration](https://github.com/samanhappy/mcphub/blob/main/docs/configuration/mcp-settings.mdx) and [OAuth](https://github.com/samanhappy/mcphub/blob/main/docs/features/oauth.mdx)
- [OpenCode MCP servers](https://opencode.ai/docs/mcp-servers/)
- [Codex MCP servers](https://developers.openai.com/codex/mcp/)
- [VS Code MCP servers](https://code.visualstudio.com/docs/agent-customization/mcp-servers)
- [Claude Code MCP](https://code.claude.com/docs/en/mcp)
