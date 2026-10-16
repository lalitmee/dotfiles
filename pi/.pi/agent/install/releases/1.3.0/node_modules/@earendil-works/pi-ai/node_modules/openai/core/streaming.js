"use strict";
var _Stream_instances, _Stream_client, _Stream_isTeeBranch, _Stream_cancelIterator;
Object.defineProperty(exports, "__esModule", { value: true });
exports.Stream = void 0;
exports._iterSSEMessages = _iterSSEMessages;
const tslib_1 = require("../internal/tslib.js");
const error_1 = require("./error.js");
const shims_1 = require("../internal/shims.js");
const line_1 = require("../internal/decoders/line.js");
const errors_1 = require("../internal/errors.js");
const bytes_1 = require("../internal/utils/bytes.js");
const log_1 = require("../internal/utils/log.js");
function isTransportAbortError(error) {
    return !(error instanceof error_1.APIError) && (0, errors_1.isAbortError)(error);
}
function createStreamTeeQueue() {
    let entries = [];
    let head = 0;
    let canceled = false;
    return {
        get length() {
            return entries.length - head;
        },
        get canceled() {
            return canceled;
        },
        enqueue(value) {
            if (!canceled) {
                entries.push(value);
            }
        },
        dequeue() {
            if (head === entries.length) {
                return undefined;
            }
            const value = entries[head];
            entries[head] = undefined;
            head += 1;
            if (head === entries.length) {
                entries = [];
                head = 0;
            }
            else if (head >= 1024 && head * 2 >= entries.length) {
                entries = entries.slice(head);
                head = 0;
            }
            return value;
        },
        cancel() {
            canceled = true;
            entries.length = 0;
            head = 0;
        },
    };
}
/**
 * A single-consumption asynchronous API response stream.
 *
 * Use {@link Stream.tee} when two consumers need the same events. Breaking out of
 * a response-backed stream early aborts its request; branches created by `tee()`
 * instead share {@link Stream.controller} for explicit cancellation.
 */
