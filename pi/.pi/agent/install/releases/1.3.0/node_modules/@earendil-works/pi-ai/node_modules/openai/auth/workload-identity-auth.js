"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.WorkloadIdentityAuth = void 0;
const tslib_1 = require("../internal/tslib.js");
const Shims = tslib_1.__importStar(require("../internal/shims.js"));
const error_1 = require("../core/error.js");
const SUBJECT_TOKEN_TYPES = {
    jwt: 'urn:ietf:params:oauth:token-type:jwt',
    id: 'urn:ietf:params:oauth:token-type:id_token',
};
const TOKEN_EXCHANGE_GRANT_TYPE = 'urn:ietf:params:oauth:grant-type:token-exchange';
// Cap the refresh buffer at half the actual token lifetime, matching the X.509
// workload-identity path, so short-lived tokens keep a usable cache window.
const MAX_REFRESH_BUFFER_FRACTION = 0.5;
function calculateExpiresAt(expiresIn, exchangeStartedAt) {
    if (typeof expiresIn !== 'number' || !Number.isFinite(expiresIn) || expiresIn <= 0) {
        throw new error_1.OpenAIError("Token exchange response has invalid 'expires_in' field");
    }
    const now = Date.now();
    const fullLifetimeDeadline = now + expiresIn * 1000;
    if (!Number.isSafeInteger(fullLifetimeDeadline) || fullLifetimeDeadline <= now) {
        throw new error_1.OpenAIError("Token exchange response has invalid 'expires_in' field");
    }
    const expiresAt = fullLifetimeDeadline - (performance.now() - exchangeStartedAt);
    if (expiresAt <= now) {
        throw new error_1.OpenAIError('Workload identity token expired before its exchange completed.');
    }
    return expiresAt;
}
function calculateRefreshAt(expiresAt, lifetimeSeconds, refreshBufferSeconds) {
    const configuredBufferMs = (refreshBufferSeconds ?? 1200) * 1000;
    const effectiveBufferMs = Math.min(configuredBufferMs, lifetimeSeconds * 1000 * MAX_REFRESH_BUFFER_FRACTION);
    return expiresAt - effectiveBufferMs;
}
const NATIVE_RESPONSE_PROTOTYPE = Response.prototype;
const READ_NATIVE_RESPONSE_BODY = NATIVE_RESPONSE_PROTOTYPE.arrayBuffer;
// oxlint-disable-next-line anti-slop/no-object-parameters -- Custom fetch response prototypes are verified through descriptors before trusting their native contract.
function isResponsePrototype(response, prototype) {
    const constructor = Object.getOwnPropertyDescriptor(prototype, 'constructor')?.value;
    if (prototype === response ||
        typeof constructor !== 'function' ||
        Object.getOwnPropertyDescriptor(constructor, 'name')?.value !== 'Response' ||
        Object.getOwnPropertyDescriptor(constructor, 'prototype')?.value !== prototype) {
        return false;
    }
    const tag = Object.getOwnPropertyDescriptor(prototype, Symbol.toStringTag);
    return ((tag?.value === 'Response' || typeof tag?.get === 'function') &&
        typeof Object.getOwnPropertyDescriptor(prototype, 'headers')?.get === 'function' &&
        typeof Object.getOwnPropertyDescriptor(prototype, 'ok')?.get === 'function' &&
        typeof Object.getOwnPropertyDescriptor(prototype, 'status')?.get === 'function');
}
// oxlint-disable-next-line anti-slop/no-object-parameters -- The prototype walk compares untrusted cross-realm objects by identity and descriptor metadata.
function isResponseBodyPrototype(prototype, responsePrototype) {
    if (prototype === responsePrototype) {
        return true;
    }
    const constructor = Object.getOwnPropertyDescriptor(prototype, 'constructor')?.value;
    return (responsePrototype !== null &&
        Object.getPrototypeOf(responsePrototype) === prototype &&
        typeof constructor === 'function' &&
        Object.getOwnPropertyDescriptor(constructor, 'name')?.value === 'Body' &&
        Object.getOwnPropertyDescriptor(constructor, 'prototype')?.value === prototype);
}
function decodeNativeResponseBody(body) {
    // SAFETY: Bun is an optional runtime global; its version is checked before selecting Bun-specific decoding behavior.
    const scope = globalThis;
    return new TextDecoder('utf-8', { ignoreBOM: typeof scope.Bun?.version === 'string' }).decode(body);
}
// oxlint-disable-next-line anti-slop/no-unknown-returns -- Decoded token JSON remains untrusted until the caller validates its fields.
async function parseOAuthTokenResponse(response) {
    let readText;
    let responsePrototype = null;
    for (let depth = 0, prototype = response; prototype !== null && depth < 16; prototype = Object.getPrototypeOf(prototype), depth += 1) {
        if (prototype === NATIVE_RESPONSE_PROTOTYPE) {
            break;
        }
        if (isResponsePrototype(response, prototype)) {
            responsePrototype = prototype;
        }
        const parser = Object.getOwnPropertyDescriptor(prototype, 'json');
        if (!parser) {
            continue;
        }
        if (typeof parser.value !== 'function') {
            break;
        }
        const bodyReader = Object.getOwnPropertyDescriptor(prototype, 'text')?.value;
        if (typeof bodyReader === 'function' && isResponseBodyPrototype(prototype, responsePrototype)) {
            readText = bodyReader;
            break;
        }
        // Custom parsers own their results and failures; rejection provenance cannot be inferred.
        return parser.value.call(response);
    }
    const body = readText === undefined
        ? decodeNativeResponseBody(await READ_NATIVE_RESPONSE_BODY.call(response))
        : await readText.call(response);
    try {
        return JSON.parse(body);
    }
    catch {
        throw new SyntaxError('Token exchange response contains invalid JSON');
    }
}
function isUnsafeAccessToken(accessToken) {
    // SAFETY: Bun is an optional runtime global; its version is checked before selecting Bun-specific decoding behavior.
    const scope = globalThis;
    if (typeof scope.Bun?.version === 'string') {
        return /[^\t\u0020-\u007E]|^[\t ]|[\t ]$/u.test(accessToken);
    }
    return /[^\t\u0020-\u007E\u0080-\u00FF]|^[\t ]|[\t ]$/u.test(accessToken);
}
/**
 * Exchanges external workload-identity tokens for cached OpenAI access tokens.
 *
 * Concurrent token exchanges are shared. Valid cached tokens are returned while
 * a proactive refresh runs in the background; expired or missing tokens wait
 * for a successful exchange before they are returned.
 */
