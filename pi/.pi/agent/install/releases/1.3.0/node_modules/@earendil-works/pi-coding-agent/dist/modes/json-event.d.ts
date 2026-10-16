import type { Usage } from "@earendil-works/pi-ai";
import type { AgentSessionEvent } from "../core/agent-session.ts";
type WithoutPartial<T> = T extends {
    partial: unknown;
} ? Omit<T, "partial"> : T;
type ToJsonAssistantMessageEvent<T> = T extends {
    type: "toolcall_start";
    partial: unknown;
} ? WithoutPartial<T> & {
    id: string;
    toolName: string;
} : WithoutPartial<T>;
type MessageUpdateEvent = Extract<AgentSessionEvent, {
    type: "message_update";
}>;
type JsonMessageUpdateEvent = {
    type: "message_update";
    usage: Usage;
    assistantMessageEvent: ToJsonAssistantMessageEvent<MessageUpdateEvent["assistantMessageEvent"]>;
};
/** Session event shape emitted by the JSON and RPC stdout protocols. */
export type JsonAgentSessionEvent = Exclude<AgentSessionEvent, {
    type: "message_update";
}> | JsonMessageUpdateEvent;
/**
 * Remove cumulative assistant snapshots from streaming wire events.
 * `message_start` provides the initial message, deltas build it, and
 * `message_end` provides the final authoritative message. Cumulative usage,
 * tool-call ids, and tool names remain available because their size is constant.
 */
export declare function toJsonEvent(event: MessageUpdateEvent): JsonMessageUpdateEvent;
export declare function toJsonEvent(event: AgentSessionEvent): JsonAgentSessionEvent;
export {};
//# sourceMappingURL=json-event.d.ts.map