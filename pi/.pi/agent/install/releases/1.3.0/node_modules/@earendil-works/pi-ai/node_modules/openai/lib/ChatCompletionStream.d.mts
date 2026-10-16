import type OpenAI from "../index.mjs";
import { type RequestOptions } from "../internal/request-options.mjs";
import type { ReadableStream } from "../internal/shim-types.mjs";
import type { ParsedChatCompletion } from "../resources/chat/completions.mjs";
import type { ChatCompletionAudio, ChatCompletion, ChatCompletionChunk, ChatCompletionCreateParams, ChatCompletionCreateParamsBase, ChatCompletionMessageParam, ChatCompletionRole, ChatCompletionTokenLogprob } from "../resources/chat/completions/completions.mjs";
import { AbstractChatCompletionRunner } from "./AbstractChatCompletionRunner.mjs";
import type { AbstractChatCompletionRunnerEvents, RunnerOptions } from "./AbstractChatCompletionRunner.mjs";
import type { ChatCompletionRunner, ChatCompletionToolRunnerParamsWithContext, ChatCompletionToolRunnerParamsWithoutContext } from "./ChatCompletionRunner.mjs";
import type { ChatCompletionStreamingRunner, ChatCompletionStreamingToolRunnerParamsWithContext, ChatCompletionStreamingToolRunnerParamsWithoutContext } from "./ChatCompletionStreamingRunner.mjs";
import type { BaseFunctionsArgs } from "./RunnableFunction.mjs";
/** An incremental assistant-text event and its accumulated state. */
export interface ContentDeltaEvent {
    /** The new text received in this chunk. */
    delta: string;
    /** All assistant text received for this choice, including `delta`. */
    snapshot: string;
    /** The partially parsed structured output when an auto-parseable response format is supplied. */
    parsed: unknown | null;
}
/** The completed assistant-text content and its fully parsed structured value. */
export interface ContentDoneEvent<ParsedT = null> {
    /** The complete assistant text for the finished choice. */
    content: string;
    /** The fully parsed structured output, or `null` when no parser was supplied. */
    parsed: ParsedT | null;
}
/** An incremental refusal-text event and its accumulated state. */
export interface RefusalDeltaEvent {
    /** The new refusal text received in this chunk. */
    delta: string;
    /** All refusal text received for this choice, including `delta`. */
    snapshot: string;
}
/** The complete refusal text emitted when the refusal finishes. */
export interface RefusalDoneEvent {
    /** The model's complete refusal message. */
    refusal: string;
}
/** An incremental function-tool argument event and its accumulated JSON state. */
export interface FunctionToolCallArgumentsDeltaEvent {
    /** The name of the function being called. */
    name: string;
    /** The position of this tool call within the assistant message. */
    index: number;
    /** The complete argument JSON received so far, including `arguments_delta`. */
    arguments: string;
    /** The partially parsed arguments when the matching tool supports parsing. */
    parsed_arguments: unknown;
    /** The new argument JSON fragment received in this chunk. */
    arguments_delta: string;
}
/** The final raw and parsed arguments for a completed function-tool call. */
export interface FunctionToolCallArgumentsDoneEvent {
    /** The name of the function being called. */
    name: string;
    /** The position of this tool call within the assistant message. */
    index: number;
    /** The complete JSON argument string produced for the tool call. */
    arguments: string;
    /** The fully parsed arguments when the matching tool supports parsing. */
    parsed_arguments: unknown;
}
/** Newly received assistant-content token probabilities and their accumulated snapshot. */
export interface LogProbsContentDeltaEvent {
    /** Token probabilities received in the current chunk. */
    content: ChatCompletionTokenLogprob[];
    /** All assistant-content token probabilities received for this choice. */
    snapshot: ChatCompletionTokenLogprob[];
}
/** The complete assistant-content token probabilities for a finished choice. */
export interface LogProbsContentDoneEvent {
    /** Every assistant-content token probability produced for this choice. */
    content: ChatCompletionTokenLogprob[];
}
/** Newly received refusal-token probabilities and their accumulated snapshot. */
export interface LogProbsRefusalDeltaEvent {
    /** Refusal-token probabilities received in the current chunk. */
    refusal: ChatCompletionTokenLogprob[];
    /** All refusal-token probabilities received for this choice. */
    snapshot: ChatCompletionTokenLogprob[];
}
/** The complete refusal-token probabilities for a finished choice. */
export interface LogProbsRefusalDoneEvent {
    /** Every refusal-token probability produced for this choice. */
    refusal: ChatCompletionTokenLogprob[];
}
/** Event listeners supported by a streamed Chat Completions helper. */
export interface ChatCompletionStreamEvents<ParsedT = null> extends AbstractChatCompletionRunnerEvents {
    /** Called with each new text fragment and the complete text accumulated so far. */
    content: (contentDelta: string, contentSnapshot: string) => void;
    /** Called with each raw API chunk and its accumulated chat-completion snapshot. */
    chunk: (chunk: ChatCompletionChunk, snapshot: ChatCompletionSnapshot) => void;
    /** Called when assistant text arrives, including any partially parsed output. */
    'content.delta': (props: ContentDeltaEvent) => void;
    /** Called once the assistant text is complete and can be fully parsed. */
    'content.done': (props: ContentDoneEvent<ParsedT>) => void;
    /** Called when another fragment of a model refusal arrives. */
    'refusal.delta': (props: RefusalDeltaEvent) => void;
    /** Called once the model's complete refusal is available. */
    'refusal.done': (props: RefusalDoneEvent) => void;
    /** Called when another JSON argument fragment arrives for a function tool. */
    'tool_calls.function.arguments.delta': (props: FunctionToolCallArgumentsDeltaEvent) => void;
    /** Called once a function tool's complete arguments are available. */
    'tool_calls.function.arguments.done': (props: FunctionToolCallArgumentsDoneEvent) => void;
    /** Called when assistant-content token probabilities arrive. */
    'logprobs.content.delta': (props: LogProbsContentDeltaEvent) => void;
    /** Called once all assistant-content token probabilities are available. */
    'logprobs.content.done': (props: LogProbsContentDoneEvent) => void;
    /** Called when refusal-token probabilities arrive. */
    'logprobs.refusal.delta': (props: LogProbsRefusalDeltaEvent) => void;
    /** Called once all refusal-token probabilities are available. */
    'logprobs.refusal.done': (props: LogProbsRefusalDoneEvent) => void;
}
/** Chat completion request parameters accepted by the streaming convenience helper. */
export type ChatCompletionStreamParams = Omit<ChatCompletionCreateParamsBase, 'stream'> & {
    /** Streaming is always enabled by the helper and may be specified explicitly. */
    stream?: true;
};
/** A conversation message embedded in a serialized chat completion stream. */
type ChatCompletionReadableStreamMessage = {
    /** Identifies this readable-stream item as a serialized conversation message. */
    type: 'message';
    /** The conversation message to restore while replaying the serialized stream. */
    message: ChatCompletionMessageParam;
    /** Tool-call identifiers to restore on the preceding assistant completion. */
    tool_call_ids?: string[];
};
declare const CHAT_COMPLETION_READABLE_STREAM_MESSAGE_PREFIX = "chat.completion.chunk.message:";
/** A serialized conversation message disguised as a backwards-compatible empty completion chunk. */
type ChatCompletionReadableStreamMessageChunk = Pick<ChatCompletionChunk, 'id' | 'created' | 'model'> & {
    /** Empty choices keep the encoded message compatible with older completion-stream readers. */
    choices: [];
    /** Reserved object prefix followed by the JSON-encoded conversation-message payload. */
    object: `${typeof CHAT_COMPLETION_READABLE_STREAM_MESSAGE_PREFIX}${string}`;
};
/** A raw completion chunk or serialized message preserved in a transportable stream. */
export type ChatCompletionReadableStreamItem = ChatCompletionChunk | ChatCompletionReadableStreamMessage | ChatCompletionReadableStreamMessageChunk;
/** Encodes a tool-result message as a backwards-compatible, empty completion chunk. */
export declare function makeChatCompletionReadableStreamMessageChunk(chunk: ChatCompletionChunk, message: ChatCompletionMessageParam, toolCallIds?: string[]): ChatCompletionReadableStreamMessageChunk;
/** Streams chat completion chunks while accumulating snapshots, parsed output, and events. */
export declare class ChatCompletionStream<ParsedT = null> extends AbstractChatCompletionRunner<ChatCompletionStreamEvents<ParsedT>, ParsedT> implements AsyncIterable<ChatCompletionChunk> {
    #private;
    /** Creates an unstarted stream, retaining request parameters for structured-output parsing. */
    constructor(params: ChatCompletionCreateParams | null);
    /** The latest accumulated completion, or `undefined` before a chunk arrives or after finalization. */
    get currentChatCompletionSnapshot(): ChatCompletionSnapshot | undefined;
    /**
     * Intended for use on the frontend, consuming a stream produced with
     * `.toReadableStream()` on the backend.
     *
     * Original input messages are not included in the serialized stream. Tool-result
     * messages explicitly serialized by a streaming tool runner are replayed.
     */
    static fromReadableStream(stream: ReadableStream): ChatCompletionStream<null>;
    /** Starts a streaming chat completion request and returns its event-driven helper. */
    static createChatCompletion<ParsedT>(client: OpenAI, params: ChatCompletionStreamParams, options?: RequestOptions): ChatCompletionStream<ParsedT>;
    /** Rejects unfinished turns before tool callbacks while preserving ordinary stream and replay behavior. */
    protected _runTools<FunctionsArgs extends BaseFunctionsArgs, ToolContext>(client: OpenAI, params: ChatCompletionToolRunnerParamsWithContext<FunctionsArgs, ToolContext> | ChatCompletionToolRunnerParamsWithoutContext<FunctionsArgs> | ChatCompletionStreamingToolRunnerParamsWithContext<FunctionsArgs, ToolContext> | ChatCompletionStreamingToolRunnerParamsWithoutContext<FunctionsArgs>, runner: ChatCompletionRunner<any> | ChatCompletionStreamingRunner<any>, options?: RunnerOptions): Promise<void>;
    protected _createChatCompletion(client: OpenAI, params: ChatCompletionCreateParams, options?: RequestOptions): Promise<ParsedChatCompletion<ParsedT>>;
    protected _fromReadableStream(readableStream: ReadableStream, options?: RequestOptions): Promise<ChatCompletion>;
    /** Iterates over raw API chunks; stopping iteration early aborts the underlying request. */
    [Symbol.asyncIterator](this: ChatCompletionStream<ParsedT>): AsyncIterator<ChatCompletionChunk>;
    /** Serializes raw completion chunks into a readable stream for transfer to another runtime. */
    toReadableStream(): ReadableStream;
}
/**
 * The chat completion accumulated from every streamed chunk received so far.
 * Fields within each choice can remain incomplete until generation finishes.
 */
