import { OpenAI } from "./client.js";
import type { ApiKeySetter, ClientOptions } from "./client.js";
import { brand_privateBedrockClient } from "./internal/bedrock.js";
import type { RequestInit } from "./internal/builtin-types.js";
import type { NullableHeaders } from "./internal/headers.js";
import type { FinalRequestOptions } from "./internal/request-options.js";
/** Configures Amazon Bedrock's OpenAI-compatible endpoint and bearer-token authentication. */
export interface BedrockClientOptions extends Omit<ClientOptions, 'apiKey' | 'adminAPIKey' | 'baseURL' | 'credential' | 'workloadIdentity' | 'x509Transport' | 'dataResidency'> {
    /**
     * Bedrock bearer token used for authentication.
     *
     * Defaults to process.env['AWS_BEARER_TOKEN_BEDROCK'].
     */
    apiKey?: string | null | undefined;
    /**
     * Bedrock API root.
     *
     * Defaults to process.env['AWS_BEDROCK_BASE_URL'], or derives
     * `https://bedrock-mantle.<region>.api.aws/openai/v1` from `awsRegion`,
     * process.env['AWS_REGION'], or process.env['AWS_DEFAULT_REGION'].
     */
    baseURL?: string | null | undefined;
    /**
     * BedrockOpenAI only supports Bedrock bearer token authentication.
     */
    adminAPIKey?: never;
    /** OpenAI data residency cannot be combined with Bedrock routing. */
    dataResidency?: never;
    /** Bedrock cannot receive an SDK-owned OpenAI X.509 certificate credential. */
    credential?: never;
    /**
     * BedrockOpenAI only supports Bedrock bearer token authentication.
     */
    workloadIdentity?: never;
    /** Bedrock cannot receive OpenAI X.509 workload-identity certificate transports. */
    x509Transport?: never;
    /**
     * AWS region used to derive the default Bedrock Mantle endpoint.
     *
     * Defaults to process.env['AWS_REGION'] or process.env['AWS_DEFAULT_REGION'].
     */
    awsRegion?: string | undefined;
    /**
     * A function that returns a Bedrock bearer token and is invoked before each request.
     */
    bedrockTokenProvider?: ApiKeySetter | undefined;
}
/** API Client for interfacing with Amazon Bedrock's OpenAI-compatible endpoint. */
export declare class BedrockOpenAI extends OpenAI {
    /**
     * Identifies this client to credential-bearing WebSocket helpers.
     *
     * @internal
     */
    readonly [brand_privateBedrockClient] = true;
    private readonly bedrockTokenProvider;
    /**
     * API Client for interfacing with Amazon Bedrock's OpenAI-compatible endpoint.
     *
     * @param {string | null | undefined} [opts.apiKey] - Defaults to `process.env['AWS_BEARER_TOKEN_BEDROCK'] ?? null`.
     * @param {string | null | undefined} [opts.baseURL] - Defaults to `process.env['AWS_BEDROCK_BASE_URL']`, or is derived from `opts.awsRegion`, `AWS_REGION`, or `AWS_DEFAULT_REGION`.
     * @param {string | undefined} [opts.awsRegion] - Defaults to `process.env['AWS_REGION'] ?? process.env['AWS_DEFAULT_REGION'] ?? undefined`.
     * @param {ApiKeySetter | undefined} opts.bedrockTokenProvider - A function that returns a Bedrock bearer token and is invoked before each request.
     */
    constructor({ baseURL, apiKey, awsRegion, bedrockTokenProvider, adminAPIKey, workloadIdentity, x509Transport, dataResidency, ...opts }?: BedrockClientOptions);
    protected prepareOptions(options: FinalRequestOptions): Promise<void>;
    protected prepareRequest(request: RequestInit, context: {
        url: string;
        options: FinalRequestOptions;
    }): Promise<void>;
    protected authHeaders(opts: FinalRequestOptions, schemes?: {
        bearerAuth?: boolean;
        adminAPIKeyAuth?: boolean;
    }): Promise<NullableHeaders | undefined>;
    /** Clones this client while preserving its refreshable Bedrock token provider when appropriate. */
    withOptions(options: Partial<BedrockClientOptions>): this;
}
//# sourceMappingURL=bedrock.d.ts.map