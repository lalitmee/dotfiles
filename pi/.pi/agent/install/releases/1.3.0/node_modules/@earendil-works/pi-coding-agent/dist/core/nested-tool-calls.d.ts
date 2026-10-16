/**
 * Tool calls that a tool makes while it runs (`ctx.executeTool()`), for example from codemode
 * scripts. The agent loop does not know about them: the session runs each one through the agent's
 * tool pipeline (`runToolCall`) with its own hooks, emits `tool_execution_*` events with
 * `parentToolCallId`, and records the calls and their usage on the model-issued call's tool result
 * message.
 *
 * Nothing here runs until a tool calls `ctx.executeTool()`.
 */
import type { AgentTool, AgentToolCall, AgentToolCallOutcome, AgentToolResult, AgentToolUpdateCallback } from "@earendil-works/pi-agent-core";
import type { NestedToolCallRecord, NestedToolCalls, Usage } from "@earendil-works/pi-ai";
/**
 * Limits of the nested-call record on a tool result: arguments
 * over the per-call or total size are omitted, calls beyond the count are dropped, and the record
 * is marked incomplete when any of that happens.
 */
export declare const NESTED_CALL_LIMITS: {
    readonly maxCalls: 256;
    readonly maxArgumentBytesPerCall: number;
    readonly maxArgumentBytesTotal: number;
    readonly maxErrorChars: 500;
};
/** What the nested calls of one model-issued tool call leave on its tool result message. */
export interface NestedCallSummary {
    /** Becomes `nestedCalls`. Undefined when no nested call was made. */
    calls: NestedToolCalls | undefined;
    /** Summed `usage` of the nested results, added to the message's `usage`. */
    usage: Usage | undefined;
}
/**
 * Collects the nested calls of one model-issued tool call, including calls made by nested tools.
 * The snapshot becomes `nestedCalls` on the tool result message.
 */
export declare class NestedCallRecorder {
    private readonly calls;
    private readonly startedAt;
    private complete;
    private argumentBytes;
    /** Summed usage of every nested result, including calls dropped from the record. */
    private usage;
    /** Record a call as it starts. Returns undefined when the call is dropped. */
    start(toolCall: AgentToolCall): NestedToolCallRecord | undefined;
    finish(record: NestedToolCallRecord | undefined, isError: boolean, errorText: string): void;
    addUsage(usage: Usage): void;
    get totalUsage(): Usage | undefined;
    /** Copy of the record so far, or undefined when no nested call was made. */
    snapshot(): NestedToolCalls | undefined;
}
export interface NestedToolCallOptions {
    /** Defaults to the calling tool's signal. */
    signal?: AbortSignal;
    /** Receives partial results of the nested tool, in addition to `tool_execution_update` events. */
    onUpdate?: AgentToolUpdateCallback;
}
/** `tool_execution_*` events of nested calls. */
export type NestedToolExecutionEvent = {
    type: "tool_execution_start";
    toolCallId: string;
    toolName: string;
    args: unknown;
    parentToolCallId: string;
} | {
    type: "tool_execution_update";
    toolCallId: string;
    toolName: string;
    args: unknown;
    partialResult: AgentToolResult<unknown>;
    parentToolCallId: string;
} | {
    type: "tool_execution_end";
    toolCallId: string;
    toolName: string;
    result: AgentToolResult<unknown>;
    isError: boolean;
    durationMs?: number;
    parentToolCallId: string;
};
export interface NestedToolCallHost {
    /** Tools nested calls resolve against. */
    getTools(): readonly AgentTool[];
    /** Whether every nested call runs exclusively, as when the agent executes tool calls sequentially. */
    isSequential(): boolean;
    /** Run the call through the tool pipeline, with hooks that report `parentToolCallId`. */
    runToolCall(toolCall: AgentToolCall, parentToolCallId: string, signal: AbortSignal | undefined, onUpdate: (partialResult: AgentToolResult<unknown>) => Promise<void>): Promise<AgentToolCallOutcome>;
    emit(event: NestedToolExecutionEvent): Promise<void>;
}
export declare class NestedToolCallRunner {
    private readonly host;
    /** Scopes by the id of the calling tool call. */
    private readonly scopes;
    /** Serializes nested calls that must not run concurrently. */
    private queueTail;
    constructor(host: NestedToolCallHost);
    /**
     * Run `name` on behalf of the call `callerId`. The nested call gets the id `<callerId>/<n>`.
     * Never rejects for tool failures: they come back as `isError: true`.
     */
    execute(callerId: string, name: string, args: unknown, options?: NestedToolCallOptions): Promise<AgentToolCallOutcome>;
    /** Remove and return the record of the nested calls a model-issued call made. */
    takeRecord(toolCallId: string): NestedCallSummary | undefined;
    clear(): void;
}
//# sourceMappingURL=nested-tool-calls.d.ts.map