export interface ChatCompletionSnapshot {
    /**
     * A unique identifier for the chat completion.
     */
    id: string;
    /**
     * A list of chat completion choices. Can be more than one if `n` is greater
     * than 1.
     */
    choices: ChatCompletionSnapshot.Choice[];
    /**
     * The Unix timestamp (in seconds) of when the chat completion was created.
     */
    created: number;
    /**
     * The model generating the completion.
     */
    model: string;
    /**
     * This fingerprint represents the backend configuration that the model runs with.
     *
     * Can be used in conjunction with the `seed` request parameter to understand when
     * backend changes have been made that might impact determinism.
     */
    system_fingerprint?: string;
}
/** Nested shapes used by an in-progress chat completion snapshot. */
export declare namespace ChatCompletionSnapshot {
    /** One in-progress assistant choice and the metadata accumulated for it. */
    interface Choice {
        /**
         * The assistant message accumulated from streamed model response deltas.
         */
        message: Choice.Message;
        /**
         * The reason the model stopped generating tokens. This will be `stop` if the model
         * hit a natural stop point or a provided stop sequence, `length` if the maximum
         * number of tokens specified in the request was reached, `content_filter` if
         * content was omitted due to a flag from our content filters, `tool_calls` if
         * the model called a tool, or the deprecated `function_call` value.
         */
        finish_reason: ChatCompletion.Choice['finish_reason'] | null;
        /**
         * Log probability information for the choice.
         */
        logprobs: ChatCompletion.Choice.Logprobs | null;
        /**
         * The index of the choice in the list of choices.
         */
        index: number;
    }
    /** Nested message shapes belonging to an in-progress completion choice. */
    namespace Choice {
        /**
         * The assistant message accumulated from streamed response deltas.
         */
        interface Message {
            /**
             * The assistant text accumulated for this message so far.
             */
            content?: string | null;
            /** Audio fields received so far; individual fields can remain absent until generation finishes. */
            audio?: Partial<ChatCompletionAudio> | null;
            /** The model's refusal text accumulated so far, when the request is refused. */
            refusal?: string | null;
            /** A best-effort partial parse of structured assistant content. */
            parsed?: unknown | null;
            /**
             * The name and arguments of a function that should be called, as generated by the
             * model.
             */
            function_call?: Message.FunctionCall;
            /** Function and custom tool calls accumulated so far; inputs may still be incomplete. */
            tool_calls?: Message.ToolCall[];
            /**
             * The role of the author of this message.
             */
            role?: ChatCompletionRole;
        }
        /** Nested tool-call shapes belonging to an in-progress assistant message. */
        namespace Message {
            /** A function or custom tool call accumulated incrementally from streamed chunks. */
            type ToolCall = ToolCall.FunctionToolCall | ToolCall.CustomToolCall;
            /** Function and custom details nested under an in-progress tool call. */
            namespace ToolCall {
                /** A function-tool call whose name, identifier, and arguments are streamed incrementally. */
                interface FunctionToolCall {
                    /**
                     * The ID of the tool call.
                     */
                    id: string;
                    /** The function name and the complete or partial JSON arguments received so far. */
                    function: ToolCall.Function;
                    /**
                     * The type of the tool.
                     */
                    type: 'function';
                }
                /** The name and incrementally accumulated arguments of a function-tool call. */
                interface Function {
                    /**
                     * The arguments to call the function with, as generated by the model in JSON
                     * format. Note that the model does not always generate valid JSON, and may
                     * hallucinate parameters not defined by your function schema. Validate the
                     * arguments in your code before calling your function.
                     */
                    arguments: string;
                    /** A best-effort partial parse of `arguments` for strict or auto-parseable tools. */
                    parsed_arguments?: unknown;
                    /**
                     * The name of the function to call.
                     */
                    name: string;
                }
                /** A custom-tool call whose name, identifier, and input are streamed incrementally. */
                interface CustomToolCall {
                    /**
                     * The ID of the tool call.
                     */
                    id: string;
                    /** The custom-tool name and complete or partial input received so far. */
                    custom: CustomToolCall.Custom;
                    /**
                     * The type of the tool.
                     */
                    type: 'custom';
                }
                /** Custom-tool details nested under an in-progress tool call. */
                namespace CustomToolCall {
                    /** The name and incrementally accumulated input of a custom-tool call. */
                    interface Custom {
                        /** The name of the custom tool to call. */
                        name: string;
                        /** The custom tool's complete or partial free-form input. */
                        input: string;
                    }
                }
            }
            /**
             * The name and arguments of a function that should be called, as generated by the
             * model.
             */
            interface FunctionCall {
                /**
                 * The arguments to call the function with, as generated by the model in JSON
                 * format. Note that the model does not always generate valid JSON, and may
                 * hallucinate parameters not defined by your function schema. Validate the
                 * arguments in your code before calling your function.
                 */
                arguments?: string;
                /**
                 * The name of the function to call.
                 */
                name?: string;
            }
        }
    }
}
export {};
//# sourceMappingURL=ChatCompletionStream.d.mts.map