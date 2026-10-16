"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.OpenAIRealtimeWebSocket = void 0;
const realtime_credentials_1 = require("../internal/realtime-credentials.js");
const bedrock_1 = require("../internal/bedrock.js");
const index_1 = require("../index.js");
const error_1 = require("../error.js");
const internal_base_1 = require("./internal-base.js");
const detect_platform_1 = require("../internal/detect-platform.js");
/** Identifies browser pages and workers without blocking trusted server runtimes. */
function isRunningInBrowserOrBrowserWorker() {
    if ((0, detect_platform_1.isRunningInBrowser)()) {
        return true;
    }
    // SAFETY: RuntimeScope describes optional host capabilities; the following predicates verify their presence and value before use.
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
/** Reports whether the runtime supports request headers in native WebSocket options. */
function supportsWebSocketRequestHeaders() {
    // SAFETY: RuntimeScope describes optional host capabilities; the following predicates verify their presence and value before use.
    const scope = globalThis;
    if (isRunningInBrowserOrBrowserWorker() ||
        scope.EdgeRuntime !== undefined ||
        scope.WebSocketPair !== undefined ||
        scope.navigator?.userAgent === 'Cloudflare-Workers') {
        return false;
    }
    if (scope.Deno !== undefined) {
        const [major, minor] = (scope.Deno.version?.deno ?? '').split('.').map(Number);
        return major !== undefined && minor !== undefined && (major > 2 || (major === 2 && minor >= 5));
    }
    if (typeof scope.Bun?.version === 'string') {
        return true;
    }
    return (Object.prototype.toString.call(scope.process) === '[object process]' &&
        typeof scope.process?.versions?.node === 'string');
}
/** Removes Azure credentials while preserving the existing public URL redaction contract. */
function redactAzureCredentials(url, isBearerToken) {
    let hasApiKey = !isBearerToken;
    let hasAuthorization = isBearerToken;
    const parameterNames = [...url.searchParams.keys()];
    for (const name of parameterNames) {
        if (name.toLowerCase() === 'api-key') {
            hasApiKey = true;
            url.searchParams.delete(name);
        }
        else if (name.toLowerCase() === 'authorization') {
            hasAuthorization = true;
            url.searchParams.delete(name);
        }
    }
    if (hasApiKey) {
        url.searchParams.set('api-key', '<REDACTED>');
    }
    if (hasAuthorization) {
        url.searchParams.set('Authorization', '<REDACTED>');
    }
}
/** Opens an Azure native socket with header authentication and a credential-free URL. */
function createAzureWebSocket(url, apiKey, isBearerToken, protocols) {
    if (!supportsWebSocketRequestHeaders()) {
        throw new error_1.OpenAIError('Azure OpenAI Realtime credentials require a WebSocket transport that supports request headers; use openai/realtime/ws or a server-side authentication proxy.');
    }
    if (!apiKey) {
        throw new Error('Azure OpenAI Realtime requires an API key');
    }
    redactAzureCredentials(url, isBearerToken);
    const socketURL = new URL(url);
    socketURL.searchParams.delete('api-key');
    socketURL.searchParams.delete('Authorization');
    const headers = isBearerToken ? { Authorization: `Bearer ${apiKey}` } : { 'api-key': apiKey };
    // @ts-ignore
    return new WebSocket(socketURL.toString(), { protocols, headers });
}
/**
 * Connects to the Realtime API using the runtime's native `WebSocket` implementation.
 *
 * Browser use is blocked by default to prevent secret API-key exposure. Use an
 * ephemeral Realtime credential in browser clients; set
 * `dangerouslyAllowBrowser` only after independently securing the credential.
 * Register an SDK `error` listener and wait for `socket`'s `open` event before
 * sending Realtime client events.
 */
class OpenAIRealtimeWebSocket extends internal_base_1.OpenAIRealtimeEmitter {
    /**
     * Immediately opens a native WebSocket session or attaches to an existing call.
     *
     * Clients with function-based credentials must use
     * {@link OpenAIRealtimeWebSocket.create}; Azure clients should use
     * {@link OpenAIRealtimeWebSocket.azure}. An ephemeral credential whose value
     * starts with `ek_` is permitted in browser runtimes automatically.
     *
     * @param props Exactly one model, transcription intent, or call ID, plus browser-safety settings.
     * @param client Existing client whose endpoint and API key should be reused.
     * @throws {OpenAIError} If browser access would expose an unapproved credential.
     */
    constructor(props, client) {
        super();
        let apiKey = (0, realtime_credentials_1.getRealtimeAPIKey)(client, props.__apiKey);
        // SAFETY: The supplied OpenAI client owns _options; these compatibility reads preserve its provider and browser-consent settings.
        const hasProvider = typeof client?._options?.apiKey === 'function';
        // SAFETY: The supplied OpenAI client owns _options; these compatibility reads preserve its provider and browser-consent settings.
        const dangerouslyAllowBrowser = props.dangerouslyAllowBrowser ??
            client?._options?.dangerouslyAllowBrowser ??
            (apiKey?.startsWith('ek_') ? true : null);
        if (!dangerouslyAllowBrowser && isRunningInBrowserOrBrowserWorker()) {
            throw new error_1.OpenAIError("It looks like you're running in a browser-like environment.\n\nThis is disabled by default, as it risks exposing your secret API credentials to attackers.\n\nYou can avoid this error by creating an ephemeral session token:\nhttps://platform.openai.com/docs/api-reference/realtime-sessions\n");
        }
        client ?? (client = new index_1.OpenAI({ dangerouslyAllowBrowser }));
        if (apiKey === undefined) {
            apiKey = client.apiKey;
        }
        if (hasProvider && !props?.__resolvedApiKey) {
            throw new Error([
                'Cannot open Realtime WebSocket with a function-based apiKey.',
                'Use the .create() method so that the key is resolved before connecting.',
            ].join('\n'));
        }
        this.url = (0, internal_base_1.buildRealtimeURL)(client, props);
        props.onURL?.(this.url);
        if (this.url.protocol !== 'wss:') {
            throw new error_1.OpenAIError('Realtime WebSocket URLs must use the wss: protocol.');
        }
        (0, bedrock_1.assertBedrockWebSocketOrigin)(client, this.url);
        const azure = (0, internal_base_1.isAzure)(client);
        const protocols = ['realtime', ...(azure ? [] : [`openai-insecure-api-key.${apiKey}`])];
        this.socket = azure
            ? createAzureWebSocket(this.url, apiKey, props.__resolvedApiKey === true, protocols)
            : new WebSocket(this.url.toString(), protocols);
        this.socket.addEventListener('message', (websocketEvent) => {
            const event = (() => {
                try {
                    const parsedEvent = (0, internal_base_1.parseRealtimeEvent)(websocketEvent.data.toString());
                    if (typeof parsedEvent !== 'object' ||
                        parsedEvent === null ||
                        Array.isArray(parsedEvent) ||
                        !Object.getOwnPropertyDescriptor(parsedEvent, 'type') ||
                        typeof parsedEvent.type !== 'string') {
                        throw new TypeError('Realtime WebSocket event must be an object with a string type.');
                    }
                    return parsedEvent;
                }
                catch (err) {
                    this._onError(null, 'could not parse websocket event', err);
                    return null;
                }
            })();
            if (event) {
                this._emit('event', event);
                if (event.type === 'error') {
                    this._onError(event);
                }
                else {
                    // @ts-expect-error TS isn't smart enough to get the relationship right here
                    this._emit(event.type, event);
                }
            }
        });
        this.socket.addEventListener('error', (event) => {
            // Native ErrorEvents can carry an empty message while `error` still holds the failure.
            const cause = event.error ?? null;
            const message = [event.message, cause?.message].find((value) => typeof value === 'string' && value !== '');
            this._onError(null, message ?? 'unknown error', cause);
        });
    }
    /**
     * Resolves a client's current API credential before opening a native Realtime WebSocket.
     *
     * Use this factory instead of the constructor when the client's `apiKey` is a function.
     *
     * @param client OpenAI client that owns the endpoint and refreshable or static credential.
     * @param props Exactly one model, transcription intent, or call ID, plus browser-safety settings.
     */
    static async create(client, props) {
        const { apiKey, isProvider: resolvedApiKey } = await (0, realtime_credentials_1.resolveRealtimeAPIKey)(client);
        const url = (0, internal_base_1.buildRealtimeURL)(client, props);
        (0, bedrock_1.assertBedrockWebSocketOrigin)(client, url);
        return new OpenAIRealtimeWebSocket({
            ...props,
            buildRealtimeURL: () => url,
            __resolvedApiKey: resolvedApiKey,
            __apiKey: apiKey,
        }, client);
    }
    /**
     * Opens a native Azure deployment or transcription session, or an existing sideband call.
     *
     * Azure credentials are sent in WebSocket handshake headers and never appear
     * in the native socket URL. Browser WebSockets cannot set these headers;
     * use a server-side authentication proxy or the Node.js `ws` transport.
     *
     * @param client Azure OpenAI client that supplies the endpoint and credential.
     * @param options Deployment, transcription intent, or call ID, plus browser-safety settings.
     * @throws {Error} If the Azure credential or required deployment is unavailable.
     */
    static async azure(client, options = {}) {
        const connection = (0, internal_base_1.getAzureRealtimeConnection)(client, options);
        const { apiKey, isProvider: isApiKeyProvider } = await (0, realtime_credentials_1.resolveRealtimeAPIKey)(client);
        if (!apiKey) {
            throw new Error('Azure OpenAI Realtime requires an API key');
        }
        const { dangerouslyAllowBrowser } = options;
        return new OpenAIRealtimeWebSocket({
            ...connection,
            // Preserve explicit browser consent as an own data property without invoking an inherited setter.
            ...(dangerouslyAllowBrowser === undefined ? {} : { dangerouslyAllowBrowser }),
            __resolvedApiKey: isApiKeyProvider,
            __apiKey: apiKey,
        }, client);
    }
    /**
     * Serializes and sends a Realtime client event after the native WebSocket has opened.
     * Serialization and transport failures are delivered to the SDK `error` event.
     */
    send(event) {
        try {
            this.socket.send(JSON.stringify(event));
        }
        catch (err) {
            this._onError(null, 'could not send data', err);
        }
    }
    /**
     * Closes the WebSocket with status code `1000` and reason `OK` by default.
     * Connection-closing failures are delivered to the SDK `error` event.
     */
    close(props) {
        try {
            this.socket.close(props?.code ?? 1000, props?.reason ?? 'OK');
        }
        catch (err) {
            this._onError(null, 'could not close the connection', err);
        }
    }
}
exports.OpenAIRealtimeWebSocket = OpenAIRealtimeWebSocket;
//# sourceMappingURL=websocket.js.map