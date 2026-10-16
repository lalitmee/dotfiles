import type { X509ExchangedToken, X509Transport } from "./x509-transport-registry.js";
export type { X509ExchangedToken } from "./x509-transport-registry.js";
/** Parameters for one certificate-authenticated OAuth exchange. */
export interface X509TokenExchangeOptions {
    /** Frozen, caller-owned certificate transport shared with the eventual API request. */
    transport: X509Transport;
    /** Identity provider enrolled for the workload certificate. */
    identityProviderId: string;
    /** OpenAI service account selected for the verified certificate identity. */
    serviceAccountId: string;
    /** Optional caller cancellation propagated through request and response consumption. */
    signal?: AbortSignal | undefined;
}
/** Exchanges one enrolled client certificate for a validated OpenAI workload access token. */
export declare function exchangeX509Token(options: X509TokenExchangeOptions): Promise<X509ExchangedToken>;
//# sourceMappingURL=x509-token-exchange.d.ts.map