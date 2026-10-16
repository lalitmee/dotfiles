var _a;
import * as Errors from "./error.mjs";
import { OpenAI } from "./client.mjs";
import { resolveRealtimeAPIKey } from "./internal/realtime-credentials.mjs";
import { assertNoDataResidency } from "./internal/data-residency.mjs";
import { assertBedrockRequestOrigin, assertValidBedrockBearerCredential, brand_privateBedrockClient, } from "./internal/bedrock.mjs";
import { buildHeaders } from "./internal/headers.mjs";
import { readEnv } from "./internal/utils.mjs";
import { addOutputText } from "./lib/ResponsesParser.mjs";
import * as API from "./resources/index.mjs";
/** Resolve the default Bedrock Mantle API root from the configured AWS region. */
function deriveBedrockBaseURL(awsRegion) {
    const region = awsRegion?.trim();
    if (!region) {
        throw new Errors.OpenAIError('Must provide one of the `baseURL` or `awsRegion` arguments, or set the `AWS_BEDROCK_BASE_URL`, `AWS_REGION`, or `AWS_DEFAULT_REGION` environment variable.');
    }
    if (!/^[a-z]{2,8}(?:-[a-z0-9]+)+-\d+$/u.test(region)) {
        throw new Errors.OpenAIError('The Bedrock AWS `region` is invalid. Use a standard AWS region such as `us-east-1`.');
    }
    return `https://bedrock-mantle.${region}.api.aws/openai/v1`;
}
/** Normalize a Bedrock Responses URL variant back to the provider API root. */
function normalizeBedrockBaseURL(baseURL) {
    const url = new URL(baseURL);
    const responsesMatch = url.pathname.match(/\/responses(?:\/.*)?$/);
    if (responsesMatch?.index !== undefined) {
        url.pathname = url.pathname.slice(0, responsesMatch.index) || '/';
    }
    return url.toString().replace(/\/$/, '');
}
/** Restore the SDK convenience property when Bedrock omits it from a streamed final response. */
function addBedrockOutputText(response) {
    if (!Object.getOwnPropertyDescriptor(response, 'output_text')) {
        addOutputText(response);
    }
    return response;
}
/** Keep the standard Responses surface while repairing Bedrock streamed final responses. */
function restoreBedrockStreamOutputText(responses) {
    const stream = responses.stream.bind(responses);
    // SAFETY: The wrapper forwards the original stream parameters and preserves its generic result, only repairing the final response's output_text property.
    responses.stream = ((body, options) => {
        const responseStream = stream(body, options);
        const finalResponse = responseStream.finalResponse.bind(responseStream);
        responseStream.finalResponse = async () => addBedrockOutputText(await finalResponse());
        return responseStream;
    });
    return responses;
}
/** API Client for interfacing with Amazon Bedrock's OpenAI-compatible endpoint. */
export class BedrockOpenAI extends OpenAI {
    /**
     * API Client for interfacing with Amazon Bedrock's OpenAI-compatible endpoint.
     *
     * @param {string | null | undefined} [opts.apiKey] - Defaults to `process.env['AWS_BEARER_TOKEN_BEDROCK'] ?? null`.
     * @param {string | null | undefined} [opts.baseURL] - Defaults to `process.env['AWS_BEDROCK_BASE_URL']`, or is derived from `opts.awsRegion`, `AWS_REGION`, or `AWS_DEFAULT_REGION`.
     * @param {string | undefined} [opts.awsRegion] - Defaults to `process.env['AWS_REGION'] ?? process.env['AWS_DEFAULT_REGION'] ?? undefined`.
     * @param {ApiKeySetter | undefined} opts.bedrockTokenProvider - A function that returns a Bedrock bearer token and is invoked before each request.
     */
    constructor({ baseURL = readEnv('AWS_BEDROCK_BASE_URL'), apiKey, awsRegion = readEnv('AWS_REGION') ?? readEnv('AWS_DEFAULT_REGION'), bedrockTokenProvider, adminAPIKey, workloadIdentity, x509Transport, dataResidency, ...opts } = {}) {
        assertNoDataResidency(dataResidency, 'BedrockOpenAI');
        if (adminAPIKey || workloadIdentity || x509Transport) {
            throw new Errors.OpenAIError('BedrockOpenAI only supports Bedrock bearer token authentication.');
        }
        if (apiKey === undefined && !bedrockTokenProvider) {
            apiKey = readEnv('AWS_BEARER_TOKEN_BEDROCK') ?? null;
        }
        // SAFETY: The widening keeps a runtime guard for JavaScript callers that supply an API-key function despite the declared string contract.
        // oxlint-disable-next-line anti-slop/no-runtime-typeof -- Reject a JavaScript function supplied as a static Bedrock API key before it can become a credential.
        if (typeof apiKey === 'function') {
            throw new Errors.OpenAIError('Pass refreshable Bedrock credentials via `bedrockTokenProvider`, not `apiKey`.');
        }
        if (apiKey && bedrockTokenProvider) {
            throw new Errors.OpenAIError('The `apiKey` and `bedrockTokenProvider` arguments are mutually exclusive; only one can be passed at a time.');
        }
        if (!apiKey && !bedrockTokenProvider) {
            throw new Errors.OpenAIError('Missing credentials. Please pass an `apiKey` or `bedrockTokenProvider`, or set the `AWS_BEARER_TOKEN_BEDROCK` environment variable.');
        }
        const configuredBaseURL = baseURL?.trim() ? baseURL : deriveBedrockBaseURL(awsRegion);
        super({
            apiKey: bedrockTokenProvider ?? apiKey,
            adminAPIKey: null,
            baseURL: normalizeBedrockBaseURL(configuredBaseURL),
            ...opts,
        });
        /**
         * Identifies this client to credential-bearing WebSocket helpers.
         *
         * @internal
         */
        this[_a] = true;
        let currentApiKey = this.apiKey;
        Object.defineProperty(this, 'apiKey', {
            enumerable: true,
            configurable: true,
            get() {
                if (currentApiKey !== null) {
                    assertValidBedrockBearerCredential(currentApiKey);
                }
                return currentApiKey;
            },
            set(nextApiKey) {
                currentApiKey = nextApiKey;
            },
        });
        const trustedBaseURL = this.baseURL;
        let currentBaseURL = trustedBaseURL;
        Object.defineProperty(this, 'baseURL', {
            enumerable: true,
            configurable: false,
            get() {
                return currentBaseURL;
            },
            set(nextBaseURL) {
                assertBedrockRequestOrigin(trustedBaseURL, nextBaseURL);
                currentBaseURL = nextBaseURL;
            },
        });
        this.bedrockTokenProvider = bedrockTokenProvider;
        this.responses = restoreBedrockStreamOutputText(new API.Responses(this));
    }
    async prepareOptions(options) {
        const configuredBaseURL = this._options.baseURL ?? this.baseURL;
        assertBedrockRequestOrigin(configuredBaseURL, this.buildURL(options.path, null, options.defaultBaseURL));
        await super.prepareOptions(options);
        assertBedrockRequestOrigin(configuredBaseURL, this.buildURL(options.path, null, options.defaultBaseURL));
    }
    async prepareRequest(request, context) {
        assertBedrockRequestOrigin(this._options.baseURL ?? this.baseURL, context.url);
        await super.prepareRequest(request, context);
        assertBedrockRequestOrigin(this._options.baseURL ?? this.baseURL, this.buildURL(context.options.path, null, context.options.defaultBaseURL));
        request.redirect = 'manual';
    }
    async authHeaders(opts, schemes) {
        const security = schemes ?? { bearerAuth: true, adminAPIKeyAuth: true };
        if (security.bearerAuth || security.adminAPIKeyAuth) {
            assertBedrockRequestOrigin(this._options.baseURL ?? this.baseURL, this.buildURL(opts.path, null, opts.defaultBaseURL));
            const { apiKey: credential } = await resolveRealtimeAPIKey(this);
            assertBedrockRequestOrigin(this._options.baseURL ?? this.baseURL, this.buildURL(opts.path, null, opts.defaultBaseURL));
            if (credential === null) {
                return undefined;
            }
            assertValidBedrockBearerCredential(credential);
            try {
                return buildHeaders([{ Authorization: `Bearer ${credential}` }]);
            }
            catch (error) {
                if (error instanceof TypeError) {
                    // oxlint-disable-next-line eslint/preserve-caught-error -- The original error contains the bearer credential.
                    throw new TypeError('Bedrock bearer credential contains an invalid HTTP header value.');
                }
                throw error;
            }
        }
        return super.authHeaders(opts, security);
    }
    /** Clones this client while preserving its refreshable Bedrock token provider when appropriate. */
    withOptions(options) {
        const bedrockTokenProvider = options.apiKey === undefined ? (options.bedrockTokenProvider ?? this.bedrockTokenProvider) : undefined;
        // SAFETY: Bedrock options extend the base client options; forwarding them preserves the subclass's existing withOptions construction behavior.
        return super.withOptions({
            ...options,
            // Spread creates an own data property without invoking inherited setters or changing the object prototype.
            ...(bedrockTokenProvider ? { apiKey: undefined, bedrockTokenProvider } : {}),
        });
    }
}
_a = brand_privateBedrockClient;
//# sourceMappingURL=bedrock.mjs.map