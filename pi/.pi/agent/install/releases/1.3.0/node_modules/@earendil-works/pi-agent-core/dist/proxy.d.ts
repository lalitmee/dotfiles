/**
 * Proxy stream function for apps that route LLM calls through a server.
 * The server manages auth and proxies requests to LLM providers.
 */
import { type AssistantMessage, type AssistantMessageEventStream, type Model, type SimpleStreamOptions, type StopReason, type ToolCall, type TranscriptContext } from "@earendil-works/pi-ai";
/**
 * Proxy event types - server sends these with partial field stripped to reduce bandwidth.
 */
export type ProxyAssistantMessageEvent = {
    type: "start";
} | {
    type: "text_start";
    contentIndex: number;
} | {
    type: "text_delta";
    contentIndex: number;
    delta: string;
} | {
    type: "text_end";
    contentIndex: number;
    contentSignature?: string;
} | {
    type: "thinking_start";
    contentIndex: number;
} | {
    type: "thinking_delta";
    contentIndex: number;
    delta: string;
} | {
    type: "thinking_end";
    contentIndex: number;
    contentSignature?: string;
} | {
    type: "toolcall_start";
    contentIndex: number;
    id: string;
    toolName: string;
} | {
    type: "toolcall_delta";
    contentIndex: number;
    delta: string;
} | {
    type: "toolcall_end";
    contentIndex: number;
    toolCall: ToolCall;
} | {
    type: "done";
    reason: Extract<StopReason, "stop" | "length" | "toolUse">;
    usage: AssistantMessage["usage"];
    providerThinkingLevel?: string;
} | {
    type: "error";
    reason: Extract<StopReason, "aborted" | "error">;
    errorMessage?: string;
    usage: AssistantMessage["usage"];
    providerThinkingLevel?: string;
};
type ProxySerializableStreamOptions = Pick<SimpleStreamOptions, "temperature" | "samplingParams" | "maxTokens" | "reasoning" | "cacheRetention" | "sessionId" | "headers" | "metadata" | "transport" | "thinkingBudgets" | "maxRetryDelayMs">;
export interface ProxyStreamOptions extends ProxySerializableStreamOptions {
    /** Local abort signal for the proxy request */
    signal?: AbortSignal;
    /** Auth token for the proxy server */
    authToken: string;
    /** Proxy server URL (e.g., "https://genai.example.com") */
    proxyUrl: string;
}
export declare function streamProxy(model: Model<any>, context: TranscriptContext, options: ProxyStreamOptions): AssistantMessageEventStream;
export {};
//# sourceMappingURL=proxy.d.ts.map