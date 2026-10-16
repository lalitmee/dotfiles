"use strict";
var _OwnedX509Credential_dispatcher, _OwnedX509Credential_closing;
Object.defineProperty(exports, "__esModule", { value: true });
exports.workloadIdentity = void 0;
exports.createX509Transport = createX509Transport;
exports.fromX509 = fromX509;
const tslib_1 = require("../internal/tslib.js");
const node_async_hooks_1 = require("node:async_hooks");
const node_crypto_1 = require("node:crypto");
const promises_1 = require("node:timers/promises");
const node_util_1 = require("node:util");
const undici_1 = require("undici");
const x509_transport_capability_1 = require("../internal/auth/x509-transport-capability.js");
const x509_token_exchange_1 = require("../internal/auth/x509-token-exchange.js");
const x509_transport_registry_1 = require("../internal/auth/x509-transport-registry.js");
const _x509_transport_state_1 = require('../internal/auth/x509-transport-state.js');
const credentialOptionNames = new Set([
    'certificateChain',
    'privateKey',
    'identityProviderId',
    'serviceAccountId',
    'ca',
    'passphrase',
    'proxy',
    'refreshBufferSeconds',
]);
const proxyOptionNames = new Set(['url', 'mode', 'ca']);
function safeOptionRecord(value, allowed, label) {
    if (!value || typeof value !== 'object' || node_util_1.types.isProxy(value)) {
        throw new Error(`X.509 ${label} options must be a non-proxy object.`);
    }
    const prototype = Object.getPrototypeOf(value);
    if (prototype !== Object.prototype && prototype !== null) {
        throw new Error(`X.509 ${label} options must have only own plain data properties.`);
    }
    // SAFETY: The snapshot starts empty with no prototype; only checked own data properties are copied into it below.
    const snapshot = Object.create(null);
    for (const name of Reflect.ownKeys(value)) {
        if (typeof name !== 'string' || !allowed.has(name)) {
            throw new Error(`Unsupported X.509 ${label} option: \`${String(name)}\`.`);
        }
        const descriptor = Object.getOwnPropertyDescriptor(value, name);
        if (!descriptor || !('value' in descriptor)) {
            throw new Error(`X.509 ${label} option \`${name}\` must be a plain data property.`);
        }
        snapshot[name] = descriptor.value;
    }
    return snapshot;
}
function requiredCredentialValue(options, name) {
    const value = options[name];
    if (typeof value !== 'string' || value.trim().length === 0) {
        throw new Error(`X.509 credential requires a nonempty own \`${name}\` value.`);
    }
    return value;
}
function snapshotCertificateAuthorities(value) {
    if (value === undefined) {
        return undefined;
    }
    if (typeof value === 'string') {
        if (value.trim().length === 0) {
            throw new Error('X.509 certificate authorities must contain nonempty PEM values.');
        }
        return value;
    }
    if (!Array.isArray(value) || node_util_1.types.isProxy(value) || value.length === 0) {
        throw new Error('X.509 certificate authorities must be a PEM string or plain PEM string array.');
    }
    const authorities = [];
    for (let index = 0; index < value.length; index += 1) {
        const entry = Object.getOwnPropertyDescriptor(value, String(index));
        if (!entry || !('value' in entry) || typeof entry.value !== 'string' || entry.value.trim().length === 0) {
            throw new Error('X.509 certificate authorities require own plain nonempty PEM strings.');
        }
        authorities.push(entry.value);
    }
    return authorities;
}
class OwnedX509Credential {
    constructor(dispatcher) {
        _OwnedX509Credential_dispatcher.set(this, void 0);
        _OwnedX509Credential_closing.set(this, void 0);
        tslib_1.__classPrivateFieldSet(this, _OwnedX509Credential_dispatcher, dispatcher, "f");
        Object.freeze(this);
    }
    /** Closes this credential's owned transport once all in-flight requests have drained. */
    close() {
        tslib_1.__classPrivateFieldSet(this, _OwnedX509Credential_closing, tslib_1.__classPrivateFieldGet(this, _OwnedX509Credential_closing, "f") ?? tslib_1.__classPrivateFieldGet(this, _OwnedX509Credential_dispatcher, "f").close(), "f");
        return tslib_1.__classPrivateFieldGet(this, _OwnedX509Credential_closing, "f");
    }
}
_OwnedX509Credential_dispatcher = new WeakMap(), _OwnedX509Credential_closing = new WeakMap();
function validatedCredentialOptions(options) {
    const configured = safeOptionRecord(options, credentialOptionNames, 'credential');
    const certificateChain = requiredCredentialValue(configured, 'certificateChain');
    const privateKeyPEM = requiredCredentialValue(configured, 'privateKey');
    const identityProviderId = requiredCredentialValue(configured, 'identityProviderId');
    const serviceAccountId = requiredCredentialValue(configured, 'serviceAccountId');
    const { refreshBufferSeconds, passphrase } = configured;
    if (passphrase !== undefined && typeof passphrase !== 'string') {
        throw new Error('X.509 credential requires a string private-key passphrase.');
    }
    if (refreshBufferSeconds !== undefined &&
        (typeof refreshBufferSeconds !== 'number' ||
            !Number.isSafeInteger(refreshBufferSeconds) ||
            refreshBufferSeconds < 0 ||
            !Number.isSafeInteger(refreshBufferSeconds * 1000))) {
        throw new Error('X.509 credential requires a nonnegative integer refreshBufferSeconds.');
    }
    const ca = snapshotCertificateAuthorities(configured['ca']);
    const leaf = new node_crypto_1.X509Certificate(certificateChain);
    const privateKey = (0, node_crypto_1.createPrivateKey)({
        key: privateKeyPEM,
        // Create an own data property so an inherited setter cannot intercept the private-key passphrase.
        ...(passphrase === undefined ? {} : { passphrase }),
    });
    if (!leaf.checkPrivateKey(privateKey)) {
        throw new Error('X.509 credential private key must match its leaf client certificate.');
    }
    return {
        certificateChain,
        privateKey: privateKeyPEM,
        identityProviderId,
        serviceAccountId,
        refreshBufferSeconds,
        passphrase,
        ca,
        proxy: configured['proxy'],
    };
}
function proxyAuthentication(url) {
    if (url.username === '' && url.password === '') {
        return undefined;
    }
    let username;
    let password;
    try {
        username = decodeURIComponent(url.username);
        password = decodeURIComponent(url.password);
    }
    catch {
        throw new Error('X.509 CONNECT proxy credentials contain invalid URL encoding.');
    }
    if (username.includes(':')) {
        throw new Error('X.509 CONNECT proxy username cannot contain a colon.');
    }
    return Buffer.from(`${username}:${password}`, 'utf-8').toString('base64');
}
function normalizeProxyURL(value) {
    if (typeof value !== 'string' && (typeof value !== 'object' || value === null || node_util_1.types.isProxy(value))) {
        throw new Error('X.509 CONNECT proxy requires an own URL string or URL value.');
    }
    try {
        return new URL(typeof value === 'string' ? value : URL.prototype.toString.call(value));
    }
    catch {
        throw new Error('X.509 CONNECT proxy requires a valid proxy URL.');
    }
}
function credentialDispatcher(proxyOptionsInput, requestTls) {
    if (proxyOptionsInput === undefined) {
        // oxlint-disable-next-line anti-slop/no-known-value-widening -- The dispatcher owner returns one contract for direct Agents and both supported CONNECT proxy modes.
        return { dispatcher: new undici_1.Agent({ connect: requestTls }), proxy: 'direct' };
    }
    const proxyOptions = safeOptionRecord(proxyOptionsInput, proxyOptionNames, 'proxy');
    const url = normalizeProxyURL(proxyOptions['url']);
    const selected = proxyOptions['mode'];
    const proxy = selected === 'http-connect' || selected === 'https-connect' ? selected : 'direct';
    if ((proxy !== 'http-connect' && proxy !== 'https-connect') ||
        url.protocol !== (proxy === 'https-connect' ? 'https:' : 'http:') ||
        url.pathname !== '/' ||
        url.search ||
        url.hash) {
        throw new Error('X.509 CONNECT proxy URL protocol must match its selected secure proxy mode.');
    }
    const proxyCA = snapshotCertificateAuthorities(proxyOptions['ca']);
    if (proxy === 'http-connect' && proxyCA !== undefined) {
        throw new Error('A plaintext X.509 CONNECT proxy cannot configure proxy TLS authorities.');
    }
    const auth = proxyAuthentication(url);
    // oxlint-disable-next-line anti-slop/no-known-value-widening -- The declared transport contract preserves the same dispatcher and proxy types across both construction paths.
    return {
        proxy,
        dispatcher: new undici_1.ProxyAgent({
            uri: url.href,
            // Define proxy credentials as own data without invoking inherited setters.
            ...(auth === undefined ? {} : { auth }),
            requestTls,
            // Keep the optional proxy TLS configuration as an own data property.
            ...(proxy === 'https-connect'
                ? {
                    proxyTls: {
                        rejectUnauthorized: true,
                        // Define explicit proxy trust roots as own data without invoking inherited setters.
                        ...(proxyCA === undefined ? {} : { ca: proxyCA }),
                    },
                }
                : {}),
        }),
    };
}
/** Creates one frozen, caller-attested Node.js transport for X.509 workload authentication. */
function createX509Transport(options) {
    const capability = (0, x509_transport_capability_1.createX509Transport)(options);
    const scopes = new node_async_hooks_1.AsyncLocalStorage();
    (0, x509_transport_capability_1.registerX509Transport)(capability, {
        dispatch: async (target, requestOptions) => {
            try {
                return await (0, x509_transport_capability_1.sendX509Request)(capability, target, requestOptions);
            }
            catch (error) {
                if (error instanceof Error && (0, x509_transport_registry_1.isRetryableX509TransportFailure)(error)) {
                    (0, _x509_transport_state_1.markTransientX509ConnectionError)(error);
                }
                throw error;
            }
        },
        exchange: async (identityProviderId, serviceAccountId, signal) => await (0, x509_token_exchange_1.exchangeX509Token)({
            transport: capability,
            identityProviderId,
            serviceAccountId,
            // Preserve the cancellation signal as own data without invoking inherited setters.
            ...(signal ? { signal } : {}),
        }),
        run: (operation) => scopes.run({ wallStartedAt: Date.now(), monotonicStartedAt: performance.now() }, operation),
        current: () => scopes.getStore(),
        resume: (scope, operation) => scopes.run(scope, operation),
        sleep: async (duration, signal) => await (0, promises_1.setTimeout)(duration, undefined, { signal: signal ?? undefined }),
    });
    return capability;
}
/** Creates a first-class certificate credential with SDK-owned, verified TLS and CONNECT policy. */
function fromX509(options) {
    const configured = validatedCredentialOptions(options);
    const requestTls = {
        cert: configured.certificateChain,
        key: configured.privateKey,
        rejectUnauthorized: true,
        // Define the TLS passphrase as own data so inherited setters cannot intercept it.
        ...(configured.passphrase === undefined ? {} : { passphrase: configured.passphrase }),
        // Define explicit workload trust roots as own data without invoking inherited setters.
        ...(configured.ca === undefined ? {} : { ca: configured.ca }),
    };
    const { dispatcher, proxy } = credentialDispatcher(configured.proxy, requestTls);
    try {
        const transport = createX509Transport({
            runtime: 'node',
            dispatcher,
            certificateIdentity: 'static',
            proxy,
        });
        const identity = Object.freeze({
            type: 'x509',
            identityProviderId: configured.identityProviderId,
            serviceAccountId: configured.serviceAccountId,
            // Preserve the optional refresh setting as own data without invoking inherited setters.
            ...(configured.refreshBufferSeconds === undefined
                ? {}
                : { refreshBufferSeconds: configured.refreshBufferSeconds }),
        });
        const credential = new OwnedX509Credential(dispatcher);
        (0, _x509_transport_state_1.rememberX509Credential)(credential, Object.freeze({ identity, transport }));
        return credential;
    }
    catch (error) {
        void dispatcher.close();
        throw error;
    }
}
/** Namespaced first-class credential factory, isolated from ordinary browser-safe auth imports. */
exports.workloadIdentity = Object.freeze({ fromX509 });
//# sourceMappingURL=x509-transport.js.map