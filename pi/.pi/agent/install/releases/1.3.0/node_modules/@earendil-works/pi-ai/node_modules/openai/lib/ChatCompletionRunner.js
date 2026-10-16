"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.ChatCompletionRunner = void 0;
const AbstractChatCompletionRunner_1 = require("./AbstractChatCompletionRunner.js");
const chatCompletionUtils_1 = require("./chatCompletionUtils.js");
/** Executes function tools and follows up with non-streaming chat completion requests. */
class ChatCompletionRunner extends AbstractChatCompletionRunner_1.AbstractChatCompletionRunner {
    /** Starts a non-streaming tool loop and returns its event-driven conversation runner. */
    static runTools(client, params, options) {
        const runner = new ChatCompletionRunner();
        const opts = {
            ...options,
            __metadata: { ...options?.__metadata, helperMethod: 'runTools' },
        };
        runner._run(() => runner._runTools(client, params, runner, opts));
        return runner;
    }
    /**
     * Appends a conversation message and emits text content for assistant replies.
     * @param normalizeContent Defaults to true; initial history passes false to preserve caller-owned messages.
     */
    _addMessage(message, emit = true, normalizeContent = true) {
        super._addMessage(message, emit, normalizeContent);
        if (emit && (0, chatCompletionUtils_1.isAssistantMessage)(message) && message.content) {
            // SAFETY: The runner's content event preserves the existing string-content contract for assistant messages supplied by the API or caller.
            this._emit('content', message.content);
        }
    }
}
exports.ChatCompletionRunner = ChatCompletionRunner;
//# sourceMappingURL=ChatCompletionRunner.js.map