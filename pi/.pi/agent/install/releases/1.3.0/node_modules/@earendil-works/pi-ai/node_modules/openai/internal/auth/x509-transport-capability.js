"use strict";
var _NodeX509Transport_dispatcher;
Object.defineProperty(exports, "__esModule", { value: true });
exports.registerX509Transport = registerX509Transport;
exports.createX509Transport = createX509Transport;
exports.sendX509Request = sendX509Request;
const tslib_1 = require("../tslib.js");
const node_util_1 = require("node:util");
const undici_1 = require("undici");
const error_1 = require("../../core/error.js");
const x509_transport_registry_1 = require("./x509-transport-registry.js");
const _x509_transport_state_1 = require('./x509-transport-state.js');
const allowedOptionNames = new Set(['runtime', 'dispatcher', 'certificateIdentity', 'proxy']);
const transportBrand = x509_transport_registry_1.x509TransportBrand;
class NodeX509Transport {
    constructor(dispatcher) {
        _NodeX509Transport_dispatcher.set(this, void 0);
        tslib_1.__classPrivateFieldSet(this, _NodeX509Transport_dispatcher, dispatcher, "f");
        Object.freeze(this);
    }
    static dispatcher(value) {
        return tslib_1.__classPrivateFieldIn(_NodeX509Transport_dispatcher, value) ? tslib_1.__classPrivateFieldGet(value, _NodeX509Transport_dispatcher, "f") : undefined;
    }
}
_NodeX509Transport_dispatcher = new WeakMap();
/** Registers only a genuine frozen capability whose JavaScript private dispatcher cannot be forged. */
function registerX509Transport(transport, registered) {
    if (!transport ||
        typeof transport !== 'object' ||
        node_util_1.types.isProxy(transport) ||
        !Object.isFrozen(transport) ||
        !NodeX509Transport.dispatcher(transport)) {
        throw new error_1.OpenAIError('Only a genuine frozen X.509 transport capability can be registered.');
    }
    if ((0, _x509_transport_state_1.findRegisteredX509Transport)(transport)) {
        throw new error_1.OpenAIError('An approved X.509 transport capability cannot be registered more than once.');
    }
    (0, _x509_transport_state_1.rememberRegisteredX509Transport)(transport, Object.freeze(registered));
}
// oxlint-disable-next-line anti-slop/no-unknown-returns -- Own data-property values must remain untrusted until their option-specific validators run.
function dataOption(options, name) {
    const descriptor = Object.getOwnPropertyDescriptor(options, name);
    if (!descriptor || !('value' in descriptor)) {
        throw new Error(`X.509 transport option \`${name}\` must be an own plain data property.`);
    }
    return descriptor.value;
}
function assertNodeRuntime() {
    if (typeof process === 'undefined' ||
        process.release.name !== 'node' ||
        'bun' in process.versions ||
        'Bun' in globalThis ||
        'Deno' in globalThis) {
        throw new Error('X.509 transport requires a genuine Node.js runtime.');
    }
}
function attestedDispatcher(options) {
    const dispatcher = dataOption(options, 'dispatcher');
    if (!dispatcher || typeof dispatcher !== 'object') {
        throw new Error('X.509 transport requires a caller-owned Undici Agent or ProxyAgent.');
    }
    if (node_util_1.types.isProxy(dispatcher)) {
        throw new Error('X.509 transport does not accept a dispatcher proxy.');
    }
    const isDirect = dispatcher instanceof undici_1.Agent;
    const isConnect = dispatcher instanceof undici_1.ProxyAgent;
    if (!isDirect && !isConnect) {
        throw new Error('X.509 transport requires a caller-owned Undici Agent or ProxyAgent.');
    }
    const proxy = dataOption(options, 'proxy');
    if (proxy !== 'direct' && proxy !== 'http-connect' && proxy !== 'https-connect') {
        throw new Error('X.509 transport requires an explicitly supported proxy mode.');
    }
    if ((proxy === 'direct') !== isDirect) {
        throw new Error('An X.509 CONNECT proxy requires an Undici ProxyAgent.');
    }
    return dispatcher;
}
function assertRequestDispatcherSupport(dispatcher) {
    let observesRequestDispatcher = false;
    // about:blank never reaches the network; the getter checks the actual fetch contract.
    void Promise.allSettled([
        (0, undici_1.fetch)('about:blank', {
            get dispatcher() {
                observesRequestDispatcher = true;
                return dispatcher;
            },
        }),
    ]);
    if (!observesRequestDispatcher) {
        throw new Error('X.509 transport requires Undici 5.2.0 or later with per-request dispatcher support.');
    }
}
function assertConnectProxySupport() {
    const targetOrigin = 'https://127.0.0.1:65535';
    let routedOrigin;
    const probe = new undici_1.ProxyAgent({
        uri: 'http://127.0.0.1:1',
        factory(origin) {
            routedOrigin = String(origin);
            throw new Error('X.509 CONNECT capability probe');
        },
    });
    // The throwing factory reveals the actual routing decision before any socket opens.
    const request = (0, undici_1.fetch)(targetOrigin, { dispatcher: probe });
    void Promise.allSettled([request, probe.close()]);
    if (routedOrigin !== targetOrigin) {
        throw new Error('X.509 CONNECT proxy requires Undici 5.5.1 or later with target TLS tunneling.');
    }
}
/**
 * Creates a frozen, opaque capability for one caller-owned Undici transport.
 *
 * `certificateIdentity: 'static'` is an application attestation: the SDK does
 * not inspect certificates, private dispatcher internals, callbacks, or TLS
 * options and cannot cryptographically prove certificate selection. Configure
 * trusted dispatcher factories, verified target and proxy TLS, one static
 * certificate identity, and independently scoped CONNECT credentials.
 * Prefer the SDK-owned `fromX509` credential when these guarantees should be
 * enforced at construction. Rotation requires a fresh caller-owned dispatcher
 * and capability; the application remains responsible for draining it.
 *
 * This Node-only preview entrypoint requires the optional `undici` peer at
 * version 5.2.0 or later. CONNECT proxy modes require version 5.5.1 or
 * later; ordinary SDK clients retain broader compatibility.
 */
