import type { OAuthClientMetadataDocument, OAuthClientProvider } from "./flow.ts";
import type { AuthorizationServerMetadata, OAuthClientInformationMixed, OAuthClientMetadata, OAuthDiscoveryState, OAuthTokens } from "./types.ts";
export interface McpOAuthState {
    serverUrl: string;
    clientInformation?: OAuthClientInformationMixed;
    tokens?: OAuthTokens;
    /** When the access token expires, in milliseconds since the epoch, from `expires_in` at the time it was saved. */
    tokensExpireAt?: number;
    codeVerifier?: string;
    oauthState?: string;
    discovery?: OAuthDiscoveryState;
}
export interface McpOAuthStateStore {
    load(): McpOAuthState | undefined | Promise<McpOAuthState | undefined>;
    save(state: McpOAuthState): void | Promise<void>;
}
export interface McpOAuthProviderOptions {
    serverUrl: string | URL;
    redirectUrl: string | URL;
    clientMetadata: Omit<OAuthClientMetadata, "redirect_uris"> & {
        redirect_uris?: string[];
    };
    /** See `OAuthClientProvider.clientMetadataDocument`. */
    clientMetadataDocument?: (metadata: AuthorizationServerMetadata | undefined) => OAuthClientMetadataDocument | undefined;
    clientId?: string;
    clientSecret?: string;
    store?: McpOAuthStateStore;
    onRedirect(url: URL): void | Promise<void>;
}
export declare class MemoryOAuthStateStore implements McpOAuthStateStore {
    private value;
    load(): McpOAuthState | undefined;
    save(state: McpOAuthState): void;
}
/** Default stateful provider for one exact MCP server URL. Applications inject durable storage if needed. */
export declare class McpOAuthProvider implements OAuthClientProvider {
    readonly redirectUrl: string;
    readonly clientMetadata: OAuthClientMetadata;
    readonly clientMetadataDocument?: (metadata: AuthorizationServerMetadata | undefined) => OAuthClientMetadataDocument | undefined;
    private serverUrl;
    private configuredClient;
    private store;
    private onRedirect;
    private writes;
    constructor(options: McpOAuthProviderOptions);
    state(): Promise<string>;
    clientInformation(): Promise<OAuthClientInformationMixed | undefined>;
    saveClientInformation(information: OAuthClientInformationMixed): Promise<void>;
    tokens(): Promise<OAuthTokens | undefined>;
    saveTokens(tokens: OAuthTokens): Promise<void>;
    redirectToAuthorization(url: URL): Promise<void>;
    saveCodeVerifier(verifier: string): Promise<void>;
    codeVerifier(): Promise<string>;
    invalidateCredentials(kind: "all" | "client" | "tokens" | "verifier" | "discovery"): Promise<void>;
    saveDiscoveryState(discovery: OAuthDiscoveryState): Promise<void>;
    discoveryState(): Promise<OAuthDiscoveryState | undefined>;
    private load;
    private update;
    /** Stored state for another server URL is ignored so credentials never leak across servers. */
    private own;
}
//# sourceMappingURL=provider.d.ts.map