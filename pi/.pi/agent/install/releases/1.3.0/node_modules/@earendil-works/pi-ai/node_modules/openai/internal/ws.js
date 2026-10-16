"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.SendQueue = void 0;
exports.recordWebSocketError = recordWebSocketError;
exports.getWebSocketError = getWebSocketError;
exports.getMaxBufferedEvents = getMaxBufferedEvents;
exports.snapshotWebSocketCredentials = snapshotWebSocketCredentials;
exports.protectWebSocketOptionsFromCredentialRedirects = protectWebSocketOptionsFromCredentialRedirects;
exports.flattenRawData = flattenRawData;
exports.rawByteLength = rawByteLength;
exports.isRecoverableClose = isRecoverableClose;
const bytes_1 = require("./utils/bytes.js");
const error_1 = require("../core/error.js");
const webSocketErrors = new WeakMap();
/** Records physical failure before transport callbacks notify public observers. @internal */
function recordWebSocketError(socket, error) {
    webSocketErrors.set(socket, error);
}
/** Returns physical failure for this socket instance, never for a replacement. @internal */
function getWebSocketError(socket) {
    return webSocketErrors.get(socket);
}
/** Snapshots and validates the iterator's limit before listeners are attached. */
function getMaxBufferedEvents(options) {
    const limit = options?.maxBufferedEvents;
    if (limit !== undefined && (!Number.isSafeInteger(limit) || limit <= 0)) {
        throw new error_1.OpenAIError('maxBufferedEvents must be a positive safe integer');
    }
    return limit;
}
const REDIRECT_SAFE_WEBSOCKET_HEADERS = new Set([
    'connection',
    'host',
    'openai-beta',
    'origin',
    'sec-websocket-extensions',
    'sec-websocket-key',
    'sec-websocket-version',
    'upgrade',
    'user-agent',
    'x-access-level',
    'x-auth-metadata',
    'x-auth-tokenization',
    'x-authentication-metadata',
    'x-authentication-tokenization',
    'x-security-policy',
    'x-token-budget',
    'x-trace-id',
]);
function isWebSocketCredentialHeader(name) {
    return !REDIRECT_SAFE_WEBSOCKET_HEADERS.has(name.toLowerCase().split('_').join('-'));
}
/**
 * Snapshots credential values in final socket options before validation and dispatch.
 * Reports potential caller authentication, including custom headers; the server
 * remains responsible for validating credentials. Noncredential headers are left intact.
 */
function snapshotWebSocketCredentials(options) {
    if (options.auth !== null && options.auth !== undefined) {
        options.auth = String(options.auth);
    }
    const credentials = new Map();
    const headers = options.headers ?? {};
    for (const [name, value] of Object.entries(headers)) {
        const normalizedName = name.toLowerCase().split('_').join('-');
        // Routing metadata is still protected on redirects, but cannot authenticate a socket.
        if (!isWebSocketCredentialHeader(name) ||
            normalizedName === 'openai-organization' ||
            normalizedName === 'openai-project') {
            continue;
        }
        let snapshot = value;
        if (Array.isArray(value)) {
            snapshot = value.map(String);
        }
        else if (value !== null && value !== undefined) {
            snapshot = String(value);
        }
        headers[name] = snapshot;
        const values = Array.isArray(snapshot) ? snapshot : [snapshot];
        credentials.set(name.toLowerCase(), values.some((item) => typeof item === 'string' && item.trim().length > 0));
    }
    // Node applies header names case-insensitively, and Authorization overrides Basic auth.
    return ([...credentials.values()].some(Boolean) ||
        (!credentials.has('authorization') && typeof options.auth === 'string' && options.auth.trim().length > 0));
}
/** Prevents WebSocket redirects from forwarding caller or SDK credentials to another origin. */
function protectWebSocketOptionsFromCredentialRedirects(options) {
    const hasSensitiveHeader = Object.keys(options.headers ?? {}).some(isWebSocketCredentialHeader);
    if (!options.auth && !hasSensitiveHeader) {
        return options;
    }
    return { ...options, followRedirects: false };
}
function toUint8Array(view) {
    if (view instanceof Uint8Array) {
        return view;
    }
    return new Uint8Array(view.buffer, view.byteOffset, view.byteLength);
}
/**
 * Flatten `ArrayBufferView[]` fragments into a single `Uint8Array` so that
 * `ws.send()` transmits the correct bytes.
 */
