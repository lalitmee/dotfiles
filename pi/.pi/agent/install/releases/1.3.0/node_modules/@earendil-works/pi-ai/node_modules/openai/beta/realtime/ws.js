"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.OpenAIRealtimeWS = void 0;
const tslib_1 = require("../../internal/tslib.js");
const realtime_credentials_1 = require("../../internal/realtime-credentials.js");
const WS = tslib_1.__importStar(require("ws"));
const bedrock_1 = require("../../internal/bedrock.js");
const ws_1 = require("../../internal/ws.js");
const index_1 = require("../../index.js");
const version_1 = require("../../version.js");
const internal_base_1 = require("./internal-base.js");
/**
 * Connects to the beta Realtime API using the Node.js `ws` WebSocket implementation.
 *
 * Install the optional `ws` peer dependency before importing this entrypoint.
 * Register an SDK `error` listener and wait for `socket`'s `open` event before
 * sending client events. Use the stable Realtime helper for Azure sideband calls.
 */
function assertTrustedRealtimeURL(client, url) {
    if (url.protocol !== 'wss:') {
        throw new Error('Realtime WebSocket URLs must use the wss: protocol.');
    }
    const configuredURL = new URL(client.baseURL);
    configuredURL.protocol = 'wss:';
    if (url.origin !== configuredURL.origin) {
        throw new Error('Realtime WebSocket URL origin must match the configured client origin.');
    }
}
class OpenAIRealtimeWS extends internal_base_1.OpenAIRealtimeEmitter {
    /**
     * Immediately opens a beta Realtime model session or attaches to an existing non-Azure call.
     *
     * Clients with function-based credentials must use
     * {@link OpenAIRealtimeWS.create}; Azure deployment sessions should use
     * {@link OpenAIRealtimeWS.azure}.
     *
     * @param props Exactly one of `model` or `callID`, plus optional `ws` client settings.
     * @param client Existing client whose endpoint and API key should be reused.
     */
    constructor(props, client) {
        super();
        client ?? (client = new index_1.OpenAI());
        const apiKey = props.__apiKey === undefined ? client.apiKey : props.__apiKey;
        // SAFETY: The supplied OpenAI client owns _options; this read detects its existing API-key provider without changing its public surface.
        const hasProvider = typeof client?._options?.apiKey === 'function';
        if (hasProvider && !props.__resolvedApiKey) {
            throw new Error([
                'Cannot open Realtime WebSocket with a function-based apiKey.',
                'Use the .create() method so that the key is resolved before connecting.',
            ].join('\n'));
        }
        this.url = (0, internal_base_1.buildRealtimeURL)(client, props);
        assertTrustedRealtimeURL(client, this.url);
        (0, bedrock_1.assertBedrockWebSocketOrigin)(client, this.url);
        const headers = {
            'User-Agent': `${client.constructor.name}/JS ${version_1.VERSION}`,
            ...props.options?.headers,
            // A credential must be an own data property without invoking an inherited setter.
            ...((0, internal_base_1.isAzure)(client) && !props.__resolvedApiKey ? {} : { Authorization: `Bearer ${apiKey}` }),
            'OpenAI-Beta': 'realtime=v1',
        };
        this.socket = new WS.WebSocket(this.url, (0, ws_1.protectWebSocketOptionsFromCredentialRedirects)({
            ...props.options,
            headers,
        }));
        this.socket.on('message', (wsEvent) => {
            const event = (() => {
                try {
                    const parsedEvent = (0, internal_base_1.parseRealtimeEvent)(wsEvent.toString());
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
        this.socket.on('error', (err) => {
            this._onError(null, err.message, err);
        });
    }
    /**
     * Resolves a client's current API credential before opening a beta Realtime connection.
     *
     * Use this factory instead of the constructor when the client's `apiKey` is a function.
     *
     * @param client OpenAI client that owns the endpoint and refreshable or static credential.
     * @param props Exactly one of `model` or `callID`, plus optional `ws` client settings.
     */
    static async create(client, props) {
        const url = (0, internal_base_1.buildRealtimeURL)(client, props);
        assertTrustedRealtimeURL(client, url);
        (0, bedrock_1.assertBedrockWebSocketOrigin)(client, url);
        const { apiKey, isProvider: resolvedApiKey } = await (0, realtime_credentials_1.resolveRealtimeAPIKey)(client);
        assertTrustedRealtimeURL(client, url);
        (0, bedrock_1.assertBedrockWebSocketOrigin)(client, url);
        return new OpenAIRealtimeWS({ ...props, __resolvedApiKey: resolvedApiKey, __apiKey: apiKey }, client);
    }
    /**
     * Opens a beta Azure OpenAI Realtime session for the selected model deployment.
     *
     * Static Azure API keys are sent in the `api-key` header; function-based
     * credentials are resolved first and sent as bearer credentials. Use the
     * stable Realtime helper when attaching to an existing Azure call.
     *
     * @param client Azure OpenAI client that supplies the endpoint and credential.
     * @param props Optional deployment override and `ws` connection settings.
     * @throws {Error} If the Azure credential or required deployment is unavailable.
     */
    static async azure(client, props = {}) {
        const { apiKey, isProvider: isApiKeyProvider } = await (0, realtime_credentials_1.resolveRealtimeAPIKey)(client);
        if (!apiKey) {
            throw new Error('Azure OpenAI Realtime requires an API key');
        }
        const deploymentName = props.deploymentName ?? client.deploymentName;
        if (!deploymentName) {
            throw new Error('No deployment name provided');
        }
        return new OpenAIRealtimeWS({
            model: deploymentName,
            options: {
                ...props.options,
                headers: {
                    ...props.options?.headers,
                    // A credential must be an own data property without invoking an inherited setter.
                    ...(isApiKeyProvider ? {} : { 'api-key': apiKey }),
                },
            },
            __resolvedApiKey: isApiKeyProvider,
            __apiKey: apiKey,
        }, client);
    }
    /**
     * Serializes and sends a beta Realtime client event after the WebSocket has opened.
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
exports.OpenAIRealtimeWS = OpenAIRealtimeWS;
//# sourceMappingURL=ws.js.map