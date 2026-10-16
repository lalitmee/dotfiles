import type OpenAI from "../index.mjs";
import type { RequestOptions } from "../internal/request-options.mjs";
import type { ChatCompletion, ChatCompletionCreateParams, ChatCompletionMessage, ChatCompletionMessageFunctionToolCall, ChatCompletionMessageParam, ParsedChatCompletion } from "../resources/chat/completions.mjs";
import type { CompletionUsage } from "../resources/completions.mjs";
import type { ChatCompletionRunner, ChatCompletionToolRunnerParamsWithContext, ChatCompletionToolRunnerParamsWithoutContext } from "./ChatCompletionRunner.mjs";
import type { ChatCompletionStreamingRunner, ChatCompletionStreamingToolRunnerParamsWithContext, ChatCompletionStreamingToolRunnerParamsWithoutContext } from "./ChatCompletionStreamingRunner.mjs";
import type { BaseEvents } from "./EventStream.mjs";
import { EventStream } from "./EventStream.mjs";
import type { BaseFunctionsArgs } from "./RunnableFunction.mjs";
/** Mutable conversation state and cancellation controls available to runner callbacks. */
export interface ChatCompletionRunnerContext {
    /** The conversation so far; callbacks may append messages before the next request. */
    messages: ChatCompletionMessageParam[];
    /** Cancels the active request and prevents the runner from continuing. */
    abort(): void;
}
/** Request and lifecycle options for chat completion tool-running helpers. */
export interface RunnerOptions extends RequestOptions {
    /** Maximum chat completion requests before the tool runner finishes; defaults to 10. */
    maxChatCompletions?: number;
    /**
     * A callback that runs after each chat completion and after any tool calls from
     * that completion have finished. The callback is awaited before the next
     * request starts or before the runner ends. The runner's mutable `messages`
     * array can be used to add context for the next request.
     */
    afterCompletion?: (completion: ChatCompletion, runner: ChatCompletionRunnerContext) => void | Promise<void>;
}
/** Shared conversation, event, cancellation, and final-result behavior for chat completion runners. */
export declare class AbstractChatCompletionRunner<EventTypes extends AbstractChatCompletionRunnerEvents, ParsedT> extends EventStream<EventTypes> {
    #private;
    protected _chatCompletions: ParsedChatCompletion<ParsedT>[];
    /** Mutable conversation history, including initial input, assistant replies, and tool results. */
    messages: ChatCompletionMessageParam[];
    protected _addChatCompletion(this: AbstractChatCompletionRunner<AbstractChatCompletionRunnerEvents, ParsedT>, chatCompletion: ParsedChatCompletion<ParsedT>): ParsedChatCompletion<ParsedT>;
    protected _addMessage(this: AbstractChatCompletionRunner<AbstractChatCompletionRunnerEvents, ParsedT>, message: ChatCompletionMessageParam, emit?: boolean, normalizeContent?: boolean): void;
    /**
     * @returns a promise that resolves with the final ChatCompletion, or rejects
     * if an error occurred or the stream ended prematurely without producing a ChatCompletion.
     */
    finalChatCompletion(): Promise<ParsedChatCompletion<ParsedT>>;
    /**
     * @returns a promise that resolves with the content of the final ChatCompletionMessage, or rejects
     * if an error occurred or the stream ended prematurely without producing a ChatCompletionMessage.
     */
    finalContent(): Promise<string | null>;
    /**
     * @returns a promise that resolves with the final assistant ChatCompletionMessage response,
     * or rejects if an error occurred or the stream ended prematurely without producing a ChatCompletionMessage.
     */
    finalMessage(): Promise<ChatCompletionMessage>;
    /**
     * Waits for completion and returns the last function-tool call, or `undefined`
     * when no assistant message contains a function-tool call.
     */
    finalFunctionToolCall(): Promise<ChatCompletionMessageFunctionToolCall.Function | undefined>;
    /** Waits for completion and returns the last matching function-tool result, if any. */
    finalFunctionToolCallResult(): Promise<string | undefined>;
    /** Waits for completion and sums token usage across every chat completion in the run. */
    totalUsage(): Promise<CompletionUsage>;
    /** Returns a copy of the chat completions received so far, in request order. */
    allChatCompletions(): ChatCompletion[];
    protected _emitFinal(this: AbstractChatCompletionRunner<AbstractChatCompletionRunnerEvents, ParsedT>): void;
    protected _createChatCompletion(client: OpenAI, params: ChatCompletionCreateParams, options?: RequestOptions): Promise<ParsedChatCompletion<ParsedT>>;
    protected _runChatCompletion(client: OpenAI, params: ChatCompletionCreateParams, options?: RequestOptions): Promise<ChatCompletion>;
    protected _runTools<FunctionsArgs extends BaseFunctionsArgs, ToolContext>(client: OpenAI, params: ChatCompletionToolRunnerParamsWithContext<FunctionsArgs, ToolContext> | ChatCompletionToolRunnerParamsWithoutContext<FunctionsArgs> | ChatCompletionStreamingToolRunnerParamsWithContext<FunctionsArgs, ToolContext> | ChatCompletionStreamingToolRunnerParamsWithoutContext<FunctionsArgs>, runner: ChatCompletionRunner<any> | ChatCompletionStreamingRunner<any>, options?: RunnerOptions): Promise<void>;
}
/** Conversation and final-result events shared by chat completion runners. */
export interface AbstractChatCompletionRunnerEvents extends BaseEvents {
    /** Called for each function-tool call produced by an assistant message. */
    functionToolCall: (functionCall: ChatCompletionMessageFunctionToolCall.Function) => void;
    /** Called when an assistant reply or tool-result message is appended to the conversation. */
    message: (message: ChatCompletionMessageParam) => void;
    /** Called whenever a complete chat completion is received. */
    chatCompletion: (completion: ChatCompletion) => void;
    /** Called at successful completion when the final assistant message contains nonempty text. */
    finalContent: (contentSnapshot: string) => void;
    /** Called at successful completion with the final assistant message. */
    finalMessage: (message: ChatCompletionMessageParam) => void;
    /** Called at successful completion with the last chat completion received. */
    finalChatCompletion: (completion: ChatCompletion) => void;
    /** Called at successful completion when the conversation contains a function-tool call. */
    finalFunctionToolCall: (functionCall: ChatCompletionMessageFunctionToolCall.Function) => void;
    /** Called when a function-tool result message with nonempty content is appended. */
    functionToolCallResult: (content: string) => void;
    /** Called at successful completion when a matching function-tool result exists. */
    finalFunctionToolCallResult: (content: string) => void;
    /** Called at successful completion when at least one response includes token usage. */
    totalUsage: (usage: CompletionUsage) => void;
}
//# sourceMappingURL=AbstractChatCompletionRunner.d.mts.map