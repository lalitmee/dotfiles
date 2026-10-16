var _NodeX509Transport_dispatcher;
import { __classPrivateFieldGet, __classPrivateFieldIn, __classPrivateFieldSet } from "../tslib.mjs";
import { types } from 'node:util';
import { Agent, ProxyAgent, Request, fetch } from 'undici';
import { OpenAIError } from "../../core/error.mjs";
import { x509TransportBrand } from "./x509-transport-registry.mjs";
import { findRegisteredX509Transport, rememberRegisteredX509Transport } from './x509-transport-state.mjs';
const allowedOptionNames = new Set(['runtime', 'dispatcher', 'certificateIdentity', 'proxy']);
const transportBrand = x509TransportBrand;
class NodeX509Transport {
    constructor(dispatcher) {
        _NodeX509Transport_dispatcher.set(this, void 0);
        __classPrivateFieldSet(this, _NodeX509Transport_dispatcher, dispatcher, "f");
        Object.freeze(this);
    }
    static dispatcher(value) {
        return __classPrivateFieldIn(_NodeX509Transport_dispatcher, value) ? __classPrivateFieldGet(value, _NodeX509Transport_dispatcher, "f") : undefined;
    }
}
_NodeX509Transport_dispatcher = new WeakMap();
/** Registers only a genuine frozen capability whose JavaScript private dispatcher cannot be forged. */
export function registerX509Transport(transport, registered) {
    if (!transport ||
        typeof transport !== 'object' ||
        types.isProxy(transport) ||
        !Object.isFrozen(transport) ||
        !NodeX509Transport.dispatcher(transport)) {
        throw new OpenAIError('Only a genuine frozen X.509 transport capability can be registered.');
    }
    if (findRegisteredX509Transport(transport)) {
        throw new OpenAIError('An approved X.509 transport capability cannot be registered more than once.');
    }
    rememberRegisteredX509Transport(transport, Object.freeze(registered));
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
    if (types.isProxy(dispatcher)) {
        throw new Error('X.509 transport does not accept a dispatcher proxy.');
    }
    const isDirect = dispatcher instanceof Agent;
    const isConnect = dispatcher instanceof ProxyAgent;
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
        fetch('about:blank', {
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
    const probe = new ProxyAgent({
        uri: 'http://127.0.0.1:1',
        factory(origin) {
            routedOrigin = String(origin);
            throw new Error('X.509 CONNECT capability probe');
        },
    });
    // The throwing factory reveals the actual routing decision before any socket opens.
    const request = fetch(targetOrigin, { dispatcher: probe });
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
export function createX509Transport(options) {
    assertNodeRuntime();
    if (!options || typeof options !== 'object' || types.isProxy(options)) {
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
    if (dispatcher instanceof ProxyAgent) {
        assertConnectProxySupport();
    }
    return new NodeX509Transport(dispatcher);
}
/** Dispatches through the opaque attested transport without accepting replacement dispatchers. */
export async function sendX509Request(transport, target, options) {
    if (!transport || typeof transport !== 'object' || types.isProxy(transport)) {
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
    const request = new Request(normalizedTarget, requestOptions);
    const response = await fetch(request, { dispatcher, redirect: 'manual' });
    return response;
}
//# sourceMappingURL=x509-transport-capability.mjs.map