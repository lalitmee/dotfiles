import type { NullableHeaders } from "../headers.js";
import type { X509WorkloadIdentity } from "../../auth/types.js";
import type { ReadableStream } from "../shim-types.js";
import type { MergedRequestInit } from "../types.js";
/** Retries only known temporary failures when neither error layer reports a permanent code. */
export declare function isRetryableX509TransportFailure(failure: unknown): boolean;
export declare const x509TransportBrand: unique symbol;
/** Opaque identity of one frozen, caller-owned, explicitly attested X.509 transport. */
export interface X509Transport {
    /** Prevents ordinary objects from satisfying the transport capability contract. */
    readonly [x509TransportBrand]: true;
}
/** Immutable selectors and transport privately registered for an SDK-owned credential. */
export interface RegisteredX509Credential {
    readonly identity: X509WorkloadIdentity;
    readonly transport: X509Transport;
}
/** Validated short-lived token exchanged using a registered certificate identity. */
export interface X509ExchangedToken {
    /** Header-safe, in-memory OpenAI bearer credential. */
    accessToken: string;
    /** Issuer-approved positive token lifetime in seconds. */
    expiresIn: number;
}
/** One logical certificate-authenticated operation and its immutable starting deadline. */
export interface X509RequestScope {
    wallStartedAt: number;
    monotonicStartedAt: number;
    deadlineArmed?: boolean;
    preparationStartedAt?: number;
    preparationWallStartedAt?: number;
    request?: {
        signal: AbortSignal | null | undefined;
        timeout: number;
        fetchOptions: MergedRequestInit;
    };
    phase?: 'planning' | 'authorizing';
    effectiveSignal?: AbortSignal;
    materializedBody?: ReadableStream;
    owner?: object;
    requestOwner?: object;
    apiURL?: string;
    tenant?: {
        organization: string | null;
        project: string | null;
    };
    defaultHeaders?: NullableHeaders;
    requestHeaders?: NullableHeaders;
    token?: string;
    tokenGeneration?: number;
    headers?: Headers;
    authorization?: string | null;
}
/** Private, peer-independent operations attached to one approved transport generation. */
export interface RegisteredX509Transport {
    /** Dispatches one request through the exact frozen certificate capability. */
    dispatch: (target: URL, options: RequestInit) => Promise<Response>;
    /** Exchanges the same certificate identity for an OpenAI service-account bearer. */
    exchange: (identityProviderId: string, serviceAccountId: string, signal?: AbortSignal) => Promise<X509ExchangedToken>;
    /** Establishes one isolated Node async context without exposing Node dependencies to the root SDK. */
    run: <T>(operation: () => T) => T;
    /** Resolves only the current logical request's private certificate-authentication scope. */
    current: () => X509RequestScope | undefined;
    /** Re-enters the original request scope when response parsing resumes outside its promise chain. */
    resume: <T>(scope: X509RequestScope, operation: () => T) => T;
    /** Waits for retry backoff using an abortable timer that keeps an active request alive. */
    sleep: (duration: number, signal?: AbortSignal | null) => Promise<void>;
}
/** Resolves a previously registered opaque capability without importing an optional transport peer. */
export declare function resolveX509Transport(value: unknown): RegisteredX509Transport;
//# sourceMappingURL=x509-transport-registry.d.ts.map