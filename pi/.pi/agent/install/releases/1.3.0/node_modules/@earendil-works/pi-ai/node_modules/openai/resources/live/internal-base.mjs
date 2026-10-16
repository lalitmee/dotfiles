// File generated from our OpenAPI spec by Castiron. See CONTRIBUTING.md for details.
import { EventEmitter } from "../../core/EventEmitter.mjs";
import { OpenAIError } from "../../core/error.mjs";
export class WebSocketError extends OpenAIError {
    constructor(message, event) {
        super(message);
        Object.defineProperty(this, 'error', {
            value: event ?? undefined,
            writable: true,
            configurable: true,
            enumerable: false,
        });
    }
}
export class LiveEmitter extends EventEmitter {
    _onError(event, message, cause) {
        const safeMessage = safeWebSocketErrorMessage(event, message);
        message = safeMessage ?? 'unknown error';
        if (!this._hasListener('error')) {
            const error = new WebSocketError(message +
                `\n\nTo resolve these unhandled rejection errors you should bind an \`error\` callback, e.g. \`ws.on('error', (error) => ...)\` `, event);
            // @ts-ignore
            error.cause = cause;
            Promise.reject(error);
            return;
        }
        const error = new WebSocketError(message, event);
        // @ts-ignore
        error.cause = cause;
        this._emit('error', error);
    }
}
export function buildURL(client, parameters) {
    const { ...query } = parameters;
    const endpoint = '/live/sessions';
    const url = new URL(client.buildURL(endpoint, query, undefined));
    url.protocol = url.protocol === 'http:' || url.protocol === 'ws:' ? 'ws:' : 'wss:';
    return url;
}
function safeWebSocketErrorMessage(event, message) {
    if (typeof message === 'string')
        return message;
    if (typeof event !== 'object' || event === null)
        return undefined;
    try {
        const error = Object.getOwnPropertyDescriptor(event, 'error')?.value;
        const nestedMessage = typeof error === 'object' && error !== null
            ? Object.getOwnPropertyDescriptor(error, 'message')?.value
            : undefined;
        const eventMessage = Object.getOwnPropertyDescriptor(event, 'message')?.value;
        const candidate = typeof nestedMessage === 'string' ? nestedMessage : eventMessage;
        return typeof candidate === 'string' ? candidate : undefined;
    }
    catch {
        return undefined;
    }
}
//# sourceMappingURL=internal-base.mjs.map