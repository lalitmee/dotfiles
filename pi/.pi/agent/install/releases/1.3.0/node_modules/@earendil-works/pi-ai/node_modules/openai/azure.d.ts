import type { RequestInit, RequestInfo, Response } from "./internal/builtin-types.js";
import type { NullableHeaders } from "./internal/headers.js";
import type { FinalRequestOptions } from "./internal/request-options.js";
import { OpenAI } from "./client.js";
import type { ClientOptions } from "./client.js";
import type { WorkloadIdentity } from "./auth/types.js";
/** API Client for interfacing with the Azure OpenAI API. */
export interface AzureClientOptions extends Omit<ClientOptions, 'provider' | 'dataResidency' | 'credential' | 'workloadIdentity' | 'x509Transport'> {
    /** AzureOpenAI does not support third-party provider configuration. */
    provider?: never;
    /** OpenAI data residency cannot be combined with Azure routing. */
    dataResidency?: never;
    /** Azure cannot receive an SDK-owned OpenAI X.509 certificate credential. */
    credential?: never;
    /** Azure cannot receive OpenAI X.509 workload-identity certificate transports. */
    x509Transport?: never;
    /** Existing subject-token workload-identity configuration remains unchanged. */
    workloadIdentity?: WorkloadIdentity | undefined;
    /**
     * Defaults to process.env['OPENAI_API_VERSION'].
     */
    apiVersion?: string | undefined;
    /**
     * Your Azure endpoint, including the resource, e.g. `https://example-resource.azure.openai.com/`
     */
    endpoint?: string | undefined;
    /**
     * Azure model deployment inserted into supported deployment-scoped request
     * paths. The client's base URL remains unchanged, so non-deployment endpoints
     * remain available.
     */
    deployment?: string | undefined;
    /**
     * Defaults to process.env['AZURE_OPENAI_API_KEY'].
     */
    apiKey?: string | undefined;
    /**
     * A function that returns an access token for Microsoft Entra (formerly known as Azure Active Directory),
     * which will be invoked on every request.
     */
    azureADTokenProvider?: (() => Promise<string>) | undefined;
}
/** API Client for interfacing with the Azure OpenAI API. */
export declare class AzureOpenAI extends OpenAI {
    /** Azure deployment configured for deployment-scoped model requests. */
    deploymentName: string | undefined;
    /** Azure OpenAI API version included in requests made by this client. */
    apiVersion: string;
    /**
     * API Client for interfacing with the Azure OpenAI API.
     *
     * @param {string | undefined} [opts.apiVersion] - Defaults to `process.env['OPENAI_API_VERSION'] ?? undefined`.
     * @param {string | undefined} [opts.endpoint] - Your Azure endpoint, including the resource, e.g. `https://example-resource.azure.openai.com/`. Defaults to `process.env['AZURE_OPENAI_ENDPOINT'] ?? undefined`.
     * @param {string | undefined} [opts.apiKey] - Defaults to `process.env['AZURE_OPENAI_API_KEY'] ?? undefined`.
     * @param {string | undefined} opts.deployment - Azure model deployment inserted into supported deployment-scoped request paths.
     * @param {string | null | undefined} [opts.organization] - Defaults to `process.env['OPENAI_ORG_ID'] ?? null`.
     * @param {string} [opts.baseURL] - Sets the base URL for the API, e.g. `https://example-resource.azure.openai.com/openai/`. Defaults to `process.env['OPENAI_BASE_URL']`.
     * @param {number} [opts.timeout] - The maximum amount of time (in milliseconds) the client will wait for a response before timing out. Defaults to 10 minutes.
     * @param {() => Promise<string>} [opts.azureADTokenProvider] - Returns a fresh Microsoft Entra access token for each request; cannot be combined with `apiKey`.
     * @param {Fetch} [opts.fetch] - Specify a custom `fetch` function implementation.
     * @param {number} [opts.maxRetries] - The maximum number of times the client will retry a request. Defaults to `2`.
     * @param {Headers} opts.defaultHeaders - Default headers to include with every request to the API.
     * @param {DefaultQuery} opts.defaultQuery - Default query parameters to include with every request to the API.
     * @param {boolean} [opts.dangerouslyAllowBrowser] - By default, client-side use of this library is not allowed, as it risks exposing your secret API credentials to attackers. Defaults to `false`.
     */
    constructor({ baseURL, apiKey, apiVersion, endpoint, deployment, azureADTokenProvider, dangerouslyAllowBrowser, dataResidency, ...opts }?: AzureClientOptions);
    /** Clones this client with Azure options; OpenAI data residency remains unsupported. */
    withOptions(options: Partial<AzureClientOptions>): this;
    /** Builds an Azure request and inserts its deployment into model-scoped endpoint paths. */
    buildRequest(options: FinalRequestOptions, props?: {
        /** Number of retries already attempted for the current request. */
        retryCount?: number;
    }): Promise<{
        /** Fetch request options after authentication, headers, and the body are prepared. */
        req: RequestInit & {
            /** Fully resolved request headers sent to Azure OpenAI. */
            headers: Headers;
        };
        /** Absolute deployment-aware request URL. */
        url: string;
        /** Request timeout in milliseconds. */
        timeout: number;
    }>;
    protected fetchWithAuth(url: RequestInfo, init: RequestInit, timeout: number, controller: AbortController, schemes?: {
        bearerAuth?: boolean;
        adminAPIKeyAuth?: boolean;
    }): Promise<Response>;
    protected authHeaders(opts: FinalRequestOptions, schemes?: {
        bearerAuth?: boolean;
        adminAPIKeyAuth?: boolean;
    }): Promise<NullableHeaders | undefined>;
}
//# sourceMappingURL=azure.d.ts.map