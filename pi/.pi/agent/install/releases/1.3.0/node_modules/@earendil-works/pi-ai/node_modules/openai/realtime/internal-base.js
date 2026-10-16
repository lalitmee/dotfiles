"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.OpenAIRealtimeEmitter = exports.OpenAIRealtimeError = void 0;
exports.parseRealtimeEvent = parseRealtimeEvent;
exports.isAzure = isAzure;
exports.buildRealtimeURL = buildRealtimeURL;
exports.getAzureRealtimeConnection = getAzureRealtimeConnection;
const EventEmitter_1 = require("../lib/EventEmitter.js");
const error_1 = require("../error.js");
const index_1 = require("../index.js");
const x509_workload_identity_auth_1 = require("../internal/auth/x509-workload-identity-auth.js");
/** Parses frame data without exposing malformed payloads through JSON syntax errors. */
function parseRealtimeEvent(data) {
    try {
        // SAFETY: RealtimeServerEvent is the API wire contract; JSON syntax is checked here while future event types remain accepted at runtime.
        return JSON.parse(data);
    }
    catch (error) {
        if (error instanceof SyntaxError) {
            throw new SyntaxError('Could not parse Realtime WebSocket event data as JSON.');
        }
        throw error;
    }
}
function safeErrorValue(value) {
    try {
        return String(value);
    }
    catch {
        return '[unserializable error value]';
    }
}
/** An API-reported or client-side error encountered by an active Realtime connection. */
class OpenAIRealtimeError extends error_1.OpenAIError {
    /**
     * Creates a Realtime error, preserving server-provided details when available.
     *
     * @param message Human-readable API or connection error description.
     * @param event Server error event, or `null` for a client-side failure.
     */
    constructor(message, event) {
        super(message);
        /** Stable error name used to identify Realtime connection failures. */
        this.name = 'OpenAIRealtimeError';
        this.error = event?.error;
        this.event_id = event?.event_id;
    }
}
exports.OpenAIRealtimeError = OpenAIRealtimeError;
/**
 * Typed event emitter shared by Realtime WebSocket client implementations.
 *
 * Listen for `event` to receive all server events, or subscribe to a specific
 * server event's `type`. Always register an `error` listener; otherwise API and
 * transport failures are reported as unhandled promise rejections.
 */
class OpenAIRealtimeEmitter extends EventEmitter_1.EventEmitter {
    _onError(event, message, cause) {
        message = event?.error
            ? `${safeErrorValue(event.error.message)} code=${safeErrorValue(event.error.code)} param=${safeErrorValue(event.error.param)} type=${safeErrorValue(event.error.type)} event_id=${safeErrorValue(event.error.event_id)}`
            : (message ?? 'unknown error');
        if (!this._hasListener('error')) {
            const error = new OpenAIRealtimeError(message +
                `\n\nTo resolve these unhandled rejection errors you should bind an \`error\` callback, e.g. \`rt.on('error', (error) => ...)\` `, event);
            // @ts-ignore
            error.cause = cause;
            Promise.reject(error);
            return;
        }
        const error = new OpenAIRealtimeError(message, event);
        // @ts-ignore
        error.cause = cause;
        this._emit('error', error);
    }
}
exports.OpenAIRealtimeEmitter = OpenAIRealtimeEmitter;
/** Reports whether the client is an Azure OpenAI client with Azure-specific Realtime routing. */
function isAzure(client) {
    return client instanceof index_1.AzureOpenAI;
}
/**
 * Builds the secure WebSocket URL for a model or transcription session, or a sideband call.
 *
 * All Azure sessions use the versioned GA Realtime endpoint. Model-backed
 * sessions select their deployment with `model`, transcription sessions use
 * `intent`, and sideband connections use `call_id`.
 *
 * @throws {Error} If the connection target is invalid or a custom URL does not use `wss:`.
 */
function buildRealtimeURL(client, connection) {
    (0, x509_workload_identity_auth_1.assertX509WebSocketSupported)(client);
    const config = typeof connection === 'string' ? { model: connection } : connection;
    const baseURL = client.baseURL;
    const azure = isAzure(client);
    const hasModel = config.model !== undefined;
    const hasCallID = config.callID !== undefined;
    const hasIntent = config.intent !== undefined;
    if (Number(hasModel) + Number(hasCallID) + Number(hasIntent) !== 1 ||
        (hasModel && !config.model) ||
        (hasCallID && !config.callID) ||
        (hasIntent && config.intent !== 'transcription')) {
        throw new Error('Pass exactly one of `model`, `callID`, or transcription `intent` when opening a Realtime WebSocket.');
    }
    if (config.buildRealtimeURL) {
        const url = new URL(config.buildRealtimeURL(client, config));
        if (url.protocol !== 'wss:') {
            throw new Error('Custom Realtime WebSocket URLs must use the wss: protocol.');
        }
        return url;
    }
    const url = new URL(baseURL);
    if (azure) {
        const basePath = url.pathname.replace(/\/+/g, '/').replace(/\/+$/, '');
        const versionedPath = basePath.endsWith('/v1') ? basePath : `${basePath}/v1`;
        url.pathname = `${versionedPath}/realtime`;
        url.search = '';
    }
    else {
        url.pathname += url.pathname.endsWith('/') ? 'realtime' : '/realtime';
    }
    url.hash = '';
    url.protocol = 'wss';
    // Sideband control connections attach to an existing call via `call_id`.
    if (hasCallID) {
        url.searchParams.set('call_id', config.callID);
    }
    else if (hasIntent) {
        url.searchParams.set('intent', 'transcription');
    }
    else {
        url.searchParams.set('model', config.model);
    }
    return url;
}
/**
 * Resolves an Azure deployment, transcription intent, or an existing Realtime call.
 *
 * @throws {Error} If connection targets conflict, intent is invalid, or no deployment is available.
 */
function getAzureRealtimeConnection(client, connection) {
    const hasDeploymentName = connection.deploymentName !== undefined;
    const hasCallID = connection.callID !== undefined;
    const hasIntent = connection.intent !== undefined;
    const customURLBuilder = connection.buildRealtimeURL;
    const normalizedOptions = customURLBuilder ? { buildRealtimeURL: customURLBuilder } : {};
    if (Number(hasDeploymentName) + Number(hasCallID) + Number(hasIntent) > 1 ||
        (hasIntent && connection.intent !== 'transcription')) {
        throw new Error('Pass exactly one of `deploymentName`, `callID`, or transcription `intent` when opening an Azure Realtime WebSocket.');
    }
    if (hasCallID) {
        return { ...normalizedOptions, callID: connection.callID };
    }
    if (hasIntent) {
        return { ...normalizedOptions, intent: 'transcription' };
    }
    const model = connection.deploymentName ?? client.deploymentName;
    if (!model) {
        throw new Error('No deployment name provided');
    }
    return { ...normalizedOptions, model };
}
//# sourceMappingURL=internal-base.js.map