class Stream {
    /** Wraps an asynchronous event iterator and the controller that owns its request. */
    constructor(iterator, controller, client) {
        _Stream_instances.add(this);
        _Stream_client.set(this, void 0);
        _Stream_isTeeBranch.set(this, false);
        this.iterator = iterator;
        this.controller = controller;
        tslib_1.__classPrivateFieldSet(this, _Stream_client, client, "f");
    }
    /**
     * Decodes an SSE response into parsed JSON events.
     *
     * The resulting stream can be consumed only once, ignores events after `[DONE]`, and
     * surfaces API error payloads as `APIError` instances. When
     * `synthesizeEventData` is enabled, each item also includes its SSE event name.
     */
    static fromSSEResponse(response, controller, client, synthesizeEventData) {
        let consumed = false;
        const logger = client ? (0, log_1.loggerFor)(client) : console;
        async function* iterator() {
            if (consumed) {
                throw new error_1.OpenAIError('Cannot iterate over a consumed stream, use `.tee()` to split the stream.');
            }
            consumed = true;
            let done = false;
            let receivedCompletionSentinel = false;
            const messages = _iterSSEMessages(response, controller);
            const closeMessages = messages.return.bind(messages);
            messages.return = (value) => {
                // Abort before nested iterator cleanup can wait on the response body's cancellation.
                if (!receivedCompletionSentinel) {
                    controller.abort();
                }
                return closeMessages(value);
            };
            try {
                for await (const sse of messages) {
                    if (sse.data === '[DONE]') {
                        receivedCompletionSentinel = true;
                        break;
                    }
                    if (sse.event === null || !sse.event.startsWith('thread.')) {
                        let data;
                        try {
                            data = JSON.parse(sse.data);
                        }
                        catch {
                            logger.error(`Could not parse message into JSON:`);
                            logger.error(`From chunk:`);
                            throw new SyntaxError('Error reading response: malformed server-sent event JSON.');
                        }
                        if (sse.event === 'error') {
                            throw new error_1.APIError(undefined, data?.error ?? data, undefined, response.headers);
                        }
                        if (data && data.error) {
                            throw new error_1.APIError(undefined, data.error, undefined, response.headers);
                        }
                        yield synthesizeEventData ? { event: sse.event, data } : data;
                    }
                    else {
                        let data;
                        try {
                            data = JSON.parse(sse.data);
                        }
                        catch {
                            logger.error(`Could not parse message into JSON:`);
                            logger.error(`From chunk:`);
                            throw new SyntaxError('Error reading response: malformed server-sent event JSON.');
                        }
                        // SAFETY: Named SSE events use the public stream's event/data envelope; Item is the caller-selected API event contract.
                        yield { event: sse.event, data };
                    }
                }
                done = true;
            }
            catch (e) {
                // Abort errors and cleanup failures after the completion sentinel are non-fatal.
                if (receivedCompletionSentinel ||
                    isTransportAbortError(e) ||
                    (controller.signal.aborted && e === controller.signal.reason)) {
                    return;
                }
                throw e;
            }
            finally {
                // If the user `break`s, abort the ongoing request.
                if (!done) {
                    controller.abort();
                }
            }
        }
        return new Stream(iterator, controller, client);
    }
    /**
     * Generates a Stream from a newline-separated ReadableStream
     * where each item is a JSON value.
     */
    static fromReadableStream(readableStream, controller, client) {
        let consumed = false;
        async function* iterLines() {
            const lineDecoder = new line_1.LineDecoder();
            const reader = readableStream.getReader();
            let closed = false;
            let cancelPromise;
            const cancel = () => {
                cancelPromise ?? (cancelPromise = reader.cancel());
                cancelPromise.catch(() => undefined);
            };
            controller.signal.addEventListener('abort', cancel, { once: true });
            try {
                if (controller.signal.aborted) {
                    cancel();
                    return;
                }
                while (true) {
                    const { value: chunk, done } = await reader.read();
                    if (done) {
                        closed = true;
                        break;
                    }
                    if (controller.signal.aborted) {
                        return;
                    }
                    for (const line of lineDecoder.decode(chunk)) {
                        if (controller.signal.aborted) {
                            return;
                        }
                        yield line;
                    }
                }
                if (controller.signal.aborted) {
                    return;
                }
                for (const line of lineDecoder.flush()) {
                    if (controller.signal.aborted) {
                        return;
                    }
                    yield line;
                }
            }
            finally {
                controller.signal.removeEventListener('abort', cancel);
                if (!closed) {
                    cancel();
                }
                reader.releaseLock();
            }
        }
        async function* iterator() {
            if (consumed) {
                throw new error_1.OpenAIError('Cannot iterate over a consumed stream, use `.tee()` to split the stream.');
            }
            consumed = true;
            let done = false;
            try {
                for await (const line of iterLines()) {
                    if (line) {
                        let data;
                        try {
                            // SAFETY: Item is the caller's NDJSON response contract; JSON syntax is parsed here without a per-resource runtime schema.
                            data = JSON.parse(line);
                        }
                        catch (error) {
                            if (error instanceof SyntaxError) {
                                throw new SyntaxError('Error reading response: malformed newline-delimited JSON.');
                            }
                            throw error;
                        }
                        yield data;
                    }
                }
                done = true;
            }
            catch (e) {
                // If the user calls `stream.controller.abort()`, we should exit without throwing.
                if (controller.signal.aborted || (0, errors_1.isAbortError)(e)) {
                    return;
                }
                throw e;
            }
            finally {
                // If the user `break`s, abort the ongoing request.
                if (!done) {
                    controller.abort();
                }
            }
        }
        return new Stream(iterator, controller, client);
    }
    /** Starts consuming this stream; attempting to consume it again throws. */
    [(_Stream_client = new WeakMap(), _Stream_isTeeBranch = new WeakMap(), _Stream_instances = new WeakSet(), Symbol.asyncIterator)]() {
        return this.iterator();
    }
    /**
     * Splits the stream into two streams which can be
     * independently read from at different speeds.
     * Closing a branch discards its buffered events without stopping its sibling.
     * Future reads on that branch finish immediately; previously issued `next()`
     * promises remain shared with its sibling and may still resolve with events.
     * Closing both branches invokes the source iterator's `return()` when available.
     * For {@link Stream.fromReadableStream}, closing both branches before iteration
     * starts does not cancel the supplied readable; cancel that readable directly.
     */
    tee() {
        const { controller } = this;
        const left = createStreamTeeQueue();
        const right = createStreamTeeQueue();
        const iterator = this.iterator();
        const teeIterator = (queue) => ({
            next: () => {
                if (queue.canceled) {
                    return Promise.resolve({ value: undefined, done: true });
                }
                if (queue.length === 0) {
                    const result = iterator.next();
                    left.enqueue(result);
                    right.enqueue(result);
                }
                return queue.dequeue();
            },
            return: async () => {
                if (!queue.canceled) {
                    queue.cancel();
                    if (left.canceled && right.canceled) {
                        await tslib_1.__classPrivateFieldGet(this, _Stream_instances, "m", _Stream_cancelIterator).call(this, iterator, controller);
                    }
                }
                return { value: undefined, done: true };
            },
        });
        const branch = (queue) => {
            const stream = new Stream(() => teeIterator(queue), controller, tslib_1.__classPrivateFieldGet(this, _Stream_client, "f"));
            tslib_1.__classPrivateFieldSet(stream, _Stream_isTeeBranch, true, "f");
            return stream;
        };
        return [branch(left), branch(right)];
    }
    /**
     * Converts this stream to a newline-separated ReadableStream of
     * JSON stringified values in the stream
     * which can be turned back into a Stream with `Stream.fromReadableStream()`.
     * Canceling a response-backed readable aborts its request. Canceling a tee
     * branch discards its buffered events and leaves sibling consumers running.
     * Read or serialization failures also release the iterator without replacing the original error.
     */
    toReadableStream() {
        const { controller } = this;
        let iter;
        let cancellation;
        const cancel = () => (cancellation ?? (cancellation = tslib_1.__classPrivateFieldGet(this, _Stream_instances, "m", _Stream_cancelIterator).call(this, iter, controller)));
        return (0, shims_1.makeReadableStream)({
            start: async () => {
                iter = this[Symbol.asyncIterator]();
            },
            async pull(ctrl) {
                try {
                    const { value, done } = await iter.next();
                    if (done) {
                        return ctrl.close();
                    }
                    const bytes = (0, bytes_1.encodeUTF8)(JSON.stringify(value) + '\n');
                    ctrl.enqueue(bytes);
                }
                catch (err) {
                    ctrl.error(err);
                    // An errored readable never invokes its cancel hook. Release the source ourselves,
                    // without letting failed or stalled cleanup replace the read/serialization error.
                    void cancel().catch(() => undefined);
                }
            },
            cancel,
        });
    }
}
exports.Stream = Stream;
_Stream_cancelIterator = async function _Stream_cancelIterator(iterator, controller) {
    const returnMethod = iterator.return;
    if (returnMethod) {
        if (!tslib_1.__classPrivateFieldGet(this, _Stream_isTeeBranch, "f")) {
            controller.abort();
        }
        // oxlint-disable-next-line anti-slop/no-reflect-apply -- Invoke the captured iterator method with its receiver even if a caller-supplied function shadows call.
        await Reflect.apply(returnMethod, iterator, []);
    }
};
function createAbortableSSESource(body, signal) {
    const reader = typeof body.getReader === 'function' ? body.getReader() : undefined;
    const source = reader
        ? {
            next: () => reader.read(),
            return: () => reader.cancel(),
        }
        : (0, shims_1.ReadableStreamToAsyncIterable)(body)[Symbol.asyncIterator]();
    const ended = { value: undefined, done: true };
    let closed = false;
    let canceled = false;
    let cancellation;
    let interrupt;
    const waitForAbort = () => 
    // oxlint-disable-next-line promise/avoid-new -- AbortSignal callbacks need a portable Promise bridge.
    new Promise((resolve) => {
        interrupt = resolve;
    });
    const cancel = () => {
        if (canceled || closed) {
            return cancellation;
        }
        canceled = true;
        try {
            cancellation = Promise.resolve(source.return?.());
        }
        catch (error) {
            cancellation = Promise.reject(error);
        }
        cancellation.catch(() => undefined);
        return cancellation;
    };
    const abort = () => {
        queueMicrotask(() => {
            interrupt?.();
            cancel();
        });
    };
    const iterator = {
        async next() {
            if (signal.aborted) {
                return ended;
            }
            const aborted = waitForAbort().then(() => ended);
            try {
                const result = await Promise.race([source.next(), aborted]);
                if (signal.aborted) {
                    return ended;
                }
                if (result.done) {
                    closed = true;
                    return ended;
                }
                return { value: result.value, done: false };
            }
            catch (error) {
                if (signal.aborted && ((0, errors_1.isAbortError)(error) || error === signal.reason)) {
                    return ended;
                }
                throw error;
            }
            finally {
                interrupt = undefined;
            }
        },
        async return() {
            const pending = cancel();
            if (pending && !signal.aborted) {
                const aborted = waitForAbort();
                try {
                    if (!signal.aborted) {
                        await Promise.race([pending, aborted]);
                    }
                }
                finally {
                    interrupt = undefined;
                }
            }
            return ended;
        },
        [Symbol.asyncIterator]() {
            return this;
        },
    };
    return {
        iterator,
        start() {
            signal.addEventListener('abort', abort, { once: true });
            if (signal.aborted) {
                abort();
            }
        },
        async cleanup(failed) {
            let cleanupError;
            try {
                signal.removeEventListener('abort', abort);
            }
            catch (error) {
                cleanupError = error;
            }
            if (!closed) {
                const pending = cancel();
                if (pending && !failed && !signal.aborted) {
                    try {
                        await pending;
                    }
                    catch (error) {
                        cleanupError ?? (cleanupError = error);
                    }
                }
            }
            if (reader) {
                try {
                    reader.releaseLock();
                }
                catch (error) {
                    cleanupError ?? (cleanupError = error);
                }
            }
            if (cleanupError !== undefined && !failed && !signal.aborted) {
                throw cleanupError;
            }
        },
    };
}
/**
 * Decodes complete SSE records from a response and aborts when its body is absent.
 * Complete events are decoded on demand without imposing a line or event size limit.
 *
 * @yields {ServerSentEvent} Each decoded server-sent event in wire order.
 */
