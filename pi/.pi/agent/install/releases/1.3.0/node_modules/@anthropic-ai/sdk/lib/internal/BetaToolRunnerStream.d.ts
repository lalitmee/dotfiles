import { type RequestOptions } from "../../internal/request-options.js";
import type { BetaRawMessageStreamEvent, BetaToolUseBlock, MessageCreateParamsBase, Messages } from "../../resources/beta/messages/messages.js";
import { BetaMessageStream, type MessageStreamEvents } from "../BetaMessageStream.js";
/**
 * The stream a tool runner yields. It hands each `tool_use` call to `onToolCall` once the model has moved on
 * from it, and the caller's listeners and `for await` loops over the stream have handled the event that shows it.
 */
export declare class BetaToolRunnerStream extends BetaMessageStream {
    #private;
    constructor(params: MessageCreateParamsBase, onToolCall: (toolUse: BetaToolUseBlock) => void);
    /** The `tool_use` blocks that have finished streaming, in the model's order */
    get toolCalls(): readonly BetaToolUseBlock[];
    /** Sends the request as `client.beta.messages.stream()` does. */
    static start(messages: Messages, params: MessageCreateParamsBase, options: RequestOptions | undefined, onToolCall: (toolUse: BetaToolUseBlock) => void): BetaToolRunnerStream;
    protected _emit<Event extends keyof MessageStreamEvents>(event: Event, ...args: Parameters<MessageStreamEvents[Event]>): void;
    [Symbol.asyncIterator](): AsyncIterator<BetaRawMessageStreamEvent>;
}
//# sourceMappingURL=BetaToolRunnerStream.d.ts.map