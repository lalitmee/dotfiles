import type { X509ProxyMode, X509Transport, X509TransportOptions } from "../internal/auth/x509-transport-capability.mjs";
import type { X509Credential } from "./types.mjs";
/** Explicit, separately trusted CONNECT configuration for an SDK-owned X.509 credential. */
export interface X509CredentialProxyOptions {
    /** CONNECT proxy endpoint; its protocol must match the selected mode. */
    url: string | URL;
    /** Whether the connection to the CONNECT proxy itself is encrypted. */
    mode: Exclude<X509ProxyMode, 'direct'>;
    /** Optional private trust roots for the HTTPS proxy; never used for workload TLS. */
    ca?: string | string[] | undefined;
}
/** Private certificate material and enrolled selectors for one SDK-owned workload credential. */
export interface X509CredentialOptions {
    /** Leaf client certificate followed by its required PEM intermediate chain. */
    certificateChain: string;
    /** PEM private key matching the leaf client certificate. */
    privateKey: string;
    /** Existing OpenAI identity-provider resource enrolled for the certificate. */
    identityProviderId: string;
    /** OpenAI service account authorized for the verified certificate identity. */
    serviceAccountId: string;
    /** Optional private certificate authorities trusted for OpenAI's issuer and API. */
    ca?: string | string[] | undefined;
    /** Optional passphrase used to decrypt an encrypted PEM private key. */
    passphrase?: string | undefined;
    /** Optional CONNECT proxy with separately scoped target and proxy TLS settings. */
    proxy?: X509CredentialProxyOptions | undefined;
    /** Seconds before expiration when access-token refresh begins; defaults to 1,200. */
    refreshBufferSeconds?: number | undefined;
}
/** Creates one frozen, caller-attested Node.js transport for X.509 workload authentication. */
export declare function createX509Transport(options: X509TransportOptions): X509Transport;
/** Creates a first-class certificate credential with SDK-owned, verified TLS and CONNECT policy. */
export declare function fromX509(options: X509CredentialOptions): X509Credential;
/** Namespaced first-class credential factory, isolated from ordinary browser-safe auth imports. */
export declare const workloadIdentity: Readonly<{
    fromX509: typeof fromX509;
}>;
export type { X509ProxyMode, X509Transport, X509TransportOptions, } from "../internal/auth/x509-transport-capability.mjs";
//# sourceMappingURL=x509-transport.d.mts.map