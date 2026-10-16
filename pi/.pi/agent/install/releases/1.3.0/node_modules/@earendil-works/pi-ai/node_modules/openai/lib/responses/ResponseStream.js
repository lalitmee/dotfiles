"use strict";
var _ResponseStream_instances, _ResponseStream_params, _ResponseStream_currentResponseSnapshot, _ResponseStream_finalResponse, _ResponseStream_accumulatorContext, _ResponseStream_beginRequest, _ResponseStream_addEvent, _ResponseStream_endRequest;
Object.defineProperty(exports, "__esModule", { value: true });
exports.ResponseStream = void 0;
const tslib_1 = require("../../internal/tslib.js");
const error_1 = require("../../error.js");
const EventStream_1 = require("../EventStream.js");
const response_accumulator_1 = require("../../internal/responses/response-accumulator.js");
const ResponsesParser_1 = require("../ResponsesParser.js");
const streaming_1 = require("../../streaming.js");
/** Streams Responses API events while accumulating the latest response and parsed output. */
class ResponseStream extends EventStream_1.EventStream {
    /** Creates an unstarted stream, retaining request parameters for structured-output parsing. */
    constructor(params) {
        super();
        _ResponseStream_instances.add(this);
        _ResponseStream_params.set(this, void 0);
        _ResponseStream_currentResponseSnapshot.set(this, void 0);
        _ResponseStream_finalResponse.set(this, void 0);
        _ResponseStream_accumulatorContext.set(this, (0, response_accumulator_1.createResponseContext)());
        tslib_1.__classPrivateFieldSet(this, _ResponseStream_params, params, "f");
    }
    /** Starts a new response stream or replays an existing response by its identifier. */
    static createResponse(client, params, options) {
        // SAFETY: The runner's request path forces stream: true; the constructor retains the same caller parameters for parsing metadata.
        const runner = new ResponseStream(params);
        runner._run(() => runner._createOrRetrieveResponse(client, params, {
            ...options,
            __metadata: { ...options?.__metadata, helperMethod: 'stream' },
        }));
        return runner;
    }
    /** Consumes serialized response events from a readable stream in another runtime. */
    static fromReadableStream(stream) {
        const runner = new ResponseStream(null);
        runner._run(() => runner._fromReadableStream(stream));
        return runner;
    }
    async _createOrRetrieveResponse(client, params, options) {
        this._listenForAbort(options?.signal);
        tslib_1.__classPrivateFieldGet(this, _ResponseStream_instances, "m", _ResponseStream_beginRequest).call(this);
        let stream;
        let starting_after = null;
        if ('response_id' in params) {
            // Keep the full replay so that `accumulateResponse()` sees `response.created` and can build
            // complete snapshots before locally filtering events at `starting_after`.
            stream = await client.responses.retrieve(params.response_id, { stream: true }, { ...options, signal: this.controller.signal, stream: true });
            starting_after = params.starting_after ?? null;
        }
        else {
            stream = await client.responses.create({ ...params, stream: true }, { ...options, signal: this.controller.signal });
        }
        this._connected();
        for await (const event of stream) {
            tslib_1.__classPrivateFieldGet(this, _ResponseStream_instances, "m", _ResponseStream_addEvent).call(this, event, starting_after);
        }
        if (stream.controller.signal?.aborted) {
            throw this._userAbortError();
        }
        return tslib_1.__classPrivateFieldGet(this, _ResponseStream_instances, "m", _ResponseStream_endRequest).call(this);
    }
    async _fromReadableStream(readableStream, options) {
        this._listenForAbort(options?.signal);
        tslib_1.__classPrivateFieldGet(this, _ResponseStream_instances, "m", _ResponseStream_beginRequest).call(this);
        this._connected();
        const stream = streaming_1.Stream.fromReadableStream(readableStream, this.controller);
        for await (const event of stream) {
            tslib_1.__classPrivateFieldGet(this, _ResponseStream_instances, "m", _ResponseStream_addEvent).call(this, event, null);
        }
        if (stream.controller.signal?.aborted) {
            throw this._userAbortError();
        }
        return tslib_1.__classPrivateFieldGet(this, _ResponseStream_instances, "m", _ResponseStream_endRequest).call(this);
    }
    /** Iterates over response events; stopping iteration early aborts the underlying request. */
    [(_ResponseStream_params = new WeakMap(), _ResponseStream_currentResponseSnapshot = new WeakMap(), _ResponseStream_finalResponse = new WeakMap(), _ResponseStream_accumulatorContext = new WeakMap(), _ResponseStream_instances = new WeakSet(), _ResponseStream_beginRequest = function _ResponseStream_beginRequest() {
        if (this.ended) {
            return;
        }
        tslib_1.__classPrivateFieldSet(this, _ResponseStream_currentResponseSnapshot, undefined, "f");
        tslib_1.__classPrivateFieldSet(this, _ResponseStream_accumulatorContext, (0, response_accumulator_1.createResponseContext)(), "f");
    }, _ResponseStream_addEvent = function _ResponseStream_addEvent(event, starting_after) {
        if (this.ended) {
            return;
        }
        const maybeEmit = (name, event) => {
            if (starting_after == null || event.sequence_number > starting_after) {
                // SAFETY: The caller derives the event name from the dispatched event discriminator; this bridge preserves the corresponding payload.
                this._emit(name, event);
            }
        };
        if (event.type === 'error') {
            // First-party providers nest their error payload; retain flat compatibility for
            // serialized events matching the currently published event schema.
            const error = 
            // oxlint-disable-next-line anti-slop/no-runtime-typeof -- An error event can contain malformed server data; validate its container before extracting error details.
            'error' in event && typeof event.error === 'object' && event.error !== null ? event.error : event;
            throw new error_1.APIError(undefined, error, event.message, undefined);
        }
        let dispatchEvent = event;
        const response = (0, response_accumulator_1.accumulateResponseWithContext)(event, tslib_1.__classPrivateFieldGet(this, _ResponseStream_currentResponseSnapshot, "f"), tslib_1.__classPrivateFieldGet(this, _ResponseStream_accumulatorContext, "f"), true, (sanitizedEvent) => {
            dispatchEvent = sanitizedEvent;
        });
        tslib_1.__classPrivateFieldSet(this, _ResponseStream_currentResponseSnapshot, response, "f");
        maybeEmit('event', event);
        switch (dispatchEvent.type) {
            case 'response.output_text.delta': {
                const output = response.output[dispatchEvent.output_index];
                if (!output) {
                    throw new error_1.OpenAIError(`missing output at index ${dispatchEvent.output_index}`);
                }
                if (output.type === 'message') {
                    const content = output.content[dispatchEvent.content_index];
                    if (!content) {
                        throw new error_1.OpenAIError(`missing content at index ${dispatchEvent.content_index}`);
                    }
                    if (content.type !== 'output_text') {
                        throw new error_1.OpenAIError(`expected content to be 'output_text', got ${content.type}`);
                    }
                    maybeEmit('response.output_text.delta', {
                        ...dispatchEvent,
                        type: dispatchEvent.type,
                        item_id: dispatchEvent.item_id,
                        output_index: dispatchEvent.output_index,
                        content_index: dispatchEvent.content_index,
                        snapshot: content.text,
                    });
                }
                break;
            }
            case 'response.function_call_arguments.delta': {
                const output = response.output[dispatchEvent.output_index];
                if (!output) {
                    throw new error_1.OpenAIError(`missing output at index ${dispatchEvent.output_index}`);
                }
                if (output.type === 'function_call') {
                    maybeEmit('response.function_call_arguments.delta', {
                        ...dispatchEvent,
                        type: dispatchEvent.type,
                        item_id: dispatchEvent.item_id,
                        output_index: dispatchEvent.output_index,
                        snapshot: output.arguments,
                    });
                }
                break;
            }
            default: {
                maybeEmit(dispatchEvent.type, event);
                break;
            }
        }
    }, _ResponseStream_endRequest = function _ResponseStream_endRequest() {
        if (this.ended) {
            throw new error_1.OpenAIError(`stream has ended, this shouldn't happen`);
        }
        const snapshot = tslib_1.__classPrivateFieldGet(this, _ResponseStream_currentResponseSnapshot, "f");
        if (!snapshot) {
            throw new error_1.OpenAIError(`request ended without sending any events`);
        }
        tslib_1.__classPrivateFieldSet(this, _ResponseStream_currentResponseSnapshot, undefined, "f");
        tslib_1.__classPrivateFieldSet(this, _ResponseStream_accumulatorContext, (0, response_accumulator_1.createResponseContext)(), "f");
        const parsedResponse = finalizeResponse(snapshot, tslib_1.__classPrivateFieldGet(this, _ResponseStream_params, "f"));
        tslib_1.__classPrivateFieldSet(this, _ResponseStream_finalResponse, parsedResponse, "f");
        return parsedResponse;
    }, Symbol.asyncIterator)]() {
        return this._createIterator((push) => {
            const onEvent = (event) => push(event);
            this.on('event', onEvent);
            return () => this.off('event', onEvent);
        }, { onReturn: () => this.abort() });
    }
    /**
     * Waits for the stream to end and returns its latest accumulated response.
     *
     * A clean end after at least one response event resolves even when the response is
     * incomplete. Network errors, cancellation, and streams without a response reject.
     */
    async finalResponse() {
        await this.done();
        const response = tslib_1.__classPrivateFieldGet(this, _ResponseStream_finalResponse, "f");
        if (!response) {
            throw new error_1.OpenAIError('stream ended without producing a Response');
        }
        return response;
    }
}
exports.ResponseStream = ResponseStream;
function finalizeResponse(snapshot, params) {
    return (0, ResponsesParser_1.maybeParseResponse)(snapshot, params);
}
//# sourceMappingURL=ResponseStream.js.map