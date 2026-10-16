"use strict";
// File generated from our OpenAPI spec by Castiron. See CONTRIBUTING.md for details.
var _OpenAI_instances, _a, _OpenAI_encoder, _OpenAI_x509Authentication, _OpenAI_x509Credential, _OpenAI_x509Fetch, _OpenAI_explicitDataResidency, _OpenAI_responseAttempts, _OpenAI_baseURLOverridden;
Object.defineProperty(exports, "__esModule", { value: true });
exports.OpenAI = void 0;
const tslib_1 = require("./internal/tslib.js");
const uuid_1 = require("./internal/utils/uuid.js");
const values_1 = require("./internal/utils/values.js");
const sleep_1 = require("./internal/utils/sleep.js");
const abort_1 = require("./internal/utils/abort.js");
const errors_1 = require("./internal/errors.js");
const parse_1 = require("./internal/parse.js");
const detect_platform_1 = require("./internal/detect-platform.js");
const Shims = tslib_1.__importStar(require("./internal/shims.js"));
const Opts = tslib_1.__importStar(require("./internal/request-options.js"));
const query_1 = require("./internal/utils/query.js");
const version_1 = require("./version.js");
const data_residency_1 = require("./internal/data-residency.js");
const Errors = tslib_1.__importStar(require("./core/error.js"));
const Pagination = tslib_1.__importStar(require("./core/pagination.js"));
const workload_identity_auth_1 = require("./auth/workload-identity-auth.js");
const x509_api_origin_1 = require("./internal/auth/x509-api-origin.js");
const x509_workload_identity_auth_1 = require("./internal/auth/x509-workload-identity-auth.js");
const x509_credential_options_1 = require("./internal/auth/x509-credential-options.js");
const _x509_transport_state_1 = require('./internal/auth/x509-transport-state.js');
const error_1 = require("./core/error.js");
const Uploads = tslib_1.__importStar(require("./core/uploads.js"));
const API = tslib_1.__importStar(require("./resources/index.js"));
const api_promise_1 = require("./core/api-promise.js");
const realtime_credentials_1 = require("./internal/realtime-credentials.js");
const batches_1 = require("./resources/batches.js");
const completions_1 = require("./resources/completions.js");
const content_provenance_checks_1 = require("./resources/content-provenance-checks.js");
const embeddings_1 = require("./resources/embeddings.js");
const files_1 = require("./resources/files.js");
const images_1 = require("./resources/images.js");
const models_1 = require("./resources/models.js");
const moderations_1 = require("./resources/moderations.js");
const videos_1 = require("./resources/videos.js");
const admin_1 = require("./resources/admin/admin.js");
const audio_1 = require("./resources/audio/audio.js");
const beta_1 = require("./resources/beta/beta.js");
const chat_1 = require("./resources/chat/chat.js");
const containers_1 = require("./resources/containers/containers.js");
const conversations_1 = require("./resources/conversations/conversations.js");
const evals_1 = require("./resources/evals/evals.js");
const fine_tuning_1 = require("./resources/fine-tuning/fine-tuning.js");
const graders_1 = require("./resources/graders/graders.js");
const live_1 = require("./resources/live/live.js");
const realtime_1 = require("./resources/realtime/realtime.js");
const responses_1 = require("./resources/responses/responses.js");
const safety_1 = require("./resources/safety/safety.js");
const skills_1 = require("./resources/skills/skills.js");
const uploads_1 = require("./resources/uploads/uploads.js");
const vector_stores_1 = require("./resources/vector-stores/vector-stores.js");
const webhooks_1 = require("./resources/webhooks/webhooks.js");
const detect_platform_2 = require("./internal/detect-platform.js");
const headers_1 = require("./internal/headers.js");
const provider_1 = require("./internal/provider.js");
const env_1 = require("./internal/utils/env.js");
const log_1 = require("./internal/utils/log.js");
const values_2 = require("./internal/utils/values.js");
function isRunningInBrowserOrBrowserWorker() {
    if ((0, detect_platform_2.isRunningInBrowser)())
        return true;
    const scope = globalThis;
    return (typeof scope.WorkerGlobalScope === 'function' &&
        scope instanceof scope.WorkerGlobalScope &&
        typeof scope.WorkerNavigator === 'function' &&
        scope.navigator instanceof scope.WorkerNavigator &&
        typeof scope.navigator?.userAgent === 'string' &&
        scope.navigator.userAgent !== 'Cloudflare-Workers' &&
        scope.process?.versions?.node === undefined &&
        scope.Deno === undefined &&
        scope.Bun === undefined &&
        scope.EdgeRuntime === undefined &&
        scope.WebSocketPair === undefined);
}
const WORKLOAD_IDENTITY_API_KEY_PLACEHOLDER = 'workload-identity-auth';
const inheritedDataResidencySelection = Symbol('inheritedDataResidencySelection');
/**
 * API Client for interfacing with the OpenAI API.
 */
