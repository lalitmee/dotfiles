var _X509WorkloadIdentityAuth_instances, _a, _X509WorkloadIdentityAuth_identityProviderId, _X509WorkloadIdentityAuth_serviceAccountId, _X509WorkloadIdentityAuth_configuredRefreshBufferMs, _X509WorkloadIdentityAuth_configuredRefreshBufferSeconds, _X509WorkloadIdentityAuth_organization, _X509WorkloadIdentityAuth_project, _X509WorkloadIdentityAuth_transport, _X509WorkloadIdentityAuth_refreshBufferMs, _X509WorkloadIdentityAuth_cachedToken, _X509WorkloadIdentityAuth_refresh, _X509WorkloadIdentityAuth_tokenGeneration, _X509WorkloadIdentityAuth_cancelRequestBody, _X509WorkloadIdentityAuth_assignToken, _X509WorkloadIdentityAuth_recoverRefreshFailure, _X509WorkloadIdentityAuth_fallbackToken, _X509WorkloadIdentityAuth_retireRefresh, _X509WorkloadIdentityAuth_beginRefresh, _X509WorkloadIdentityAuth_refreshToken, _X509WorkloadIdentityAuth_preflight, _X509WorkloadIdentityAuth_scope, _X509WorkloadIdentityAuth_assertTenantHeaders;
import { __classPrivateFieldGet, __classPrivateFieldSet } from "../tslib.mjs";
import { APIConnectionTimeoutError, APIUserAbortError, OAuthError, OpenAIError } from "../../core/error.mjs";
import { buildHeaders } from "../headers.mjs";
import { CancelReadableStream } from "../shims.mjs";
import { isSensitiveHeader } from "../utils/log.mjs";
import { hasOwn } from "../utils/values.mjs";
import { assertX509APIOrigin } from "./x509-api-origin.mjs";
import { resolveX509Transport } from "./x509-transport-registry.mjs";
import { isApprovedX509Client, findX509OAuthError, isRetryableX509IssuerError, isTransientX509ConnectionError, } from './x509-transport-state.mjs';
const FORBIDDEN_TRANSPORT_OPTIONS = ['dispatcher', 'agent', 'client', 'tls', 'proxy'];
const headerValue = (headers, name) => Headers.prototype.get.call(headers, name);
const DEFAULT_REFRESH_BUFFER_MS = 20 * 60 * 1000;
const FAILED_REFRESH_COOLDOWN_MS = 1000;
const userAbortError = (signal) => {
    const error = new APIUserAbortError();
    Object.defineProperty(error, 'cause', { value: signal.reason, writable: true, configurable: true });
    return error;
};
function assertSafeHeaders(headers) {
    for (const name of Headers.prototype.keys.call(headers)) {
        const canonical = name.toLowerCase().split('_').join('-');
        if ((canonical !== 'authorization' && isSensitiveHeader(canonical)) || canonical === 'host') {
            throw new OpenAIError('X.509 workload identity cannot send conflicting authentication credentials.');
        }
    }
}
function exchangeDeadline(timeout, callerSignal) {
    const deadline = new AbortController();
    const timer = timeout === undefined
        ? undefined
        : setTimeout(() => deadline.abort(new APIConnectionTimeoutError()), timeout);
    const timerHandle = timer;
    if (typeof timerHandle === 'object' &&
        timerHandle !== null &&
        'unref' in timerHandle &&
        typeof timerHandle.unref === 'function') {
        timerHandle.unref();
    }
    const cancel = () => deadline.abort(callerSignal?.reason);
    callerSignal?.addEventListener('abort', cancel, { once: true });
    if (callerSignal?.aborted) {
        cancel();
    }
    return {
        signal: deadline.signal,
        dispose: () => {
            callerSignal?.removeEventListener('abort', cancel);
            if (timer) {
                clearTimeout(timer);
            }
        },
    };
}
function waitForRefresh(attempt, signal) {
    let abort;
    // AbortSignal remains callback-only on supported TypeScript/runtime combinations.
    // oxlint-disable-next-line promise/avoid-new -- A callback-only AbortSignal must race a shared refresh.
    const canceled = new Promise((_resolve, reject) => {
        abort = () => reject(signal.reason);
        signal.addEventListener('abort', abort, { once: true });
        if (signal.aborted) {
            abort();
        }
    });
    return {
        result: Promise.race([attempt.promise, canceled]),
        dispose: () => {
            if (abort) {
                signal.removeEventListener('abort', abort);
            }
        },
    };
}
/** Distinguishes true certificate identities from extensible legacy subject-token identities. */
export function isX509WorkloadIdentity(identity) {
    if (!identity || typeof identity !== 'object') {
        return false;
    }
    let providerOwner = identity;
    while (providerOwner !== null && providerOwner !== Object.prototype) {
        const provider = Object.getOwnPropertyDescriptor(providerOwner, 'provider');
        if (provider) {
            if (!('value' in provider) || provider.value !== undefined) {
                return false;
            }
            break;
        }
        // SAFETY: Object.getPrototypeOf returns an object or null; the traversal checks descriptors rather than assuming a credential-provider subtype.
        providerOwner = Object.getPrototypeOf(providerOwner);
    }
    let current = identity;
    while (current !== null && current !== Object.prototype) {
        const discriminator = Object.getOwnPropertyDescriptor(current, 'type');
        if (discriminator) {
            if (!('value' in discriminator)) {
                throw new OpenAIError('X.509 workload identity type must be a plain data property.');
            }
            return discriminator.value === 'x509';
        }
        // SAFETY: Object.getPrototypeOf returns an object or null; the traversal checks descriptors rather than assuming a credential-provider subtype.
        current = Object.getPrototypeOf(current);
    }
    return false;
}
/** Rejects unsupported WebSocket authentication before any connection or credential side effect. */
export function assertX509WebSocketSupported(client) {
    if (!client || typeof client !== 'object') {
        return;
    }
    if (isApprovedX509Client(client)) {
        throw new OpenAIError('X.509 workload identity does not support WebSocket connections.');
    }
}
/** Prevents caller options from replacing the immutable transport selected at construction. */
export function assertX509FetchOptions(options) {
    if (!options) {
        return;
    }
    for (const name of FORBIDDEN_TRANSPORT_OPTIONS) {
        if (hasOwn(options, name)) {
            throw new OpenAIError('X.509 workload identity cannot override its approved transport capability.');
        }
    }
    const redirect = Object.getOwnPropertyDescriptor(options, 'redirect')?.value;
    if (redirect !== undefined && redirect !== 'manual') {
        throw new OpenAIError('X.509 workload identity requests require manual redirects.');
    }
}
/** Rejects caller overrides while allowing the SDK-owned fields on the final RequestInit. */
export function assertX509RequestOptions(options) {
    assertX509FetchOptions(options);
    if (options && ['body', 'headers', 'method', 'signal'].some((name) => hasOwn(options, name))) {
        throw new OpenAIError('X.509 workload identity cannot override its request body, headers, method, or signal through fetch options.');
    }
}
/** Validates and snapshots the exact caller options that will reach authenticated dispatch. */
export function snapshotX509RequestOptions(options) {
    assertX509RequestOptions(options);
    const snapshot = { ...options };
    assertX509RequestOptions(snapshot);
    return snapshot;
}
/** Bridges certificate authentication into existing OpenAI auth and fetch hooks without optional peers. */
export class X509WorkloadIdentityAuth {
    /** Captures one registered, immutable certificate identity and its enrolled selectors. */
    constructor(identity, transport, organization, project) {
        _X509WorkloadIdentityAuth_instances.add(this);
        _X509WorkloadIdentityAuth_identityProviderId.set(this, void 0);
        _X509WorkloadIdentityAuth_serviceAccountId.set(this, void 0);
        _X509WorkloadIdentityAuth_configuredRefreshBufferMs.set(this, void 0);
        _X509WorkloadIdentityAuth_configuredRefreshBufferSeconds.set(this, void 0);
        _X509WorkloadIdentityAuth_organization.set(this, void 0);
        _X509WorkloadIdentityAuth_project.set(this, void 0);
        _X509WorkloadIdentityAuth_transport.set(this, void 0);
        _X509WorkloadIdentityAuth_refreshBufferMs.set(this, void 0);
        _X509WorkloadIdentityAuth_cachedToken.set(this, void 0);
        _X509WorkloadIdentityAuth_refresh.set(this, void 0);
        _X509WorkloadIdentityAuth_tokenGeneration.set(this, 0);
        __classPrivateFieldSet(this, _X509WorkloadIdentityAuth_transport, resolveX509Transport(transport), "f");
        __classPrivateFieldSet(this, _X509WorkloadIdentityAuth_identityProviderId, identity.identityProviderId, "f");
        __classPrivateFieldSet(this, _X509WorkloadIdentityAuth_serviceAccountId, identity.serviceAccountId, "f");
        __classPrivateFieldSet(this, _X509WorkloadIdentityAuth_configuredRefreshBufferMs, identity.refreshBufferMs, "f");
        __classPrivateFieldSet(this, _X509WorkloadIdentityAuth_configuredRefreshBufferSeconds, identity.refreshBufferSeconds, "f");
        __classPrivateFieldSet(this, _X509WorkloadIdentityAuth_organization, organization, "f");
        __classPrivateFieldSet(this, _X509WorkloadIdentityAuth_project, project, "f");
        if (__classPrivateFieldGet(this, _X509WorkloadIdentityAuth_configuredRefreshBufferMs, "f") !== undefined && __classPrivateFieldGet(this, _X509WorkloadIdentityAuth_configuredRefreshBufferSeconds, "f") !== undefined) {
            throw new OpenAIError('X.509 workload identity cannot combine refreshBufferSeconds and refreshBufferMs.');
        }
        if (__classPrivateFieldGet(this, _X509WorkloadIdentityAuth_configuredRefreshBufferMs, "f") !== undefined &&
            (!Number.isSafeInteger(__classPrivateFieldGet(this, _X509WorkloadIdentityAuth_configuredRefreshBufferMs, "f")) || __classPrivateFieldGet(this, _X509WorkloadIdentityAuth_configuredRefreshBufferMs, "f") < 0)) {
            throw new OpenAIError('X.509 workload identity requires a nonnegative integer refreshBufferMs.');
        }
        if (__classPrivateFieldGet(this, _X509WorkloadIdentityAuth_configuredRefreshBufferSeconds, "f") !== undefined &&
            (!Number.isSafeInteger(__classPrivateFieldGet(this, _X509WorkloadIdentityAuth_configuredRefreshBufferSeconds, "f")) ||
                __classPrivateFieldGet(this, _X509WorkloadIdentityAuth_configuredRefreshBufferSeconds, "f") < 0 ||
                !Number.isSafeInteger(__classPrivateFieldGet(this, _X509WorkloadIdentityAuth_configuredRefreshBufferSeconds, "f") * 1000))) {
            throw new OpenAIError('X.509 workload identity requires a nonnegative integer refreshBufferSeconds.');
        }
        __classPrivateFieldSet(this, _X509WorkloadIdentityAuth_refreshBufferMs, __classPrivateFieldGet(this, _X509WorkloadIdentityAuth_configuredRefreshBufferSeconds, "f") === undefined
            ? (__classPrivateFieldGet(this, _X509WorkloadIdentityAuth_configuredRefreshBufferMs, "f") ?? DEFAULT_REFRESH_BUFFER_MS)
            : __classPrivateFieldGet(this, _X509WorkloadIdentityAuth_configuredRefreshBufferSeconds, "f") * 1000, "f");
    }
    /** Reconstructs the immutable selectors captured before caller-owned identity mutation. */
    identitySnapshot() {
        return {
            type: 'x509',
            identityProviderId: __classPrivateFieldGet(this, _X509WorkloadIdentityAuth_identityProviderId, "f"),
            serviceAccountId: __classPrivateFieldGet(this, _X509WorkloadIdentityAuth_serviceAccountId, "f"),
            // Spread creates an own data property without invoking inherited setters or changing the object prototype.
            ...(__classPrivateFieldGet(this, _X509WorkloadIdentityAuth_configuredRefreshBufferMs, "f") === undefined
                ? {}
                : { refreshBufferMs: __classPrivateFieldGet(this, _X509WorkloadIdentityAuth_configuredRefreshBufferMs, "f") }),
            // Spread creates an own data property without invoking inherited setters or changing the object prototype.
            ...(__classPrivateFieldGet(this, _X509WorkloadIdentityAuth_configuredRefreshBufferSeconds, "f") === undefined
                ? {}
                : { refreshBufferSeconds: __classPrivateFieldGet(this, _X509WorkloadIdentityAuth_configuredRefreshBufferSeconds, "f") }),
        };
    }
    /** Preserves explicitly headerless requests without presenting a certificate to the issuer. */
    static shouldAuthenticate(options, defaultHeaders, requestHeaders = options.headers) {
        return !buildHeaders([defaultHeaders, requestHeaders]).nulls.has('authorization');
    }
    /** Snapshots each caller-owned header layer once while preserving nulls and precedence. */
    snapshotHeaders(defaultHeaders, requestHeaders) {
        const scope = __classPrivateFieldGet(this, _X509WorkloadIdentityAuth_instances, "m", _X509WorkloadIdentityAuth_scope).call(this);
        scope.defaultHeaders ?? (scope.defaultHeaders = buildHeaders([defaultHeaders]));
        scope.requestHeaders ?? (scope.requestHeaders = buildHeaders([requestHeaders]));
        return this.headerSnapshots();
    }
    /** Returns the already rendered caller headers without touching mutable inputs again. */
    headerSnapshots() {
        const { defaultHeaders, requestHeaders } = __classPrivateFieldGet(this, _X509WorkloadIdentityAuth_instances, "m", _X509WorkloadIdentityAuth_scope).call(this);
        if (!defaultHeaders || !requestHeaders) {
            throw new OpenAIError('X.509 workload identity requires snapshotted request headers.');
        }
        // oxlint-disable-next-line anti-slop/no-known-value-widening -- The exposed snapshot contract deliberately hides the private request-scope representation.
        return { defaultHeaders, requestHeaders };
    }
    /** Captures enrolled public tenant selectors once before certificate presentation. */
    snapshotTenant(organization, project) {
        if (organization !== __classPrivateFieldGet(this, _X509WorkloadIdentityAuth_organization, "f") || project !== __classPrivateFieldGet(this, _X509WorkloadIdentityAuth_project, "f")) {
            throw new OpenAIError('X.509 workload identity cannot override its enrolled organization or project.');
        }
        const scope = __classPrivateFieldGet(this, _X509WorkloadIdentityAuth_instances, "m", _X509WorkloadIdentityAuth_scope).call(this);
        scope.tenant = { organization, project };
        return scope.tenant;
    }
    /** Returns the tenant selectors already approved for this logical request. */
    tenantSnapshot() {
        const { tenant } = __classPrivateFieldGet(this, _X509WorkloadIdentityAuth_instances, "m", _X509WorkloadIdentityAuth_scope).call(this);
        if (!tenant) {
            throw new OpenAIError('X.509 workload identity requires snapshotted tenant selectors.');
        }
        return tenant;
    }
    /** Validates and retains the exact destination that authenticated dispatch will use. */
    snapshotAPIURL(value) {
        assertX509APIOrigin(value);
        __classPrivateFieldGet(this, _X509WorkloadIdentityAuth_instances, "m", _X509WorkloadIdentityAuth_scope).call(this).apiURL = value;
    }
    /** Reads the already-approved destination without rerendering caller-owned request options. */
    requestAPIURL() {
        const { apiURL } = __classPrivateFieldGet(this, _X509WorkloadIdentityAuth_instances, "m", _X509WorkloadIdentityAuth_scope).call(this);
        if (apiURL === undefined) {
            throw new OpenAIError('X.509 workload identity requires a snapshotted API destination.');
        }
        return apiURL;
    }
    /** Captures the exact caller settings approved for authenticated dispatch. */
    snapshotRequest(signal, timeout, fetchOptions) {
        var _b;
        (_b = __classPrivateFieldGet(this, _X509WorkloadIdentityAuth_instances, "m", _X509WorkloadIdentityAuth_scope).call(this)).request ?? (_b.request = { signal, timeout, fetchOptions });
    }
    /** Returns immutable request settings without invoking caller-owned accessors again. */
    requestSnapshot() {
        const { request } = __classPrivateFieldGet(this, _X509WorkloadIdentityAuth_instances, "m", _X509WorkloadIdentityAuth_scope).call(this);
        if (!request) {
            throw new OpenAIError('X.509 workload identity requires snapshotted request settings.');
        }
        return request;
    }
    /** Suspends an already-running network budget during retry-local asynchronous preparation. */
    beginRequestPreparation() {
        const scope = __classPrivateFieldGet(this, _X509WorkloadIdentityAuth_instances, "m", _X509WorkloadIdentityAuth_scope).call(this);
        if (scope.deadlineArmed && scope.preparationStartedAt === undefined) {
            scope.preparationStartedAt = performance.now();
            scope.preparationWallStartedAt = Date.now();
        }
    }
    /** Begins local request construction without charging protected hook latency to the network. */
    beginRequestPlanning() {
        __classPrivateFieldGet(this, _X509WorkloadIdentityAuth_instances, "m", _X509WorkloadIdentityAuth_scope).call(this).phase = 'planning';
    }
    /** Arms one absolute network deadline only after all local request preparation completes. */
    beginRequestNetwork() {
        const scope = __classPrivateFieldGet(this, _X509WorkloadIdentityAuth_instances, "m", _X509WorkloadIdentityAuth_scope).call(this);
        if (!scope.deadlineArmed) {
            scope.wallStartedAt = Date.now();
            scope.monotonicStartedAt = performance.now();
            scope.deadlineArmed = true;
        }
        else if (scope.preparationStartedAt !== undefined) {
            scope.monotonicStartedAt += performance.now() - scope.preparationStartedAt;
            scope.wallStartedAt += Date.now() - (scope.preparationWallStartedAt ?? Date.now());
            delete scope.preparationStartedAt;
            delete scope.preparationWallStartedAt;
        }
    }
    /** Keeps certificate authentication outside overridable request construction. */
    isPlanningRequest() {
        return __classPrivateFieldGet(this, _X509WorkloadIdentityAuth_instances, "m", _X509WorkloadIdentityAuth_scope).call(this).phase === 'planning';
    }
    /** Approves the final overridden destination and transport before minting a bearer. */
    authorizePlannedRequest(url, request, timeout, allowHookSignal = false) {
        const scope = __classPrivateFieldGet(this, _X509WorkloadIdentityAuth_instances, "m", _X509WorkloadIdentityAuth_scope).call(this);
        const headers = Object.getOwnPropertyDescriptor(request, 'headers');
        const body = Object.getOwnPropertyDescriptor(request, 'body');
        const signal = Object.getOwnPropertyDescriptor(request, 'signal');
        const redirect = Object.getOwnPropertyDescriptor(request, 'redirect');
        if (scope.phase !== 'planning' ||
            !headers ||
            !(headers.value instanceof Headers) ||
            (!body && 'body' in request) ||
            [body, signal, redirect].some((descriptor) => descriptor && !('value' in descriptor))) {
            throw new OpenAIError('X.509 workload identity requires an approved final request.');
        }
        this.snapshotAPIURL(url);
        assertX509FetchOptions(request);
        try {
            assertSafeHeaders(headers.value);
        }
        catch {
            throw new OpenAIError('X.509 workload identity cannot use caller-supplied authentication credentials.');
        }
        if (headerValue(headers.value, 'Authorization') !== null) {
            throw new OpenAIError('X.509 workload identity cannot use caller-supplied authorization credentials.');
        }
        __classPrivateFieldGet(this, _X509WorkloadIdentityAuth_instances, "m", _X509WorkloadIdentityAuth_assertTenantHeaders).call(this, headers.value);
        if (!allowHookSignal && (signal?.value ?? undefined) !== (this.requestSnapshot().signal ?? undefined)) {
            throw new OpenAIError('X.509 workload identity must preserve its approved request signal.');
        }
        const approved = this.requestSnapshot();
        scope.request = { ...approved, timeout: Math.min(approved.timeout, timeout) };
        scope.phase = 'authorizing';
    }
    /** Owns only SDK-created iterator adapters until authenticated dispatch takes responsibility. */
    ownRequestBody(body, source) {
        if (body instanceof ReadableStream && body !== source) {
            __classPrivateFieldGet(this, _X509WorkloadIdentityAuth_instances, "m", _X509WorkloadIdentityAuth_scope).call(this).materializedBody = body;
        }
    }
    /** Recognizes every one-shot upload before issuer authentication or request replay. */
    static isStreamingRequestBody(body) {
        return ((globalThis.ReadableStream !== undefined && body instanceof globalThis.ReadableStream) ||
            (typeof body === 'object' &&
                body !== null &&
                (Symbol.asyncIterator in body ||
                    (Symbol.iterator in body && 'next' in body && typeof body.next === 'function'))));
    }
    /** Retires abandoned upload adapters without masking or blocking their authentication failure. */
    retireRequestBody() {
        const scope = __classPrivateFieldGet(this, _X509WorkloadIdentityAuth_instances, "m", _X509WorkloadIdentityAuth_scope).call(this);
        const body = scope.materializedBody;
        delete scope.materializedBody;
        if (body) {
            void __classPrivateFieldGet(_a, _a, "m", _X509WorkloadIdentityAuth_cancelRequestBody).call(_a, body);
        }
    }
    /** Transfers the dispatched upload while retiring any SDK-owned body replaced by a hook. */
    releaseRequestBody(body) {
        const scope = __classPrivateFieldGet(this, _X509WorkloadIdentityAuth_instances, "m", _X509WorkloadIdentityAuth_scope).call(this);
        if (scope.materializedBody === body) {
            delete scope.materializedBody;
        }
        else {
            this.retireRequestBody();
        }
    }
    /** Retains caller-only cancellation separately from SDK-created deadline controllers. */
    setEffectiveSignal(signal) {
        if (signal) {
            __classPrivateFieldGet(this, _X509WorkloadIdentityAuth_instances, "m", _X509WorkloadIdentityAuth_scope).call(this).effectiveSignal = signal;
        }
        else {
            delete __classPrivateFieldGet(this, _X509WorkloadIdentityAuth_instances, "m", _X509WorkloadIdentityAuth_scope).call(this).effectiveSignal;
        }
    }
    /** Uses protected-hook cancellation when an authenticated attempt enters retry backoff. */
    effectiveSignal() {
        const scope = __classPrivateFieldGet(this, _X509WorkloadIdentityAuth_instances, "m", _X509WorkloadIdentityAuth_scope).call(this);
        return scope.effectiveSignal ?? scope.request?.signal;
    }
    /** Establishes an independent scope even when concurrent requests share caller options. */
    // oxlint-disable-next-line anti-slop/no-object-parameters -- Logical request owners are opaque identity tokens; their properties are never read.
    runRequest(operation, requestOwner) {
        return __classPrivateFieldGet(this, _X509WorkloadIdentityAuth_transport, "f").run(async () => {
            const scope = __classPrivateFieldGet(this, _X509WorkloadIdentityAuth_transport, "f").current();
            if (!scope) {
                throw new OpenAIError('X.509 workload identity requires an active certificate request scope.');
            }
            scope.owner = this;
            scope.requestOwner = requestOwner;
            try {
                return await operation();
            }
            finally {
                this.retireRequestBody();
                this.releaseRequestCredentials();
                delete scope.requestOwner;
                delete scope.owner;
            }
        });
    }
    /** Reports whether a public request-building call already belongs to an active logical operation. */
    // oxlint-disable-next-line anti-slop/no-object-parameters -- Request scope membership compares the opaque caller token by identity only.
    inRequest(requestOwner) {
        const scope = __classPrivateFieldGet(this, _X509WorkloadIdentityAuth_transport, "f").current();
        return scope?.owner === this && scope.requestOwner === requestOwner && scope.phase !== 'authorizing';
    }
    /** Shares a cache only when the complete, privately snapshotted credential identity matches. */
    matches(other) {
        return (__classPrivateFieldGet(this, _X509WorkloadIdentityAuth_transport, "f") === __classPrivateFieldGet(other, _X509WorkloadIdentityAuth_transport, "f") &&
            __classPrivateFieldGet(this, _X509WorkloadIdentityAuth_identityProviderId, "f") === __classPrivateFieldGet(other, _X509WorkloadIdentityAuth_identityProviderId, "f") &&
            __classPrivateFieldGet(this, _X509WorkloadIdentityAuth_serviceAccountId, "f") === __classPrivateFieldGet(other, _X509WorkloadIdentityAuth_serviceAccountId, "f") &&
            __classPrivateFieldGet(this, _X509WorkloadIdentityAuth_organization, "f") === __classPrivateFieldGet(other, _X509WorkloadIdentityAuth_organization, "f") &&
            __classPrivateFieldGet(this, _X509WorkloadIdentityAuth_project, "f") === __classPrivateFieldGet(other, _X509WorkloadIdentityAuth_project, "f") &&
            __classPrivateFieldGet(this, _X509WorkloadIdentityAuth_refreshBufferMs, "f") === __classPrivateFieldGet(other, _X509WorkloadIdentityAuth_refreshBufferMs, "f"));
    }
    /** Binds deferred response parsing to the original logical request and its unchanged deadline. */
    continuation() {
        const { wallStartedAt, monotonicStartedAt, deadlineArmed, request, requestOwner, effectiveSignal } = __classPrivateFieldGet(this, _X509WorkloadIdentityAuth_instances, "m", _X509WorkloadIdentityAuth_scope).call(this);
        const scope = {
            wallStartedAt,
            monotonicStartedAt,
            owner: this,
            // Spread creates an own data property without invoking inherited setters or changing the object prototype.
            ...(deadlineArmed ? { deadlineArmed } : {}),
            // Spread creates an own data property without invoking inherited setters or changing the object prototype.
            ...(request ? { request } : {}),
            // Spread creates an own data property without invoking inherited setters or changing the object prototype.
            ...(effectiveSignal ? { effectiveSignal } : {}),
            // Spread creates an own data property without invoking inherited setters or changing the object prototype.
            ...(requestOwner ? { requestOwner } : {}),
        };
        return (operation) => __classPrivateFieldGet(this, _X509WorkloadIdentityAuth_transport, "f").resume(scope, async () => {
            try {
                return await operation();
            }
            finally {
                this.releaseRequestCredentials();
                delete scope.requestOwner;
                delete scope.owner;
            }
        });
    }
    /** Removes dispatched bearer material before settled request promises can retain their scope. */
    releaseRequestCredentials() {
        const scope = __classPrivateFieldGet(this, _X509WorkloadIdentityAuth_instances, "m", _X509WorkloadIdentityAuth_scope).call(this);
        delete scope.request;
        delete scope.phase;
        delete scope.deadlineArmed;
        delete scope.preparationStartedAt;
        delete scope.preparationWallStartedAt;
        delete scope.effectiveSignal;
        delete scope.materializedBody;
        delete scope.apiURL;
        delete scope.tenant;
        delete scope.token;
        delete scope.defaultHeaders;
        delete scope.requestHeaders;
        delete scope.tokenGeneration;
        delete scope.headers;
        delete scope.authorization;
    }
    /** Returns the original authentication start so response consumption shares its request deadline. */
    requestStartedAt(_options) {
        return __classPrivateFieldGet(this, _X509WorkloadIdentityAuth_transport, "f").current()?.wallStartedAt;
    }
    /** Distinguishes issued workload credentials from independent admin or headerless requests. */
    usedWorkloadToken(_options) {
        return __classPrivateFieldGet(this, _X509WorkloadIdentityAuth_transport, "f").current()?.token !== undefined;
    }
    /** Returns the budget left after certificate authentication without starting another timeout. */
    remainingTimeout(_options, timeout) {
        const scope = __classPrivateFieldGet(this, _X509WorkloadIdentityAuth_transport, "f").current();
        if (scope === undefined) {
            return timeout;
        }
        const remaining = timeout - (performance.now() - scope.monotonicStartedAt);
        if (remaining <= 0) {
            throw new APIConnectionTimeoutError();
        }
        return remaining;
    }
    /** Cancels active retry timers promptly without changing public caller-abort semantics. */
    async waitForRetry(duration, signal) {
        try {
            await __classPrivateFieldGet(this, _X509WorkloadIdentityAuth_transport, "f").sleep(duration, signal);
        }
        catch (error) {
            if (signal?.aborted) {
                throw userAbortError(signal);
            }
            throw error;
        }
    }
    /** Trusts only issuer or connection failures privately branded by the approved transport. */
    static isRetryableFailure(error) {
        return (typeof error === 'object' &&
            error !== null &&
            (isTransientX509ConnectionError(error) || isRetryableX509IssuerError(error)));
    }
    /** Reads safe retry hints only from a privately branded, sanitized issuer response. */
    static retryHeaders(error) {
        if (!error || typeof error !== 'object' || !isRetryableX509IssuerError(error)) {
            return undefined;
        }
        const headers = Object.getOwnPropertyDescriptor(error, 'headers')?.value;
        return headers instanceof Headers ? headers : undefined;
    }
    /** Exchanges the exact certificate capability selected for the matching API dispatch. */
    async getToken(options, context) {
        const callerSignal = context ? context.signal : options?.signal;
        if (callerSignal?.aborted) {
            throw userAbortError(callerSignal);
        }
        if (options) {
            assertX509RequestOptions(context ? context.fetchOptions : options.fetchOptions);
        }
        __classPrivateFieldGet(this, _X509WorkloadIdentityAuth_instances, "m", _X509WorkloadIdentityAuth_preflight).call(this, context);
        const scope = options ? __classPrivateFieldGet(this, _X509WorkloadIdentityAuth_instances, "m", _X509WorkloadIdentityAuth_scope).call(this) : undefined;
        const cached = __classPrivateFieldGet(this, _X509WorkloadIdentityAuth_cachedToken, "f");
        if (cached && performance.now() < cached.refreshAt && Date.now() < cached.wallRefreshAt) {
            return __classPrivateFieldGet(_a, _a, "m", _X509WorkloadIdentityAuth_assignToken).call(_a, scope, cached);
        }
        const remaining = context && options ? this.remainingTimeout(options, context.timeout) : context?.timeout;
        const { signal, dispose } = exchangeDeadline(remaining, callerSignal);
        if (callerSignal?.aborted) {
            dispose();
            throw userAbortError(callerSignal);
        }
        const attempt = __classPrivateFieldGet(this, _X509WorkloadIdentityAuth_refresh, "f") ?? __classPrivateFieldGet(this, _X509WorkloadIdentityAuth_instances, "m", _X509WorkloadIdentityAuth_beginRefresh).call(this);
        attempt.waiters += 1;
        const waiter = waitForRefresh(attempt, signal);
        try {
            const exchanged = await waiter.result;
            const refreshed = __classPrivateFieldGet(this, _X509WorkloadIdentityAuth_cachedToken, "f");
            if (!refreshed || refreshed.accessToken !== exchanged.accessToken) {
                throw new APIUserAbortError();
            }
            return __classPrivateFieldGet(_a, _a, "m", _X509WorkloadIdentityAuth_assignToken).call(_a, scope, refreshed);
        }
        catch (error) {
            return await __classPrivateFieldGet(this, _X509WorkloadIdentityAuth_instances, "m", _X509WorkloadIdentityAuth_recoverRefreshFailure).call(this, error, attempt, cached, scope, options, context);
        }
        finally {
            waiter.dispose();
            dispose();
            attempt.waiters -= 1;
            __classPrivateFieldGet(this, _X509WorkloadIdentityAuth_instances, "m", _X509WorkloadIdentityAuth_retireRefresh).call(this, attempt);
        }
    }
    /** Invalidates only the workload-token generation actually rejected by the current request. */
    invalidateToken() {
        const rejected = __classPrivateFieldGet(this, _X509WorkloadIdentityAuth_transport, "f").current();
        if (!rejected?.token ||
            __classPrivateFieldGet(this, _X509WorkloadIdentityAuth_cachedToken, "f")?.accessToken !== rejected.token ||
            __classPrivateFieldGet(this, _X509WorkloadIdentityAuth_cachedToken, "f").generation !== rejected.tokenGeneration) {
            return;
        }
        __classPrivateFieldSet(this, _X509WorkloadIdentityAuth_tokenGeneration, __classPrivateFieldGet(this, _X509WorkloadIdentityAuth_tokenGeneration, "f") + 1, "f");
        __classPrivateFieldSet(this, _X509WorkloadIdentityAuth_cachedToken, undefined, "f");
        const refresh = __classPrivateFieldGet(this, _X509WorkloadIdentityAuth_refresh, "f");
        __classPrivateFieldSet(this, _X509WorkloadIdentityAuth_refresh, undefined, "f");
        refresh?.controller.abort(new APIUserAbortError());
    }
    /** Binds the minted credential to the original headers before protected request hooks run. */
    bindRequest(options, request, adminAPIKey) {
        if (!(request.headers instanceof Headers)) {
            throw new OpenAIError('X.509 workload identity requires the original workload authorization headers.');
        }
        const scope = __classPrivateFieldGet(this, _X509WorkloadIdentityAuth_instances, "m", _X509WorkloadIdentityAuth_scope).call(this);
        const { token } = scope;
        const security = options.__security ?? { bearerAuth: true };
        let approvedAuthorization = token ? `Bearer ${token}` : null;
        if (!token &&
            security.adminAPIKeyAuth &&
            adminAPIKey !== null &&
            headerValue(request.headers, 'Authorization') !== null) {
            approvedAuthorization = new Headers({ Authorization: `Bearer ${adminAPIKey}` }).get('Authorization');
        }
        scope.headers = request.headers;
        scope.authorization = approvedAuthorization;
        this.assertRequest(request);
    }
    /** Rebinds an equivalent protected-hook container without relaxing final dispatch identity checks. */
    adoptRequestHeaders(request) {
        const scope = __classPrivateFieldGet(this, _X509WorkloadIdentityAuth_instances, "m", _X509WorkloadIdentityAuth_scope).call(this);
        const original = scope.headers;
        if (!(original instanceof Headers) || !(request.headers instanceof Headers)) {
            throw new OpenAIError('X.509 workload identity must preserve its issued workload authorization.');
        }
        scope.headers = request.headers;
        try {
            this.assertRequest(request);
        }
        catch (error) {
            scope.headers = original;
            throw error;
        }
    }
    /** Rejects request hooks that replace the selected bearer or its approved header identity. */
    assertRequest(request) {
        const { headers } = request;
        if (!(headers instanceof Headers)) {
            throw new OpenAIError('X.509 workload identity must preserve its issued workload authorization.');
        }
        const scope = __classPrivateFieldGet(this, _X509WorkloadIdentityAuth_transport, "f").current();
        if (!scope ||
            scope.headers !== headers ||
            scope.authorization === undefined ||
            headerValue(headers, 'Authorization') !== scope.authorization) {
            throw new OpenAIError('X.509 workload identity must preserve its issued workload authorization.');
        }
        __classPrivateFieldGet(this, _X509WorkloadIdentityAuth_instances, "m", _X509WorkloadIdentityAuth_assertTenantHeaders).call(this, headers);
        assertSafeHeaders(headers);
    }
    /** Returns a guarded final dispatcher while preserving all existing request hook object identities. */
    fetch() {
        return async (input, init = {}) => {
            const target = assertX509APIOrigin(typeof input === 'string' || input instanceof URL ? input : input.url);
            assertX509FetchOptions(init);
            this.assertRequest(init);
            const approved = init.headers;
            if (!(approved instanceof Headers)) {
                throw new OpenAIError('X.509 workload identity must preserve its issued workload authorization.');
            }
            const headers = new Headers([...Headers.prototype.entries.call(approved)]);
            assertSafeHeaders(headers);
            init.headers = headers;
            init.redirect = 'manual';
            return await __classPrivateFieldGet(this, _X509WorkloadIdentityAuth_transport, "f").dispatch(target, init);
        };
    }
}
_a = X509WorkloadIdentityAuth, _X509WorkloadIdentityAuth_identityProviderId = new WeakMap(), _X509WorkloadIdentityAuth_serviceAccountId = new WeakMap(), _X509WorkloadIdentityAuth_configuredRefreshBufferMs = new WeakMap(), _X509WorkloadIdentityAuth_configuredRefreshBufferSeconds = new WeakMap(), _X509WorkloadIdentityAuth_organization = new WeakMap(), _X509WorkloadIdentityAuth_project = new WeakMap(), _X509WorkloadIdentityAuth_transport = new WeakMap(), _X509WorkloadIdentityAuth_refreshBufferMs = new WeakMap(), _X509WorkloadIdentityAuth_cachedToken = new WeakMap(), _X509WorkloadIdentityAuth_refresh = new WeakMap(), _X509WorkloadIdentityAuth_tokenGeneration = new WeakMap(), _X509WorkloadIdentityAuth_instances = new WeakSet(), _X509WorkloadIdentityAuth_cancelRequestBody = async function _X509WorkloadIdentityAuth_cancelRequestBody(body) {
    try {
        await CancelReadableStream(body);
    }
    catch {
        // Upload retirement must never replace the original authentication failure.
    }
}, _X509WorkloadIdentityAuth_assignToken = function _X509WorkloadIdentityAuth_assignToken(scope, token) {
    if (scope) {
        scope.token = token.accessToken;
        scope.tokenGeneration = token.generation;
    }
    return token.accessToken;
}, _X509WorkloadIdentityAuth_recoverRefreshFailure = async function _X509WorkloadIdentityAuth_recoverRefreshFailure(error, attempt, cached, scope, options, context) {
    const callerSignal = context ? context.signal : options?.signal;
    if (callerSignal?.aborted) {
        throw userAbortError(callerSignal);
    }
    if (attempt.controller.signal.aborted && attempt.generation !== __classPrivateFieldGet(this, _X509WorkloadIdentityAuth_tokenGeneration, "f")) {
        return await this.getToken(options, context);
    }
    const fallback = __classPrivateFieldGet(this, _X509WorkloadIdentityAuth_instances, "m", _X509WorkloadIdentityAuth_fallbackToken).call(this, error, cached, scope);
    if (fallback !== undefined) {
        return fallback;
    }
    if (error && typeof error === 'object' && !(error instanceof OAuthError)) {
        const oauth = findX509OAuthError(error);
        if (oauth) {
            throw new OAuthError(oauth.status, oauth.error, oauth.headers);
        }
    }
    throw error;
}, _X509WorkloadIdentityAuth_fallbackToken = function _X509WorkloadIdentityAuth_fallbackToken(error, cached, scope) {
    if (!cached ||
        cached !== __classPrivateFieldGet(this, _X509WorkloadIdentityAuth_cachedToken, "f") ||
        performance.now() >= cached.expiresAt ||
        Date.now() >= cached.wallExpiresAt ||
        !_a.isRetryableFailure(error)) {
        return undefined;
    }
    const headers = _a.retryHeaders(error);
    const milliseconds = headers?.get('retry-after-ms');
    let requested = milliseconds ? Number(milliseconds) : undefined;
    const retryAfter = headers?.get('retry-after');
    if (retryAfter && (requested === undefined || Number.isNaN(requested))) {
        const seconds = Number(retryAfter);
        requested = Number.isNaN(seconds) ? Date.parse(retryAfter) - Date.now() : seconds * 1000;
    }
    const cooldown = requested !== undefined && Number.isFinite(requested) && requested >= 0 && requested <= 60000
        ? Math.max(FAILED_REFRESH_COOLDOWN_MS, requested)
        : FAILED_REFRESH_COOLDOWN_MS;
    cached.refreshAt = Math.min(cached.expiresAt, performance.now() + cooldown);
    cached.wallRefreshAt = Math.min(cached.wallExpiresAt, Date.now() + cooldown);
    return __classPrivateFieldGet(_a, _a, "m", _X509WorkloadIdentityAuth_assignToken).call(_a, scope, cached);
}, _X509WorkloadIdentityAuth_retireRefresh = function _X509WorkloadIdentityAuth_retireRefresh(attempt) {
    if (attempt.waiters !== 0 || __classPrivateFieldGet(this, _X509WorkloadIdentityAuth_refresh, "f") !== attempt) {
        return;
    }
    queueMicrotask(() => {
        if (attempt.waiters === 0 && __classPrivateFieldGet(this, _X509WorkloadIdentityAuth_refresh, "f") === attempt) {
            __classPrivateFieldSet(this, _X509WorkloadIdentityAuth_refresh, undefined, "f");
            __classPrivateFieldSet(this, _X509WorkloadIdentityAuth_tokenGeneration, __classPrivateFieldGet(this, _X509WorkloadIdentityAuth_tokenGeneration, "f") + 1, "f");
            attempt.controller.abort(new APIUserAbortError());
        }
    });
}, _X509WorkloadIdentityAuth_beginRefresh = function _X509WorkloadIdentityAuth_beginRefresh() {
    const controller = new AbortController();
    const generation = __classPrivateFieldGet(this, _X509WorkloadIdentityAuth_tokenGeneration, "f");
    const attempt = {
        controller,
        generation,
        waiters: 0,
        promise: __classPrivateFieldGet(this, _X509WorkloadIdentityAuth_instances, "m", _X509WorkloadIdentityAuth_refreshToken).call(this, controller, generation),
    };
    __classPrivateFieldSet(this, _X509WorkloadIdentityAuth_refresh, attempt, "f");
    return attempt;
}, _X509WorkloadIdentityAuth_refreshToken = async function _X509WorkloadIdentityAuth_refreshToken(controller, generation) {
    const startedAt = performance.now();
    const wallStartedAt = Date.now();
    try {
        const token = await __classPrivateFieldGet(this, _X509WorkloadIdentityAuth_transport, "f").exchange(__classPrivateFieldGet(this, _X509WorkloadIdentityAuth_identityProviderId, "f"), __classPrivateFieldGet(this, _X509WorkloadIdentityAuth_serviceAccountId, "f"), controller.signal);
        const lifetime = token.expiresIn * 1000;
        const expiresAt = startedAt + lifetime;
        const wallExpiresAt = wallStartedAt + lifetime;
        if (performance.now() >= expiresAt || Date.now() >= wallExpiresAt) {
            throw new OpenAIError('X.509 workload identity token expired before its exchange completed.');
        }
        if (__classPrivateFieldGet(this, _X509WorkloadIdentityAuth_tokenGeneration, "f") !== generation ||
            controller.signal.aborted ||
            __classPrivateFieldGet(this, _X509WorkloadIdentityAuth_refresh, "f")?.controller !== controller) {
            throw new APIUserAbortError();
        }
        __classPrivateFieldSet(this, _X509WorkloadIdentityAuth_tokenGeneration, __classPrivateFieldGet(this, _X509WorkloadIdentityAuth_tokenGeneration, "f") + 1, "f");
        __classPrivateFieldSet(this, _X509WorkloadIdentityAuth_cachedToken, {
            accessToken: token.accessToken,
            generation: __classPrivateFieldGet(this, _X509WorkloadIdentityAuth_tokenGeneration, "f"),
            expiresAt,
            refreshAt: expiresAt - Math.min(__classPrivateFieldGet(this, _X509WorkloadIdentityAuth_refreshBufferMs, "f"), lifetime / 2),
            wallExpiresAt,
            wallRefreshAt: wallExpiresAt - Math.min(__classPrivateFieldGet(this, _X509WorkloadIdentityAuth_refreshBufferMs, "f"), lifetime / 2),
        }, "f");
        return token;
    }
    finally {
        if (__classPrivateFieldGet(this, _X509WorkloadIdentityAuth_refresh, "f")?.controller === controller) {
            __classPrivateFieldSet(this, _X509WorkloadIdentityAuth_refresh, undefined, "f");
        }
    }
}, _X509WorkloadIdentityAuth_preflight = function _X509WorkloadIdentityAuth_preflight(context) {
    if (!context) {
        return;
    }
    if (context.organization !== __classPrivateFieldGet(this, _X509WorkloadIdentityAuth_organization, "f") || context.project !== __classPrivateFieldGet(this, _X509WorkloadIdentityAuth_project, "f")) {
        throw new OpenAIError('X.509 workload identity cannot override its enrolled organization or project.');
    }
    assertX509APIOrigin(context.apiURL);
    const supplied = buildHeaders([context.defaultHeaders, context.requestHeaders]);
    if ((__classPrivateFieldGet(this, _X509WorkloadIdentityAuth_organization, "f") !== null && supplied.nulls.has('openai-organization')) ||
        (__classPrivateFieldGet(this, _X509WorkloadIdentityAuth_project, "f") !== null && supplied.nulls.has('openai-project'))) {
        throw new OpenAIError('X.509 workload identity cannot omit its enrolled organization or project.');
    }
    for (const name of supplied.values.keys()) {
        const canonical = name.toLowerCase().split('_').join('-');
        if ((canonical === 'openai-organization' || canonical === 'openai-project') &&
            (name !== canonical ||
                headerValue(supplied.values, name) !==
                    (canonical === 'openai-organization' ? context.organization : context.project))) {
            throw new OpenAIError('X.509 workload identity cannot override its enrolled organization or project.');
        }
        if (isSensitiveHeader(canonical) || canonical === 'host') {
            throw new OpenAIError('X.509 workload identity cannot use caller-supplied authentication credentials.');
        }
    }
}, _X509WorkloadIdentityAuth_scope = function _X509WorkloadIdentityAuth_scope() {
    const scope = __classPrivateFieldGet(this, _X509WorkloadIdentityAuth_transport, "f").current();
    if (!scope || scope.owner !== this) {
        throw new OpenAIError('X.509 workload identity requires an active certificate request scope.');
    }
    return scope;
}, _X509WorkloadIdentityAuth_assertTenantHeaders = function _X509WorkloadIdentityAuth_assertTenantHeaders(headers) {
    if (headerValue(headers, 'OpenAI-Organization') !== __classPrivateFieldGet(this, _X509WorkloadIdentityAuth_organization, "f") ||
        headerValue(headers, 'OpenAI-Project') !== __classPrivateFieldGet(this, _X509WorkloadIdentityAuth_project, "f")) {
        throw new OpenAIError('X.509 workload identity cannot override its enrolled organization or project.');
    }
    for (const name of Headers.prototype.keys.call(headers)) {
        const canonical = name.toLowerCase().split('_').join('-');
        if ((canonical === 'openai-organization' || canonical === 'openai-project') && name !== canonical) {
            throw new OpenAIError('X.509 workload identity cannot override its enrolled organization or project.');
        }
    }
};
//# sourceMappingURL=x509-workload-identity-auth.mjs.map