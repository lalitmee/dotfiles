import type { ParsedResponse, ResponseCreateParamsBase, ResponseStreamEvent, ResponseTextConfig } from "../../resources/responses/responses.js";
import type { RequestOptions } from "../../internal/request-options.js";
import type { ReadableStream } from "../../internal/shim-types.js";
import type OpenAI from "../../index.js";
import { EventStream } from "../EventStream.js";
import type { BaseEvents } from "../EventStream.js";
import type { ResponseFunctionCallArgumentsDeltaEvent, ResponseTextDeltaEvent } from "./EventTypes.js";
import type { ParseableToolsParams } from "../ResponsesParser.js";
/** Parameters for starting a new response stream or replaying an existing response. */
export type ResponseStreamParams = ResponseCreateAndStreamParams | ResponseStreamByIdParams;
/** Response-creation parameters accepted by the streaming convenience helper. */
export type ResponseCreateAndStreamParams = Omit<ResponseCreateParamsBase, 'stream'> & {
    /** Streaming is always enabled by the helper and may be specified explicitly. */
    stream?: true;
};
/** Parameters for replaying an existing response and optionally filtering emitted events. */
export type ResponseStreamByIdParams = {
    /**
     * The ID of the response to stream.
     */
    response_id: string;
    /**
     * If provided, events with a sequence number less than or equal to this value
     * will not be emitted. The helper still replays them internally to build a
     * complete snapshot for later events and `finalResponse()`.
     */
    starting_after?: number;
    /**
     * Configuration options for a text response from the model. Can be plain text or
     * structured JSON data. Learn more:
     *
     * - [Text inputs and outputs](https://platform.openai.com/docs/guides/text)
     * - [Structured Outputs](https://platform.openai.com/docs/guides/structured-outputs)
     */
    text?: ResponseTextConfig;
    /**
     * An array of tools the model may call while generating a response. When continuing a stream, provide
     * the same tools as the original request.
     */
    tools?: ParseableToolsParams;
};
/** Raw Responses API events, lifecycle notifications, and snapshot-enhanced delta listeners. */
type ResponseEvents = BaseEvents & Omit<{
    [K in ResponseStreamEvent['type']]: (event: Extract<ResponseStreamEvent, {
        /** Event discriminator that selects the listener's precise server-event payload. */
        type: K;
    }>) => void;
}, 'response.output_text.delta' | 'response.function_call_arguments.delta' | 'error'> & {
    /** Called for every raw response event that passes the replay sequence filter. */
    event: (event: ResponseStreamEvent) => void;
    /** Called with each text fragment and the complete text accumulated for its content part. */
    'response.output_text.delta': (event: ResponseTextDeltaEvent) => void;
    /** Called with each argument fragment and the complete JSON accumulated for its function call. */
    'response.function_call_arguments.delta': (event: ResponseFunctionCallArgumentsDeltaEvent) => void;
};
/** Response request parameters retained to parse structured output and tool arguments. */
export type ResponseStreamingParams = Omit<ResponseCreateParamsBase, 'stream'> & {
    /** Streaming is always enabled by the helper and may be specified explicitly. */
    stream?: true;
};
/** Streams Responses API events while accumulating the latest response and parsed output. */
export declare class ResponseStream<ParsedT = null> extends EventStream<ResponseEvents> implements AsyncIterable<ResponseStreamEvent> {
    #private;
    /** Creates an unstarted stream, retaining request parameters for structured-output parsing. */
    constructor(params: ResponseStreamingParams | null);
    /** Starts a new response stream or replays an existing response by its identifier. */
    static createResponse<ParsedT>(client: OpenAI, params: ResponseStreamParams, options?: RequestOptions): ResponseStream<ParsedT>;
    /** Consumes serialized response events from a readable stream in another runtime. */
    static fromReadableStream(stream: ReadableStream): ResponseStream<null>;
    protected _createOrRetrieveResponse(client: OpenAI, params: ResponseStreamParams, options?: RequestOptions): Promise<ParsedResponse<ParsedT>>;
    protected _fromReadableStream(readableStream: ReadableStream, options?: RequestOptions): Promise<ParsedResponse<ParsedT>>;
    /** Iterates over response events; stopping iteration early aborts the underlying request. */
    [Symbol.asyncIterator](this: ResponseStream<ParsedT>): AsyncIterator<ResponseStreamEvent>;
    /**
     * Waits for the stream to end and returns its latest accumulated response.
     *
     * A clean end after at least one response event resolves even when the response is
     * incomplete. Network errors, cancellation, and streams without a response reject.
     */
    finalResponse(): Promise<ParsedResponse<ParsedT>>;
}
export {};
//# sourceMappingURL=ResponseStream.d.ts.map