import { type JsonRpcMessage } from "../protocol/jsonrpc.ts";
import { type McpTransport, TransportEvents } from "./transport.ts";
export declare class InMemoryTransport extends TransportEvents implements McpTransport {
    private peer;
    private started;
    private closed;
    connectPeer(peer: InMemoryTransport): void;
    start(): Promise<void>;
    send(message: JsonRpcMessage): Promise<void>;
    close(): Promise<void>;
    /** Exposed so tests can simulate transport-level failures. */
    emitError(error: unknown): void;
    private deliver;
}
export declare function createInMemoryTransportPair(): {
    client: InMemoryTransport;
    server: InMemoryTransport;
};
//# sourceMappingURL=in-memory.d.ts.map