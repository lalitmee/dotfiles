"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.isToolMessage = exports.isAssistantMessage = void 0;
exports.isPresent = isPresent;
/** Returns whether a conversation message was produced by the assistant. */
const isAssistantMessage = (message) => message?.role === 'assistant';
exports.isAssistantMessage = isAssistantMessage;
/** Returns whether a conversation message contains the result of a tool call. */
const isToolMessage = (message) => message?.role === 'tool';
exports.isToolMessage = isToolMessage;
/** Narrows a value by excluding both `null` and `undefined`. */
function isPresent(obj) {
    return obj != null;
}
//# sourceMappingURL=chatCompletionUtils.js.map