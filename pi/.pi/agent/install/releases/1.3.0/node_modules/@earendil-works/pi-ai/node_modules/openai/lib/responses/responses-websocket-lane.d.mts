import type { Response, ResponsesClientEvent, ResponsesServerEvent } from "../../resources/responses/responses.mjs";
type WireResponse = Omit<Response, 'output' | 'output_text'> & Partial<Pick<Response, 'output' | 'output_text'>>;
type WireEvent<Event> = Event extends {
    response: Response;
} ? Omit<Event, 'response'> & {
    response: WireResponse;
} : Event;
/** Raw lane events, including future types with unknown fields. Response output may be omitted. */
export type ResponsesWebSocketEvent = WireEvent<ResponsesServerEvent> | {
    /** The server's event tag, which may be newer than the SDK. */
    type: string;
    [key: string]: unknown;
};
/** @internal */
export declare function positiveInteger(value: number): number;
/** A single ordered local consumer. Canceling receive cancels only that wait. */
export declare class ResponsesWebSocketLane {
    #private;
    readonly streamID: string | undefined;
    /** Created by ResponsesWebSocketSession.lane().
     * @internal
     */
    constructor(streamID: string | undefined, send: (event: ResponsesClientEvent) => void, release: (bytes: number) => void, maxEvents: number, maxBytes: number);
    /** Sends a request on this lane, omitting HTTP-only stream/background fields. previous_response_id remains caller-controlled. */
    create(request: Omit<Extract<ResponsesClientEvent, {
        type: 'response.create';
    }>, 'type' | 'stream_id' | 'stream' | 'background'>): void;
    /** Returns the next raw event without filling omitted output or computing output_text. */
    receive(options?: {
        signal?: AbortSignal;
    }): Promise<ResponsesWebSocketEvent>;
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
    finalResponse(options?: {
        signal?: AbortSignal;
        maxResponseBytes?: number;
    }): Promise<Response>;
    /** Detaches this consumer without canceling remote work. Its ID remains reserved until reconnect. */
    close(): void;
    /** Preserves already accepted events when the transport ends.
     * @internal
     */
    end(error: Error): void;
    /** @internal */
    get ended(): boolean;
    /** @internal */
    push(event: ResponsesWebSocketEvent, bytes: number): void;
    /** @internal */
    fail(error: Error): void;
}
export {};
//# sourceMappingURL=responses-websocket-lane.d.mts.map