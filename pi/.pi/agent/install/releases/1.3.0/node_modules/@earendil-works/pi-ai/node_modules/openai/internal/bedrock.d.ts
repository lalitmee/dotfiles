import * as Errors from "../error.js";
import type { ApiKeySetter } from "../client.js";
import type { FinalizedRequestInit } from "./types.js";
import type { ProviderRequestContext } from "./provider.js";
/** Identifies legacy Bedrock clients without importing the client class into WebSocket modules. */
export declare const brand_privateBedrockClient: unique symbol;
/** Selects the regional Amazon Bedrock endpoint and its matching SigV4 service. */
export type BedrockEndpoint = 'mantle' | 'runtime';
/** Endpoint and region settings shared by the Bedrock provider variants. */
export interface BedrockEndpointOptions {
    /**
     * Amazon Bedrock endpoint family. Recognized AWS endpoint overrides select
     * their own family; otherwise defaults to `mantle` for compatibility.
     */
    endpoint?: BedrockEndpoint | undefined;
    /**
     * AWS region used to derive the selected endpoint and sign AWS requests.
     * Defaults to `AWS_REGION`, then `AWS_DEFAULT_REGION`.
     */
    region?: string | undefined;
    /**
     * Bedrock API root. Defaults to `AWS_BEDROCK_BASE_URL`, then the regional
     * selected endpoint. Set to `null` to bypass the environment override.
     */
    baseURL?: string | null | undefined;
}
/** Mutually exclusive sources for a Bedrock bearer credential. */
export interface BedrockBearerOptions {
    /**
     * Explicit Bedrock bearer credential. Set to `null` to disable the
     * `AWS_BEARER_TOKEN_BEDROCK` fallback.
     */
    apiKey?: string | null | undefined;
    /** Resolves a fresh bearer credential before every request attempt and retry. */
    tokenProvider?: ApiKeySetter | undefined;
}
/** Per-client authentication handler invoked before each Bedrock request. */
export interface BedrockRequestAuth {
    /** Adds provider-owned authentication headers or rejects invalid credentials. */
    prepareRequest(request: FinalizedRequestInit, context: ProviderRequestContext): void | Promise<void>;
}
/** Creates an authentication handler with independent per-client state. */
export type BedrockAuthFactory = () => BedrockRequestAuth;
/** Wraps a provider failure in an SDK error while preserving its original cause. */
export declare function errorWithCause(message: string, cause: unknown): Errors.OpenAIError;
/** Trims a configuration string, treating missing and whitespace-only values as absent. */
export declare function normalizeOptionalString(value: string | null | undefined): string | undefined;
/** Identifies a canonical Amazon Bedrock hostname and its embedded AWS region. */
export declare function parseBedrockEndpointHostname(hostname: string): {
    /** Endpoint family identified by the canonical AWS hostname. */
    endpoint: BedrockEndpoint;
    /** AWS region embedded in the canonical endpoint hostname. */
    region: string;
} | undefined;
/**
 * Resolves the Bedrock endpoint family, region, and API root from configuration.
 *
 * Region precedence is `region`, `AWS_REGION`, then `AWS_DEFAULT_REGION`.
 * Endpoint precedence is `baseURL`, `AWS_BEDROCK_BASE_URL`, then the regional
 * selected endpoint; an explicit `null` base URL skips the environment override.
 * Existing `/responses` suffixes and trailing slashes are removed. Canonical
 * AWS hostnames infer the endpoint family when none is selected explicitly.
 * Other configured URLs and derived endpoints default to Mantle.
 *
 * @throws {Errors.OpenAIError} If an option is invalid, a canonical hostname
 * conflicts with the endpoint family, or the default endpoint needs a region.
 */
export declare function resolveBedrockEndpoint(options: BedrockEndpointOptions): {
    /** Resolved endpoint family, defaulting to Mantle for backwards compatibility. */
    endpoint: BedrockEndpoint;
    /** Resolved AWS region, when explicitly configured or available in the environment. */
    region: string | undefined;
    /** Canonical Bedrock API root with no trailing slash or `/responses` suffix. */
    baseURL: string;
};
/**
 * Ensures Bedrock credentials are only attached to the configured endpoint origin.
 *
 * @throws {Errors.OpenAIError} If either URL is not HTTP(S) or the request targets a different origin.
 */
export declare function assertBedrockRequestOrigin(baseURL: string, requestURL: string): void;
/** Validates a final WebSocket URL before a legacy Bedrock client resolves or attaches credentials. */
export declare function assertBedrockWebSocketOrigin(client: unknown, requestURL: URL): void;
/**
 * Rejects caller-provided authorization headers that conflict with provider authentication.
 *
 * @throws {Errors.OpenAIError} If an `Authorization` header is already present.
 */
export declare function assertProviderOwnsAuthorization(headers: Headers): void;
/** Rejects non-HTTP field bytes without retaining or exposing a bearer credential. */
export declare function assertValidBedrockBearerCredential(credential: string): void;
/**
 * Resolves Bedrock authentication work with caller cancellation, then applies
 * its result synchronously after the final cancellation checks.
 *
 * @internal
 */
export declare function prepareBedrockAuth<T>(request: FinalizedRequestInit, context: ProviderRequestContext, operation: {
    resolve: () => Promise<T>;
    failureMessage: string;
    apply: (value: T) => void;
}): Promise<void>;
/**
 * Resolves a bearer-authentication factory without calling token providers eagerly.
 *
 * Explicit `tokenProvider` and `apiKey` options are mutually exclusive. When
 * neither is set, `AWS_BEARER_TOKEN_BEDROCK` is used unless environment
 * credentials are disabled or `apiKey` is explicitly `null`.
 *
 * @throws {Errors.OpenAIError} If an explicit key is empty or multiple bearer
 * credential sources are configured.
 */
export declare function resolveBedrockBearerAuth(options: BedrockBearerOptions, { allowEnvironment, }?: {
    /** Whether `AWS_BEARER_TOKEN_BEDROCK` may provide a fallback credential. */
    allowEnvironment?: boolean;
}): {
    /** Creates a request authenticator, or is absent when no bearer source is configured. */
    factory: BedrockAuthFactory | undefined;
    /** Whether authentication came from an explicit option rather than the environment. */
    explicit: boolean;
};
//# sourceMappingURL=bedrock.d.ts.map