class OpenAI {
    /**
     * API Client for interfacing with the OpenAI API.
     *
     * @param {string | null | undefined} [opts.apiKey=process.env['OPENAI_API_KEY'] ?? null]
     * @param {string | null | undefined} [opts.adminAPIKey=process.env['OPENAI_ADMIN_KEY'] ?? null]
     * @param {string | null | undefined} [opts.organization=process.env['OPENAI_ORG_ID'] ?? null]
     * @param {string | null | undefined} [opts.project=process.env['OPENAI_PROJECT_ID'] ?? null]
     * @param {string | null | undefined} [opts.webhookSecret=process.env['OPENAI_WEBHOOK_SECRET'] ?? null]
     * @param {string} [opts.baseURL=process.env['OPENAI_BASE_URL'] ?? https://api.openai.com/v1] - Override the default base URL for the API.
     * @param {Provider} [opts.provider] - Configure a third-party API provider. Mutually exclusive with top-level authentication and base URL options.
     * @param {number} [opts.timeout=10 minutes] - The maximum amount of time (in milliseconds) the client will wait for a response before timing out.
     * @param {MergedRequestInit} [opts.fetchOptions] - Additional `RequestInit` options to be passed to `fetch` calls.
     * @param {Fetch} [opts.fetch] - Specify a custom `fetch` function implementation.
     * @param {number} [opts.maxRetries=2] - The maximum number of times the client will retry a request.
     * @param {HeadersLike} opts.defaultHeaders - Default headers to include with every request to the API.
     * @param {Record<string, string | undefined>} opts.defaultQuery - Default query parameters to include with every request to the API.
     * @param {boolean} [opts.dangerouslyAllowBrowser=false] - By default, client-side use of this library is not allowed, as it risks exposing your secret API credentials to attackers.
     */
    constructor(clientOptions = {}) {
        _OpenAI_instances.add(this);
        _OpenAI_encoder.set(this, void 0);
        _OpenAI_x509Authentication.set(this, void 0);
        _OpenAI_x509Credential.set(this, void 0);
        _OpenAI_x509Fetch.set(this, void 0);
        // Preserve an explicit global selection without storing a second routing URL.
        _OpenAI_explicitDataResidency.set(this, false);
        _OpenAI_responseAttempts.set(this, new WeakMap());
        /**
         * Given a prompt, the model will return one or more predicted completions, and can also return the probabilities of alternative tokens at each position.
         */
        this.completions = new API.Completions(this);
        this.chat = new API.Chat(this);
        /**
         * Get a vector representation of a given input that can be easily consumed by machine learning models and algorithms.
         */
        this.embeddings = new API.Embeddings(this);
        /**
         * Files are used to upload documents that can be used with features like Assistants and Fine-tuning.
         */
        this.files = new API.Files(this);
        /**
         * Given a prompt and/or an input image, the model will generate a new image.
         */
        this.images = new API.Images(this);
        this.contentProvenanceChecks = new API.ContentProvenanceChecks(this);
        this.audio = new API.Audio(this);
        /**
         * Given text and/or image inputs, classifies if those inputs are potentially harmful.
         */
        this.moderations = new API.Moderations(this);
        /**
         * List and describe the various models available in the API.
         */
        this.models = new API.Models(this);
        this.fineTuning = new API.FineTuning(this);
        this.graders = new API.Graders(this);
        this.vectorStores = new API.VectorStores(this);
        this.safety = new API.Safety(this);
        this.webhooks = new API.Webhooks(this);
        this.beta = new API.Beta(this);
        /**
         * Create large batches of API requests to run asynchronously.
         */
        this.batches = new API.Batches(this);
        /**
         * Use Uploads to upload large files in multiple parts.
         */
        this.uploads = new API.Uploads(this);
        this.admin = new API.Admin(this);
        this.responses = new API.Responses(this);
        this.live = new API.Live(this);
        this.realtime = new API.Realtime(this);
        /**
         * Manage conversations and conversation items.
         */
        this.conversations = new API.Conversations(this);
        /**
         * Manage and run evals in the OpenAI platform.
         */
        this.evals = new API.Evals(this);
        this.containers = new API.Containers(this);
        this.skills = new API.Skills(this);
        /**
         * @deprecated The Sora API is scheduled to permanently shut down on September 24, 2026.
         */
        this.videos = new API.Videos(this);
        const { credential, options: normalizedOptions } = (0, x509_credential_options_1.normalizeX509CredentialOptions)(clientOptions);
        clientOptions = normalizedOptions;
        const residencyBaseURL = (0, data_residency_1.resolveDataResidency)(clientOptions);
        const provider = clientOptions.provider;
        const { baseURL = provider ? null : (0, env_1.readEnv)('OPENAI_BASE_URL'), dataResidency: _dataResidency, [inheritedDataResidencySelection]: inheritedResidencySelection = false, apiKey = provider ? null : ((0, env_1.readEnv)('OPENAI_API_KEY') ?? null), adminAPIKey = provider ? null : ((0, env_1.readEnv)('OPENAI_ADMIN_KEY') ?? null), organization = provider ? null : ((0, env_1.readEnv)('OPENAI_ORG_ID') ?? null), project = provider ? null : ((0, env_1.readEnv)('OPENAI_PROJECT_ID') ?? null), webhookSecret = (0, env_1.readEnv)('OPENAI_WEBHOOK_SECRET') ?? null, workloadIdentity, x509Transport, credential: _credential, ...opts } = clientOptions;
        if (provider) {
            const conflictingOptions = ['apiKey', 'adminAPIKey', 'workloadIdentity', 'x509Transport', 'baseURL', 'dataResidency'].filter((key) => (key === 'workloadIdentity' ? workloadIdentity : clientOptions[key]) != null);
            if (conflictingOptions.length) {
                throw new Errors.OpenAIError(`The \`provider\` option cannot be used with ${conflictingOptions
                    .map((key) => `\`${key}\``)
                    .join(', ')}. Configure authentication and the base URL through the provider instead.`);
            }
        }
        const identity = (0, x509_workload_identity_auth_1.isX509WorkloadIdentity)(workloadIdentity)
            ? { x509: workloadIdentity, legacy: undefined }
            : { x509: undefined, legacy: workloadIdentity };
        const x509Identity = identity.x509;
        const usesX509Identity = x509Identity !== undefined;
        const providerRuntime = provider ? (0, provider_1.configureProvider)(provider) : undefined;
        const options = {
            apiKey,
            adminAPIKey,
            organization,
            project,
            webhookSecret,
            workloadIdentity,
            x509Transport,
            provider,
            ...opts,
            baseURL: providerRuntime?.baseURL ??
                residencyBaseURL ??
                (baseURL || (usesX509Identity ? x509_api_origin_1.X509_API_BASE_URL : `https://api.openai.com/v1`)),
        };
        if (x509Transport && !usesX509Identity) {
            throw new Errors.OpenAIError('An X.509 transport requires an X.509 workload identity.');
        }
        if (usesX509Identity) {
            if (residencyBaseURL !== undefined || inheritedResidencySelection) {
                throw new Errors.OpenAIError('X.509 workload identity does not support data residency selection.');
            }
            if (clientOptions.fetch !== undefined) {
                throw new Errors.OpenAIError('X.509 workload identity does not support a custom fetch implementation.');
            }
            (0, x509_api_origin_1.assertX509APIOrigin)(options.baseURL);
            (0, x509_workload_identity_auth_1.assertX509RequestOptions)(options.fetchOptions);
            if (this.fetchWithAuth !== _a.prototype.fetchWithAuth ||
                this.fetchWithTimeout !== _a.prototype.fetchWithTimeout) {
                throw new Errors.OpenAIError('X.509 workload identity does not support overridden fetch dispatch hooks.');
            }
        }
        if (apiKey && workloadIdentity) {
            throw new Errors.OpenAIError('The `apiKey` and `workloadIdentity` options are mutually exclusive');
        }
        if (!providerRuntime && !apiKey && !adminAPIKey && !workloadIdentity) {
            throw new Errors.OpenAIError('Missing credentials. Please pass an `apiKey`, `workloadIdentity`, `adminAPIKey`, or set the `OPENAI_API_KEY` or `OPENAI_ADMIN_KEY` environment variable.');
        }
        if (!options.dangerouslyAllowBrowser && isRunningInBrowserOrBrowserWorker()) {
            throw new Errors.OpenAIError("It looks like you're running in a browser-like environment.\n\nThis is disabled by default, as it risks exposing your secret API credentials to attackers.\nIf you understand the risks and have appropriate mitigations in place,\nyou can set the `dangerouslyAllowBrowser` option to `true`, e.g.,\n\nnew OpenAI({ apiKey, dangerouslyAllowBrowser: true });\n\nhttps://help.openai.com/en/articles/5112595-best-practices-for-api-key-safety\n");
        }
        this.baseURL = options.baseURL;
        tslib_1.__classPrivateFieldSet(this, _OpenAI_explicitDataResidency, residencyBaseURL !== undefined || inheritedResidencySelection, "f");
        this.timeout = options.timeout ?? _a.DEFAULT_TIMEOUT; /* 10 minutes */
        this.logger = options.logger ?? console;
        const defaultLogLevel = 'warn';
        // Set default logLevel early so that we can log a warning in parseLogLevel.
        this.logLevel = defaultLogLevel;
        this.logLevel =
            (0, log_1.parseLogLevel)(options.logLevel, 'ClientOptions.logLevel', this) ??
                (0, log_1.parseLogLevel)((0, env_1.readEnv)('OPENAI_LOG'), "process.env['OPENAI_LOG']", this) ??
                defaultLogLevel;
        this.fetchOptions = options.fetchOptions;
        this.maxRetries = options.maxRetries ?? 2;
        this.fetch = options.fetch ?? Shims.getDefaultFetch();
        tslib_1.__classPrivateFieldSet(this, _OpenAI_encoder, Opts.FallbackEncoder, "f");
        const customHeadersEnv = provider || credential ? undefined : (0, env_1.readEnv)('OPENAI_CUSTOM_HEADERS');
        if (customHeadersEnv) {
            const parsed = {};
            for (const line of customHeadersEnv.split('\n')) {
                const colon = line.indexOf(':');
                if (colon >= 0) {
                    parsed[line.substring(0, colon).trim()] = line.substring(colon + 1).trim();
                }
            }
            options.defaultHeaders = (0, headers_1.buildHeaders)([parsed, options.defaultHeaders]);
        }
        this._options = options;
        this._provider = providerRuntime;
        if (x509Identity) {
            const authentication = new x509_workload_identity_auth_1.X509WorkloadIdentityAuth(x509Identity, x509Transport, organization, project);
            this._workloadIdentityAuth = authentication;
            tslib_1.__classPrivateFieldSet(this, _OpenAI_x509Authentication, authentication, "f");
            tslib_1.__classPrivateFieldSet(this, _OpenAI_x509Credential, credential, "f");
            tslib_1.__classPrivateFieldSet(this, _OpenAI_x509Fetch, authentication.fetch(), "f");
            this.fetch = tslib_1.__classPrivateFieldGet(this, _OpenAI_x509Fetch, "f");
            (0, _x509_transport_state_1.markApprovedX509Client)(this);
        }
        else if (identity.legacy) {
            this._workloadIdentityAuth = new workload_identity_auth_1.WorkloadIdentityAuth(identity.legacy, this.fetch);
        }
        this.apiKey = typeof apiKey === 'string' ? apiKey : null;
        this.adminAPIKey = adminAPIKey;
        this.organization = organization;
        this.project = project;
        this.webhookSecret = webhookSecret;
    }
    /**
     * Create a new client instance re-using the same options given to the current client with optional overriding.
     */
    withOptions(options) {
        const residencyBaseURL = (0, data_residency_1.resolveDataResidency)(options);
        const x509Authentication = tslib_1.__classPrivateFieldGet(this, _OpenAI_x509Authentication, "f");
        const inheritedOptions = {
            ...this._options,
            baseURL: this.baseURL,
            maxRetries: this.maxRetries,
            timeout: this.timeout,
            logger: this.logger,
            logLevel: this.logLevel,
            fetch: tslib_1.__classPrivateFieldGet(this, _OpenAI_x509Authentication, "f") ? undefined : this.fetch,
            fetchOptions: this.fetchOptions,
            apiKey: this._options.apiKey,
            adminAPIKey: this.adminAPIKey,
            workloadIdentity: x509Authentication?.identitySnapshot() ?? this._options.workloadIdentity,
            x509Transport: this._options.x509Transport,
            organization: this.organization,
            project: this.project,
            webhookSecret: this.webhookSecret,
        };
        const { credential, provider } = (0, x509_credential_options_1.prepareX509ClientClone)(inheritedOptions, options, tslib_1.__classPrivateFieldGet(this, _OpenAI_x509Credential, "f"), x509Authentication !== undefined);
        if (residencyBaseURL !== undefined) {
            delete inheritedOptions.baseURL;
        }
        const clientOptions = {
            ...inheritedOptions,
            ...options,
            credential,
            provider,
            [inheritedDataResidencySelection]: tslib_1.__classPrivateFieldGet(this, _OpenAI_explicitDataResidency, "f") &&
                residencyBaseURL === undefined &&
                !(0, values_1.hasOwn)(options, 'baseURL') &&
                options.credential === undefined &&
                !provider,
        };
        const client = new this.constructor(clientOptions);
        if (provider && new URL(client.baseURL).origin !== new URL(this.baseURL).origin) {
            Object.assign(client._options, {
                defaultHeaders: options.defaultHeaders,
                defaultQuery: options.defaultQuery,
                fetchOptions: options.fetchOptions,
                fetch: options.fetch,
            });
            client.fetchOptions = options.fetchOptions;
            client.fetch = options.fetch ?? Shims.getDefaultFetch();
            client.organization = options.organization ?? null;
            client.project = options.project ?? null;
        }
        if (tslib_1.__classPrivateFieldGet(this, _OpenAI_x509Authentication, "f") &&
            tslib_1.__classPrivateFieldGet(client, _OpenAI_x509Authentication, "f") &&
            this.baseURL === client.baseURL &&
            tslib_1.__classPrivateFieldGet(this, _OpenAI_x509Authentication, "f").matches(tslib_1.__classPrivateFieldGet(client, _OpenAI_x509Authentication, "f"))) {
            client._workloadIdentityAuth = tslib_1.__classPrivateFieldGet(this, _OpenAI_x509Authentication, "f");
            tslib_1.__classPrivateFieldSet(client, _OpenAI_x509Authentication, tslib_1.__classPrivateFieldGet(this, _OpenAI_x509Authentication, "f"), "f");
            tslib_1.__classPrivateFieldSet(client, _OpenAI_x509Fetch, tslib_1.__classPrivateFieldGet(this, _OpenAI_x509Fetch, "f"), "f");
        }
        return client;
    }
    defaultQuery() {
        return this._options.defaultQuery;
    }
    /** @internal Client request headers for each new WebSocket handshake. */
    _buildWebSocketHeaders(authHeaders) {
        return Object.fromEntries((0, headers_1.buildHeaders)([
            {
                'User-Agent': this.getUserAgent(),
                'OpenAI-Organization': this.organization,
                'OpenAI-Project': this.project,
            },
            authHeaders,
            this._options.defaultHeaders,
        ]).values);
    }
    validateHeaders({ values, nulls }, schemes = {
        bearerAuth: true,
        adminAPIKeyAuth: true,
    }) {
        if (values.get('authorization') || values.get('api-key')) {
            return;
        }
        if (nulls.has('authorization') || nulls.has('api-key')) {
            return;
        }
        if (this._workloadIdentityAuth && schemes.bearerAuth) {
            return;
        }
        throw new Error('Could not resolve authentication method. Expected either apiKey or adminAPIKey to be set. Or for one of the "Authorization" or "api-key" headers to be explicitly omitted');
    }
    async authHeaders(opts, schemes = {
        bearerAuth: true,
        adminAPIKeyAuth: true,
    }) {
        const authentication = tslib_1.__classPrivateFieldGet(this, _OpenAI_x509Authentication, "f") ?? this._workloadIdentityAuth;
        if (authentication instanceof x509_workload_identity_auth_1.X509WorkloadIdentityAuth &&
            schemes.adminAPIKeyAuth &&
            this.adminAPIKey !== null) {
            return await this.adminAPIKeyAuth(opts);
        }
        return (0, headers_1.buildHeaders)([
            schemes.bearerAuth ? await this.bearerAuth(opts) : null,
            schemes.adminAPIKeyAuth ? await this.adminAPIKeyAuth(opts) : null,
        ]);
    }
    async bearerAuth(opts) {
        const authentication = tslib_1.__classPrivateFieldGet(this, _OpenAI_x509Authentication, "f") ?? this._workloadIdentityAuth;
        if (authentication) {
            if (authentication instanceof x509_workload_identity_auth_1.X509WorkloadIdentityAuth) {
                if (authentication === this._workloadIdentityAuth &&
                    (this.fetchWithAuth !== _a.prototype.fetchWithAuth ||
                        this.fetchWithTimeout !== _a.prototype.fetchWithTimeout)) {
                    throw new Errors.OpenAIError('X.509 workload identity does not support overridden fetch dispatch hooks.');
                }
                const snapshots = authentication.headerSnapshots();
                if (!x509_workload_identity_auth_1.X509WorkloadIdentityAuth.shouldAuthenticate(opts, snapshots.defaultHeaders, snapshots.requestHeaders)) {
                    return undefined;
                }
            }
            const token = authentication instanceof x509_workload_identity_auth_1.X509WorkloadIdentityAuth
                ? await authentication.getToken(opts, {
                    apiURL: authentication.requestAPIURL(),
                    ...authentication.headerSnapshots(),
                    ...authentication.requestSnapshot(),
                    signal: authentication.effectiveSignal(),
                    ...authentication.tenantSnapshot(),
                })
                : await authentication.getToken();
            return (0, headers_1.buildHeaders)([{ Authorization: `Bearer ${token}` }]);
        }
        const { apiKey } = await (0, realtime_credentials_1.resolveRealtimeAPIKey)(this);
        if (apiKey == null) {
            return undefined;
        }
        return (0, headers_1.buildHeaders)([{ Authorization: `Bearer ${apiKey}` }]);
    }
    async adminAPIKeyAuth(opts) {
        if (this.adminAPIKey == null) {
            return undefined;
        }
        return (0, headers_1.buildHeaders)([{ Authorization: `Bearer ${this.adminAPIKey}` }]);
    }
    stringifyQuery(query) {
        return (0, query_1.stringifyQuery)(query);
    }
    getUserAgent() {
        return `${this.constructor.name}/JS ${version_1.VERSION}`;
    }
    defaultIdempotencyKey() {
        return `stainless-node-retry-${(0, uuid_1.uuid4)()}`;
    }
    makeStatusError(status, error, message, headers) {
        const normalizedError = error && typeof error === 'object' && error.error == null ? { error } : error;
        return Errors.APIError.generate(status, normalizedError, message, headers);
    }
    _hasApiKeyProvider() {
        return typeof this._options.apiKey === 'function';
    }
    /**
     * Resolves a function-based API key and retains the resolved value on this client.
     * Returns whether a provider was invoked. Internal callers can capture this
     * invocation's key before another request updates the shared `apiKey` property.
     * Overrides should forward `capture` or invoke it with their own resolved key
     * to preserve invocation-local credentials in concurrent requests and Realtime factories.
     * @internal
     */
    async _callApiKey(capture) {
        if (this._provider) {
            capture?.(this.apiKey);
            return false;
        }
        const apiKey = this._options.apiKey;
        if (typeof apiKey !== 'function') {
            capture?.(this.apiKey);
            return false;
        }
        let token;
        try {
            token = await apiKey();
        }
        catch (err) {
            if (err instanceof Errors.OpenAIError)
                throw err;
            throw new Errors.OpenAIError(`Failed to get token from 'apiKey' function: ${err.message}`, 
            // @ts-ignore
            { cause: err });
        }
        if (typeof token !== 'string' || !token) {
            throw new Errors.OpenAIError(`Expected 'apiKey' function argument to return a string but it returned ${token}`);
        }
        this.apiKey = token;
        capture?.(this.apiKey);
        return true;
    }
    buildURL(path, query, defaultBaseURL) {
        const baseURL = (!tslib_1.__classPrivateFieldGet(this, _OpenAI_instances, "m", _OpenAI_baseURLOverridden).call(this) && defaultBaseURL) || this.baseURL;
        const url = (0, values_1.isAbsoluteURL)(path)
            ? new URL(path)
            : new URL(baseURL + (baseURL.endsWith('/') && path.startsWith('/') ? path.slice(1) : path));
        const defaultQuery = this.defaultQuery();
        const pathQuery = Object.fromEntries(url.searchParams);
        if (!(0, values_2.isEmptyObj)(defaultQuery) || !(0, values_2.isEmptyObj)(pathQuery)) {
            query = { ...pathQuery, ...defaultQuery, ...query };
        }
        if (typeof query === 'object' && query && !Array.isArray(query)) {
            url.search = this.stringifyQuery(query);
        }
        return url.toString();
    }
    /**
     * Used as a callback for mutating the given `FinalRequestOptions` object.
     * Function-based credentials are resolved later, when building authentication
     * headers, including for direct `buildRequest()` calls. Overriding this hook
     * does not bypass that resolution.
     */
    async prepareOptions(options) { }
    /**
     * Used as a callback for mutating the given `RequestInit` object.
     *
     * This is useful for cases where you want to add certain headers based off of
     * the request properties, e.g. `method` or `url`.
     */
    async prepareRequest(request, { url, options }) { }
    get(path, opts) {
        return this.methodRequest('get', path, opts);
    }
    post(path, opts) {
        return this.methodRequest('post', path, opts);
    }
    patch(path, opts) {
        return this.methodRequest('patch', path, opts);
    }
    put(path, opts) {
        return this.methodRequest('put', path, opts);
    }
    delete(path, opts) {
        return this.methodRequest('delete', path, opts);
    }
    methodRequest(method, path, opts) {
        return this.request(Promise.resolve(opts).then((opts) => {
            return { method, path, ...opts };
        }));
    }
    request(options, remainingRetries = null) {
        const authentication = tslib_1.__classPrivateFieldGet(this, _OpenAI_x509Authentication, "f") ?? this._workloadIdentityAuth;
        const request = authentication instanceof x509_workload_identity_auth_1.X509WorkloadIdentityAuth
            ? Promise.resolve(options).then((resolved) => authentication.runRequest(() => this.makeRequest(resolved, remainingRetries, undefined), this))
            : this.makeRequest(options, remainingRetries, undefined);
        return this.responsePromise(request);
    }
    responsePromise(request, parse = (client, props) => this.parseResponseWithTimeout(client, props)) {
        const promise = new api_promise_1.APIPromise(this, request, (client, props) => {
            const resume = tslib_1.__classPrivateFieldGet(this, _OpenAI_responseAttempts, "f").get(props.controller)?.continueRequest;
            return resume ? resume(() => parse(client, props)) : parse(client, props);
        });
        // A body timeout can retry after the original raw response has arrived. Wait for
        // parsing before selecting the response so withResponse() reports the retry.
        promise.withResponse = async () => {
            const data = await promise;
            const { response } = await request;
            return { data, response, request_id: response.headers.get('x-request-id') };
        };
        promise._thenUnwrap = (transform) => this.responsePromise(request, async (client, props) => (0, parse_1.addRequestID)(transform(await parse(client, props), props), props.response));
        return promise;
    }
    async parseResponseWithTimeout(client, props) {
        if (props.options.stream ||
            props.options.__binaryResponse ||
            props.response.status === 204 ||
            props.response.headers.get('content-length') === '0') {
            return (0, parse_1.defaultParseResponse)(client, props);
        }
        while (true) {
            const attempt = tslib_1.__classPrivateFieldGet(this, _OpenAI_responseAttempts, "f").get(props.controller);
            const timeout = attempt?.timeout ?? props.options.timeout ?? this.timeout;
            const x509Authentication = attempt?.authentication;
            const callerSignal = x509Authentication ? props.controller.signal : props.options.signal;
            const abortError = () => x509Authentication && callerSignal
                ? this._makeUserAbortError(callerSignal)
                : new Errors.APIUserAbortError();
            let remaining;
            try {
                remaining =
                    x509Authentication?.remainingTimeout(props.options, timeout) ??
                        Math.max(0, props.startTime + timeout - Date.now());
            }
            catch (error) {
                const cancellation = callerSignal?.aborted ? abortError() : undefined;
                props.controller.abort();
                void Shims.CancelReadableStream(props.response.body).catch(() => undefined);
                throw cancellation ?? error;
            }
            let timer;
            let abortListener;
            let timedOut = false;
            try {
                // Tool runners preserve a completed buffered turn before cancellation stops the next request.
                if (callerSignal?.aborted && attempt?.helperMethod !== 'runTools') {
                    throw abortError();
                }
                const timeoutPromise = new Promise((_, reject) => {
                    timer = setTimeout(() => {
                        timedOut = true;
                        props.controller.abort();
                        reject(new Errors.APIConnectionTimeoutError());
                    }, remaining);
                    if (callerSignal) {
                        abortListener = () => {
                            if (!timedOut)
                                reject(abortError());
                        };
                        callerSignal.addEventListener('abort', abortListener, { once: true });
                    }
                });
                return await Promise.race([(0, parse_1.defaultParseResponse)(client, props), timeoutPromise]);
            }
            catch (error) {
                if (callerSignal?.aborted && !timedOut) {
                    throw abortError();
                }
                if (!timedOut) {
                    if (x509Authentication && error instanceof SyntaxError) {
                        throw new SyntaxError('X.509 workload identity API response contains invalid JSON.');
                    }
                    if (x509Authentication && !(error instanceof Errors.OpenAIError)) {
                        throw new Errors.APIConnectionError({
                            message: 'X.509 workload identity API response body could not be read.',
                        });
                    }
                    throw error;
                }
                const retriesRemaining = attempt?.retriesRemaining ?? 0;
                if (!retriesRemaining ||
                    attempt?.hasStreamingBody ||
                    props.options.__metadata?.['hasStreamingBody'] ||
                    (globalThis.ReadableStream &&
                        props.options.body instanceof globalThis.ReadableStream) ||
                    (typeof props.options.body === 'object' &&
                        props.options.body !== null &&
                        (Symbol.asyncIterator in props.options.body ||
                            (Symbol.iterator in props.options.body &&
                                'next' in props.options.body &&
                                typeof props.options.body.next === 'function')))) {
                    throw new Errors.APIConnectionTimeoutError();
                }
                if (timer !== undefined)
                    clearTimeout(timer);
                if (abortListener)
                    callerSignal?.removeEventListener('abort', abortListener);
                abortListener = undefined;
                const next = await this.retryRequest(props.options, retriesRemaining, props.retryOfRequestLogID ?? props.requestLogID, undefined, props.requestSignal);
                Object.assign(props, next);
            }
            finally {
                if (timer !== undefined)
                    clearTimeout(timer);
                if (abortListener)
                    callerSignal?.removeEventListener('abort', abortListener);
            }
        }
    }
    /** Keeps terminal X.509 error-body consumption inside the original logical request deadline. */
    async readX509ResponseError(response, options, timeout, controller, authentication) {
        const deadline = new AbortController();
        const callerSignal = controller.signal;
        let timedOut = false;
        const cancel = () => deadline.abort(callerSignal.reason);
        callerSignal.addEventListener('abort', cancel, { once: true });
        if (callerSignal.aborted) {
            cancel();
        }
        try {
            const remaining = authentication.remainingTimeout(options, timeout);
            const expiration = authentication.waitForRetry(remaining, deadline.signal).then(() => {
                throw new Errors.APIConnectionTimeoutError();
            });
            const body = await Promise.race([
                response.text().catch(() => 'X.509 workload identity API response body could not be read.'),
                expiration,
            ]);
            if (callerSignal.aborted) {
                throw this._makeUserAbortError(callerSignal);
            }
            return body;
        }
        catch (error) {
            if (error instanceof Errors.APIConnectionTimeoutError) {
                timedOut = !callerSignal.aborted;
                controller.abort();
                void Shims.CancelReadableStream(response.body).catch(() => undefined);
            }
            if (callerSignal.aborted && !timedOut) {
                throw this._makeUserAbortError(callerSignal);
            }
            throw error;
        }
        finally {
            callerSignal.removeEventListener('abort', cancel);
            deadline.abort();
        }
    }
    async makeRequest(optionsInput, retriesRemaining, retryOfRequestLogID) {
        const options = await optionsInput;
        const maxRetries = options.maxRetries ?? this.maxRetries;
        if (retriesRemaining == null) {
            retriesRemaining = maxRetries;
        }
        const x509Authentication = tslib_1.__classPrivateFieldGet(this, _OpenAI_x509Authentication, "f");
        x509Authentication?.beginRequestPreparation();
        await this.prepareOptions(options);
        x509Authentication?.beginRequestPlanning();
        let built;
        try {
            const candidate = await this.buildRequest(options, {
                retryCount: maxRetries - retriesRemaining,
            });
            built = { req: candidate.req, url: candidate.url, timeout: candidate.timeout };
            if (x509Authentication) {
                (0, values_1.validatePositiveInteger)('timeout', built.timeout);
                x509Authentication.authorizePlannedRequest(built.url, built.req, built.timeout);
                if (x509_workload_identity_auth_1.X509WorkloadIdentityAuth.isStreamingRequestBody(built.req.body)) {
                    options.__metadata = { ...options.__metadata, hasStreamingBody: true };
                }
                await this.prepareRequest(built.req, { url: built.url, options });
                await this._provider?.prepareRequest?.(built.req, { url: built.url, options });
                x509Authentication.beginRequestPlanning();
                x509Authentication.authorizePlannedRequest(built.url, built.req, built.timeout, true);
                if (x509_workload_identity_auth_1.X509WorkloadIdentityAuth.isStreamingRequestBody(built.req.body)) {
                    options.__metadata = { ...options.__metadata, hasStreamingBody: true };
                }
                const callerSignal = x509Authentication.requestSnapshot().signal;
                if (callerSignal?.aborted || built.req.signal?.aborted) {
                    throw this._makeUserAbortError(callerSignal?.aborted ? callerSignal : built.req.signal);
                }
                x509Authentication.setEffectiveSignal(built.req.signal || callerSignal
                    ? createRequestController(built.req.signal ?? callerSignal, callerSignal).signal
                    : undefined);
                x509Authentication.beginRequestNetwork();
                const security = options.__security ?? { bearerAuth: true };
                const authenticationHeaders = await this.authHeaders(options, security);
                const suppliedHeaders = x509Authentication.headerSnapshots();
                const supplied = (0, headers_1.buildHeaders)([suppliedHeaders.defaultHeaders, suppliedHeaders.requestHeaders]);
                for (const [name, value] of authenticationHeaders?.values ?? []) {
                    if (!supplied.nulls.has(name) && !built.req.headers.has(name)) {
                        built.req.headers.set(name, value);
                    }
                }
                this.validateHeaders((0, headers_1.buildHeaders)([supplied, built.req.headers]), security);
            }
        }
        catch (error) {
            x509Authentication?.retireRequestBody();
            if (x509Authentication &&
                retriesRemaining &&
                !options.__metadata?.['hasStreamingBody'] &&
                x509_workload_identity_auth_1.X509WorkloadIdentityAuth.isRetryableFailure(error)) {
                return await this.retryRequest(options, retriesRemaining, retryOfRequestLogID ?? 'x509-token-exchange', x509_workload_identity_auth_1.X509WorkloadIdentityAuth.retryHeaders(error));
            }
            throw error;
        }
        const { req, url } = built;
        const timeout = x509Authentication
            ? Math.min(built.timeout, x509Authentication.requestSnapshot().timeout)
            : built.timeout;
        x509Authentication?.bindRequest(options, req, this.adminAPIKey);
        let hasStreamingBody = options.__metadata?.['hasStreamingBody'] === true;
        if (!x509Authentication) {
            await this.prepareRequest(req, { url, options });
            await this._provider?.prepareRequest?.(req, { url, options });
        }
        x509Authentication?.adoptRequestHeaders(req);
        if (x509Authentication && x509_workload_identity_auth_1.X509WorkloadIdentityAuth.isStreamingRequestBody(req.body)) {
            hasStreamingBody = true;
        }
        /** Not an API request ID, just for correlating local log entries. */
        const requestLogID = 'log_' + ((Math.random() * (1 << 24)) | 0).toString(16).padStart(6, '0');
        const retryLogStr = retryOfRequestLogID === undefined ? '' : `, retryOf: ${retryOfRequestLogID}`;
        const startTime = x509Authentication?.requestStartedAt(options) ?? Date.now();
        if (this.logLevel === 'debug') {
            // Summarize serialized strings without reparsing or re-running caller serialization hooks.
            const body = typeof req.body === 'string' ? { type: 'string', length: req.body.length } : req.body;
            (0, log_1.loggerFor)(this).debug(`[${requestLogID}] sending request`, (0, log_1.formatRequestDetails)({
                retryOfRequestLogID,
                method: options.method,
                url,
                options: x509Authentication
                    ? { body, ...x509Authentication.requestSnapshot() }
                    : { ...options, body },
                headers: req.headers,
            }));
        }
        const callerSignal = x509Authentication ? x509Authentication.requestSnapshot().signal : options.signal;
        if (callerSignal?.aborted || req.signal?.aborted) {
            throw this._makeUserAbortError(callerSignal?.aborted ? callerSignal : req.signal);
        }
        const security = options.__security ?? { bearerAuth: true };
        // Request hooks may replace the caller signal before it reaches fetch.
        const controller = x509Authentication || this.fetchWithTimeout === _a.prototype.fetchWithTimeout
            ? createRequestController(req.signal ?? (x509Authentication ? callerSignal : undefined), x509Authentication ? callerSignal : undefined)
            : new AbortController();
        const remainingTimeout = x509Authentication?.remainingTimeout(options, timeout) ?? timeout;
        const fetchWithAuth = x509Authentication ? _a.prototype.fetchWithAuth : this.fetchWithAuth;
        x509Authentication?.releaseRequestBody(req.body);
        const response = await fetchWithAuth
            .call(this, url, req, remainingTimeout, controller, security)
            .catch(errors_1.castToError);
        const headersTime = Date.now();
        if (response instanceof globalThis.Error) {
            const retryMessage = `retrying, ${retriesRemaining} attempts remaining`;
            if (callerSignal?.aborted || req.signal?.aborted) {
                throw this._makeUserAbortError(callerSignal?.aborted ? callerSignal : req.signal);
            }
            // detect native connection timeout errors
            // deno throws "TypeError: error sending request for url (https://example/): client error (Connect): tcp connect error: Operation timed out (os error 60): Operation timed out (os error 60)"
            // undici throws "TypeError: fetch failed" with cause "ConnectTimeoutError: Connect Timeout Error (attempted address: example:443, timeout: 1ms)"
            // others do not provide enough information to distinguish timeouts from other connection errors
            const isTimeout = (0, errors_1.isAbortError)(response) ||
                /timed? ?out/i.test(String(response) + ('cause' in response ? String(response.cause) : ''));
            if (retriesRemaining &&
                !hasStreamingBody &&
                (!x509Authentication || (0, _x509_transport_state_1.isTransientX509ConnectionError)(response))) {
                (0, log_1.loggerFor)(this).info(`[${requestLogID}] connection ${isTimeout ? 'timed out' : 'failed'} - ${retryMessage}`);
                (0, log_1.loggerFor)(this).debug(`[${requestLogID}] connection ${isTimeout ? 'timed out' : 'failed'} (${retryMessage})`, (0, log_1.formatRequestDetails)({
                    retryOfRequestLogID,
                    url,
                    durationMs: headersTime - startTime,
                    message: x509Authentication ? 'X.509 workload identity API connection failed.' : response.message,
                }));
                return this.retryRequest(options, retriesRemaining, retryOfRequestLogID ?? requestLogID, undefined, req.signal);
            }
            const terminalMessage = hasStreamingBody
                ? 'error; streaming body cannot be retried'
                : 'error; no more retries left';
            (0, log_1.loggerFor)(this).info(`[${requestLogID}] connection ${isTimeout ? 'timed out' : 'failed'} - ${terminalMessage}`);
            (0, log_1.loggerFor)(this).debug(`[${requestLogID}] connection ${isTimeout ? 'timed out' : 'failed'} (${terminalMessage})`, (0, log_1.formatRequestDetails)({
                retryOfRequestLogID,
                url,
                durationMs: headersTime - startTime,
                message: x509Authentication ? 'X.509 workload identity API connection failed.' : response.message,
            }));
            if (response instanceof error_1.OAuthError || response instanceof error_1.SubjectTokenProviderError) {
                throw response;
            }
            if (isTimeout) {
                const transportCause = 'cause' in response ? response.cause : undefined;
                const isHeadersTimeout = typeof transportCause === 'object' &&
                    transportCause !== null &&
                    'code' in transportCause &&
                    transportCause.code === 'UND_ERR_HEADERS_TIMEOUT';
                const timeoutError = isHeadersTimeout
                    ? new Errors.APIConnectionTimeoutError({
                        message: 'Request timed out. Node.js fetch timed out waiting for response headers; ' +
                            'configure a matching undici fetch and fetchOptions.dispatcher with an Agent whose headersTimeout is at least the SDK timeout.',
                    })
                    : new Errors.APIConnectionTimeoutError();
                if (x509Authentication) {
                    throw new Errors.APIConnectionTimeoutError();
                }
                throw Object.assign(timeoutError, { cause: response });
            }
            if (x509Authentication) {
                throw new Errors.APIConnectionError({ message: 'X.509 workload identity API connection failed.' });
            }
            throw new Errors.APIConnectionError({
                message: getConnectionErrorMessage(response),
                cause: response,
            });
        }
        const specialHeaders = [...response.headers.entries()]
            .filter(([name]) => name === 'x-request-id')
            .map(([name, value]) => ', ' + name + ': ' + JSON.stringify(value))
            .join('');
        const responseInfo = `[${requestLogID}${retryLogStr}${specialHeaders}] ${req.method} ${(0, log_1.redactURL)(url)} ${response.ok ? 'succeeded' : 'failed'} with status ${response.status} in ${headersTime - startTime}ms`;
        if (!response.ok) {
            const rejectedX509Credential = response.status === 401 &&
                x509Authentication &&
                security.bearerAuth &&
                x509Authentication.usedWorkloadToken(options);
            if (rejectedX509Credential) {
                x509Authentication.invalidateToken();
            }
            if (response.status === 401 &&
                (x509Authentication || this._workloadIdentityAuth) &&
                security.bearerAuth &&
                (!x509Authentication || x509Authentication.usedWorkloadToken(options)) &&
                (!x509Authentication || retriesRemaining > 0) &&
                !hasStreamingBody &&
                !options.__metadata?.['workloadIdentityTokenRefreshed']) {
                if (x509Authentication) {
                    void Shims.CancelReadableStream(response.body).catch(() => undefined);
                }
                else {
                    await Shims.CancelReadableStream(response.body);
                    this._workloadIdentityAuth?.invalidateToken();
                }
                const replayOptions = {
                    ...options,
                    __metadata: {
                        ...options.__metadata,
                        workloadIdentityTokenRefreshed: true,
                    },
                };
                return this.makeRequest(replayOptions, x509Authentication ? retriesRemaining - 1 : retriesRemaining, retryOfRequestLogID ?? requestLogID);
            }
            const shouldRetry = rejectedX509Credential && options.__metadata?.['workloadIdentityTokenRefreshed']
                ? false
                : await this.shouldRetry(response);
            if (retriesRemaining && shouldRetry && !hasStreamingBody) {
                const retryMessage = `retrying, ${retriesRemaining} attempts remaining`;
                // We don't need the body of this response.
                if (x509Authentication) {
                    void Shims.CancelReadableStream(response.body).catch(() => undefined);
                }
                else {
                    await Shims.CancelReadableStream(response.body);
                }
                (0, log_1.loggerFor)(this).info(`${responseInfo} - ${retryMessage}`);
                (0, log_1.loggerFor)(this).debug(`[${requestLogID}] response error (${retryMessage})`, (0, log_1.formatRequestDetails)({
                    retryOfRequestLogID,
                    url: response.url,
                    status: response.status,
                    headers: response.headers,
                    durationMs: headersTime - startTime,
                }));
                return this.retryRequest(options, retriesRemaining, retryOfRequestLogID ?? requestLogID, response.headers, req.signal);
            }
            const retryMessage = shouldRetry
                ? hasStreamingBody
                    ? `error; streaming body cannot be retried`
                    : `error; no more retries left`
                : `error; not retryable`;
            (0, log_1.loggerFor)(this).info(`${responseInfo} - ${retryMessage}`);
            const errText = x509Authentication
                ? await this.readX509ResponseError(response, options, timeout, controller, x509Authentication)
                : await response.text().catch((err) => (0, errors_1.castToError)(err).message);
            const errJSON = (0, values_1.safeJSON)(errText);
            const errMessage = errJSON ? undefined : errText;
            (0, log_1.loggerFor)(this).debug(`[${requestLogID}] response error (${retryMessage})`, (0, log_1.formatRequestDetails)({
                retryOfRequestLogID,
                url: response.url,
                status: response.status,
                headers: response.headers,
                message: errMessage,
                durationMs: Date.now() - startTime,
            }));
            const err = this.makeStatusError(response.status, errJSON, errMessage, response.headers);
            throw err;
        }
        (0, log_1.loggerFor)(this).info(responseInfo);
        (0, log_1.loggerFor)(this).debug(`[${requestLogID}] response start`, (0, log_1.formatRequestDetails)({
            retryOfRequestLogID,
            url: response.url,
            status: response.status,
            headers: response.headers,
            durationMs: headersTime - startTime,
        }));
        const continueRequest = x509Authentication?.continuation();
        x509Authentication?.releaseRequestCredentials();
        tslib_1.__classPrivateFieldGet(this, _OpenAI_responseAttempts, "f").set(controller, {
            timeout,
            retriesRemaining,
            hasStreamingBody,
            ...(x509Authentication ? { authentication: x509Authentication } : {}),
            helperMethod: options.__metadata?.['helperMethod'],
            ...(continueRequest ? { continueRequest } : {}),
        });
        return {
            response,
            options,
            controller,
            requestSignal: req.signal,
            requestLogID,
            retryOfRequestLogID,
            startTime,
        };
    }
    getAPIList(path, Page, opts) {
        return this.requestAPIList(Page, opts && 'then' in opts
            ? opts.then((opts) => ({ method: 'get', path, ...opts }))
            : { method: 'get', path, ...opts });
    }
    requestAPIList(Page, options) {
        const authentication = tslib_1.__classPrivateFieldGet(this, _OpenAI_x509Authentication, "f") ?? this._workloadIdentityAuth;
        const request = authentication instanceof x509_workload_identity_auth_1.X509WorkloadIdentityAuth
            ? Promise.resolve(options).then((resolved) => authentication.runRequest(() => this.makeRequest(resolved, null, undefined), this))
            : this.makeRequest(options, null, undefined);
        const page = new Pagination.PagePromise(this, request, Page);
        const guarded = this.responsePromise(request, async (client, props) => {
            const body = await this.parseResponseWithTimeout(client, props);
            return new Page(client, props.response, body, props.options);
        });
        page.then = guarded.then.bind(guarded);
        page.catch = guarded.catch.bind(guarded);
        page.finally = guarded.finally.bind(guarded);
        page.withResponse = guarded.withResponse.bind(guarded);
        page._thenUnwrap = guarded._thenUnwrap.bind(guarded);
        return page;
    }
    async fetchWithAuth(url, init, timeout, controller, schemes = {
        bearerAuth: true,
        adminAPIKeyAuth: true,
    }) {
        if (this._workloadIdentityAuth && !tslib_1.__classPrivateFieldGet(this, _OpenAI_x509Fetch, "f") && schemes.bearerAuth) {
            const headers = init.headers;
            const authHeader = headers.get('Authorization');
            if (authHeader === `Bearer ${WORKLOAD_IDENTITY_API_KEY_PLACEHOLDER}`) {
                const token = await this._workloadIdentityAuth.getToken();
                headers.set('Authorization', `Bearer ${token}`);
            }
        }
        const fetchWithTimeout = tslib_1.__classPrivateFieldGet(this, _OpenAI_x509Fetch, "f") ? _a.prototype.fetchWithTimeout : this.fetchWithTimeout;
        const response = await fetchWithTimeout.call(this, url, init, timeout, controller);
        return response;
    }
    async fetchWithTimeout(url, init, ms, controller) {
        const { signal, method, ...options } = init || {};
        const abort = this._makeAbort(controller);
        const composed = !!signal && composedCallerSignals.get(controller) === signal;
        const cleanup = signal && !composed ? (0, abort_1.addRequestAbortListener)(signal, abort, controller.signal) : undefined;
        const timeout = setTimeout(abort, ms);
        const isReadableBody = (globalThis.ReadableStream && options.body instanceof globalThis.ReadableStream) ||
            (typeof options.body === 'object' && options.body !== null && Symbol.asyncIterator in options.body);
        const fetchOptions = {
            signal: controller.signal,
            ...(isReadableBody ? { duplex: 'half' } : {}),
            method: 'GET',
            ...options,
        };
        if (method) {
            // Custom methods like 'patch' need to be uppercased
            // See https://github.com/nodejs/undici/issues/2294
            fetchOptions.method = method.toUpperCase();
        }
        try {
            // use undefined this binding; fetch errors if bound to something else in browser/cloudflare
            const response = await (tslib_1.__classPrivateFieldGet(this, _OpenAI_x509Fetch, "f") ?? this.fetch).call(undefined, url, fetchOptions);
            if (cleanup) {
                (0, abort_1.retainRequestAbortCallback)(response.body ?? response, abort, controller.signal);
            }
            return response;
        }
        catch (err) {
            cleanup?.();
            throw err;
        }
        finally {
            clearTimeout(timeout);
        }
    }
    async shouldRetry(response) {
        // Note this is not a standard header.
        const shouldRetryHeader = response.headers.get('x-should-retry');
        // If the server explicitly says whether or not to retry, obey.
        if (shouldRetryHeader === 'true')
            return true;
        if (shouldRetryHeader === 'false')
            return false;
        // Retry on request timeouts.
        if (response.status === 408)
            return true;
        // Retry on lock timeouts.
        if (response.status === 409)
            return true;
        // Retry on rate limits.
        if (response.status === 429)
            return true;
        // Retry internal errors.
        if (response.status >= 500)
            return true;
        return false;
    }
    async retryRequest(options, retriesRemaining, requestLogID, responseHeaders, requestSignal = options.signal) {
        let timeoutMillis;
        // Note the `retry-after-ms` header may not be standard, but is a good idea and we'd like proactive support for it.
        const retryAfterMillisHeader = responseHeaders?.get('retry-after-ms');
        if (retryAfterMillisHeader) {
            const timeoutMs = parseFloat(retryAfterMillisHeader);
            if (!Number.isNaN(timeoutMs)) {
                timeoutMillis = timeoutMs;
            }
        }
        // About the Retry-After header: https://developer.mozilla.org/en-US/docs/Web/HTTP/Headers/Retry-After
        const retryAfterHeader = responseHeaders?.get('retry-after');
        if (retryAfterHeader && timeoutMillis === undefined) {
            const timeoutSeconds = parseFloat(retryAfterHeader);
            if (!Number.isNaN(timeoutSeconds)) {
                timeoutMillis = timeoutSeconds * 1000;
            }
            else {
                timeoutMillis = Date.parse(retryAfterHeader) - Date.now();
            }
        }
        // If the API asks us to wait a certain amount of time, just do what it
        // says, but otherwise calculate a default
        if (timeoutMillis === undefined ||
            !Number.isFinite(timeoutMillis) ||
            timeoutMillis < 0 ||
            timeoutMillis > 60 * 1000) {
            const maxRetries = options.maxRetries ?? this.maxRetries;
            timeoutMillis = this.calculateDefaultRetryTimeoutMillis(retriesRemaining, maxRetries);
        }
        const x509Authentication = tslib_1.__classPrivateFieldGet(this, _OpenAI_x509Authentication, "f");
        if (x509Authentication) {
            const remaining = x509Authentication.remainingTimeout(options, x509Authentication.requestSnapshot().timeout);
            if (timeoutMillis >= remaining) {
                throw new Errors.APIConnectionTimeoutError();
            }
        }
        if (x509Authentication) {
            await x509Authentication.waitForRetry(timeoutMillis, x509Authentication.effectiveSignal());
        }
        else {
            const retrySignals = requestSignal === options.signal ? [requestSignal] : [requestSignal, options.signal];
            try {
                await (0, sleep_1.sleep)(timeoutMillis, ...retrySignals);
            }
            catch (error) {
                const abortedSignal = retrySignals.find((signal) => signal?.aborted);
                if (abortedSignal) {
                    throw this._makeUserAbortError(abortedSignal);
                }
                throw error;
            }
        }
        return this.makeRequest(options, retriesRemaining - 1, requestLogID);
    }
    calculateDefaultRetryTimeoutMillis(retriesRemaining, maxRetries) {
        const initialRetryDelay = 0.5;
        const maxRetryDelay = 8.0;
        const numRetries = maxRetries - retriesRemaining;
        // Apply exponential backoff, but not more than the max.
        const sleepSeconds = Math.min(initialRetryDelay * Math.pow(2, numRetries), maxRetryDelay);
        // Apply some jitter, take up to at most 25 percent of the retry time.
        const jitter = 1 - Math.random() * 0.25;
        return sleepSeconds * jitter * 1000;
    }
    /**
     * Builds a request, resolving callback credentials when constructing authentication
     * headers, after any subclass request-option rewrites. Calling this method directly
     * also resolves credentials. Complete replacement builders own authentication and
     * can call `this.authHeaders()` to resolve headers with request-local credentials.
     */
    async buildRequest(inputOptions, { retryCount = 0 } = {}) {
        if (tslib_1.__classPrivateFieldGet(this, _OpenAI_x509Authentication, "f") && !tslib_1.__classPrivateFieldGet(this, _OpenAI_x509Authentication, "f").inRequest(this)) {
            const authentication = tslib_1.__classPrivateFieldGet(this, _OpenAI_x509Authentication, "f");
            return await authentication.runRequest(async () => {
                const built = await _a.prototype.buildRequest.call(this, inputOptions, { retryCount });
                authentication.releaseRequestBody(built.req.body);
                return built;
            }, this);
        }
        const options = { ...inputOptions };
        const x509Authentication = tslib_1.__classPrivateFieldGet(this, _OpenAI_x509Authentication, "f");
        const x509Tenant = x509Authentication?.snapshotTenant(this.organization, this.project);
        const x509Headers = x509Authentication?.snapshotHeaders(this._options.defaultHeaders, options.headers);
        if (x509Headers) {
            options.headers = x509Headers.requestHeaders;
        }
        const x509ClientFetchOptions = x509Authentication
            ? (0, x509_workload_identity_auth_1.snapshotX509RequestOptions)(this.fetchOptions)
            : undefined;
        const x509RequestFetchOptions = x509Authentication
            ? (0, x509_workload_identity_auth_1.snapshotX509RequestOptions)(options.fetchOptions)
            : undefined;
        const { method, path, query, defaultBaseURL } = options;
        const url = this.buildURL(path, query, defaultBaseURL);
        x509Authentication?.snapshotAPIURL(url);
        const explicitTimeout = 'timeout' in options;
        if (explicitTimeout)
            (0, values_1.validatePositiveInteger)('timeout', options.timeout);
        options.timeout = options.timeout ?? this.timeout;
        if (x509Authentication && x509RequestFetchOptions) {
            x509Authentication.snapshotRequest(options.signal, options.timeout, x509RequestFetchOptions);
        }
        if (x509Authentication) {
            const snapshot = x509Authentication.requestSnapshot();
            options.timeout = snapshot.timeout;
            if (snapshot.signal === undefined) {
                delete options.signal;
            }
            else {
                options.signal = snapshot.signal;
            }
        }
        const authenticationHeaders = this._provider || x509Authentication
            ? undefined
            : await this.authHeaders(inputOptions, inputOptions.__security ?? { bearerAuth: true });
        const { bodyHeaders, body, isStreamingBody } = this.buildBody({ options });
        if (isStreamingBody) {
            inputOptions.__metadata = {
                ...inputOptions.__metadata,
                hasStreamingBody: true,
            };
            x509Authentication?.ownRequestBody(body, options.body);
        }
        const reqHeaders = await this.buildHeaders({
            options: inputOptions,
            method,
            bodyHeaders,
            authenticationHeaders,
            retryCount,
            x509Headers,
            x509Timeout: explicitTimeout ? options.timeout : undefined,
            x509Tenant,
        });
        const req = {
            method,
            headers: reqHeaders,
            ...(options.signal && { signal: options.signal }),
            ...(globalThis.ReadableStream &&
                body instanceof globalThis.ReadableStream && { duplex: 'half' }),
            ...(body && { body }),
            ...((x509Authentication ? x509ClientFetchOptions : this.fetchOptions) ?? {}),
            ...((x509Authentication ? x509RequestFetchOptions : options.fetchOptions) ?? {}),
        };
        return { req, url, timeout: options.timeout };
    }
    async buildHeaders({ options, method, bodyHeaders, authenticationHeaders, retryCount, x509Headers, x509Timeout, x509Tenant, }) {
        let idempotencyHeaders = {};
        if (this.idempotencyHeader && method !== 'get') {
            if (!options.idempotencyKey)
                options.idempotencyKey = this.defaultIdempotencyKey();
            idempotencyHeaders[this.idempotencyHeader] = options.idempotencyKey;
        }
        const helperMethod = options.__metadata?.['helperMethod'];
        const timeout = x509Headers ? x509Timeout : options.timeout;
        const headers = (0, headers_1.buildHeaders)([
            idempotencyHeaders,
            {
                Accept: 'application/json',
                ...(!isRunningInBrowserOrBrowserWorker() ? { 'User-Agent': this.getUserAgent() } : undefined),
                'X-Stainless-Retry-Count': String(retryCount),
                ...(timeout ? { 'X-Stainless-Timeout': String(Math.trunc(timeout / 1000)) } : {}),
                ...(0, detect_platform_1.getPlatformHeaders)(),
                ...(typeof helperMethod === 'string' ? { 'X-Stainless-Helper-Method': helperMethod } : {}),
                'OpenAI-Organization': x509Tenant ? x509Tenant.organization : this.organization,
                'OpenAI-Project': x509Tenant ? x509Tenant.project : this.project,
            },
            // X.509 owns streaming uploads before authentication so it can retire them on failure.
            tslib_1.__classPrivateFieldGet(this, _OpenAI_x509Authentication, "f") && !tslib_1.__classPrivateFieldGet(this, _OpenAI_x509Authentication, "f").isPlanningRequest()
                ? await this.authHeaders(options, options.__security ?? { bearerAuth: true })
                : authenticationHeaders,
            x509Headers?.defaultHeaders ?? this._options.defaultHeaders,
            bodyHeaders,
            x509Headers?.requestHeaders ?? options.headers,
        ]);
        if (!this._provider && !tslib_1.__classPrivateFieldGet(this, _OpenAI_x509Authentication, "f")?.isPlanningRequest()) {
            this.validateHeaders(headers, options.__security ?? { bearerAuth: true });
        }
        return headers.values;
    }
    _makeAbort(controller) {
        // note: we can't just inline this method inside `fetchWithTimeout()` because then the closure
        //       would capture all request options, and cause a memory leak.
        return () => controller.abort();
    }
    _makeUserAbortError(signal) {
        const error = new Errors.APIUserAbortError();
        Object.defineProperty(error, 'cause', { value: signal.reason, writable: true, configurable: true });
        return error;
    }
    buildBody({ options }) {
        const { body, headers: rawHeaders } = options;
        if (!body) {
            // A resource method always passes a `body` key when its operation defines a
            // request body, even if the caller omitted an optional body param. Keep the
            // content-type for those, and only elide it for operations with no body at
            // all (e.g. GET/DELETE).
            if (body === undefined && 'body' in options) {
                return { ...tslib_1.__classPrivateFieldGet(this, _OpenAI_encoder, "f").call(this, { body, headers: (0, headers_1.buildHeaders)([rawHeaders]) }), isStreamingBody: false };
            }
            return { bodyHeaders: undefined, body: undefined, isStreamingBody: false };
        }
        const headers = (0, headers_1.buildHeaders)([rawHeaders]);
        const isReadableStream = typeof globalThis.ReadableStream !== 'undefined' &&
            body instanceof globalThis.ReadableStream;
        const isRetryableBody = !isReadableStream &&
            (typeof body === 'string' ||
                body instanceof ArrayBuffer ||
                ArrayBuffer.isView(body) ||
                (typeof globalThis.Blob !== 'undefined' && body instanceof globalThis.Blob) ||
                body instanceof URLSearchParams ||
                body instanceof FormData);
        if (
        // Pass raw type verbatim
        ArrayBuffer.isView(body) ||
            body instanceof ArrayBuffer ||
            body instanceof DataView ||
            (typeof body === 'string' &&
                // Preserve legacy string encoding behavior for now
                headers.values.has('content-type')) ||
            // `Blob` is superset of `File`
            (globalThis.Blob && body instanceof globalThis.Blob) ||
            // `FormData` -> `multipart/form-data`
            body instanceof FormData ||
            // `URLSearchParams` -> `application/x-www-form-urlencoded`
            body instanceof URLSearchParams ||
            // Send chunked stream (each chunk has own `length`)
            isReadableStream) {
            return { bodyHeaders: undefined, body: body, isStreamingBody: !isRetryableBody };
        }
        else if (typeof body === 'object' &&
            (Symbol.asyncIterator in body ||
                (Symbol.iterator in body && 'next' in body && typeof body.next === 'function'))) {
            return {
                bodyHeaders: undefined,
                body: Shims.ReadableStreamFrom(body),
                isStreamingBody: true,
            };
        }
        else if (typeof body === 'object' &&
            headers.values.get('content-type') === 'application/x-www-form-urlencoded') {
            return {
                bodyHeaders: { 'content-type': 'application/x-www-form-urlencoded' },
                body: this.stringifyQuery(body),
                isStreamingBody: false,
            };
        }
        else {
            return { ...tslib_1.__classPrivateFieldGet(this, _OpenAI_encoder, "f").call(this, { body, headers }), isStreamingBody: false };
        }
    }
}
exports.OpenAI = OpenAI;
_a = OpenAI, _OpenAI_encoder = new WeakMap(), _OpenAI_x509Authentication = new WeakMap(), _OpenAI_x509Credential = new WeakMap(), _OpenAI_x509Fetch = new WeakMap(), _OpenAI_explicitDataResidency = new WeakMap(), _OpenAI_responseAttempts = new WeakMap(), _OpenAI_instances = new WeakSet(), _OpenAI_baseURLOverridden = function _OpenAI_baseURLOverridden() {
    return (tslib_1.__classPrivateFieldGet(this, _OpenAI_explicitDataResidency, "f") ||
        this._provider !== undefined ||
        this.baseURL !== 'https://api.openai.com/v1');
};
OpenAI.OpenAI = _a;
OpenAI.DEFAULT_TIMEOUT = 600000; // 10 minutes
OpenAI.OpenAIError = Errors.OpenAIError;
OpenAI.APIError = Errors.APIError;
OpenAI.APIConnectionError = Errors.APIConnectionError;
OpenAI.APIConnectionTimeoutError = Errors.APIConnectionTimeoutError;
OpenAI.APIUserAbortError = Errors.APIUserAbortError;
OpenAI.NotFoundError = Errors.NotFoundError;
OpenAI.ConflictError = Errors.ConflictError;
OpenAI.RateLimitError = Errors.RateLimitError;
OpenAI.BadRequestError = Errors.BadRequestError;
OpenAI.AuthenticationError = Errors.AuthenticationError;
OpenAI.InternalServerError = Errors.InternalServerError;
OpenAI.PermissionDeniedError = Errors.PermissionDeniedError;
OpenAI.UnprocessableEntityError = Errors.UnprocessableEntityError;
OpenAI.InvalidWebhookSignatureError = Errors.InvalidWebhookSignatureError;
OpenAI.toFile = Uploads.toFile;
OpenAI.toStreamingFile = Uploads.toStreamingFile;
OpenAI.Completions = completions_1.Completions;
OpenAI.Chat = chat_1.Chat;
OpenAI.Embeddings = embeddings_1.Embeddings;
OpenAI.Files = files_1.Files;
OpenAI.Images = images_1.Images;
OpenAI.ContentProvenanceChecks = content_provenance_checks_1.ContentProvenanceChecks;
OpenAI.Audio = audio_1.Audio;
OpenAI.Moderations = moderations_1.Moderations;
OpenAI.Models = models_1.Models;
OpenAI.FineTuning = fine_tuning_1.FineTuning;
OpenAI.Graders = graders_1.Graders;
OpenAI.VectorStores = vector_stores_1.VectorStores;
OpenAI.Safety = safety_1.Safety;
OpenAI.Webhooks = webhooks_1.Webhooks;
OpenAI.Beta = beta_1.Beta;
OpenAI.Batches = batches_1.Batches;
OpenAI.Uploads = uploads_1.Uploads;
OpenAI.Admin = admin_1.Admin;
OpenAI.Responses = responses_1.Responses;
OpenAI.Live = live_1.Live;
OpenAI.Realtime = realtime_1.Realtime;
OpenAI.Conversations = conversations_1.Conversations;
OpenAI.Evals = evals_1.Evals;
OpenAI.Containers = containers_1.Containers;
OpenAI.Skills = skills_1.Skills;
OpenAI.Videos = videos_1.Videos;
OpenAI.ConversationCursorPage = Pagination.ConversationCursorPage;
OpenAI.CursorPage = Pagination.CursorPage;
OpenAI.NextCursorPage = Pagination.NextCursorPage;
OpenAI.Page = Pagination.Page;
OpenAI.TokenPage = Pagination.TokenPage;
const composedCallerSignals = new WeakMap();
function createRequestController(callerSignal, originalSignal) {
    const controller = new AbortController();
    if (!callerSignal)
        return controller;
    const nativeAbortSignal = globalThis.AbortSignal;
    if (typeof nativeAbortSignal?.any !== 'function' || !(callerSignal instanceof nativeAbortSignal)) {
        return controller;
    }
    try {
        // Native composition keeps cancellation active after response headers without
        // retaining an abort listener on the caller's signal or changing its reason.
        const signals = [controller.signal, callerSignal];
        if (originalSignal && originalSignal !== callerSignal) {
            signals.push(originalSignal);
        }
        const composed = nativeAbortSignal.any(signals);
        Object.defineProperty(controller, 'signal', { value: composed, configurable: true });
        composedCallerSignals.set(controller, callerSignal);
    }
    catch {
        // Older or incompatible runtimes retain the existing listener-based fallback.
    }
    return controller;
}
function getConnectionErrorMessage(error) {
    if (isUndiciDispatcherVersionMismatchError(error)) {
        return `Connection error. This may be caused by passing an undici dispatcher, such as ProxyAgent, that is incompatible with the fetch implementation. If you are using undici's ProxyAgent, pass the fetch implementation from the same undici package: import { fetch, ProxyAgent } from 'undici'; new OpenAI({ fetch, fetchOptions: { dispatcher: new ProxyAgent(...) } });`;
    }
    return undefined;
}
function isUndiciDispatcherVersionMismatchError(error) {
    let current = error;
    for (let i = 0; i < 8 && current && typeof current === 'object'; i++) {
        const err = current;
        if (err.code === 'UND_ERR_INVALID_ARG' &&
            typeof err.message === 'string' &&
            err.message.includes('invalid onRequestStart method')) {
            return true;
        }
        current = err.cause;
    }
    return false;
}
//# sourceMappingURL=client.js.map