async function* _iterSSEMessages(response, controller) {
    if (!response.body) {
        controller.abort();
        // SAFETY: navigator is optional across SDK runtimes; this compatibility branch checks its presence before identifying React Native.
        if (globalThis.navigator !== undefined &&
            globalThis.navigator.product === 'ReactNative') {
            throw new error_1.OpenAIError(`The default react-native fetch implementation does not support streaming. Please use expo/fetch: https://docs.expo.dev/versions/latest/sdk/expo/#expofetch-api`);
        }
        throw new error_1.OpenAIError(`Attempted to iterate over a response with no body`);
    }
    const sseDecoder = new SSEDecoder();
    const lineDecoder = new line_1.LineDecoder();
    const { signal } = controller;
    const source = createAbortableSSESource(response.body, signal);
    let failed = false;
    try {
        source.start();
        for await (const sseChunk of iterSSEChunks(source.iterator)) {
            if (signal.aborted) {
                return;
            }
            for (const line of lineDecoder.decode(sseChunk)) {
                if (signal.aborted) {
                    return;
                }
                const sse = sseDecoder.decode(line);
                if (sse) {
                    yield sse;
                }
            }
        }
        if (signal.aborted) {
            return;
        }
        for (const line of lineDecoder.flush()) {
            if (signal.aborted) {
                return;
            }
            const sse = sseDecoder.decode(line);
            if (sse) {
                yield sse;
            }
        }
        // Servers sometimes omit the trailing blank line that normally
        // terminates the last event. Flush any in-progress event exactly once.
        if (signal.aborted) {
            return;
        }
        const pending = sseDecoder.flush();
        if (pending) {
            yield pending;
        }
    }
    catch (error) {
        failed = true;
        if (!signal.aborted || (!(0, errors_1.isAbortError)(error) && error !== signal.reason)) {
            throw error;
        }
    }
    finally {
        await source.cleanup(failed);
    }
}
// A `\r\n\r\n` separator may retain up to three bytes from the previous chunk.
const DOUBLE_NEWLINE_DELIMITER_MAX_OVERLAP_BYTES = 3;
/**
 * Given an async iterable iterator, iterates over it and yields full
 * SSE chunks, i.e. yields when a double new-line is encountered.
 *
 * @yields {Uint8Array} A complete SSE chunk.
 */
