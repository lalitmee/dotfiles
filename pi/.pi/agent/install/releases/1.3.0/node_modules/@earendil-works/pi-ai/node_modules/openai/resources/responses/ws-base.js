"use strict";
// File generated from our OpenAPI spec by Castiron. See CONTRIBUTING.md for details.
Object.defineProperty(exports, "__esModule", { value: true });
exports.ResponsesWSBase = void 0;
exports.getWebSocketEventBytes = getWebSocketEventBytes;
exports.getWebSocketEventPayload = getWebSocketEventPayload;
const internal_base_1 = require("./internal-base.js");
const EventEmitter_1 = require("../../core/EventEmitter.js");
const sleep_1 = require("../../internal/utils/sleep.js");
const ws_adapter_1 = require("../../internal/ws-adapter.js");
const ws_1 = require("../../internal/ws.js");
const error_1 = require("../../core/error.js");
const webSocketEventPayloads = new WeakMap();
const webSocketEventBytes = new WeakMap();
/** Uses immutable wire size, or JSON accounting for a custom emitter. @internal */
function getWebSocketEventBytes(event) {
    return webSocketEventBytes.get(event) ?? (0, ws_1.rawByteLength)(JSON.stringify(event));
}
/** Original JSON, available only during synchronous event notification.
 * @internal
 */
