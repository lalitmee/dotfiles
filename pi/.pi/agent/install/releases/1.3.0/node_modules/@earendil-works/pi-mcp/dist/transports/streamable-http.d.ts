import type { AuthProvider, McpFetch } from "../auth-provider.ts";
import { type JsonRpcMessage } from "../protocol/jsonrpc.ts";
import { type McpTransport, type McpTransportSendOptions, TransportEvents } from "./transport.ts";
export interface SseEvent {
    event?: string;
    data: string;
    id?: string;
}
export interface ConsumeSseOptions {
    maxEventBytes?: number;
    onEvent(event: SseEvent): void;
    /** Called for every `id` field, including events without data (for example resumption priming events). */
    onId?(id: string): void;
    /** Called for every valid `retry` field, in milliseconds. */
    onRetry?(delayMs: number): void;
}
export declare function consumeSseStream(stream: ReadableStream<Uint8Array>, options: ConsumeSseOptions): Promise<void>;
export interface StreamableHttpReconnectOptions {
    /** Delay before the first reconnection attempt, unless the server sent a `retry` field. Default: 1000. */
    initialDelayMs?: number;
    /** Upper bound for the exponential backoff. Default: 30000. */
    maxDelayMs?: number;
    /** Consecutive failed attempts before giving up on a stream. Default: 5. */
    maxRetries?: number;
}
export interface StreamableHttpTransportOptions {
    url: string | URL;
    headers?: Record<string, string>;
    fetch?: McpFetch;
    /** Open the server-to-client GET stream after initialization. Default: true. */
    openGetStream?: boolean;
    maxMessageBytes?: number;
    authProvider?: AuthProvider;
    /** Reconnection of dropped SSE streams (the GET stream, and response streams that carry event IDs). */
    reconnect?: StreamableHttpReconnectOptions;
}
export declare class McpHttpError extends Error {
    readonly status: number;
    readonly body: string;
    constructor(status: number, message: string, body?: string);
}
export declare class McpAuthRequiredError extends McpHttpError {
    readonly wwwAuthenticate: string | null;
    constructor(response: Response, body?: string);
}
export declare class McpSessionExpiredError extends McpHttpError {
    constructor(body?: string);
}
export declare class StreamableHttpTransport extends TransportEvents implements McpTransport {
    readonly url: URL;
    readonly options: Readonly<StreamableHttpTransportOptions>;
    private fetch;
    private controller;
    private started;
    private closed;
    private sessionIdValue;
    private protocolVersion;
    private getStreamStarted;
    /** Access token of the latest request, which `close()` reuses instead of asking the auth provider. */
    private lastToken;
    constructor(options: StreamableHttpTransportOptions);
    get sessionId(): string | undefined;
    start(): Promise<void>;
    setProtocolVersion(version: string): void;
    send(message: JsonRpcMessage, { signal }?: McpTransportSendOptions): Promise<void>;
    close(): Promise<void>;
    /**
     * Fetch with auth headers. A 401 (or a 403 asking for more scope) is handed to the auth provider
     * once, and the request is retried with whatever credentials it left behind.
     *
     * `signal` only stops dispatch: getting a token or the authorization recovery can take a while, and a
     * request its sender gave up on in the meantime must not reach the server. It does not abort the shared
     * recovery, which other requests may wait for.
     */
    private authorizedFetch;
    private headers;
    private buildHeaders;
    private captureSession;
    private checkResponse;
    private consumeSse;
    /**
     * Read the SSE stream answering one request. When the stream ends or breaks before the response
     * arrives and the server assigned event IDs, resume it with GET and `Last-Event-ID`, as the
     * server may close response streams at will. Otherwise only this request fails.
     */
    private consumeResponseStream;
    private startGetStream;
    /** Keep the server-to-client stream open, reconnecting with backoff when it drops. */
    private runGetStream;
    /** Open a GET SSE stream. Resolves to undefined when the server answers 405 (no GET stream). */
    private openSseStream;
    /**
     * Network failures and transient statuses are retried; auth, session, and protocol errors are not.
     * `fetch` reports network failures, including a connection dropped mid-body, as `TypeError`.
     */
    private isRetryable;
    private reconnectDelay;
    private maxDelay;
    private maxRetries;
    /** Resolves false when the transport closed while waiting. */
    private sleep;
}
//# sourceMappingURL=streamable-http.d.ts.map