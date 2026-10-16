import { ChatCompletionStream, makeChatCompletionReadableStreamMessageChunk } from "./ChatCompletionStream.mjs";
import { OpenAIError } from "../error.mjs";
import { Stream } from "../streaming.mjs";
import { isAssistantMessage, isToolMessage } from "./chatCompletionUtils.mjs";
/** Executes function tools while streaming every intermediate chat completion. */
export class ChatCompletionStreamingRunner extends ChatCompletionStream {
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
                if (isAssistantMessage(message)) {
                    toolCallIds = message.tool_calls?.map((toolCall) => toolCall.id);
                    return;
                }
                if (isToolMessage(message)) {
                    if (!lastChunk) {
                        throw new OpenAIError('cannot serialize a tool message before receiving any chunks');
                    }
                    push(makeChatCompletionReadableStreamMessageChunk(lastChunk, message, toolCallIds));
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
        const stream = new Stream(() => iterator, this.controller);
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
//# sourceMappingURL=ChatCompletionStreamingRunner.mjs.map