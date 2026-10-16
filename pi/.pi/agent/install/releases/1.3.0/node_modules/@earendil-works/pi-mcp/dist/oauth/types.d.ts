export interface OAuthProtectedResourceMetadata {
    resource: string;
    authorization_servers?: string[];
    scopes_supported?: string[];
    [key: string]: unknown;
}
export interface AuthorizationServerMetadata {
    issuer: string;
    authorization_endpoint: string;
    token_endpoint: string;
    registration_endpoint?: string;
    scopes_supported?: string[];
    response_types_supported: string[];
    grant_types_supported?: string[];
    token_endpoint_auth_methods_supported?: string[];
    code_challenge_methods_supported?: string[];
    client_id_metadata_document_supported?: boolean;
    /** Whether authorization responses carry an `iss` parameter (RFC 9207). */
    authorization_response_iss_parameter_supported?: boolean;
    [key: string]: unknown;
}
export interface OAuthTokens {
    access_token: string;
    token_type: string;
    expires_in?: number;
    scope?: string;
    refresh_token?: string;
    id_token?: string;
}
export interface OAuthClientMetadata {
    redirect_uris: string[];
    token_endpoint_auth_method?: string;
    grant_types?: string[];
    response_types?: string[];
    /**
     * OpenID Connect client type, `native` or `web`. Dynamic client registration derives it from
     * `redirect_uris` when absent (MCP SEP-837).
     */
    application_type?: string;
    client_name?: string;
    client_uri?: string;
    logo_uri?: string;
    scope?: string;
    contacts?: string[];
    tos_uri?: string;
    policy_uri?: string;
    jwks_uri?: string;
    jwks?: unknown;
    software_id?: string;
    software_version?: string;
    software_statement?: string;
}
export interface OAuthClientInformation {
    client_id: string;
    client_secret?: string;
    client_id_issued_at?: number;
    client_secret_expires_at?: number;
}
export type OAuthClientInformationFull = OAuthClientInformation & OAuthClientMetadata;
export type OAuthClientInformationMixed = OAuthClientInformation | OAuthClientInformationFull;
export interface OAuthDiscoveryState {
    authorizationServerUrl: string;
    authorizationServerMetadata?: AuthorizationServerMetadata;
    resourceMetadata?: OAuthProtectedResourceMetadata;
    resourceMetadataUrl?: string;
}
export interface OAuthServerInfo {
    authorizationServerUrl: string;
    authorizationServerMetadata?: AuthorizationServerMetadata;
    resourceMetadata?: OAuthProtectedResourceMetadata;
}
export interface OAuthChallenge {
    resourceMetadataUrl?: URL;
    scope?: string;
    error?: string;
    errorDescription?: string;
}
export declare function parseProtectedResourceMetadata(value: unknown): OAuthProtectedResourceMetadata;
export declare function parseAuthorizationServerMetadata(value: unknown): AuthorizationServerMetadata;
export declare function parseOAuthTokens(value: unknown): OAuthTokens;
export declare function parseClientInformation(value: unknown): OAuthClientInformationFull;
//# sourceMappingURL=types.d.ts.map