async function* iterSSEChunks(iterator) {
    let data = new Uint8Array();
    let dataStart = 0;
    let dataEnd = 0;
    let searchStartIndex = 0;
    for await (const chunk of iterator) {
        if (chunk == null) {
            continue;
        }
        let binaryChunk;
        if (chunk instanceof ArrayBuffer) {
            binaryChunk = new Uint8Array(chunk);
        }
        else if (typeof chunk === 'string') {
            binaryChunk = (0, bytes_1.encodeUTF8)(chunk);
        }
        else {
            binaryChunk = chunk;
        }
        if (dataEnd + binaryChunk.length > data.length) {
            const bufferedLength = dataEnd - dataStart;
            // Compact only when it reclaims substantial space without moving a large live tail repeatedly.
            if (dataStart >= data.length / 2 && bufferedLength + binaryChunk.length <= data.length) {
                data.copyWithin(0, dataStart, dataEnd);
            }
            else {
                const newData = new Uint8Array(Math.max(data.length * 2, bufferedLength + binaryChunk.length));
                newData.set(data.subarray(dataStart, dataEnd));
                data = newData;
            }
            searchStartIndex -= dataStart;
            dataStart = 0;
            dataEnd = bufferedLength;
        }
        data.set(binaryChunk, dataEnd);
        dataEnd += binaryChunk.length;
        let patternIndex;
        while ((patternIndex = (0, line_1.findDoubleNewlineIndex)(data.subarray(searchStartIndex, dataEnd))) !== -1) {
            patternIndex += searchStartIndex;
            yield data.slice(dataStart, patternIndex);
            dataStart = patternIndex;
            searchStartIndex = dataStart;
        }
        searchStartIndex = Math.max(dataStart, dataEnd - DOUBLE_NEWLINE_DELIMITER_MAX_OVERLAP_BYTES);
    }
    if (dataEnd > dataStart) {
        yield data.slice(dataStart, dataEnd);
    }
}
class SSEDecoder {
    constructor() {
        this.event = null;
        this.data = [];
        this.chunks = [];
    }
    decode(line) {
        if (line.endsWith('\r')) {
            line = line.slice(0, -1);
        }
        if (!line) {
            // empty line and we didn't previously encounter any messages
            if (!this.event && !this.data.length) {
                return null;
            }
            const sse = {
                event: this.event,
                data: this.data.join('\n'),
                raw: this.chunks,
            };
            this.event = null;
            this.data = [];
            this.chunks = [];
            return sse;
        }
        this.chunks.push(line);
        if (line.startsWith(':')) {
            return null;
        }
        const [fieldname, , initialValue] = partition(line, ':');
        let value = initialValue;
        if (value.startsWith(' ')) {
            value = value.slice(1);
        }
        if (fieldname === 'event') {
            this.event = value;
        }
        else if (fieldname === 'data') {
            this.data.push(value);
        }
        return null;
    }
    /**
     * Emits a pending event at EOF when the stream omitted the trailing blank
     * line. Returns `null` when no event is in progress so a record that already
     * ended with a blank line is not delivered twice.
     */
    flush() {
        return this.decode('');
    }
}
function partition(str, delimiter) {
    const index = str.indexOf(delimiter);
    if (index !== -1) {
        return [str.slice(0, index), delimiter, str.slice(index + delimiter.length)];
    }
    return [str, '', ''];
}
//# sourceMappingURL=streaming.js.map