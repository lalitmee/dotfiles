"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.AzureOpenAI = void 0;
const tslib_1 = require("./internal/tslib.js");
const headers_1 = require("./internal/headers.js");
const Errors = tslib_1.__importStar(require("./error.js"));
const utils_1 = require("./internal/utils.js");
const path_1 = require("./internal/utils/path.js");
const client_1 = require("./client.js");
const data_residency_1 = require("./internal/data-residency.js");
/** API Client for interfacing with the Azure OpenAI API. */
class AzureOpenAI extends client_1.OpenAI {
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
    constructor({ baseURL = (0, utils_1.readEnv)('OPENAI_BASE_URL'), apiKey = (0, utils_1.readEnv)('AZURE_OPENAI_API_KEY'), apiVersion = (0, utils_1.readEnv)('OPENAI_API_VERSION'), endpoint, deployment, azureADTokenProvider, dangerouslyAllowBrowser, dataResidency, ...opts } = {}) {
        (0, data_residency_1.assertNoDataResidency)(dataResidency, 'AzureOpenAI');
        if (!apiVersion) {
            throw new Errors.OpenAIError("The OPENAI_API_VERSION environment variable is missing or empty; either provide it, or instantiate the AzureOpenAI client with an apiVersion option, like new AzureOpenAI({ apiVersion: 'My API Version' }).");
        }
        // oxlint-disable-next-line anti-slop/no-runtime-typeof -- Azure accepts JavaScript credential configuration; distinguish static keys from callable token providers.
        if (typeof azureADTokenProvider === 'function') {
            dangerouslyAllowBrowser ?? (dangerouslyAllowBrowser = true);
        }
        if (!azureADTokenProvider && !apiKey) {
            throw new Errors.OpenAIError('Missing credentials. Please pass one of `apiKey` and `azureADTokenProvider`, or set the `AZURE_OPENAI_API_KEY` environment variable.');
        }
        if (azureADTokenProvider && apiKey) {
            throw new Errors.OpenAIError('The `apiKey` and `azureADTokenProvider` arguments are mutually exclusive; only one can be passed at a time.');
        }
        opts.defaultQuery = { ...opts.defaultQuery, 'api-version': apiVersion };
        if (!baseURL) {
            if (!endpoint) {
                endpoint = process.env['AZURE_OPENAI_ENDPOINT'];
            }
            if (!endpoint) {
                throw new Errors.OpenAIError('Must provide one of the `baseURL` or `endpoint` arguments, or the `AZURE_OPENAI_ENDPOINT` environment variable');
            }
            let endpointEnd = endpoint.length;
            while (endpointEnd > 0 && endpoint[endpointEnd - 1] === '/') {
                endpointEnd--;
            }
            baseURL = `${endpoint.slice(0, endpointEnd)}/openai`;
        }
        else if (endpoint) {
            throw new Errors.OpenAIError('baseURL and endpoint are mutually exclusive');
        }
        super({
            apiKey: azureADTokenProvider ?? apiKey,
            baseURL,
            ...opts,
            // Spread creates an own data property without invoking inherited setters or changing the object prototype.
            ...(dangerouslyAllowBrowser === undefined ? {} : { dangerouslyAllowBrowser }),
        });
        /** Azure OpenAI API version included in requests made by this client. */
        this.apiVersion = '';
        this.apiVersion = apiVersion;
        this.deploymentName = deployment;
    }
    /** Clones this client with Azure options; OpenAI data residency remains unsupported. */
    withOptions(options) {
        // `OpenAI.withOptions` rebuilds the clone from `this._options`, which never holds the
        // Azure-only construction options, so they are re-injected here the same way the Bedrock
        // client re-injects its own subclass-only field.
        const azureOptions = {
            apiVersion: this.apiVersion,
            deployment: this.deploymentName,
            ...options,
        };
        // The inherited base URL is always carried into the clone, so an `endpoint` override would
        // otherwise collide with it; let the endpoint rebuild the base URL instead. Both tests read
        // own properties, so an option bag that passed neither field keeps the inherited base URL.
        if ((0, utils_1.hasOwn)(options, 'endpoint') && options.endpoint !== undefined && !(0, utils_1.hasOwn)(options, 'baseURL')) {
            azureOptions.baseURL = undefined;
        }
        return super.withOptions(azureOptions);
    }
    /** Builds an Azure request and inserts its deployment into model-scoped endpoint paths. */
    async buildRequest(options, props = {}) {
        if (_deployments_endpoints.has(options.path) && options.method === 'post' && options.body !== undefined) {
            if (!(0, utils_1.isObj)(options.body)) {
                throw new Error('Expected request body to be an object');
            }
            const model = this.deploymentName || options.body['model'] || options.__metadata?.['model'];
            if (model !== undefined && !hasDeploymentPathSegment(this.baseURL)) {
                options.path = (0, path_1.path) `/deployments/${model}` + options.path;
            }
        }
        const built = await super.buildRequest(options, props);
        if (built.req.headers.has('api-key')) {
            built.req.redirect = 'manual';
        }
        return built;
    }
    async fetchWithAuth(url, init, timeout, controller, schemes) {
        if (new Headers(init.headers).has('api-key')) {
            init.redirect = 'manual';
        }
        return super.fetchWithAuth(url, init, timeout, controller, schemes);
    }
    async authHeaders(opts, schemes) {
        const security = schemes ?? { bearerAuth: true, adminAPIKeyAuth: true };
        // oxlint-disable-next-line anti-slop/no-runtime-typeof -- Azure accepts JavaScript credential configuration; distinguish static keys from callable token providers.
        if (security.bearerAuth && typeof this._options.apiKey === 'string') {
            return (0, headers_1.buildHeaders)([{ 'api-key': this.apiKey }]);
        }
        return super.authHeaders(opts, security);
    }
}
exports.AzureOpenAI = AzureOpenAI;
/**
 * Reports whether the base URL already routes through a `/deployments` path segment, so the
 * deployment must not be inserted again. A substring test would also match an unrelated segment
 * such as `/deployments-proxy/`, or a host like `deployments.example.com`.
 */
function hasDeploymentPathSegment(baseURL) {
    try {
        return new URL(baseURL).pathname.split('/').includes('deployments');
    }
    catch {
        // A base URL that is not an absolute URL has no path segments to read. Report none, the way
        // the previous substring test did, and let joining the request path reject it as it did before.
        return false;
    }
}
const _deployments_endpoints = new Set([
    '/completions',
    '/chat/completions',
    '/embeddings',
    '/audio/transcriptions',
    '/audio/translations',
    '/audio/speech',
    '/images/generations',
    '/batches',
    '/images/edits',
]);
//# sourceMappingURL=azure.js.map