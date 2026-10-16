import type { ReadableStream } from "../internal/shim-types.js";
import type { OpenAI } from "../client.js";
/** A decoded server-sent event before its JSON payload has been parsed. */
export type ServerSentEvent = {
    /** Explicit SSE event name, or `null` when the event has no `event:` field. */
    event: string | null;
    /** Joined contents of the event's `data:` fields. */
    data: string;
    /** Original event lines retained for diagnostics when parsing fails. */
    raw: string[];
};
/**
 * A single-consumption asynchronous API response stream.
 *
 * Use {@link Stream.tee} when two consumers need the same events. Breaking out of
 * a response-backed stream early aborts its request; branches created by `tee()`
 * instead share {@link Stream.controller} for explicit cancellation.
 */
export declare class Stream<Item> implements AsyncIterable<Item> {
    #private;
    /** Abort controller for the underlying request and all branches created with `tee()`. */
    controller: AbortController;
    private iterator;
    /** Wraps an asynchronous event iterator and the controller that owns its request. */
    constructor(iterator: () => AsyncIterator<Item>, controller: AbortController, client?: OpenAI);
    /**
     * Decodes an SSE response into parsed JSON events.
     *
     * The resulting stream can be consumed only once, ignores events after `[DONE]`, and
     * surfaces API error payloads as `APIError` instances. When
     * `synthesizeEventData` is enabled, each item also includes its SSE event name.
     */
    static fromSSEResponse<Item>(response: Response, controller: AbortController, client?: OpenAI, synthesizeEventData?: boolean): Stream<Item>;
    /**
     * Generates a Stream from a newline-separated ReadableStream
     * where each item is a JSON value.
     */
    static fromReadableStream<Item>(readableStream: ReadableStream, controller: AbortController, client?: OpenAI): Stream<Item>;
    /** Starts consuming this stream; attempting to consume it again throws. */
    [Symbol.asyncIterator](): AsyncIterator<Item>;
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
    tee(): [Stream<Item>, Stream<Item>];
    /**
     * Converts this stream to a newline-separated ReadableStream of
     * JSON stringified values in the stream
     * which can be turned back into a Stream with `Stream.fromReadableStream()`.
     * Canceling a response-backed readable aborts its request. Canceling a tee
     * branch discards its buffered events and leaves sibling consumers running.
     * Read or serialization failures also release the iterator without replacing the original error.
     */
    toReadableStream(): ReadableStream;
}
/**
 * Decodes complete SSE records from a response and aborts when its body is absent.
 * Complete events are decoded on demand without imposing a line or event size limit.
 *
 * @yields {ServerSentEvent} Each decoded server-sent event in wire order.
 */
export declare function _iterSSEMessages(response: Response, controller: AbortController): AsyncGenerator<ServerSentEvent, void, unknown>;
//# sourceMappingURL=streaming.d.ts.map