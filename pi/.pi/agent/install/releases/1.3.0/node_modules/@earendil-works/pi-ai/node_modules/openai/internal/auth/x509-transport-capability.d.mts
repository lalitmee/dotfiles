import { Agent, ProxyAgent } from 'undici';
import type { RegisteredX509Transport, X509Transport } from "./x509-transport-registry.mjs";
export type { X509Transport } from "./x509-transport-registry.mjs";
/** Explicitly supported, application-owned Undici proxy configurations. */
export type X509ProxyMode = 'direct' | 'http-connect' | 'https-connect';
/** Application attestation for one caller-owned static-certificate Undici transport. */
export interface X509TransportOptions {
    /** X.509 transport currently supports genuine Node.js runtimes only. */
    runtime: 'node';
    /**
     * Caller-owned Undici Agent or ProxyAgent; the SDK never closes or inspects it.
     *
     * The application attests that its dispatcher, factories, TLS verification,
     * certificate selection, and CONNECT proxy configuration are trustworthy.
     * Use `fromX509` when the SDK should own and enforce transport configuration.
     */
    dispatcher: Agent | ProxyAgent;
    /** Attests that the dispatcher uses one static workload-certificate identity. */
    certificateIdentity: 'static';
    /** Attests that proxy TLS and CONNECT credentials are independently configured. */
    proxy: X509ProxyMode;
}
/** Registers only a genuine frozen capability whose JavaScript private dispatcher cannot be forged. */
export declare function registerX509Transport(transport: X509Transport, registered: RegisteredX509Transport): void;
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
export declare function createX509Transport(options: X509TransportOptions): X509Transport;
/** Dispatches through the opaque attested transport without accepting replacement dispatchers. */
export declare function sendX509Request(transport: X509Transport, target: URL, options: RequestInit): Promise<Response>;
//# sourceMappingURL=x509-transport-capability.d.mts.map