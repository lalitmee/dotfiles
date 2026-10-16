import type { McpFetch } from "../auth-provider.ts";
import { type AuthorizationServerMetadata, type OAuthChallenge, type OAuthProtectedResourceMetadata, type OAuthServerInfo } from "./types.ts";
export declare function parseWwwAuthenticate(header: string | null): OAuthChallenge;
export declare function discoverProtectedResourceMetadata(serverUrl: string | URL, options?: {
    resourceMetadataUrl?: string | URL;
    protocolVersion?: string;
    fetch?: McpFetch;
    signal?: AbortSignal;
}): Promise<OAuthProtectedResourceMetadata>;
export declare function buildAuthorizationServerDiscoveryUrls(authorizationServerUrl: string | URL): {
    url: URL;
    type: "oauth" | "oidc";
}[];
export declare function discoverAuthorizationServerMetadata(authorizationServerUrl: string | URL, options?: {
    fetch?: McpFetch;
    protocolVersion?: string;
    skipIssuerValidation?: boolean;
    signal?: AbortSignal;
}): Promise<AuthorizationServerMetadata | undefined>;
export declare function discoverOAuthServerInfo(serverUrl: string | URL, options?: {
    resourceMetadataUrl?: URL;
    /** Metadata document to use instead of discovery. It is trusted as configured, so its issuer is not checked. */
    authorizationServerMetadataUrl?: URL;
    fetch?: McpFetch;
    skipIssuerValidation?: boolean;
    signal?: AbortSignal;
}): Promise<OAuthServerInfo>;
export declare function resourceUrlFromServerUrl(value: string | URL): URL;
export declare function selectResource(serverUrl: string | URL, metadata?: OAuthProtectedResourceMetadata): string | undefined;
//# sourceMappingURL=discovery.d.ts.map