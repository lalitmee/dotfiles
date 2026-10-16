import type { ChatCompletionMessageParam, ChatCompletionCreateParamsNonStreaming } from "../resources/chat/completions.mjs";
import type { BaseFunctionsArgs, RunnableTools } from "./RunnableFunction.mjs";
import type { AbstractChatCompletionRunnerEvents, RunnerOptions } from "./AbstractChatCompletionRunner.mjs";
import { AbstractChatCompletionRunner } from "./AbstractChatCompletionRunner.mjs";
import type OpenAI from "../index.mjs";
import type { AutoParseableTool } from "../lib/parser.mjs";
/** Events emitted while executing a non-streaming chat completion tool run. */
export interface ChatCompletionRunnerEvents extends AbstractChatCompletionRunnerEvents {
    /** Called when a new assistant message with nonempty text is received; input history is not emitted. */
    content: (content: string) => void;
}
/** Non-streaming chat completion request fields shared by all tool-runner overloads. */
type ChatCompletionToolRunnerParamsBase = Omit<ChatCompletionCreateParamsNonStreaming, 'tools'>;
/**
 * Parameters for tools that do not require a context value.
 */
export type ChatCompletionToolRunnerParamsWithoutContext<FunctionsArgs extends BaseFunctionsArgs> = ChatCompletionToolRunnerParamsBase & {
    /** Runnable function tools or auto-parseable tools with an attached callback. */
    tools: RunnableTools<FunctionsArgs> | AutoParseableTool<any, true>[];
    /** Context is unavailable for the no-context runner overload. */
    toolContext?: never;
};
/**
 * Parameters for tools that require a context value.
 */
export type ChatCompletionToolRunnerParamsWithContext<FunctionsArgs extends BaseFunctionsArgs, ToolContext> = ChatCompletionToolRunnerParamsBase & {
    /** Runnable function tools or auto-parseable tools that receive `toolContext`. */
    tools: RunnableTools<FunctionsArgs, ToolContext> | AutoParseableTool<any, true>[];
    /**
     * Context to pass to each tool callback during this run.
     */
    toolContext: ToolContext;
};
/**
 * Parameters for running tools. Supplying a context type makes `toolContext`
 * required; omitting it preserves the existing no-context form.
 */
export type ChatCompletionToolRunnerParams<FunctionsArgs extends BaseFunctionsArgs, ToolContext = never> = [
    ToolContext
] extends [never] ? ChatCompletionToolRunnerParamsWithoutContext<FunctionsArgs> : ChatCompletionToolRunnerParamsWithContext<FunctionsArgs, ToolContext>;
/** Executes function tools and follows up with non-streaming chat completion requests. */
export declare class ChatCompletionRunner<ParsedT = null> extends AbstractChatCompletionRunner<ChatCompletionRunnerEvents, ParsedT> {
    /** Runs function tools, passing the supplied context to each tool callback. */
    static runTools<ParsedT, ToolContext = unknown>(client: OpenAI, params: ChatCompletionToolRunnerParamsWithContext<any[], ToolContext>, options?: RunnerOptions): ChatCompletionRunner<ParsedT>;
    /** Runs function tools until the model produces a final assistant message. */
    static runTools<ParsedT>(client: OpenAI, params: ChatCompletionToolRunnerParamsWithoutContext<any[]>, options?: RunnerOptions): ChatCompletionRunner<ParsedT>;
    /**
     * Appends a conversation message and emits text content for assistant replies.
     * @param normalizeContent Defaults to true; initial history passes false to preserve caller-owned messages.
     */
    _addMessage(this: ChatCompletionRunner<ParsedT>, message: ChatCompletionMessageParam, emit?: boolean, normalizeContent?: boolean): void;
}
export {};
//# sourceMappingURL=ChatCompletionRunner.d.mts.map