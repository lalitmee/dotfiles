import type { WorkloadIdentity } from "./types.js";
import type { Fetch } from "../internal/builtin-types.js";
/**
 * Exchanges external workload-identity tokens for cached OpenAI access tokens.
 *
 * Concurrent token exchanges are shared. Valid cached tokens are returned while
 * a proactive refresh runs in the background; expired or missing tokens wait
 * for a successful exchange before they are returned.
 */
export declare class WorkloadIdentityAuth {
    private cachedToken;
    private refreshPromise;
    private tokenGeneration;
    private readonly config;
    private readonly tokenExchangeUrl;
    private readonly fetch;
    /**
     * Creates a workload-identity token cache and OAuth token-exchange client.
     *
     * @param config External identity provider, OpenAI service account, and refresh settings.
     * @param fetch Optional fetch implementation for calls to the OpenAI token endpoint.
     */
    constructor(config: WorkloadIdentity, fetch?: Fetch);
    /**
     * Returns a valid OpenAI access token, exchanging or refreshing credentials as needed.
     *
     * Cached tokens nearing expiration are returned immediately while a background
     * refresh runs. Concurrent callers share the same in-flight token exchange.
     *
     * @throws {OAuthError} When the token endpoint rejects the subject token or identity.
     * @throws {APIError} When another unsuccessful HTTP response prevents token exchange.
     * @throws {OpenAIError} When a successful exchange has an invalid access token or expiration.
     */
    getToken(): Promise<string>;
    private refreshToken;
    private static isTokenExpired;
    private static needsRefresh;
    /** Discards the cached access token so the next request performs a fresh exchange. */
    invalidateToken(): void;
}
//# sourceMappingURL=workload-identity-auth.d.ts.map