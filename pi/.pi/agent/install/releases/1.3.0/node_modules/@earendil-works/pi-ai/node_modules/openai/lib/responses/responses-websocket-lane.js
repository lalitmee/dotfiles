"use strict";
var _ResponsesWebSocketLane_instances, _a, _ResponsesWebSocketLane_streamID, _ResponsesWebSocketLane_send, _ResponsesWebSocketLane_release, _ResponsesWebSocketLane_maxEvents, _ResponsesWebSocketLane_maxBytes, _ResponsesWebSocketLane_bytes, _ResponsesWebSocketLane_queue, _ResponsesWebSocketLane_queueHead, _ResponsesWebSocketLane_wake, _ResponsesWebSocketLane_failure, _ResponsesWebSocketLane_reading, _ResponsesWebSocketLane_acquireReader, _ResponsesWebSocketLane_receive, _ResponsesWebSocketLane_finalizeResponse, _ResponsesWebSocketLane_validateOutputItem, _ResponsesWebSocketLane_isValidOutputItem, _ResponsesWebSocketLane_validateTerminalResponse;
Object.defineProperty(exports, "__esModule", { value: true });
exports.ResponsesWebSocketLane = void 0;
exports.positiveInteger = positiveInteger;
const tslib_1 = require("../../internal/tslib.js");
const internal_base_1 = require("../../resources/responses/internal-base.js");
const error_1 = require("../../core/error.js");
const values_1 = require("../../internal/utils/values.js");
const canonical_output_text_1 = require("../../internal/responses/canonical-output-text.js");
function isEventType(event, ...types) {
    return types.some((type) => event.type === type);
}
/** @internal */
function positiveInteger(value) {
    if (!Number.isSafeInteger(value) || value <= 0) {
        throw new error_1.OpenAIError('Responses WebSocket limits must be positive integers');
    }
    return value;
}
/** A single ordered local consumer. Canceling receive cancels only that wait. */
class ResponsesWebSocketLane {
    /** Created by ResponsesWebSocketSession.lane().
     * @internal
     */
    constructor(streamID, send, release, maxEvents, maxBytes) {
        _ResponsesWebSocketLane_instances.add(this);
        _ResponsesWebSocketLane_streamID.set(this, void 0);
        _ResponsesWebSocketLane_send.set(this, void 0);
        _ResponsesWebSocketLane_release.set(this, void 0);
        _ResponsesWebSocketLane_maxEvents.set(this, void 0);
        _ResponsesWebSocketLane_maxBytes.set(this, void 0);
        _ResponsesWebSocketLane_bytes.set(this, 0);
        _ResponsesWebSocketLane_queue.set(this, []);
        _ResponsesWebSocketLane_queueHead.set(this, 0);
        _ResponsesWebSocketLane_wake.set(this, void 0);
        _ResponsesWebSocketLane_failure.set(this, void 0);
        _ResponsesWebSocketLane_reading.set(this, false);
        tslib_1.__classPrivateFieldSet(this, _ResponsesWebSocketLane_streamID, streamID, "f");
        Object.defineProperty(this, 'streamID', {
            value: streamID,
            enumerable: true,
            configurable: true,
            writable: true,
        });
        tslib_1.__classPrivateFieldSet(this, _ResponsesWebSocketLane_send, send, "f");
        tslib_1.__classPrivateFieldSet(this, _ResponsesWebSocketLane_release, release, "f");
        tslib_1.__classPrivateFieldSet(this, _ResponsesWebSocketLane_maxEvents, maxEvents, "f");
        tslib_1.__classPrivateFieldSet(this, _ResponsesWebSocketLane_maxBytes, maxBytes, "f");
    }
    /** Sends a request on this lane, omitting HTTP-only stream/background fields. previous_response_id remains caller-controlled. */
    create(request) {
        if (tslib_1.__classPrivateFieldGet(this, _ResponsesWebSocketLane_failure, "f")) {
            throw tslib_1.__classPrivateFieldGet(this, _ResponsesWebSocketLane_failure, "f");
        }
        const event = {
            ...request,
            type: 'response.create',
        };
        // The SDK owns this envelope; a top-level hook must not replace its routing.
        Object.defineProperty(event, 'toJSON', { value: undefined });
        delete event.stream;
        delete event.background;
        if (tslib_1.__classPrivateFieldGet(this, _ResponsesWebSocketLane_streamID, "f") === undefined) {
            delete event.stream_id;
        }
        else {
            Object.defineProperty(event, 'stream_id', { value: tslib_1.__classPrivateFieldGet(this, _ResponsesWebSocketLane_streamID, "f"), enumerable: true });
        }
        tslib_1.__classPrivateFieldGet(this, _ResponsesWebSocketLane_send, "f").call(this, event);
    }
    /** Returns the next raw event without filling omitted output or computing output_text. */
    async receive(options = {}) {
        tslib_1.__classPrivateFieldGet(this, _ResponsesWebSocketLane_instances, "m", _ResponsesWebSocketLane_acquireReader).call(this);
        try {
            const item = await tslib_1.__classPrivateFieldGet(this, _ResponsesWebSocketLane_instances, "m", _ResponsesWebSocketLane_receive).call(this, options);
            return item.event;
        }
        finally {
            tslib_1.__classPrivateFieldSet(this, _ResponsesWebSocketLane_reading, false, "f");
        }
    }
    /**
     * Consumes the next response, returning completed, failed, or incomplete results.
     * Collects finalized items and uses the existing Responses snapshot normalizer.
     * Socket error events retain their nested data.
     * Raw events remain observable on the original connection. maxResponseBytes
     * optionally bounds the cumulative UTF-8 event bytes consumed for this result.
     * There is no cumulative limit unless maxResponseBytes is supplied; the lane's
     * queue budget only limits events waiting to be consumed. Exceeding the limit
     * before a terminal event fails this lane, so the partial response cannot be
     * consumed as a new result by a later call. Cancellation after consuming events
     * also fails the lane; cancellation before consuming anything leaves it reusable.
     * An invalid completed output item or terminal response fails only this lane.
     */
    async finalResponse(options = {}) {
        const { signal } = options;
        const maxBytes = options.maxResponseBytes === undefined ? Infinity : positiveInteger(options.maxResponseBytes);
        const completedOutput = new Map();
        let consumedBytes = 0;
        tslib_1.__classPrivateFieldGet(this, _ResponsesWebSocketLane_instances, "m", _ResponsesWebSocketLane_acquireReader).call(this);
        try {
            for (;;) {
                // oxlint-disable-next-line eslint/no-await-in-loop -- Protocol order is required to accumulate one response.
                const { event, bytes } = await tslib_1.__classPrivateFieldGet(this, _ResponsesWebSocketLane_instances, "m", _ResponsesWebSocketLane_receive).call(this, { signal });
                consumedBytes += bytes;
                const terminal = isEventType(event, 'error', 'response.completed', 'response.failed', 'response.incomplete');
                if (consumedBytes > maxBytes) {
                    const error = new error_1.OpenAIError('Responses WebSocket accumulated response limit exceeded');
                    if (!terminal) {
                        this.fail(error);
                    }
                    throw error;
                }
                if (isEventType(event, 'error')) {
                    throw new internal_base_1.WebSocketError('Responses WebSocket request failed', event);
                }
                if (isEventType(event, 'response.created')) {
                    completedOutput.clear();
                }
                else if (isEventType(event, 'response.output_item.done')) {
                    tslib_1.__classPrivateFieldGet(this, _ResponsesWebSocketLane_instances, "m", _ResponsesWebSocketLane_validateOutputItem).call(this, event);
                    completedOutput.set(event.output_index, structuredClone(event.item));
                }
                if (terminal) {
                    tslib_1.__classPrivateFieldGet(this, _ResponsesWebSocketLane_instances, "m", _ResponsesWebSocketLane_validateTerminalResponse).call(this, event);
                    return tslib_1.__classPrivateFieldGet(this, _ResponsesWebSocketLane_instances, "m", _ResponsesWebSocketLane_finalizeResponse).call(this, event.response, completedOutput);
                }
            }
        }
        catch (error) {
            if (consumedBytes > 0 && signal?.aborted) {
                this.fail(new error_1.OpenAIError('Responses WebSocket final response canceled after consuming events'));
            }
            throw error;
        }
        finally {
            tslib_1.__classPrivateFieldSet(this, _ResponsesWebSocketLane_reading, false, "f");
        }
    }
    /** Detaches this consumer without canceling remote work. Its ID remains reserved until reconnect. */
    close() {
        this.fail(new error_1.OpenAIError('Responses WebSocket lane is closed'));
    }
    /** Preserves already accepted events when the transport ends.
     * @internal
     */
    end(error) {
        if (tslib_1.__classPrivateFieldGet(this, _ResponsesWebSocketLane_failure, "f")) {
            return;
        }
        tslib_1.__classPrivateFieldSet(this, _ResponsesWebSocketLane_failure, error, "f");
        // Keep queued events owned by the session until drain, close, or reconnect.
        tslib_1.__classPrivateFieldGet(this, _ResponsesWebSocketLane_wake, "f")?.call(this);
    }
    /** @internal */
    get ended() {
        return tslib_1.__classPrivateFieldGet(this, _ResponsesWebSocketLane_failure, "f") !== undefined;
    }
    /** @internal */
    push(event, bytes) {
        if (tslib_1.__classPrivateFieldGet(this, _ResponsesWebSocketLane_failure, "f")) {
            tslib_1.__classPrivateFieldGet(this, _ResponsesWebSocketLane_release, "f").call(this, bytes);
            return;
        }
        if (tslib_1.__classPrivateFieldGet(this, _ResponsesWebSocketLane_queue, "f").length - tslib_1.__classPrivateFieldGet(this, _ResponsesWebSocketLane_queueHead, "f") >= tslib_1.__classPrivateFieldGet(this, _ResponsesWebSocketLane_maxEvents, "f") || bytes > tslib_1.__classPrivateFieldGet(this, _ResponsesWebSocketLane_maxBytes, "f") - tslib_1.__classPrivateFieldGet(this, _ResponsesWebSocketLane_bytes, "f")) {
            tslib_1.__classPrivateFieldGet(this, _ResponsesWebSocketLane_release, "f").call(this, bytes);
            this.fail(new error_1.OpenAIError('Responses WebSocket lane buffer limit exceeded'));
            return;
        }
        tslib_1.__classPrivateFieldSet(this, _ResponsesWebSocketLane_bytes, tslib_1.__classPrivateFieldGet(this, _ResponsesWebSocketLane_bytes, "f") + bytes, "f");
        tslib_1.__classPrivateFieldGet(this, _ResponsesWebSocketLane_queue, "f").push({ event, bytes });
        tslib_1.__classPrivateFieldGet(this, _ResponsesWebSocketLane_wake, "f")?.call(this);
    }
    /** @internal */
    fail(error) {
        tslib_1.__classPrivateFieldSet(this, _ResponsesWebSocketLane_failure, tslib_1.__classPrivateFieldGet(this, _ResponsesWebSocketLane_failure, "f") ?? error, "f");
        for (const item of tslib_1.__classPrivateFieldGet(this, _ResponsesWebSocketLane_queue, "f")) {
            if (item) {
                tslib_1.__classPrivateFieldGet(this, _ResponsesWebSocketLane_release, "f").call(this, item.bytes);
            }
        }
        tslib_1.__classPrivateFieldGet(this, _ResponsesWebSocketLane_queue, "f").length = 0;
        tslib_1.__classPrivateFieldSet(this, _ResponsesWebSocketLane_queueHead, 0, "f");
        tslib_1.__classPrivateFieldSet(this, _ResponsesWebSocketLane_bytes, 0, "f");
        tslib_1.__classPrivateFieldGet(this, _ResponsesWebSocketLane_wake, "f")?.call(this);
    }
}
exports.ResponsesWebSocketLane = ResponsesWebSocketLane;
_a = ResponsesWebSocketLane, _ResponsesWebSocketLane_streamID = new WeakMap(), _ResponsesWebSocketLane_send = new WeakMap(), _ResponsesWebSocketLane_release = new WeakMap(), _ResponsesWebSocketLane_maxEvents = new WeakMap(), _ResponsesWebSocketLane_maxBytes = new WeakMap(), _ResponsesWebSocketLane_bytes = new WeakMap(), _ResponsesWebSocketLane_queue = new WeakMap(), _ResponsesWebSocketLane_queueHead = new WeakMap(), _ResponsesWebSocketLane_wake = new WeakMap(), _ResponsesWebSocketLane_failure = new WeakMap(), _ResponsesWebSocketLane_reading = new WeakMap(), _ResponsesWebSocketLane_instances = new WeakSet(), _ResponsesWebSocketLane_acquireReader = function _ResponsesWebSocketLane_acquireReader() {
    if (tslib_1.__classPrivateFieldGet(this, _ResponsesWebSocketLane_reading, "f")) {
        throw new error_1.OpenAIError('Responses WebSocket lane already has a reader');
    }
    tslib_1.__classPrivateFieldSet(this, _ResponsesWebSocketLane_reading, true, "f");
}, _ResponsesWebSocketLane_receive = async function _ResponsesWebSocketLane_receive(options) {
    const { signal } = options;
    for (;;) {
        if (signal?.aborted) {
            throw signal.reason;
        }
        const item = tslib_1.__classPrivateFieldGet(this, _ResponsesWebSocketLane_queue, "f")[tslib_1.__classPrivateFieldGet(this, _ResponsesWebSocketLane_queueHead, "f")];
        if (item) {
            tslib_1.__classPrivateFieldGet(this, _ResponsesWebSocketLane_queue, "f")[tslib_1.__classPrivateFieldGet(this, _ResponsesWebSocketLane_queueHead, "f")] = undefined;
            tslib_1.__classPrivateFieldSet(this, _ResponsesWebSocketLane_queueHead, tslib_1.__classPrivateFieldGet(this, _ResponsesWebSocketLane_queueHead, "f") + 1, "f");
            if (tslib_1.__classPrivateFieldGet(this, _ResponsesWebSocketLane_queueHead, "f") >= 64 && tslib_1.__classPrivateFieldGet(this, _ResponsesWebSocketLane_queueHead, "f") * 2 >= tslib_1.__classPrivateFieldGet(this, _ResponsesWebSocketLane_queue, "f").length) {
                tslib_1.__classPrivateFieldGet(this, _ResponsesWebSocketLane_queue, "f").splice(0, tslib_1.__classPrivateFieldGet(this, _ResponsesWebSocketLane_queueHead, "f"));
                tslib_1.__classPrivateFieldSet(this, _ResponsesWebSocketLane_queueHead, 0, "f");
            }
            tslib_1.__classPrivateFieldGet(this, _ResponsesWebSocketLane_release, "f").call(this, item.bytes);
            tslib_1.__classPrivateFieldSet(this, _ResponsesWebSocketLane_bytes, tslib_1.__classPrivateFieldGet(this, _ResponsesWebSocketLane_bytes, "f") - item.bytes, "f");
            return item;
        }
        if (tslib_1.__classPrivateFieldGet(this, _ResponsesWebSocketLane_failure, "f")) {
            throw tslib_1.__classPrivateFieldGet(this, _ResponsesWebSocketLane_failure, "f");
        }
        // oxlint-disable-next-line eslint/no-await-in-loop, promise/avoid-new -- A single ordered consumer waits for socket callbacks; canceling a wait must preserve queued events.
        await new Promise((resolve) => {
            tslib_1.__classPrivateFieldSet(this, _ResponsesWebSocketLane_wake, () => resolve(), "f");
            signal?.addEventListener('abort', tslib_1.__classPrivateFieldGet(this, _ResponsesWebSocketLane_wake, "f"), { once: true });
        }).finally(() => {
            if (tslib_1.__classPrivateFieldGet(this, _ResponsesWebSocketLane_wake, "f")) {
                signal?.removeEventListener('abort', tslib_1.__classPrivateFieldGet(this, _ResponsesWebSocketLane_wake, "f"));
            }
            tslib_1.__classPrivateFieldSet(this, _ResponsesWebSocketLane_wake, undefined, "f");
        });
    }
}, _ResponsesWebSocketLane_finalizeResponse = function _ResponsesWebSocketLane_finalizeResponse(response, completedOutput) {
    const context = (0, canonical_output_text_1.createCanonicalResponseContext)();
    try {
        // Socket deltas need not include the setup events required by SSE.
        // The terminal response is authoritative; finalized items fill an omitted output.
        const completedEntries = [...completedOutput];
        completedEntries.sort(([left], [right]) => left - right);
        const output = (0, values_1.hasOwn)(response, 'output') ? response.output : undefined;
        const outputText = (0, values_1.hasOwn)(response, 'output_text') ? response.output_text : undefined;
        if ((output !== undefined &&
            output !== null &&
            (!Array.isArray(output) ||
                !output.every((item) => tslib_1.__classPrivateFieldGet(_a, _a, "m", _ResponsesWebSocketLane_isValidOutputItem).call(_a, item)))) ||
            // oxlint-disable-next-line anti-slop/no-runtime-typeof -- Validate present wire fields before exposing a typed final response.
            (outputText !== undefined && outputText !== null && typeof outputText !== 'string')) {
            throw new error_1.OpenAIError('Invalid Responses WebSocket terminal response');
        }
        const snapshot = (0, canonical_output_text_1.cloneResponse)(context, {
            ...response,
            output: output ?? completedEntries.map(([, item]) => item),
            output_text: outputText ?? '',
        });
        if (outputText === undefined || outputText === null) {
            (0, canonical_output_text_1.ensureCanonicalOutputText)(context, snapshot);
        }
        return snapshot;
    }
    catch {
        const error = new error_1.OpenAIError('Invalid Responses WebSocket terminal response');
        this.fail(error);
        throw error;
    }
}, _ResponsesWebSocketLane_validateOutputItem = function _ResponsesWebSocketLane_validateOutputItem(event) {
    if (!(0, values_1.hasOwn)(event, 'output_index') ||
        !Number.isSafeInteger(event.output_index) ||
        event.output_index < 0) {
        const error = new error_1.OpenAIError('Responses WebSocket output index must be a nonnegative integer');
        this.fail(error);
        throw error;
    }
    if (!(0, values_1.hasOwn)(event, 'item')) {
        const error = new error_1.OpenAIError('Responses WebSocket output item must be an own property');
        this.fail(error);
        throw error;
    }
    // oxlint-disable-next-line anti-slop/no-runtime-typeof -- Completed output items must be wire objects before they enter the typed response.
    if (event.item === null || typeof event.item !== 'object' || Array.isArray(event.item)) {
        const error = new error_1.OpenAIError('Responses WebSocket output item must be an object');
        this.fail(error);
        throw error;
    }
    if (!tslib_1.__classPrivateFieldGet(_a, _a, "m", _ResponsesWebSocketLane_isValidOutputItem).call(_a, event.item)) {
        const error = new error_1.OpenAIError('Invalid Responses WebSocket completed output item');
        this.fail(error);
        throw error;
    }
}, _ResponsesWebSocketLane_isValidOutputItem = function _ResponsesWebSocketLane_isValidOutputItem(item) {
    // oxlint-disable-next-line anti-slop/no-runtime-typeof -- Wire items require an own string discriminator, including unknown future variants.
    if (!(0, values_1.isObj)(item) || !(0, values_1.hasOwn)(item, 'type') || typeof item['type'] !== 'string') {
        return false;
    }
    if (item['type'] !== 'message') {
        return true;
    }
    return ((0, values_1.hasOwn)(item, 'content') &&
        Array.isArray(item['content']) &&
        // oxlint-disable-next-line anti-slop/no-unknown-parameters -- Validate untyped message parts before exposing the final response.
        item['content'].every((content) => {
            // oxlint-disable-next-line anti-slop/no-runtime-typeof -- Message parts use the same wire discriminator contract.
            if (!(0, values_1.isObj)(content) || !(0, values_1.hasOwn)(content, 'type') || typeof content['type'] !== 'string') {
                return false;
            }
            return (content['type'] !== 'output_text' ||
                // oxlint-disable-next-line anti-slop/no-runtime-typeof -- Canonical text accumulation consumes this exact wire field.
                ((0, values_1.hasOwn)(content, 'text') && typeof content['text'] === 'string'));
        }));
}, _ResponsesWebSocketLane_validateTerminalResponse = function _ResponsesWebSocketLane_validateTerminalResponse(event) {
    if (!(0, values_1.hasOwn)(event, 'response') ||
        event.response === null ||
        // oxlint-disable-next-line anti-slop/no-runtime-typeof -- Validate the untrusted terminal envelope before normalizing a typed response snapshot.
        typeof event.response !== 'object' ||
        Array.isArray(event.response)) {
        const error = new error_1.OpenAIError('Responses WebSocket terminal response must be an object');
        this.fail(error);
        throw error;
    }
};
//# sourceMappingURL=responses-websocket-lane.js.map