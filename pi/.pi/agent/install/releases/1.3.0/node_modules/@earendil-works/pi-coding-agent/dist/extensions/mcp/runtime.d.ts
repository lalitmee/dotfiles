/**
 * The part of the MCP integration that talks to servers: connections, transports, and OAuth
 * sign-in. It pulls in the MCP client, so index.ts loads it through runtime.lazy.ts only when a
 * server is configured.
 */
import { type AuthProvider, type CallToolResult, type ListResourcesResult, type ListResourceTemplatesResult, McpClient, type McpRequestOptions, type Tool as McpTool, type McpTransport, type ReadResourceResult, type Resource, type ResourceTemplate } from "@earendil-works/pi-mcp";
import { type OAuthChallenge } from "@earendil-works/pi-mcp/oauth";
import type { McpServerEntry } from "./config.ts";
import type { McpServerLog } from "./log.ts";
import { type McpOAuthCredentialStore, type McpOAuthSettings } from "./oauth.ts";
import type { McpResourceServer } from "./resources.ts";
import type { McpToolCaller } from "./tools.ts";
export { McpServerLog } from "./log.ts";
export { McpOAuthCredentialStore, McpSignInCancelledError, signInMcpServer } from "./oauth.ts";
/**
 * `disconnected`: the connection dropped (for example the stdio server exited); the next call
 * reconnects.
 */
type ServerState = "connecting" | "connected" | "disconnected" | "needs-auth" | "failed" | "closed";
export type McpTransportFactory = (entry: McpServerEntry, cwd: string, authProvider: AuthProvider | undefined) => McpTransport;
export declare function createDefaultTransport(entry: McpServerEntry, cwd: string, authProvider: AuthProvider | undefined): McpTransport;
/** One configured server. Reconnects lazily when a call finds the connection gone. */
export declare class McpServerConnection implements McpToolCaller, McpResourceServer {
    readonly entry: McpServerEntry;
    state: ServerState;
    error: string | undefined;
    tools: McpTool[];
    /**
     * Whether the server offers resources, which the resource tools list and read on demand. They are
     * not listed at connect: listing every resource can take long (a large drive, say).
     */
    hasResources: boolean;
    /** Server instructions from `initialize`, describing its tools as a group. */
    instructions: string | undefined;
    /** Last OAuth challenge from the server; sign-in uses its resource metadata URL and scope. */
    challenge: OAuthChallenge | undefined;
    private client;
    private opening;
    /** Aborted by `close()`; cancels a connect in progress, including the wait between retries. */
    private readonly shutdown;
    /** Stderr of the last stdio server that failed to connect. */
    private stderrTail;
    private readonly cwd;
    private readonly createTransport;
    private readonly authProvider;
    private readonly onTools;
    private readonly onChange;
    private readonly log;
    constructor(options: {
        entry: McpServerEntry;
        cwd: string;
        createTransport: McpTransportFactory;
        credentials: McpOAuthCredentialStore;
        /** The current token of a pi provider, for servers with `auth.provider`. */
        providerToken?: (provider: string) => Promise<string | undefined>;
        onTools: (connection: McpServerConnection) => void;
        /** Called when `state`, `error`, or `tools` change. */
        onChange?: (connection: McpServerConnection) => void;
        /** Receives the server's log messages (`notifications/message`). */
        log?: McpServerLog;
    });
    get name(): string;
    private get closed();
    get timeoutMs(): number;
    /** Server URL when the server authenticates with OAuth. */
    get oauthUrl(): string | undefined;
    oauthSettings(): McpOAuthSettings;
    getClient(): Promise<McpClient>;
    callTool(name: string, args: Record<string, unknown>, options: McpRequestOptions): Promise<CallToolResult>;
    readResource(uri: string, options: McpRequestOptions): Promise<ReadResourceResult>;
    resourcesPage(cursor: string | undefined, options: McpRequestOptions): Promise<ListResourcesResult>;
    resourceTemplatesPage(cursor: string | undefined, options: McpRequestOptions): Promise<ListResourceTemplatesResult>;
    allResources(options: McpRequestOptions): Promise<Resource[]>;
    allResourceTemplates(options: McpRequestOptions): Promise<ResourceTemplate[]>;
    /**
     * Run a request, reconnecting when needed. `readOnly` requests are retried once after a transient
     * HTTP error; tool calls are not, since they may have run.
     */
    private withClient;
    /** Connect again with fresh credentials, for example after signing in. */
    reconnect(): Promise<void>;
    /** Disconnect after the stored credentials were removed. */
    signOut(): Promise<void>;
    /** OAuth servers that still reject the request after a refresh need the user to sign in again. */
    private needsSignIn;
    private markNeedsAuth;
    private changed;
    private dropClient;
    private open;
    private connectOnce;
    private connectFailed;
    /** The transport dropped. The next call reconnects; until then the status shows why. */
    private handleClientClose;
    private refreshTools;
    /** Resolves once no transport of this server is open, including one that was still connecting. */
    close(): Promise<void>;
}
//# sourceMappingURL=runtime.d.ts.map