function createX509Transport(options) {
    assertNodeRuntime();
    if (!options || typeof options !== 'object' || node_util_1.types.isProxy(options)) {
        throw new Error('X.509 transport configuration must be a non-proxy object.');
    }
    for (const name of Reflect.ownKeys(options)) {
        if (typeof name !== 'string' || !allowedOptionNames.has(name)) {
            throw new Error(`Unsupported X.509 transport option: \`${String(name)}\`.`);
        }
    }
    if (dataOption(options, 'runtime') !== 'node') {
        throw new Error('X.509 transport requires an explicitly attested Node.js runtime.');
    }
    if (dataOption(options, 'certificateIdentity') !== 'static') {
        throw new Error('X.509 transport requires an explicitly attested static client certificate.');
    }
    const dispatcher = attestedDispatcher(options);
    assertRequestDispatcherSupport(dispatcher);
    if (dispatcher instanceof undici_1.ProxyAgent) {
        assertConnectProxySupport();
    }
    return new NodeX509Transport(dispatcher);
}
/** Dispatches through the opaque attested transport without accepting replacement dispatchers. */
async function sendX509Request(transport, target, options) {
    if (!transport || typeof transport !== 'object' || node_util_1.types.isProxy(transport)) {
        throw new Error('Invalid X.509 transport capability.');
    }
    const dispatcher = NodeX509Transport.dispatcher(transport);
    if (!dispatcher) {
        throw new Error('Invalid X.509 transport capability.');
    }
    const normalizedTarget = new URL(target.href);
    if (normalizedTarget.protocol !== 'https:') {
        throw new Error('X.509 transport requires an HTTPS destination.');
    }
    if (Object.getOwnPropertyDescriptor(options, 'dispatcher')) {
        throw new Error('X.509 transport does not allow a per-request dispatcher override.');
    }
    const requestOptions = options;
    const request = new undici_1.Request(normalizedTarget, requestOptions);
    const response = await (0, undici_1.fetch)(request, { dispatcher, redirect: 'manual' });
    return response;
}
//# sourceMappingURL=x509-transport-capability.js.map