function getWebSocketEventPayload(event) {
    return webSocketEventPayloads.get(event);
}
class ResponsesWSBase extends internal_base_1.ResponsesEmitter {
    constructor(client, options) {
        super();
        this._isReconnecting = false;
        this._intentionallyClosed = false;
        this._closeCode = 1000;
        this._closeReason = 'OK';
        this._lastCloseCode = 1006;
        this._lastCloseReason = '';
        // Necessary to keep the public event interface clean while we manage reconnecting
        this._internalEvents = new EventEmitter_1.InternalEventEmitter();
        this._client = client;
        this._parameters = undefined;
        this._reconnectOptions = options?.reconnect ?? null;
        this._sendQueue = new ws_1.SendQueue(options?.maxQueueSize);
    }
    /** Establishes the initial WebSocket connection. */
    _connectInitial() {
        this.url = (0, internal_base_1.buildURL)(this._client, {});
        this.socket = this._connect();
    }
    send(event) {
        if (!this.socket) {
            throw new error_1.OpenAIError('Internal error: failed to initialize socket. Please report this issue.');
        }
        if (this._isReconnecting || this.socket.readyState === ws_adapter_1.ReadyState.CONNECTING) {
            if (!this._sendQueue.enqueue(event)) {
                this._onError(null, 'send queue is full, message discarded', undefined);
            }
            return;
        }
        if (this.socket.readyState !== ws_adapter_1.ReadyState.OPEN) {
            this._onError(null, 'cannot send on a closed WebSocket', undefined);
            return;
        }
        try {
            this.socket.send(JSON.stringify(event));
        }
        catch (err) {
            this._onError(null, 'could not send data', err);
        }
    }
    sendRaw(data) {
        if (!this.socket) {
            throw new error_1.OpenAIError('Internal error: failed to initialize socket. Please report this issue.');
        }
        if (this._isReconnecting || this.socket.readyState === ws_adapter_1.ReadyState.CONNECTING) {
            if (!this._sendQueue.enqueueRaw(data)) {
                this._onError(null, 'send queue is full, message discarded', undefined);
            }
            return;
        }
        if (this.socket.readyState !== ws_adapter_1.ReadyState.OPEN) {
            this._onError(null, 'cannot send on a closed WebSocket', undefined);
            return;
        }
        try {
            this.socket.send((0, ws_1.flattenRawData)(data));
        }
        catch (err) {
            this._onError(null, 'could not send data', err);
        }
    }
    close(props) {
        if (!this.socket) {
            throw new error_1.OpenAIError('Internal error: failed to initialize socket. Please report this issue.');
        }
        this._intentionallyClosed = true;
        this._closeCode = props?.code ?? 1000;
        this._closeReason = props?.reason ?? 'OK';
        try {
            this.socket.close(this._closeCode, this._closeReason);
        }
        catch (err) {
            this._onError(null, 'could not close the connection', err);
        }
    }
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
    stream(options) {
        return options === undefined ? this[Symbol.asyncIterator]() : this[Symbol.asyncIterator](options);
    }
    [Symbol.asyncIterator](options) {
        if (!this.socket) {
            throw new error_1.OpenAIError('Internal error: failed to initialize socket. Please report this issue.');
        }
        const maxBufferedEvents = (0, ws_1.getMaxBufferedEvents)(options);
        // Two-queue async iterator: `queue` buffers incoming messages,
        // `resolvers` buffers waiting next() calls. A push wakes the
        // oldest next(); a next() drains the oldest message.
        const queue = [];
        const resolvers = [];
        let queueHead = 0;
        let resolverHead = 0;
        let done = false;
        let failure;
        let currentSocket = this.socket;
        const wakeResolver = () => {
            if (resolverHead >= resolvers.length)
                return;
            const resolver = resolvers[resolverHead];
            resolvers[resolverHead] = undefined;
            resolverHead += 1;
            if (resolverHead >= 64 && resolverHead * 2 >= resolvers.length) {
                resolvers.splice(0, resolverHead);
                resolverHead = 0;
            }
            resolver?.();
        };
        const push = (msg) => {
            if (done)
                return;
            if (maxBufferedEvents !== undefined && queue.length - queueHead >= maxBufferedEvents) {
                failure = new internal_base_1.WebSocketError(`WebSocket stream exceeded maxBufferedEvents (${maxBufferedEvents})`, null);
                done = true;
                queue.length = 0;
                queueHead = 0;
                cleanup();
                flushResolvers();
                return;
            }
            queue.push(msg);
            wakeResolver();
        };
        const onEvent = (event) => {
            if (event.type === 'error')
                return; // handled by onEmitterError
            push({ type: 'message', message: event });
        };
        const onRaw = (data) => {
            push({ type: 'raw', data });
        };
        // All errors (API + socket) funnel through _onError → 'error' event
        const onEmitterError = (err) => {
            push({ type: 'error', error: err });
        };
        const onOpen = () => {
            push({ type: 'open' });
        };
        const onReconnecting = (evt) => {
            push({ type: 'reconnecting', reconnect: evt });
        };
        const onReconnected = () => {
            push({ type: 'reconnected' });
        };
        const flushResolvers = () => {
            while (resolverHead < resolvers.length) {
                const resolver = resolvers[resolverHead];
                resolvers[resolverHead] = undefined;
                resolverHead += 1;
                resolver?.();
            }
            resolvers.length = 0;
            resolverHead = 0;
        };
        const onClose = (code, reason, unsent) => {
            push({ type: 'close', code, reason, unsent });
            done = true;
            flushResolvers();
            cleanup();
        };
        const onSocketSwap = (_oldSocket, newSocket) => {
            if (currentSocket === newSocket)
                return;
            currentSocket.off('open', onOpen);
            newSocket.on('open', onOpen);
            currentSocket = newSocket;
        };
        const cleanup = () => {
            this.off('event', onEvent);
            this.off('raw', onRaw);
            this.off('error', onEmitterError);
            currentSocket.off('open', onOpen);
            this._internalEvents.off('close', onClose);
            this._internalEvents.off('socketSwap', onSocketSwap);
            this._internalEvents.off('reconnecting', onReconnecting);
            this._internalEvents.off('reconnected', onReconnected);
        };
        this.on('event', onEvent);
        this.on('raw', onRaw);
        this.on('error', onEmitterError);
        this.socket.on('open', onOpen);
        this._internalEvents.on('close', onClose);
        this._internalEvents.on('socketSwap', onSocketSwap);
        this._internalEvents.on('reconnecting', onReconnecting);
        this._internalEvents.on('reconnected', onReconnected);
        if (this._isReconnecting) {
            // A reconnect is already in flight. The socket may be CLOSED but the
            // instance is still alive. Emit 'reconnecting' so the iterator stays
            // open and receives the upcoming reconnected/message events.
            push({
                type: 'reconnecting',
                reconnect: { attempt: 0, maxAttempts: 0, delay: 0, closeCode: 0, parameters: undefined },
            });
        }
        else {
            switch (this.socket.readyState) {
                case ws_adapter_1.ReadyState.CONNECTING:
                    push({ type: 'connecting' });
                    break;
                case ws_adapter_1.ReadyState.OPEN:
                    push({ type: 'open' });
                    break;
                case ws_adapter_1.ReadyState.CLOSING:
                    push({ type: 'closing' });
                    break;
                case ws_adapter_1.ReadyState.CLOSED:
                    push({
                        type: 'close',
                        code: this._lastCloseCode,
                        reason: this._lastCloseReason,
                        unsent: this._sendQueue.drain(),
                    });
                    done = true;
                    cleanup();
                    break;
            }
        }
        const resolve = (res, reject) => {
            if (failure) {
                reject(failure);
            }
            else if (queueHead < queue.length) {
                const queued = queue[queueHead];
                queue[queueHead] = undefined;
                queueHead += 1;
                if (queueHead >= 64 && queueHead * 2 >= queue.length) {
                    queue.splice(0, queueHead);
                    queueHead = 0;
                }
                res({ value: queued, done: false });
            }
            else if (done) {
                res({ value: undefined, done: true });
            }
            else {
                return false;
            }
            return true;
        };
        const next = () => new Promise((res, reject) => {
            if (resolve(res, reject))
                return;
            resolvers.push(() => {
                resolve(res, reject);
            });
        });
        return {
            next,
            return: () => {
                done = true;
                queue.length = 0;
                queueHead = 0;
                cleanup();
                flushResolvers();
                return Promise.resolve({ value: undefined, done: true });
            },
            [Symbol.asyncIterator]() {
                return this;
            },
        };
    }
    _connect() {
        this.url = (0, internal_base_1.buildURL)(this._client, this._parameters ?? {});
        const socket = this._createSocket(this.url, this._authHeaders());
        socket.on('message', (data, isBinary) => {
            if (isBinary) {
                this._emit('raw', data);
                return;
            }
            // Coerce to string in case the adapter delivers a typed-array for text frames.
            const text = typeof data === 'string' ? data : String(data);
            let event;
            try {
                event = JSON.parse(text);
            }
            catch {
                this._emit('raw', data);
                return;
            }
            if (event === null ||
                typeof event !== 'object' ||
                Array.isArray(event) ||
                !Object.prototype.hasOwnProperty.call(event, 'type') ||
                typeof event.type !== 'string') {
                this._onError(null, 'received invalid WebSocket event: expected an object with an own string type', undefined);
                return;
            }
            const eventType = event.type;
            const errorEvent = event.type === 'error' ? event : undefined;
            const reservedEventType = eventType === 'raw' ||
                eventType === 'close' ||
                eventType === 'event' ||
                eventType === 'reconnecting' ||
                eventType === 'reconnected' ||
                eventType === 'open' ||
                eventType === 'error';
            if (reservedEventType && eventType !== 'error') {
                this._onError(null, 'received reserved WebSocket event type', undefined);
                return;
            }
            webSocketEventBytes.set(event, (0, ws_1.rawByteLength)(data));
            webSocketEventPayloads.set(event, text);
            try {
                this._emit('event', event);
            }
            finally {
                webSocketEventPayloads.delete(event);
            }
            if (errorEvent) {
                this._onError(errorEvent);
            }
            else {
                // @ts-ignore TS isn't smart enough to get the relationship right here
                this._emit(eventType, event);
            }
        });
        socket.on('error', (err) => {
            (0, ws_1.recordWebSocketError)(socket, err);
            // Suppress transient errors during reconnection — the retry loop
            // already handles them and will surface a close if retries exhaust.
            if (this._isReconnecting)
                return;
            this._onError(null, err.message, err);
        });
        socket.on('open', () => {
            this._flushSendQueue();
        });
        socket.on('close', (code, reason) => {
            // Ignore close events from superseded sockets — a stale socket's
            // late close must not kick off a second reconnect loop.
            if (socket !== this.socket)
                return;
            if (!this._intentionallyClosed && this._canReconnect(code)) {
                this._reconnect(code);
            }
            else if (!this._isReconnecting) {
                this._emitPermanentClose(code, reason);
            }
        });
        return socket;
    }
    // Reconnect is opt-in via onReconnecting so callers can pass
    // state (e.g. session IDs) into the new connection.
    _canReconnect(code) {
        if (this._intentionallyClosed)
            return false;
        if (!this._reconnectOptions)
            return false;
        if (this._reconnectOptions.maxRetries === 0)
            return false;
        if (!this._reconnectOptions.onReconnecting)
            return false;
        return (0, ws_1.isRecoverableClose)(code);
    }
    async _reconnect(closeCode) {
        if (!this.socket) {
            throw new error_1.OpenAIError('Internal error: failed to initialize socket. Please report this issue.');
        }
        if (this._isReconnecting || !this._reconnectOptions)
            return;
        this._isReconnecting = true;
        const maxRetries = this._reconnectOptions.maxRetries ?? 5;
        const initialDelay = this._reconnectOptions.initialDelay ?? 500;
        const maxDelay = this._reconnectOptions.maxDelay ?? 8000;
        for (let attempt = 1; attempt <= maxRetries; attempt++) {
            if (!this._canReconnect(closeCode)) {
                this._isReconnecting = false;
                if (!this._intentionallyClosed) {
                    this._onError(null, `WebSocket reconnect aborted: non-recoverable close code ${closeCode}`, undefined);
                }
                this._emitPermanentClose(this._intentionallyClosed ? this._closeCode : closeCode, this._intentionallyClosed ? this._closeReason : 'reconnect aborted');
                return;
            }
            const baseDelay = Math.min(initialDelay * Math.pow(2, attempt - 1), maxDelay);
            // Jitter: rand [0.75, 1.0] to spread out connection attempts without over-delaying
            const jitter = 0.75 + Math.random() * 0.25;
            const actualDelay = Math.round(baseDelay * jitter);
            let reconnectingEvent = {
                attempt,
                maxAttempts: maxRetries,
                delay: actualDelay,
                closeCode,
                parameters: this._parameters ? { ...this._parameters } : undefined,
            };
            let overrides;
            try {
                overrides = this._reconnectOptions.onReconnecting(reconnectingEvent);
            }
            catch (err) {
                this._isReconnecting = false;
                this._onError(null, 'onReconnecting callback threw', err);
                this._emitPermanentClose(closeCode, 'onReconnecting callback threw');
                return;
            }
            if (overrides && 'abort' in overrides && overrides.abort) {
                this._isReconnecting = false;
                this._emitPermanentClose(closeCode, 'reconnect aborted by handler');
                return;
            }
            if (overrides && 'parameters' in overrides) {
                this._parameters = overrides.parameters;
                reconnectingEvent = { ...reconnectingEvent, parameters: this._parameters };
            }
            try {
                this._emit('reconnecting', reconnectingEvent);
            }
            catch (err) {
                this._onError(null, 'onReconnecting callback threw', err);
            }
            this._internalEvents._emit('reconnecting', reconnectingEvent);
            if (!this._canReconnect(closeCode)) {
                this._isReconnecting = false;
                if (!this._intentionallyClosed) {
                    this._onError(null, `WebSocket reconnect aborted: non-recoverable close code ${closeCode}`, undefined);
                }
                this._emitPermanentClose(this._intentionallyClosed ? this._closeCode : closeCode, this._intentionallyClosed ? this._closeReason : 'reconnect aborted');
                return;
            }
            await (0, sleep_1.sleep)(actualDelay);
            if (!this._canReconnect(closeCode)) {
                this._isReconnecting = false;
                if (!this._intentionallyClosed) {
                    this._onError(null, `WebSocket reconnect aborted: non-recoverable close code ${closeCode}`, undefined);
                }
                this._emitPermanentClose(this._intentionallyClosed ? this._closeCode : closeCode, this._intentionallyClosed ? this._closeReason : 'reconnect aborted');
                return;
            }
            let closeCodePromise;
            try {
                const oldSocket = this.socket;
                this.socket = this._connect();
                // Registered synchronously after _connect() and before any
                // await so the code is captured even when ws emits 'close'
                // in the same tick as 'error' (e.g. abortHandshake).
                closeCodePromise = new Promise((resolve) => {
                    this.socket.once('close', resolve);
                });
                await this._awaitOpen(this.socket);
                this._internalEvents._emit('socketSwap', oldSocket, this.socket);
                this._isReconnecting = false;
                this._flushSendQueue();
                this._emit('reconnected');
                this._internalEvents._emit('reconnected');
                return;
            }
            catch {
                if (closeCodePromise) {
                    // ws may emit 'error' before 'close', so await the code
                    // rather than reading it synchronously.
                    closeCode = await closeCodePromise;
                }
            }
        }
        // All retries exhausted — surface an error so consumers can
        // distinguish retry failure from a clean close.
        this._isReconnecting = false;
        this._onError(null, `WebSocket reconnect failed after ${maxRetries} attempts (close code: ${closeCode})`, undefined);
        this._emitPermanentClose(closeCode, `reconnect failed after ${maxRetries} attempts`);
    }
    /**
     * Resolves once the socket is open, rejects if it errors or closes first
     */
    _awaitOpen(socket) {
        return new Promise((resolve, reject) => {
            const cleanup = () => {
                socket.off('open', onOpen);
                socket.off('error', onError);
                socket.off('close', onFail);
            };
            const onOpen = () => {
                cleanup();
                resolve();
            };
            const onError = (err) => {
                cleanup();
                reject(err);
            };
            const onFail = () => {
                cleanup();
                reject(new Error('socket closed before open'));
            };
            socket.once('open', onOpen);
            socket.once('error', onError);
            socket.once('close', onFail);
        });
    }
    _flushSendQueue() {
        if (!this.socket) {
            throw new error_1.OpenAIError('Internal error: failed to initialize socket. Please report this issue.');
        }
        try {
            this._sendQueue.flush((data) => this.socket.send((0, ws_1.flattenRawData)(data)));
        }
        catch (err) {
            this._onError(null, 'could not send queued data', err);
        }
    }
    /**
     * Emits the public `close` event with unsent messages and the internal
     * `close` event used by the async iterator.
     */
    _emitPermanentClose(code, reason) {
        this._lastCloseCode = code;
        this._lastCloseReason = reason;
        const unsent = this._sendQueue.drain();
        // Internal close fires first so the async iterator is guaranteed to
        // terminate even if a public 'close' listener throws.
        this._internalEvents._emit('close', code, reason, unsent);
        this._emit('close', code, reason, unsent);
    }
    _authHeaders() {
        const apiKey = this._client.apiKey;
        return typeof apiKey === 'string' && apiKey ? { Authorization: `Bearer ${apiKey}` } : {};
    }
}
exports.ResponsesWSBase = ResponsesWSBase;
//# sourceMappingURL=ws-base.js.map