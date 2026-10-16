/**
 * MCP server configuration.
 *
 * Servers are read from `mcp.json` in the agent directory and, for trusted projects, from
 * `<project>/.pi/mcp.json`. Both use the `mcpServers` shape shared by other MCP clients, so
 * existing configurations can be copied over. Project entries replace global entries with the
 * same name.
 *
 * A project entry without `command`, `url`, or `type` overrides only `enabled`, `exposure`, and
 * `toolExposure` of the global server with the same name, for example to turn it off in one project:
 * `{ "mcpServers": { "internal-tools": { "enabled": false } } }`. The rest of the global entry is kept,
 * including credentials the project could not set itself.
 *
 * ```json
 * {
 *   "mcpServers": {
 *     "filesystem": { "command": "npx", "args": ["-y", "@modelcontextprotocol/server-filesystem", "."] },
 *     "docs": { "url": "https://example.com/mcp", "headers": { "Authorization": "Bearer ${DOCS_TOKEN}" } },
 *     "sentry": { "url": "https://mcp.sentry.dev/mcp" }
 *   }
 * }
 * ```
 *
 * HTTP servers without an `Authorization` header use OAuth when they answer 401 (sign in with `/mcp`).
 * `"auth": { "provider": "<provider>" }` sends the token of a `/login` provider instead. Project files
 * cannot use it, so a repository cannot pick where the credential goes.
 *
 * The top-level `autoEnableCodemode` (default true) activates the codemode tool when a server
 * with `codemode` exposure connects. A project value overrides the global one.
 */
import { type McpExposure, type McpServerConfig } from "../../core/mcp-servers.ts";
export type { McpExposure, McpHttpServerConfig, McpOAuthConfig, McpServerConfig, McpStdioServerConfig, } from "../../core/mcp-servers.ts";
export { getMcpToolExposure } from "../../core/mcp-servers.ts";
export interface McpServerEntry {
    name: string;
    config: McpServerConfig;
    /** Config file that defined the entry, or the path of the extension that registered it. */
    source: string;
    /**
     * The global or the project `mcp.json`, or `extension` for servers registered with
     * `pi.registerMcpServer()`. Changes to extension servers are not saved.
     */
    scope?: "global" | "project" | "extension";
    /** Project `mcp.json` with an override of this global server's `enabled`, `exposure`, or `toolExposure`. */
    override?: string;
}
export interface LoadedMcpConfig {
    servers: McpServerEntry[];
    /** Activate the codemode tool when `codemode` servers connect. Default: true. */
    autoEnableCodemode?: boolean;
    errors: string[];
    /** The project `mcp.json` when the project is trusted, where `/mcp` saves project overrides. */
    projectConfig?: string;
}
/**
 * Load global and (when trusted) project MCP configuration. Disabled servers are included with
 * `enabled: false`, so they can be enabled again.
 */
export declare function loadMcpConfig(options: {
    agentDir: string;
    cwd: string;
    projectTrusted: boolean;
}): LoadedMcpConfig;
/** Settings `/mcp` changes. `enabled: true` and `exposure: "codemode"` are the defaults and remove the key. */
export interface McpServerConfigPatch {
    enabled?: boolean;
    exposure?: McpExposure;
}
/**
 * Change one server's settings in the `mcp.json` that defines or overrides it. With `override`, a
 * missing entry is added as an override. Overrides keep default values, since they replace the global
 * server's. Other content is kept; the file is rewritten with its indentation.
 */
export declare function updateMcpServerConfig(path: string, name: string, patch: McpServerConfigPatch, options?: {
    override?: boolean;
}): void;
/**
 * Add a server to an `mcp.json`, creating the file when missing. An existing entry with the same
 * name is replaced. Returns true when an entry was replaced.
 */
export declare function addMcpServerConfig(path: string, name: string, config: McpServerConfig): boolean;
/** Remove a server from an `mcp.json`. Returns false when the file does not define it. */
export declare function removeMcpServerConfig(path: string, name: string): boolean;
//# sourceMappingURL=config.d.ts.map