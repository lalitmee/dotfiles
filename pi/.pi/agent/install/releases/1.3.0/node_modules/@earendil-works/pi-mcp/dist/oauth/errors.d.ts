export declare class OAuthError extends Error {
    readonly code: string;
    readonly errorUri: string | undefined;
    constructor(code: string, message: string, errorUri?: string);
}
export declare class OAuthIssuerMismatchError extends Error {
    /** `undefined` when no authorization server metadata was discovered. */
    readonly expected: string | undefined;
    /** `undefined` when an authorization response lacks the `iss` parameter its server promised (RFC 9207). */
    readonly received: string | undefined;
    constructor(expected: string | undefined, received: string | undefined);
}
export declare class OAuthInsecureEndpointError extends Error {
    readonly endpoint: string;
    constructor(endpoint: string);
}
export declare class OAuthRegistrationError extends Error {
    readonly status: number;
    readonly body: string;
    constructor(status: number, body: string);
}
export declare class McpOAuthAuthorizationRequiredError extends Error {
    constructor();
}
//# sourceMappingURL=errors.d.ts.map