class WorkloadIdentityAuth {
    /**
     * Creates a workload-identity token cache and OAuth token-exchange client.
     *
     * @param config External identity provider, OpenAI service account, and refresh settings.
     * @param fetch Optional fetch implementation for calls to the OpenAI token endpoint.
     */
    constructor(config, fetch) {
        this.cachedToken = null;
        this.refreshPromise = null;
        this.tokenGeneration = 0;
        this.tokenExchangeUrl = 'https://auth.openai.com/oauth/token';
        const { identityProviderId, serviceAccountId, clientId, refreshBufferSeconds, provider } = config;
        this.config = {
            identityProviderId,
            serviceAccountId,
            // Spread creates an own data property without invoking inherited setters or changing the object prototype.
            ...(clientId === undefined ? {} : { clientId }),
            // Spread creates an own data property without invoking inherited setters or changing the object prototype.
            ...(refreshBufferSeconds === undefined ? {} : { refreshBufferSeconds }),
            provider: {
                tokenType: provider.tokenType,
                getToken: provider.getToken.bind(provider),
            },
        };
        this.fetch = fetch ?? Shims.getDefaultFetch();
    }
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
    async getToken() {
        if (!this.cachedToken || WorkloadIdentityAuth.isTokenExpired(this.cachedToken)) {
            if (this.refreshPromise) {
                return await this.refreshPromise;
            }
            const refreshPromise = this.refreshToken(this.tokenGeneration);
            this.refreshPromise = refreshPromise;
            try {
                return await refreshPromise;
            }
            finally {
                if (this.refreshPromise === refreshPromise) {
                    this.refreshPromise = null;
                }
            }
        }
        if (WorkloadIdentityAuth.needsRefresh(this.cachedToken) && !this.refreshPromise) {
            const refreshPromise = this.refreshToken(this.tokenGeneration).finally(() => {
                if (this.refreshPromise === refreshPromise) {
                    this.refreshPromise = null;
                }
            });
            this.refreshPromise = refreshPromise;
            void refreshPromise.catch(() => null);
        }
        return this.cachedToken.token;
    }
    async refreshToken(generation) {
        const subjectToken = await this.config.provider.getToken();
        // oxlint-disable-next-line anti-slop/no-known-value-widening -- The token-exchange field dictionary gains an optional client_id after its required fields are initialized.
        const body = {
            grant_type: TOKEN_EXCHANGE_GRANT_TYPE,
            subject_token: subjectToken,
            subject_token_type: SUBJECT_TOKEN_TYPES[this.config.provider.tokenType],
            identity_provider_id: this.config.identityProviderId,
            service_account_id: this.config.serviceAccountId,
        };
        if (this.config.clientId) {
            body['client_id'] = this.config.clientId;
        }
        // Exclude provider acquisition and measure delivery time independently of wall-clock changes.
        const exchangeStartedAt = performance.now();
        const response = await this.fetch(this.tokenExchangeUrl, {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json',
            },
            body: JSON.stringify(body),
            redirect: 'manual',
        });
        if (!response.ok) {
            const errorText = await response.text();
            let body = undefined;
            try {
                body = JSON.parse(errorText);
            }
            catch {
                // Ignore non-JSON error bodies.
            }
            if (response.status === 400 || response.status === 401 || response.status === 403) {
                throw new error_1.OAuthError(response.status, body, response.headers);
            }
            throw error_1.APIError.generate(response.status, body, `Token exchange failed with status ${response.status}`, response.headers);
        }
        const tokenResponse = await parseOAuthTokenResponse(response);
        const accessToken = typeof tokenResponse === 'object' && tokenResponse !== null && 'access_token' in tokenResponse
            ? tokenResponse.access_token
            : undefined;
        if (typeof accessToken !== 'string' ||
            accessToken.trim().length === 0 ||
            isUnsafeAccessToken(accessToken)) {
            throw new error_1.OpenAIError("Token exchange response missing 'access_token' field");
        }
        // SAFETY: The token response was checked as an object with a valid access token; expires_in is still validated by calculateExpiresAt.
        const expiresIn = tokenResponse.expires_in ?? 3600;
        const expiresAt = calculateExpiresAt(expiresIn, exchangeStartedAt);
        if (this.tokenGeneration === generation) {
            this.cachedToken = {
                token: accessToken,
                expiresAt,
                refreshAt: calculateRefreshAt(expiresAt, expiresIn, this.config.refreshBufferSeconds),
            };
        }
        return accessToken;
    }
    static isTokenExpired(cachedToken) {
        return Date.now() >= cachedToken.expiresAt;
    }
    static needsRefresh(cachedToken) {
        return Date.now() >= cachedToken.refreshAt;
    }
    /** Discards the cached access token so the next request performs a fresh exchange. */
    invalidateToken() {
        this.tokenGeneration += 1;
        this.cachedToken = null;
        this.refreshPromise = null;
    }
}
exports.WorkloadIdentityAuth = WorkloadIdentityAuth;
//# sourceMappingURL=workload-identity-auth.js.map