function flattenRawData(data) {
    if (Array.isArray(data)) {
        return (0, bytes_1.concatBytes)(data.map(toUint8Array));
    }
    return data;
}
function snapshotRawData(data) {
    if (typeof data === 'string') {
        return data;
    }
    if (Array.isArray(data)) {
        return (0, bytes_1.concatBytes)(data.map(toUint8Array));
    }
    if (ArrayBuffer.isView(data)) {
        const copy = new Uint8Array(data.byteLength);
        copy.set(toUint8Array(data));
        return copy;
    }
    // oxlint-disable-next-line unicorn/prefer-spread -- ArrayBufferLike.slice copies bytes while spread changes the return type.
    return data.slice(0);
}
/** Counts wire bytes without allocating another payload-sized buffer. */
function rawByteLength(data) {
    if (typeof data === 'string') {
        let bytes = 0;
        for (let index = 0; index < data.length; index += 1) {
            const code = data.codePointAt(index);
            if (code < 128) {
                bytes += 1;
            }
            else if (code < 2048) {
                bytes += 2;
            }
            else if (code <= 65535) {
                bytes += 3;
            }
            else {
                bytes += 4;
                index += 1;
            }
        }
        return bytes;
    }
    if (Array.isArray(data)) {
        return data.reduce((sum, buf) => sum + buf.byteLength, 0);
    }
    if ('byteLength' in data) {
        return data.byteLength;
    }
    return 0;
}
/**
 * Buffers outgoing WebSocket messages while a connection is unavailable.
 *
 * JSON values are serialized immediately, and raw binary payloads are copied,
 * so later caller mutations cannot change queued messages. A single oversized
 * message is accepted when the queue is empty; further messages are rejected
 * whenever they would exceed the configured byte budget.
 */
class SendQueue {
    /** Creates a queue with a one-mebibyte default byte budget. */
    constructor(maxBytes = 1048576) {
        this._queue = [];
        this._bytes = 0;
        this._maxBytes = maxBytes;
    }
    /**
     * Serializes and snapshots a JSON message before queueing it.
     *
     * @returns `true` when accepted, including an oversized first message; `false`
     * when adding it to a nonempty queue would exceed the byte budget.
     */
    enqueue(event) {
        const data = JSON.stringify(event);
        const byteLength = (0, bytes_1.encodeUTF8)(data).byteLength;
        if (this._bytes + byteLength > this._maxBytes && this._queue.length > 0) {
            return false;
        }
        this._queue.push({ kind: 'json', data, byteLength });
        this._bytes += byteLength;
        return true;
    }
    /**
     * Queues a raw string or a defensive copy of a binary WebSocket payload.
     * Fragmented typed-array payloads are flattened before storage.
     *
     * @returns `true` when accepted, including an oversized first frame; `false`
     * when adding it to a nonempty queue would exceed the byte budget.
     */
    enqueueRaw(data) {
        const snapshot = snapshotRawData(data);
        const byteLength = rawByteLength(snapshot);
        if (this._bytes + byteLength > this._maxBytes && this._queue.length > 0) {
            return false;
        }
        this._queue.push({ kind: 'raw', data: snapshot, byteLength });
        this._bytes += byteLength;
        return true;
    }
    /**
     * Send every queued message via `send`. If `send` throws, the failing
     * message and all subsequent messages are re-queued and the error is
     * re-thrown so the caller can report it.
     */
    flush(send) {
        const pending = this._queue.splice(0);
        this._bytes = 0;
        for (let i = 0; i < pending.length; i++) {
            try {
                send(pending[i].data);
            }
            catch (err) {
                const remaining = pending.slice(i);
                this._queue = [...remaining, ...this._queue];
                this._bytes = this._queue.reduce((sum, item) => sum + item.byteLength, 0);
                throw err;
            }
        }
    }
    /**
     * Drain the queue and return the unsent messages. JSON messages are
     * deserialized back to their original form. Resets byte tracking to zero.
     */
    drain() {
        const unsent = this._queue.map((entry) => {
            if (entry.kind === 'raw') {
                return { type: 'raw', data: entry.data };
            }
            // SAFETY: T is the transport caller's event contract; JSON syntax is parsed here without imposing a runtime schema on forward-compatible events.
            return { type: 'message', message: JSON.parse(entry.data) };
        });
        this._queue = [];
        this._bytes = 0;
        return unsent;
    }
}
exports.SendQueue = SendQueue;
/**
 * Reports whether an RFC 6455 close code represents a recoverable interruption.
 *
 * Network failures, service restarts, temporary server errors, and TLS
 * handshake failures can be retried; normal closure, protocol violations,
 * invalid payloads, and unrecognized codes cannot.
 */
function isRecoverableClose(code) {
    switch (code) {
        case 1000: {
            return false;
        } // Normal closure
        case 1001: {
            return true;
        } // Going away (server shutting down)
        case 1002: {
            return false;
        } // Protocol error
        case 1003: {
            return false;
        } // Unsupported data
        case 1005: {
            return true;
        } // No status code (abnormal)
        case 1006: {
            return true;
        } // Abnormal closure (network drop)
        case 1007: {
            return false;
        } // Invalid payload
        case 1008: {
            return false;
        } // Policy violation
        case 1009: {
            return false;
        } // Message too big
        case 1010: {
            return false;
        } // Missing extension
        case 1011: {
            return true;
        } // Internal server error
        case 1012: {
            return true;
        } // Service restart
        case 1013: {
            return true;
        } // Try again later
        case 1015: {
            return true;
        } // TLS handshake failure
        default: {
            return false;
        }
    }
}
//# sourceMappingURL=ws.js.map