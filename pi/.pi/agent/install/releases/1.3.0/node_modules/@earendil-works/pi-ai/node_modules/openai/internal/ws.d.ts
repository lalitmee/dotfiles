import type { WebSocketLike } from "./ws-adapter.js";
/** Records physical failure before transport callbacks notify public observers. @internal */
export declare function recordWebSocketError(socket: WebSocketLike, error: Error): void;
/** Returns physical failure for this socket instance, never for a replacement. @internal */
export declare function getWebSocketError(socket: WebSocketLike): Error | undefined;
/** Options for an independently buffered WebSocket stream iterator. */
export interface WebSocketStreamOptions {
    /**
     * Maximum queued records, including raw data, errors and lifecycle events.
     * Must be a positive safe integer. Omitted means unlimited. Overflow discards
     * this iterator's backlog and rejects its next() calls with a WebSocketError,
     * without closing the shared socket or affecting other iterators.
     * This bounds event count, not payload bytes or total memory.
     */
    maxBufferedEvents?: number | undefined;
}
/** Snapshots and validates the iterator's limit before listeners are attached. */
export declare function getMaxBufferedEvents(options?: WebSocketStreamOptions): number | undefined;
/** Reconnection event passed to the `onReconnecting` handler and event listeners. */
export interface ReconnectingEvent<Parameters = Record<string, unknown>> {
    /** Which retry attempt this is (1-based). */
    readonly attempt: number;
    /** Total attempts that will be made. */
    readonly maxAttempts: number;
    /** Delay in ms before this attempt connects. */
    readonly delay: number;
    /** The WebSocket close code that triggered reconnection. */
    readonly closeCode: number;
    /** The current query parameters. */
    readonly parameters: (Parameters & Record<string, unknown>) | undefined;
}
/**
 * Optional overrides returned from the `onReconnecting` handler
 * to customize the next reconnection attempt.
 */
export type ReconnectingOverrides<Parameters = Record<string, unknown>> = {
    /**
     * If provided, assigns the query parameters for the next connection.
     * Set to `undefined` to clear all query parameters.
     */
    parameters?: (Parameters & Record<string, unknown>) | undefined;
} | {
    /**
     * If set, will stop attempting to reconnect.
     */
    abort: true;
};
/**
 * Raw data types that can be sent over a WebSocket without serialization.
 */
export type RawWebSocketData = string | ArrayBufferLike | ArrayBufferView | ArrayBufferView[];
interface CredentialedWebSocketOptions {
    auth?: string | null | undefined;
    followRedirects?: boolean | undefined;
    headers?: object | null | undefined;
}
/**
 * Snapshots credential values in final socket options before validation and dispatch.
 * Reports potential caller authentication, including custom headers; the server
 * remains responsible for validating credentials. Noncredential headers are left intact.
 */
export declare function snapshotWebSocketCredentials(options: {
    auth?: unknown;
    headers?: Record<string, unknown> | undefined;
}): boolean;
/** Prevents WebSocket redirects from forwarding caller or SDK credentials to another origin. */
export declare function protectWebSocketOptionsFromCredentialRedirects<Options extends CredentialedWebSocketOptions>(options: Options): Options;
/** A queued application message or raw WebSocket frame that was never transmitted. */
export type UnsentMessage<T> = {
    /** Identifies a JSON-serialized application message. */
    type: 'message';
    /** The deserialized snapshot captured when the message was queued. */
    message: T;
} | {
    /** Identifies an unencoded WebSocket frame. */
    type: 'raw';
    /** The string or copied binary payload captured when the frame was queued. */
    data: RawWebSocketData;
};
/**
 * Flatten `ArrayBufferView[]` fragments into a single `Uint8Array` so that
 * `ws.send()` transmits the correct bytes.
 */
export declare function flattenRawData(data: RawWebSocketData): Exclude<RawWebSocketData, ArrayBufferView[]>;
/** Counts wire bytes without allocating another payload-sized buffer. */
export declare function rawByteLength(data: RawWebSocketData): number;
/**
 * Buffers outgoing WebSocket messages while a connection is unavailable.
 *
 * JSON values are serialized immediately, and raw binary payloads are copied,
 * so later caller mutations cannot change queued messages. A single oversized
 * message is accepted when the queue is empty; further messages are rejected
 * whenever they would exceed the configured byte budget.
 */
export declare class SendQueue<T = unknown> {
    private _queue;
    private _bytes;
    private _maxBytes;
    /** Creates a queue with a one-mebibyte default byte budget. */
    constructor(maxBytes?: number);
    /**
     * Serializes and snapshots a JSON message before queueing it.
     *
     * @returns `true` when accepted, including an oversized first message; `false`
     * when adding it to a nonempty queue would exceed the byte budget.
     */
    enqueue(event: T): boolean;
    /**
     * Queues a raw string or a defensive copy of a binary WebSocket payload.
     * Fragmented typed-array payloads are flattened before storage.
     *
     * @returns `true` when accepted, including an oversized first frame; `false`
     * when adding it to a nonempty queue would exceed the byte budget.
     */
    enqueueRaw(data: RawWebSocketData): boolean;
    /**
     * Send every queued message via `send`. If `send` throws, the failing
     * message and all subsequent messages are re-queued and the error is
     * re-thrown so the caller can report it.
     */
    flush(send: (data: RawWebSocketData) => void): void;
    /**
     * Drain the queue and return the unsent messages. JSON messages are
     * deserialized back to their original form. Resets byte tracking to zero.
     */
    drain(): UnsentMessage<T>[];
}
/**
 * Reports whether an RFC 6455 close code represents a recoverable interruption.
 *
 * Network failures, service restarts, temporary server errors, and TLS
 * handshake failures can be retried; normal closure, protocol violations,
 * invalid payloads, and unrecognized codes cannot.
 */
export declare function isRecoverableClose(code: number): boolean;
export {};
//# sourceMappingURL=ws.d.ts.map