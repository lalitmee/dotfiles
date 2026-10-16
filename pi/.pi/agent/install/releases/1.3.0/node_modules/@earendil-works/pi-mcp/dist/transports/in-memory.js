import { McpConnectionClosedError } from "../protocol/jsonrpc.js";
import { TransportEvents } from "./transport.js";
export class InMemoryTransport extends TransportEvents {
    peer;
    started = false;
    closed = false;
    connectPeer(peer) {
        if (this.peer)
            throw new Error("In-memory MCP transport already has a peer");
        this.peer = peer;
    }
    async start() {
        if (this.closed)
            throw new McpConnectionClosedError();
        this.started = true;
    }
    async send(message) {
        if (!this.started || this.closed)
            throw new McpConnectionClosedError();
        const peer = this.peer;
        if (!peer?.started || peer.closed)
            throw new McpConnectionClosedError("In-memory MCP peer is not connected");
        const copy = structuredClone(message);
        queueMicrotask(() => peer.deliver(copy));
    }
    async close() {
        if (this.closed)
            return;
        this.closed = true;
        this.emitClose();
        await this.peer?.close();
    }
    /** Exposed so tests can simulate transport-level failures. */
    emitError(error) {
        super.emitError(error);
    }
    deliver(message) {
        if (this.closed)
            return;
        this.emitMessage(message);
    }
}
export function createInMemoryTransportPair() {
    const client = new InMemoryTransport();
    const server = new InMemoryTransport();
    client.connectPeer(server);
    server.connectPeer(client);
    return { client, server };
}
//# sourceMappingURL=in-memory.js.map