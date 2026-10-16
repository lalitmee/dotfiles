import { AbstractChatCompletionRunner } from "./AbstractChatCompletionRunner.mjs";
import { isAssistantMessage } from "./chatCompletionUtils.mjs";
/** Executes function tools and follows up with non-streaming chat completion requests. */
export class ChatCompletionRunner extends AbstractChatCompletionRunner {
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
        if (emit && isAssistantMessage(message) && message.content) {
            // SAFETY: The runner's content event preserves the existing string-content contract for assistant messages supplied by the API or caller.
            this._emit('content', message.content);
        }
    }
}
//# sourceMappingURL=ChatCompletionRunner.mjs.map