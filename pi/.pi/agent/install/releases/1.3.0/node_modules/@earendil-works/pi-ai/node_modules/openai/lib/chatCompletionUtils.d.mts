import type { ChatCompletionAssistantMessageParam, ChatCompletionMessageParam, ChatCompletionToolMessageParam } from "../resources.mjs";
/** Returns whether a conversation message was produced by the assistant. */
export declare const isAssistantMessage: (message: ChatCompletionMessageParam | null | undefined) => message is ChatCompletionAssistantMessageParam;
/** Returns whether a conversation message contains the result of a tool call. */
export declare const isToolMessage: (message: ChatCompletionMessageParam | null | undefined) => message is ChatCompletionToolMessageParam;
/** Narrows a value by excluding both `null` and `undefined`. */
export declare function isPresent<T>(obj: T | null | undefined): obj is T;
//# sourceMappingURL=chatCompletionUtils.d.mts.map