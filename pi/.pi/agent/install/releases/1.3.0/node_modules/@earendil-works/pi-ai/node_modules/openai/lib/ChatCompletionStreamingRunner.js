"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.ChatCompletionStreamingRunner = void 0;
const ChatCompletionStream_1 = require("./ChatCompletionStream.js");
const error_1 = require("../error.js");
const streaming_1 = require("../streaming.js");
const chatCompletionUtils_1 = require("./chatCompletionUtils.js");
/** Executes function tools while streaming every intermediate chat completion. */
class ChatCompletionStreamingRunner extends ChatCompletionStream_1.ChatCompletionStream {
    /** Restores a serialized tool run, including intermediate completions and tool-result messages. */
    static fromReadableStream(stream) {
        const runner = new ChatCompletionStreamingRunner(null);
        runner._run(() => runner._fromReadableStream(stream));
        return runner;
    }
    /** Serializes completion chunks and tool-result messages for replay in another runtime. */
    toReadableStream() {
        let lastChunk;
        let toolCallIds;
        const iterator = this._createIterator((push) => {
            const onChunk = (chunk) => {
                lastChunk = chunk;
                push(chunk);
            };
            const onMessage = (message) => {
                if ((0, chatCompletionUtils_1.isAssistantMessage)(message)) {
                    toolCallIds = message.tool_calls?.map((toolCall) => toolCall.id);
                    return;
                }
                if ((0, chatCompletionUtils_1.isToolMessage)(message)) {
                    if (!lastChunk) {
                        throw new error_1.OpenAIError('cannot serialize a tool message before receiving any chunks');
                    }
                    push((0, ChatCompletionStream_1.makeChatCompletionReadableStreamMessageChunk)(lastChunk, message, toolCallIds));
                    toolCallIds = undefined;
                }
            };
            this.on('chunk', onChunk);
            this.on('message', onMessage);
            return () => {
                this.off('chunk', onChunk);
                this.off('message', onMessage);
            };
        }, { onReturn: () => this.abort() });
        const stream = new streaming_1.Stream(() => iterator, this.controller);
        return stream.toReadableStream();
    }
    /** Starts a streaming tool loop and returns its event-driven conversation runner. */
    static runTools(client, params, options) {
        const runner = new ChatCompletionStreamingRunner(
        // @ts-expect-error TODO these types are incompatible
        params);
        const opts = {
            ...options,
            __metadata: { ...options?.__metadata, helperMethod: 'runTools' },
        };
        runner._run(() => runner._runTools(client, params, runner, opts));
        return runner;
    }
}
exports.ChatCompletionStreamingRunner = ChatCompletionStreamingRunner;
//# sourceMappingURL=ChatCompletionStreamingRunner.js.map