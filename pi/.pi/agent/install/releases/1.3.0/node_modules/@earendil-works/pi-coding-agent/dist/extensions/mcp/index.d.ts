/**
 * Built-in MCP integration.
 *
 * Connects the servers from `mcp.json` and the servers extensions register with
 * `pi.registerMcpServer()` when a session starts, and servers registered later right away. A server
 * in `mcp.json` takes precedence over a registered server of the same name. Connections run in the
 * background: the first prompt waits only for servers with `direct` tools, and codemode scripts,
 * `tool_search`, and the resource tools wait for the servers they need when they run. Tools are
 * registered as `mcp__<server>__<tool>`. By default (`"exposure": "codemode"`) the tools are only
 * callable from codemode scripts, which keeps MCP tools out of the model's tool declarations and
 * the codemode description: scripts find the tools with `searchTools()` and the server instructions
 * with `describeNamespace()`. The codemode tool is activated for that unless `autoEnableCodemode` is
 * false. `"deferred"` declares the tools to the model once the `tool_search` tool loads them, and
 * activates `tool_search` instead of codemode.
 * `"exposure": "direct"` declares them to the model right away, and `"hidden"` makes them
 * unreachable. `toolExposure` overrides the exposure of single tools. Servers with resources are
 * reached through Codex's `list_mcp_resources`, `list_mcp_resource_templates`, and
 * `read_mcp_resource` tools (resources.ts).
 *
 * Every call runs through pi's tool pipeline, so `tool_call`/`tool_result` hooks and permission
 * extensions apply to MCP tools the same way they do to built-in tools.
 *
 * Problems found at startup (config errors, failed connections, servers that need a sign-in) are
 * reported once. `/mcp` opens a manager to sign in, reconnect, enable or disable servers, and change
 * their exposure; the last two are saved to the `mcp.json` that defines the server, or apply to the
 * current session for registered servers.
 */
import type { ExtensionContext, ExtensionFactory } from "../../core/extensions/types.ts";
import { type LoadedMcpConfig, type McpServerConfigPatch, type McpServerEntry } from "./config.ts";
import type { McpOAuthCredentialStore } from "./oauth.ts";
import type { McpTransportFactory } from "./runtime.ts";
export type { McpTransportFactory } from "./runtime.ts";
export interface McpExtensionOptions {
    /** Defaults to reading `mcp.json` from the agent directory and the trusted project. */
    loadConfig?: (ctx: ExtensionContext) => LoadedMcpConfig;
    /** Defaults to stdio and streamable HTTP transports built from the server config. */
    createTransport?: McpTransportFactory;
    /** Defaults to `mcp-auth.json` in the agent directory. */
    credentials?: McpOAuthCredentialStore;
    /** File server log messages are appended to. Defaults to `mcp.log` in the agent directory. */
    logPath?: string;
    /** Opens the OAuth authorization URL. Defaults to the platform browser. */
    openUrl?: (url: string) => void;
    /**
     * Saves `/mcp` changes to the server's config file: its project `override` when set, else its
     * `source`. Defaults to editing that `mcp.json`.
     */
    updateConfig?: (entry: McpServerEntry, patch: McpServerConfigPatch) => void;
    /**
     * How long the first prompt waits for servers with `direct` tools that are still connecting at
     * startup, in milliseconds. Their tools become available when they connect. Other servers are
     * waited for when a script or search needs them. Default: 10000.
     */
    startupWaitMs?: number;
}
/** Name of the system prompt section that lists the servers whose tools are not declared. */
export declare const MCP_SERVERS_SECTION = "mcp_servers";
/**
 * Characters of the whole section. Descriptions shrink to fit; when the server lines alone do not
 * fit, the last servers are left out and counted in a closing line.
 */
export declare const MAX_SERVERS_SECTION_CHARS = 4096;
/** What the `mcp_servers` section needs of a server. */
export interface McpServerListing {
    entry: McpServerEntry;
    connection?: {
        instructions?: string;
    };
}
/**
 * The `mcp_servers` section: every enabled server with codemode or deferred tools, with how its
 * tools are reached and a one-line summary. The model learns of the servers from it, since neither
 * codemode nor tool_search lists them. Undefined when there are no such servers.
 */
export declare function renderServersSection(servers: readonly McpServerListing[]): string | undefined;
export declare function createMcpExtension(options?: McpExtensionOptions): ExtensionFactory;
declare const _default: ExtensionFactory;
export default _default;
//# sourceMappingURL=index.d.ts.map