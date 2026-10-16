import type { WorkloadIdentity, X509WorkloadIdentity } from "../../auth/types.js";
import type { Fetch } from "../builtin-types.js";
import type { HeadersLike, NullableHeaders } from "../headers.js";
import type { FinalRequestOptions } from "../request-options.js";
import type { MergedRequestInit } from "../types.js";
import type { X509Transport } from "./x509-transport-registry.js";
interface X509TokenRequestContext {
    apiURL: string;
    defaultHeaders: HeadersLike | undefined;
    requestHeaders: HeadersLike;
    signal: AbortSignal | null | undefined;
    organization: string | null;
    project: string | null;
    timeout: number;
    fetchOptions: MergedRequestInit;
}
/** Distinguishes true certificate identities from extensible legacy subject-token identities. */
export declare function isX509WorkloadIdentity(identity: WorkloadIdentity | X509WorkloadIdentity | undefined): identity is X509WorkloadIdentity;
/** Rejects unsupported WebSocket authentication before any connection or credential side effect. */
export declare function assertX509WebSocketSupported(client: unknown): void;
/** Prevents caller options from replacing the immutable transport selected at construction. */
export declare function assertX509FetchOptions(options: MergedRequestInit | RequestInit | undefined): void;
/** Rejects caller overrides while allowing the SDK-owned fields on the final RequestInit. */
export declare function assertX509RequestOptions(options: MergedRequestInit | RequestInit | undefined): void;
/** Validates and snapshots the exact caller options that will reach authenticated dispatch. */
export declare function snapshotX509RequestOptions(options: MergedRequestInit | undefined): MergedRequestInit;
/** Bridges certificate authentication into existing OpenAI auth and fetch hooks without optional peers. */
export declare class X509WorkloadIdentityAuth {
    #private;
    /** Captures one registered, immutable certificate identity and its enrolled selectors. */
    constructor(identity: X509WorkloadIdentity, transport: X509Transport | undefined, organization: string | null, project: string | null);
    /** Reconstructs the immutable selectors captured before caller-owned identity mutation. */
    identitySnapshot(): X509WorkloadIdentity;
    /** Preserves explicitly headerless requests without presenting a certificate to the issuer. */
    static shouldAuthenticate(options: FinalRequestOptions, defaultHeaders: HeadersLike | undefined, requestHeaders?: HeadersLike): boolean;
    /** Snapshots each caller-owned header layer once while preserving nulls and precedence. */
    snapshotHeaders(defaultHeaders: HeadersLike, requestHeaders: HeadersLike): {
        defaultHeaders: NullableHeaders;
        requestHeaders: NullableHeaders;
    };
    /** Returns the already rendered caller headers without touching mutable inputs again. */
    headerSnapshots(): {
        defaultHeaders: NullableHeaders;
        requestHeaders: NullableHeaders;
    };
    /** Captures enrolled public tenant selectors once before certificate presentation. */
    snapshotTenant(organization: string | null, project: string | null): {
        organization: string | null;
        project: string | null;
    };
    /** Returns the tenant selectors already approved for this logical request. */
    tenantSnapshot(): {
        organization: string | null;
        project: string | null;
    };
    /** Validates and retains the exact destination that authenticated dispatch will use. */
    snapshotAPIURL(value: string): void;
    /** Reads the already-approved destination without rerendering caller-owned request options. */
    requestAPIURL(): string;
    /** Captures the exact caller settings approved for authenticated dispatch. */
    snapshotRequest(signal: AbortSignal | null | undefined, timeout: number, fetchOptions: MergedRequestInit): void;
    /** Returns immutable request settings without invoking caller-owned accessors again. */
    requestSnapshot(): {
        signal: AbortSignal | null | undefined;
        timeout: number;
        fetchOptions: MergedRequestInit;
    };
    /** Suspends an already-running network budget during retry-local asynchronous preparation. */
    beginRequestPreparation(): void;
    /** Begins local request construction without charging protected hook latency to the network. */
    beginRequestPlanning(): void;
    /** Arms one absolute network deadline only after all local request preparation completes. */
    beginRequestNetwork(): void;
    /** Keeps certificate authentication outside overridable request construction. */
    isPlanningRequest(): boolean;
    /** Approves the final overridden destination and transport before minting a bearer. */
    authorizePlannedRequest(url: string, request: RequestInit, timeout: number, allowHookSignal?: boolean): void;
    /** Owns only SDK-created iterator adapters until authenticated dispatch takes responsibility. */
    ownRequestBody(body: unknown, source: unknown): void;
    /** Recognizes every one-shot upload before issuer authentication or request replay. */
    static isStreamingRequestBody(body: unknown): boolean;
    /** Retires abandoned upload adapters without masking or blocking their authentication failure. */
    retireRequestBody(): void;
    /** Transfers the dispatched upload while retiring any SDK-owned body replaced by a hook. */
    releaseRequestBody(body: unknown): void;
    /** Retains caller-only cancellation separately from SDK-created deadline controllers. */
    setEffectiveSignal(signal: AbortSignal | undefined): void;
    /** Uses protected-hook cancellation when an authenticated attempt enters retry backoff. */
    effectiveSignal(): AbortSignal | null | undefined;
    /** Establishes an independent scope even when concurrent requests share caller options. */
    runRequest<T>(operation: () => Promise<T>, requestOwner: object): Promise<T>;
    /** Reports whether a public request-building call already belongs to an active logical operation. */
    inRequest(requestOwner: object): boolean;
    /** Shares a cache only when the complete, privately snapshotted credential identity matches. */
    matches(other: X509WorkloadIdentityAuth): boolean;
    /** Binds deferred response parsing to the original logical request and its unchanged deadline. */
    continuation(): <T>(operation: () => Promise<T>) => Promise<T>;
    /** Removes dispatched bearer material before settled request promises can retain their scope. */
    releaseRequestCredentials(): void;
    /** Returns the original authentication start so response consumption shares its request deadline. */
    requestStartedAt(_options: FinalRequestOptions): number | undefined;
    /** Distinguishes issued workload credentials from independent admin or headerless requests. */
    usedWorkloadToken(_options: FinalRequestOptions): boolean;
    /** Returns the budget left after certificate authentication without starting another timeout. */
    remainingTimeout(_options: FinalRequestOptions, timeout: number): number;
    /** Cancels active retry timers promptly without changing public caller-abort semantics. */
    waitForRetry(duration: number, signal?: AbortSignal | null): Promise<void>;
    /** Trusts only issuer or connection failures privately branded by the approved transport. */
    static isRetryableFailure(error: unknown): boolean;
    /** Reads safe retry hints only from a privately branded, sanitized issuer response. */
    static retryHeaders(error: unknown): Headers | undefined;
    /** Exchanges the exact certificate capability selected for the matching API dispatch. */
    getToken(options?: FinalRequestOptions, context?: X509TokenRequestContext): Promise<string>;
    /** Invalidates only the workload-token generation actually rejected by the current request. */
    invalidateToken(): void;
    /** Binds the minted credential to the original headers before protected request hooks run. */
    bindRequest(options: FinalRequestOptions, request: RequestInit, adminAPIKey: string | null): void;
    /** Rebinds an equivalent protected-hook container without relaxing final dispatch identity checks. */
    adoptRequestHeaders(request: RequestInit): void;
    /** Rejects request hooks that replace the selected bearer or its approved header identity. */
    assertRequest(request: RequestInit): void;
    /** Returns a guarded final dispatcher while preserving all existing request hook object identities. */
    fetch(): Fetch;
}
export {};
//# sourceMappingURL=x509-workload-identity-auth.d.ts.map