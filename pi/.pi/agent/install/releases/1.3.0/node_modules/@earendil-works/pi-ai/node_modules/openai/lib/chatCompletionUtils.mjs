/** Returns whether a conversation message was produced by the assistant. */
export const isAssistantMessage = (message) => message?.role === 'assistant';
/** Returns whether a conversation message contains the result of a tool call. */
export const isToolMessage = (message) => message?.role === 'tool';
/** Narrows a value by excluding both `null` and `undefined`. */
export function isPresent(obj) {
    return obj != null;
}
//# sourceMappingURL=chatCompletionUtils.mjs.map