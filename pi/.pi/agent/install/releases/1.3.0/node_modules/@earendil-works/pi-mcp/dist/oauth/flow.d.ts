import type { AuthProvider, McpFetch } from "../auth-provider.ts";
import { type AuthorizationServerMetadata, type OAuthClientInformationFull, type OAuthClientInformationMixed, type OAuthClientMetadata, type OAuthDiscoveryState, type OAuthTokens } from "./types.ts";
export type AddClientAuthentication = (headers: Headers, params: URLSearchParams, url: string | URL, metadata?: AuthorizationServerMetadata) => void | Promise<void>;
/** A Client ID Metadata Document: an https URL used as `client_id`, and a redirect URI it lists. */
export interface OAuthClientMetadataDocument {
    url: string;
    redirectUrl: string;
}
export interface OAuthClientProvider {
    readonly redirectUrl: string | URL;
    readonly clientMetadata: OAuthClientMetadata;
    /**
     * Client ID Metadata Document to identify as instead of registering dynamically, or `undefined` to
     * register. Called when no client information is stored; the document is not stored. `metadata` is
     * `undefined` when the authorization server has none; check `client_id_metadata_document_supported`.
     */
    clientMetadataDocument?(metadata: AuthorizationServerMetadata | undefined): OAuthClientMetadataDocument | undefined;
    state?(): string | Promise<string>;
    clientInformation(): OAuthClientInformationMixed | undefined | Promise<OAuthClientInformationMixed | undefined>;
    saveClientInformation?(information: OAuthClientInformationMixed): void | Promise<void>;
    tokens(): OAuthTokens | undefined | Promise<OAuthTokens | undefined>;
    saveTokens(tokens: OAuthTokens): void | Promise<void>;
    redirectToAuthorization(url: URL): void | Promise<void>;
    saveCodeVerifier(verifier: string): void | Promise<void>;
    codeVerifier(): string | Promise<string>;
    addClientAuthentication?: AddClientAuthentication;
    invalidateCredentials?(kind: "all" | "client" | "tokens" | "verifier" | "discovery"): void | Promise<void>;
    saveDiscoveryState?(state: OAuthDiscoveryState): void | Promise<void>;
    discoveryState?(): OAuthDiscoveryState | undefined | Promise<OAuthDiscoveryState | undefined>;
}
export interface OAuthFlowOptions {
    serverUrl: string | URL;
    authorizationCode?: string;
    /** `iss` parameter of the authorization response that delivered `authorizationCode` (RFC 9207). */
    iss?: string;
    scope?: string;
    resourceMetadataUrl?: URL;
    /**
     * Authorization server metadata document to use instead of discovery, for servers that advertise a
     * wrong authorization server or none. It is trusted as configured. Must use https, except on loopback.
     */
    authorizationServerMetadataUrl?: URL;
    fetch?: McpFetch;
    /** Aborts every request of the flow. Requests have no time limit of their own; combine with a timeout as needed. */
    signal?: AbortSignal;
    skipIssuerValidation?: boolean;
    /**
     * Go straight to the authorization redirect instead of refreshing stored tokens, for example when the
     * server asks for scopes the current grant lacks (a refresh keeps the old scope).
     */
    skipRefresh?: boolean;
}
export type OAuthFlowResult = "AUTHORIZED" | "REDIRECT";
export interface TokenRequestOptions {
    metadata?: AuthorizationServerMetadata;
    clientInformation: OAuthClientInformationMixed;
    resource?: string;
    addClientAuthentication?: AddClientAuthentication;
    fetch?: McpFetch;
    signal?: AbortSignal;
}
export declare function startAuthorization(authorizationServerUrl: string | URL, options: {
    metadata?: AuthorizationServerMetadata;
    clientInformation: OAuthClientInformationMixed;
    redirectUrl: string | URL;
    scope?: string;
    state?: string;
    resource?: string;
}): Promise<{
    authorizationUrl: URL;
    codeVerifier: string;
}>;
export declare function registerClient(authorizationServerUrl: string | URL, options: {
    metadata?: AuthorizationServerMetadata;
    clientMetadata: OAuthClientMetadata;
    scope?: string;
    fetch?: McpFetch;
    signal?: AbortSignal;
}): Promise<OAuthClientInformationFull>;
export declare function exchangeAuthorizationCode(authorizationServerUrl: string | URL, options: TokenRequestOptions & {
    code: string;
    codeVerifier: string;
    redirectUrl: string | URL;
}): Promise<OAuthTokens>;
export declare function refreshAuthorization(authorizationServerUrl: string | URL, options: TokenRequestOptions & {
    refreshToken: string;
}): Promise<OAuthTokens>;
/**
 * Scopes for a step-up authorization: the challenged scopes plus the ones granted so far, since a
 * challenge may list only the missing scopes and a token with just those would lose access the old
 * one had (SEP-2350). Without challenged scopes, `undefined` lets the flow pick its default.
 */
export declare function stepUpScope(granted: string | undefined, challenged: string | undefined): string | undefined;
export declare function authorizeMcp(provider: OAuthClientProvider, options: OAuthFlowOptions): Promise<OAuthFlowResult>;
/**
 * Auth provider for `StreamableHttpTransport`. After a 401 it refreshes the tokens, or throws
 * `McpOAuthAuthorizationRequiredError` when the user has to authorize (again). Concurrent 401s share
 * one refresh, and a request whose token was already replaced is just retried: with rotating refresh
 * tokens, a second refresh with the old refresh token would fail and discard the new grant.
 */
export declare function adaptOAuthProvider(provider: OAuthClientProvider): AuthProvider;
//# sourceMappingURL=flow.d.ts.map