import type { ChatCompletionChunk, ChatCompletionCreateParamsStreaming } from "../resources/chat/completions.mjs";
import type { AbstractChatCompletionRunnerEvents, RunnerOptions } from "./AbstractChatCompletionRunner.mjs";
import type { ReadableStream } from "../internal/shim-types.mjs";
import type { BaseFunctionsArgs, RunnableTools } from "./RunnableFunction.mjs";
import { ChatCompletionStream } from "./ChatCompletionStream.mjs";
import type { ChatCompletionSnapshot } from "./ChatCompletionStream.mjs";
import type OpenAI from "../index.mjs";
import type { AutoParseableTool } from "../lib/parser.mjs";
/** Conversation and chunk events emitted by a streaming chat completion tool runner. */
export interface ChatCompletionStreamEvents extends AbstractChatCompletionRunnerEvents {
    /** Called with each assistant-text fragment and the text accumulated so far. */
    content: (contentDelta: string, contentSnapshot: string) => void;
    /** Called with each raw API chunk and its accumulated completion snapshot. */
    chunk: (chunk: ChatCompletionChunk, snapshot: ChatCompletionSnapshot) => void;
}
/** Streaming chat completion request fields shared by all tool-runner overloads. */
type ChatCompletionStreamingToolRunnerParamsBase = Omit<ChatCompletionCreateParamsStreaming, 'tools'>;
/**
 * Parameters for tools that do not require a context value.
 */
export type ChatCompletionStreamingToolRunnerParamsWithoutContext<FunctionsArgs extends BaseFunctionsArgs> = ChatCompletionStreamingToolRunnerParamsBase & {
    /** Runnable function tools or auto-parseable tools with an attached callback. */
    tools: RunnableTools<FunctionsArgs> | AutoParseableTool<any, true>[];
    /** Context is unavailable for the no-context runner overload. */
    toolContext?: never;
};
/**
 * Parameters for tools that require a context value.
 */
export type ChatCompletionStreamingToolRunnerParamsWithContext<FunctionsArgs extends BaseFunctionsArgs, ToolContext> = ChatCompletionStreamingToolRunnerParamsBase & {
    /** Runnable function tools or auto-parseable tools that receive `toolContext`. */
    tools: RunnableTools<FunctionsArgs, ToolContext> | AutoParseableTool<any, true>[];
    /**
     * Context to pass to each tool callback during this run.
     */
    toolContext: ToolContext;
};
/**
 * Parameters for running streaming tools. Supplying a context type makes
 * `toolContext` required; omitting it preserves the existing no-context form.
 */
export type ChatCompletionStreamingToolRunnerParams<FunctionsArgs extends BaseFunctionsArgs, ToolContext = never> = [ToolContext] extends [never] ? ChatCompletionStreamingToolRunnerParamsWithoutContext<FunctionsArgs> : ChatCompletionStreamingToolRunnerParamsWithContext<FunctionsArgs, ToolContext>;
/** Executes function tools while streaming every intermediate chat completion. */
export declare class ChatCompletionStreamingRunner<ParsedT = null> extends ChatCompletionStream<ParsedT> implements AsyncIterable<ChatCompletionChunk> {
    /** Restores a serialized tool run, including intermediate completions and tool-result messages. */
    static fromReadableStream(stream: ReadableStream): ChatCompletionStreamingRunner<null>;
    /** Serializes completion chunks and tool-result messages for replay in another runtime. */
    toReadableStream(): ReadableStream;
    /** Runs streaming function tools, passing the supplied context to each callback. */
    static runTools<T extends (string | object)[], ParsedT = null, ToolContext = unknown>(client: OpenAI, params: ChatCompletionStreamingToolRunnerParamsWithContext<T, ToolContext>, options?: RunnerOptions): ChatCompletionStreamingRunner<ParsedT>;
    /** Runs streaming function tools until the model produces a final assistant message. */
    static runTools<T extends (string | object)[], ParsedT = null>(client: OpenAI, params: ChatCompletionStreamingToolRunnerParamsWithoutContext<T>, options?: RunnerOptions): ChatCompletionStreamingRunner<ParsedT>;
}
export {};
//# sourceMappingURL=ChatCompletionStreamingRunner.d.mts.map