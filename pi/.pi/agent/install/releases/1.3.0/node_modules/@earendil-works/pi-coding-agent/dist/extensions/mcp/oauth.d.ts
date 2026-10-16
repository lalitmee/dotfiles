/**
 * OAuth sign-in for remote MCP servers.
 *
 * Connections never start a browser flow on their own. They send the stored access token and, after
 * a 401, try the stored refresh token. When that is not possible they fail with
 * `McpOAuthAuthorizationRequiredError`, and the user signs in through `/mcp`, which runs
 * the authorization code flow (PKCE, a Client ID Metadata Document or dynamic client registration)
 * against a loopback callback.
 *
 * Credentials live in `<agent-dir>/mcp-auth.json`, keyed by server name and URL.
 */
import type { AuthProvider } from "@earendil-works/pi-mcp";
import { type McpOAuthState, type McpOAuthStateStore, type OAuthChallenge } from "@earendil-works/pi-mcp/oauth";
import { type AuthStorageBackend } from "../../core/auth-storage.ts";
export interface McpOAuthSettings {
    clientId?: string;
    /** Already resolved. */
    clientSecret?: string;
    callbackPort?: number;
    /** Loopback redirect URI; see `McpOAuthConfig.callbackUrl`. */
    callbackUrl?: string;
    /** Scopes to request, separated by spaces. */
    scope?: string;
    /** `client_name` for dynamic client registration. Default: `APP_NAME`. */
    clientName?: string;
    /** See `McpOAuthConfig.clientRegistration`. */
    clientRegistration?: "dcr" | "cimd";
    /** See `McpOAuthConfig.authServerMetadataUrl`. */
    authServerMetadataUrl?: URL;
}
export interface McpOAuthServerStore extends McpOAuthStateStore {
    /** Run `fn` while no other process refreshes the server's tokens. */
    withRefreshLock<T>(fn: () => Promise<T>): Promise<T>;
}
/** Per-server OAuth state (client registration, tokens, pending PKCE verifier) in `mcp-auth.json`. */
export declare class McpOAuthCredentialStore {
    private readonly backend;
    /** Directory for the refresh lock files. Without one, refreshes are only serialized in this process. */
    private readonly lockDir;
    constructor(backend?: AuthStorageBackend, lockDir?: string);
    forServer(name: string, serverUrl: string): McpOAuthServerStore;
    /**
     * A lock file per server. When the process exits, proper-lockfile removes the locks it holds; when
     * it is killed, the lock goes stale because it is no longer renewed, and the next process takes it over.
     */
    private withRefreshLock;
    /** The stored tokens of a server, for noticing sign-ins done by another process. Does not take over legacy state. */
    tokens(name: string, serverUrl: string): McpOAuthState["tokens"];
    /** Returns whether credentials were stored for the server. Removes legacy state the server would take over. */
    remove(name: string, serverUrl: string): boolean;
    private write;
}
export interface McpAuthProvider extends AuthProvider {
    /** Resolves when no refresh is running, so shutdown does not drop rotated tokens before they are saved. */
    settled(): Promise<void>;
}
/**
 * Auth provider for MCP connections: sends the stored access token and refreshes it when it is about
 * to expire or after a 401. Throws `McpOAuthAuthorizationRequiredError` when the user has to sign in,
 * including when the server asks for more scope (`insufficient_scope`). `onChallenge` receives the
 * server's `WWW-Authenticate` challenge so sign-in can use its resource metadata URL and scope.
 * `settings` is only called when a refresh is needed, so a secret that fails to resolve fails the
 * refresh instead of the whole connection setup.
 *
 * Many servers rotate refresh tokens, so two refreshes with the same refresh token lose the grant.
 * Requests in this process share one refresh, and other processes are kept out by the store's
 * refresh lock, held from reading the tokens to saving new ones. Tokens that changed meanwhile
 * (another process refreshed them, or the user signed in) are used without refreshing.
 */
export declare function createMcpAuthProvider(options: {
    serverUrl: string;
    store: McpOAuthServerStore;
    settings: () => McpOAuthSettings;
    onChallenge: (challenge: OAuthChallenge) => void;
}): McpAuthProvider;
export interface McpSignInPrompt {
    /** Show the authorization URL to the user and open it in a browser. */
    showAuthorizationUrl(url: URL): void;
    /**
     * Ask for the redirect URL from the browser address bar, for when the browser cannot reach the
     * loopback callback (for example over SSH). Aborted once the callback arrives or the sign-in is
     * cancelled. Resolves to `undefined` or an empty string when the user cancels.
     */
    promptForRedirectUrl(signal: AbortSignal): Promise<string | undefined>;
}
export declare class McpSignInCancelledError extends Error {
    constructor();
}
/**
 * Sign in to an MCP server. Uses the stored refresh token when possible; otherwise runs the browser
 * authorization code flow. Tokens are saved to `store`. Aborting `signal` stops the sign-in at any
 * step with `McpSignInCancelledError`; requests to the authorization server are also time-limited.
 */
export declare function signInMcpServer(options: {
    serverUrl: string;
    store: McpOAuthStateStore;
    settings: McpOAuthSettings;
    challenge?: OAuthChallenge;
    prompt: McpSignInPrompt;
    signal?: AbortSignal;
}): Promise<void>;
//# sourceMappingURL=oauth.d.ts.map