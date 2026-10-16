import { ForksEmitter, ForksStreamMessage } from "./internal-base.mjs";
import { type WebSocketLike } from "../../../internal/ws-adapter.mjs";
import { type WebSocketStreamOptions, type RawWebSocketData, type ReconnectingEvent, type ReconnectingOverrides } from "../../../internal/ws.mjs";
import * as ForksAPI from "./forks.mjs";
import { OpenAI } from "../../../client.mjs";
export interface ForksWSParameters extends Record<string, unknown> {
    session_id: string;
}
export interface ForksWSReconnectOptions {
    /**
     * Called before each reconnect attempt. Return an object with
     * `parameters` to override query parameters for the next connection.
     */
    onReconnecting(event: ReconnectingEvent<ForksWSParameters>): ReconnectingOverrides<ForksWSParameters> | void;
    /**
     * Maximum number of reconnection attempts. Default: 5.
     * Set to 0 to disable reconnection entirely.
     */
    maxRetries?: number;
    /**
     * Initial backoff delay in milliseconds. Default: 500.
     */
    initialDelay?: number;
    /**
     * Maximum backoff delay in milliseconds. Default: 8000.
     */
    maxDelay?: number;
}
export interface ForksWSBaseOptions {
    /**
     * Options for automatic reconnection on recoverable close codes.
     * Automatic reconnection is only enabled when this has a non-null value.
     */
    reconnect?: ForksWSReconnectOptions | null | undefined;
    /**
     * Byte budget for outgoing messages queued while the socket is connecting
     * or reconnecting. An empty queue accepts one message even if it exceeds
     * this budget. Further messages are discarded and an `error` event is emitted
     * if the total queued size would exceed the budget.
     * Default: 1 MiB (1,048,576 bytes).
     */
    maxQueueSize?: number | undefined;
}
export declare abstract class ForksWSBase<TSocket extends WebSocketLike> extends ForksEmitter {
    url: URL;
    socket: TSocket;
    protected _client: OpenAI;
    protected _parameters: ForksWSParameters | null | undefined;
    private _reconnectOptions;
    private _sendQueue;
    private _isReconnecting;
    private _intentionallyClosed;
    private _closeCode;
    private _closeReason;
    private _lastCloseCode;
    private _lastCloseReason;
    private _internalEvents;
    constructor(client: OpenAI, parameters: ForksWSParameters, options?: ForksWSBaseOptions | undefined);
    /** Establishes the initial WebSocket connection. */
    protected _connectInitial(): void;
    /** Creates a platform-specific WebSocket for the given URL and auth headers. */
    protected abstract _createSocket(url: URL, authHeaders: Record<string, string>): TSocket;
    send(event: ForksAPI.ForkClientEvent): void;
    sendRaw(data: RawWebSocketData): void;
    close(props?: {
        code: number;
        reason: string;
    }): void;
    /**
     * Returns an async iterator over WebSocket lifecycle and message events,
     * providing an alternative to the event-based `.on()` API.
     * The iterator will exit if the socket closes but exiting the iterator
     * does not close the socket.
     *
     * Pass `maxBufferedEvents` to limit queued records for this iterator, including
     * lifecycle events. Overflow discards its backlog and rejects `next()` with a
     * WebSocketError; the shared socket and other iterators remain active.
     * Omitted means unlimited. This is an event-count limit, not a byte limit.
     *
     * @example
     * ```ts
     * for await (const event of client.stream()) {
     *   switch (event.type) {
     *     case 'message':
     *       console.log('received:', event.message);
     *       break;
     *     case 'error':
     *       console.error(event.error);
     *       break;
     *     case 'close':
     *       console.log('connection closed');
     *       break;
     *   }
     * }
     * ```
     */
    stream(options?: WebSocketStreamOptions): AsyncIterableIterator<ForksStreamMessage>;
    [Symbol.asyncIterator](options?: WebSocketStreamOptions): AsyncIterableIterator<ForksStreamMessage>;
    private _connect;
    private _canReconnect;
    private _reconnect;
    /**
     * Resolves once the socket is open, rejects if it errors or closes first
     */
    private _awaitOpen;
    private _flushSendQueue;
    /**
     * Emits the public `close` event with unsent messages and the internal
     * `close` event used by the async iterator.
     */
    private _emitPermanentClose;
    protected _authHeaders(): Record<string, string>;
}
//# sourceMappingURL=ws-base.d.mts.map