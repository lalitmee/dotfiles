import type { CallToolResult } from "./protocol/content.ts";
import { type ClientCapabilities, type Implementation, type InitializeResult, type ListResourcesResult, type ListResourceTemplatesResult, type ProgressNotification, type ReadResourceResult, type Resource, type ResourceTemplate, type Root, type ServerCapabilities, type SupportedProtocolVersion, type Tool } from "./protocol/types.ts";
import type { McpTransport } from "./transports/transport.ts";
type ClientState = "idle" | "connecting" | "connected" | "closed";
type NotificationListener = (params: unknown) => void;
type ErrorListener = (error: Error) => void;
type CloseListener = () => void;
type RequestHandler = (params: unknown, context: {
    signal: AbortSignal;
}) => unknown | Promise<unknown>;
export interface McpClientOptions extends Implementation {
    capabilities?: ClientCapabilities;
    protocolVersion?: SupportedProtocolVersion;
    requestTimeoutMs?: number;
    roots?: readonly Root[] | (() => readonly Root[] | Promise<readonly Root[]>);
}
export interface McpRequestOptions {
    signal?: AbortSignal;
    timeoutMs?: number;
    onProgress?: (progress: ProgressNotification) => void;
}
export declare class McpClient {
    readonly options: Readonly<McpClientOptions>;
    private state;
    private transport;
    private nextRequestId;
    private serverInfoValue;
    private serverCapabilitiesValue;
    private instructionsValue;
    private protocolVersionValue;
    private pending;
    private progressRequests;
    private incoming;
    private requestHandlers;
    private notificationListeners;
    private errorListeners;
    private closeListeners;
    private disposers;
    constructor(options: McpClientOptions);
    get connectionState(): ClientState;
    get serverInfo(): Implementation | undefined;
    get serverCapabilities(): ServerCapabilities | undefined;
    get instructions(): string | undefined;
    get protocolVersion(): string | undefined;
    connect(transport: McpTransport): Promise<InitializeResult>;
    request<Result = unknown>(method: string, params?: Record<string, unknown>, options?: McpRequestOptions): Promise<Result>;
    notify(method: string, params?: Record<string, unknown>): Promise<void>;
    setRequestHandler(method: string, handler: RequestHandler): () => void;
    onNotification(method: string, listener: NotificationListener): () => void;
    onError(listener: ErrorListener): () => void;
    /** Called once when the connection closes, whether the transport dropped or `close()` was called. */
    onClose(listener: CloseListener): () => void;
    ping(options?: McpRequestOptions): Promise<void>;
    listTools(options?: McpRequestOptions): Promise<Tool[]>;
    /** Every resource, following `nextCursor` through all pages. */
    listResources(options?: McpRequestOptions): Promise<Resource[]>;
    /** One page of resources, starting at `cursor`. */
    listResourcesPage(cursor?: string, options?: McpRequestOptions): Promise<ListResourcesResult>;
    /** Every resource template, following `nextCursor` through all pages. */
    listResourceTemplates(options?: McpRequestOptions): Promise<ResourceTemplate[]>;
    /** One page of resource templates, starting at `cursor`. */
    listResourceTemplatesPage(cursor?: string, options?: McpRequestOptions): Promise<ListResourceTemplatesResult>;
    readResource(uri: string, options?: McpRequestOptions): Promise<ReadResourceResult>;
    private listPage;
    /** Every item of a paginated list method. */
    private listAll;
    callTool(name: string, args?: Record<string, unknown>, options?: McpRequestOptions): Promise<CallToolResult>;
    close(): Promise<void>;
    private requestInternal;
    private notifyInternal;
    private requireTransport;
    private handleMessage;
    private handleResponse;
    private handleRequest;
    private handleNotification;
    private handleProgress;
    private handleCancelled;
    private armTimeout;
    private cancelPending;
    private removePending;
    private rejectPending;
    private handleTransportClose;
    /** Idempotent: rejects in-flight requests, aborts server requests we are serving, and flips the state. */
    private markClosed;
    private emitError;
    private disposeTransportListeners;
}
export {};
//# sourceMappingURL=client.d.ts.map