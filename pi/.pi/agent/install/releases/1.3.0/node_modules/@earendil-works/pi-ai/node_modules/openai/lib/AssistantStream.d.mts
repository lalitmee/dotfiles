import type { Message, Text, ImageFile, TextDelta, MessageDelta } from "../resources/beta/threads/messages.mjs";
import type { RequestOptions } from "../internal/request-options.mjs";
import type { Run, RunCreateParamsBase, Runs, RunSubmitToolOutputsParamsBase } from "../resources/beta/threads/runs/runs.mjs";
import type { ReadableStream } from "../internal/shim-types.mjs";
import type { AssistantStreamEvent } from "../resources/beta/assistants.mjs";
import type { RunStep, RunStepDelta, ToolCall, ToolCallDelta } from "../resources/beta/threads/runs/steps.mjs";
import type { ThreadCreateAndRunParamsBase, Threads } from "../resources/beta/threads/threads.mjs";
import type { BaseEvents } from "./EventStream.mjs";
import { EventStream } from "./EventStream.mjs";
/** Lifecycle, message, run-step, tool-call, and content events emitted by an assistant stream. */
export interface AssistantStreamEvents extends BaseEvents {
    /** Called with the finalized assistant run after all stream events have been processed. */
    run: (run: Run) => void;
    /** Called when a new assistant-thread message is created. */
    messageCreated: (message: Message) => void;
    /** Called with a message delta and the message snapshot after applying that delta. */
    messageDelta: (message: MessageDelta, snapshot: Message) => void;
    /** Called when an assistant-thread message reaches a completed or incomplete terminal state. */
    messageDone: (message: Message) => void;
    /** Called when a new step is added to the assistant run. */
    runStepCreated: (runStep: RunStep) => void;
    /** Called with a run-step delta and the step snapshot after applying that delta. */
    runStepDelta: (delta: RunStepDelta, snapshot: Runs.RunStep) => void;
    /** Called with the terminal run-step event and its accumulated snapshot. */
    runStepDone: (runStep: Runs.RunStep, snapshot: Runs.RunStep) => void;
    /** Called when a new tool call begins within an assistant run step. */
    toolCallCreated: (toolCall: ToolCall) => void;
    /** Called with a tool-call delta and the tool-call snapshot after applying that delta. */
    toolCallDelta: (delta: ToolCallDelta, snapshot: ToolCall) => void;
    /** Called when the current tool call finishes or a subsequent tool call begins. */
    toolCallDone: (toolCall: ToolCall) => void;
    /** Called when a new text content block is added to an assistant message. */
    textCreated: (content: Text) => void;
    /** Called with a text fragment and the complete text accumulated for its content block. */
    textDelta: (delta: TextDelta, snapshot: Text) => void;
    /** Called when a text content block finishes, together with its containing message. */
    textDone: (content: Text, snapshot: Message) => void;
    /** Called with a completed image-file content block; image files do not have delta events. */
    imageFileDone: (content: ImageFile, snapshot: Message) => void;
    /** Called for every raw assistant-stream event received from the API. */
    event: (event: AssistantStreamEvent) => void;
}
/** Parameters for creating an assistant thread and immediately streaming its run. */
export type ThreadCreateAndRunParamsBaseStream = Omit<ThreadCreateAndRunParamsBase, 'stream'> & {
    /** Streaming is always enabled by the helper and may be specified explicitly. */
    stream?: true;
};
/** Parameters for creating and streaming an assistant run on an existing thread. */
export type RunCreateParamsBaseStream = Omit<RunCreateParamsBase, 'stream'> & {
    /** Streaming is always enabled by the helper and may be specified explicitly. */
    stream?: true;
};
/** Parameters for submitting tool outputs and streaming the resumed assistant run. */
export type RunSubmitToolOutputsParamsStream = Omit<RunSubmitToolOutputsParamsBase, 'stream'> & {
    /** Streaming is always enabled by the helper and may be specified explicitly. */
    stream?: true;
};
/** Streams assistant-run events while accumulating messages, run steps, and tool-call snapshots. */
export declare class AssistantStream extends EventStream<AssistantStreamEvents> implements AsyncIterable<AssistantStreamEvent> {
    #private;
    /** Iterates over cloned raw assistant events; stopping early aborts the underlying request. */
    [Symbol.asyncIterator](): AsyncIterator<AssistantStreamEvent>;
    /** Restores an assistant stream from events serialized by `toReadableStream()`. */
    static fromReadableStream(stream: ReadableStream): AssistantStream;
    protected _fromReadableStream(readableStream: ReadableStream, options?: RequestOptions): Promise<Run>;
    /** Serializes assistant events into a readable stream for transfer to another runtime. */
    toReadableStream(): ReadableStream;
    /** Submits tool outputs and starts streaming the continuation of an existing assistant run. */
    static createToolAssistantStream(runId: string, runs: Runs, params: RunSubmitToolOutputsParamsStream, options: RequestOptions | undefined): AssistantStream;
    protected _createToolAssistantStream(run: Runs, runId: string, params: RunSubmitToolOutputsParamsStream, options?: RequestOptions): Promise<Run>;
    /** Creates an assistant thread and starts streaming its newly created run. */
    static createThreadAssistantStream(params: ThreadCreateAndRunParamsBaseStream, thread: Threads, options?: RequestOptions): AssistantStream;
    /** Creates a run on an existing assistant thread and starts streaming its events. */
    static createAssistantStream(threadId: string, runs: Runs, params: RunCreateParamsBaseStream, options?: RequestOptions): AssistantStream;
    /** Returns the most recent raw event, or `undefined` before any event arrives. */
    currentEvent(): AssistantStreamEvent | undefined;
    /** Returns the latest run snapshot, or `undefined` before a run event arrives. */
    currentRun(): Run | undefined;
    /** Returns the message currently being accumulated, or `undefined` before message creation. */
    currentMessageSnapshot(): Message | undefined;
    /** Returns the run step currently being accumulated, or `undefined` before a step begins. */
    currentRunStepSnapshot(): Runs.RunStep | undefined;
    /** Waits for successful completion and returns the final snapshot of every observed run step. */
    finalRunSteps(): Promise<Runs.RunStep[]>;
    /**
     * Waits for successful completion and returns the final snapshot of every observed message.
     * Terminal message events replace accumulated snapshots without mutating earlier snapshots.
     */
    finalMessages(): Promise<Message[]>;
    /** Waits for completion and returns the final run, or rejects if no terminal run was received. */
    finalRun(): Promise<Run>;
    protected _createThreadAssistantStream(thread: Threads, params: ThreadCreateAndRunParamsBase, options?: RequestOptions): Promise<Run>;
    protected _createAssistantStream(run: Runs, threadId: string, params: RunCreateParamsBase, options?: RequestOptions): Promise<Run>;
    /**
     * Applies an assistant delta to its mutable snapshot, concatenating text and
     * merging nested objects and indexed array entries.
     */
    static accumulateDelta(acc: Record<string, any>, delta: Record<string, any>): Record<string, any>;
    protected _addRun(run: Run): Run;
    protected _threadAssistantStream(params: ThreadCreateAndRunParamsBase, thread: Threads, options?: RequestOptions): Promise<Run>;
    protected _runAssistantStream(threadId: string, runs: Runs, params: RunCreateParamsBase, options?: RequestOptions): Promise<Run>;
    protected _runToolAssistantStream(runId: string, runs: Runs, params: RunSubmitToolOutputsParamsStream, options?: RequestOptions): Promise<Run>;
}
//# sourceMappingURL=AssistantStream.d.mts.map