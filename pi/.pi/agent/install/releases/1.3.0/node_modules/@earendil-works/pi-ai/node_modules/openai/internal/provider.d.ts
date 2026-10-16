import type { FinalRequestOptions } from "./request-options.js";
import type { FinalizedRequestInit } from "./types.js";
declare const providerBrand: unique symbol;
/** An opaque provider configuration created by {@link createProvider}. */
export interface Provider {
    /** Prevents arbitrary objects from being treated as SDK-created providers. */
    readonly [providerBrand]: true;
}
/** Request details supplied to a provider immediately before each request attempt. */
export interface ProviderRequestContext {
    /** Absolute URL of the request being prepared. */
    url: string;
    /** Final SDK request options, including the HTTP method and resource path. */
    options: FinalRequestOptions;
}
/** Provider configuration instantiated separately for each OpenAI client. */
export interface ProviderRuntime {
    /** Provider identifier used to distinguish the client's upstream service. */
    name: string;
    /** Absolute API root used to resolve the client's resource paths. */
    baseURL: string;
    /**
     * Updates a request immediately before each attempt, including retries.
     *
     * Providers can refresh credentials or replace request headers in place. A
     * rejected promise prevents that attempt from being sent.
     */
    prepareRequest?(request: FinalizedRequestInit, context: ProviderRequestContext): void | Promise<void>;
}
/** Factory for the per-client runtime associated with an opaque provider. */
export interface ProviderDefinition {
    /** Creates a fresh runtime whenever the provider is attached to a client. */
    configure(): ProviderRuntime;
}
/**
 * Creates an opaque, immutable provider handle for a runtime definition.
 *
 * The definition is registered out of band and can be resolved by another
 * installed copy of the SDK in the same JavaScript realm.
 */
export declare function createProvider(definition: ProviderDefinition): Provider;
/**
 * Creates a new client-specific runtime from a previously registered provider.
 *
 * @throws {Error} If the value was not created with {@link createProvider}.
 */
export declare function configureProvider(provider: Provider): ProviderRuntime;
export {};
//# sourceMappingURL=provider.d.ts.map