"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.OpenAIRealtimeEmitter = exports.OpenAIRealtimeError = void 0;
exports.parseRealtimeEvent = parseRealtimeEvent;
exports.isAzure = isAzure;
exports.buildRealtimeURL = buildRealtimeURL;
const EventEmitter_1 = require("../../lib/EventEmitter.js");
const error_1 = require("../../error.js");
const index_1 = require("../../index.js");
const x509_workload_identity_auth_1 = require("../../internal/auth/x509-workload-identity-auth.js");
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
/** An API-reported or client-side error encountered by a beta Realtime connection. */
class OpenAIRealtimeError extends error_1.OpenAIError {
    /**
     * Creates a beta Realtime error, preserving server-provided details when available.
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
 * Typed event emitter shared by the beta Realtime WebSocket implementations.
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
 * Builds the secure WebSocket URL for a beta Realtime session or non-Azure sideband call.
 *
 * @throws {Error} If both `model` and `callID`, or neither, are supplied, or an
 * Azure sideband call is requested through the beta helpers.
 */
function buildRealtimeURL(client, connection) {
    (0, x509_workload_identity_auth_1.assertX509WebSocketSupported)(client);
    const config = typeof connection === 'string' ? { model: connection } : connection;
    const baseURL = client.baseURL;
    const azure = isAzure(client);
    const hasModel = !!config.model;
    const hasCallID = !!config.callID;
    const url = new URL(baseURL);
    url.pathname += url.pathname.endsWith('/') ? 'realtime' : '/realtime';
    url.hash = '';
    if (hasModel === hasCallID) {
        throw new Error('Pass exactly one of `model` or `callID` when opening a Realtime WebSocket.');
    }
    url.protocol = 'wss';
    // Sideband control connections attach to an existing call via `call_id`.
    if (azure) {
        if (hasCallID) {
            throw new Error('Azure `callID` connections require the stable Realtime helpers.');
        }
        url.searchParams.set('api-version', client.apiVersion);
        url.searchParams.set('deployment', config.model);
    }
    else if (hasCallID) {
        url.searchParams.set('call_id', config.callID);
    }
    else {
        url.searchParams.set('model', config.model);
    }
    return url;
}
//# sourceMappingURL=internal-base.js.map