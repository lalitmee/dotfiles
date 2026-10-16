import { type JsonRpcMessage } from "../protocol/jsonrpc.ts";
export declare const DEFAULT_MAX_MESSAGE_BYTES: number;
export type McpTransportMessageListener = (message: JsonRpcMessage) => void;
export type McpTransportErrorListener = (error: Error) => void;
export type McpTransportCloseListener = () => void;
export interface McpTransportSendOptions {
    /**
     * Aborted once the sender no longer waits for a reply (the request was cancelled, timed out, answered,
     * or the client closed). A transport must not dispatch the message after that, for example when
     * retrying it after an authorization refresh. It does not undo a message already dispatched.
     */
    signal?: AbortSignal;
}
export interface McpTransport {
    start(): Promise<void>;
    send(message: JsonRpcMessage, options?: McpTransportSendOptions): Promise<void>;
    close(): Promise<void>;
    onMessage(listener: McpTransportMessageListener): () => void;
    onError(listener: McpTransportErrorListener): () => void;
    onClose(listener: McpTransportCloseListener): () => void;
    setProtocolVersion?(version: string): void;
}
/** Listener bookkeeping shared by transports. `emitClose` fires at most once per transport. */
export declare abstract class TransportEvents {
    private messageListeners;
    private errorListeners;
    private closeListeners;
    private closeEmitted;
    onMessage(listener: McpTransportMessageListener): () => void;
    onError(listener: McpTransportErrorListener): () => void;
    onClose(listener: McpTransportCloseListener): () => void;
    protected emitMessage(message: JsonRpcMessage): void;
    protected emitError(error: unknown): void;
    protected emitClose(): void;
}
//# sourceMappingURL=transport.d.ts.map