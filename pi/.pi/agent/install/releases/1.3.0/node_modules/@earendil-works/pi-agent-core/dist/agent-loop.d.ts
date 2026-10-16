/**
 * Agent loop that works with AgentMessage throughout.
 * Transforms to Message[] only at the LLM call boundary.
 */
import { type AssistantMessage, EventStream } from "@earendil-works/pi-ai";
import type { AgentContext, AgentEvent, AgentLoopConfig, AgentMessage, AgentTool, AgentToolCall, AgentToolCallOutcome, AgentToolResult, StreamFn } from "./types.ts";
export type AgentEventSink = (event: AgentEvent) => Promise<void> | void;
/**
 * Start an agent loop with a new prompt message.
 * The prompt is added to the context and events are emitted for it.
 */
export declare function agentLoop(prompts: AgentMessage[], context: AgentContext, config: AgentLoopConfig, signal: AbortSignal | undefined, streamFn: StreamFn): EventStream<AgentEvent, AgentMessage[]>;
/**
 * Continue an agent loop from the current context without adding a new message.
 * Used for retries - context already has user message or tool results.
 *
 * **Important:** The last message in context must convert to a `user` or `toolResult` message
 * via `convertToLlm`. If it doesn't, the LLM provider will reject the request.
 * This cannot be validated here since `convertToLlm` is only called once per turn.
 */
export declare function agentLoopContinue(context: AgentContext, config: AgentLoopConfig, signal: AbortSignal | undefined, streamFn: StreamFn): EventStream<AgentEvent, AgentMessage[]>;
export declare function runAgentLoop(prompts: AgentMessage[], context: AgentContext, config: AgentLoopConfig, emit: AgentEventSink, signal: AbortSignal | undefined, streamFn: StreamFn): Promise<AgentMessage[]>;
export declare function runAgentLoopContinue(context: AgentContext, config: AgentLoopConfig, emit: AgentEventSink, signal: AbortSignal | undefined, streamFn: StreamFn): Promise<AgentMessage[]>;
/** The `beforeToolCall` and `afterToolCall` hooks of {@link AgentLoopConfig}. */
export type ToolCallHooks = Pick<AgentLoopConfig, "beforeToolCall" | "afterToolCall">;
type ToolUpdateSink = (partialResult: AgentToolResult<any>) => Promise<void> | void;
/** Options for {@link runToolCall}. */
export interface RunToolCallOptions extends ToolCallHooks {
    /** Tools the call resolves against. */
    tools: readonly AgentTool<any>[];
    /** Passed to the hooks as the message that issued the call. */
    assistantMessage: AssistantMessage;
    /** Passed to the hooks as the current agent context. */
    context: AgentContext;
    signal?: AbortSignal;
    onUpdate?: ToolUpdateSink;
}
/**
 * Run one tool call through the same steps as a model-issued call: argument preparation, schema
 * validation, `beforeToolCall`, execution, and `afterToolCall`. Emits no events and adds no
 * messages. Tools that call other tools use this so the hooks (for example permission checks)
 * apply to those calls too.
 *
 * Never rejects for tool failures: unknown tools, validation errors, blocked calls, and thrown
 * errors come back as `isError: true`.
 */
export declare function runToolCall(toolCall: AgentToolCall, options: RunToolCallOptions): Promise<AgentToolCallOutcome>;
export {};
//# sourceMappingURL=agent-loop.d.ts.map