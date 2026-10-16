import type * as WS from 'ws';
import type { WebSocketLike } from "./ws-adapter.js";
/** A generic event listener callback. */
type Listener = (...args: any[]) => void;
/**
 * Adapts a Node.js `ws` socket to the SDK's platform-neutral WebSocket API.
 *
 * Text frames become strings, binary frames become `Buffer` values, fragmented
 * messages are merged, and close reasons are decoded before reaching listeners.
 */
export declare class NodeWebSocket implements WebSocketLike {
    private _ws;
    /** Maps `(event, originalListener)` to every wrapped registration in listener order. */
    private _listenerMap;
    /** Wraps an existing socket created by the optional `ws` package. */
    constructor(ws: WS.WebSocket);
    /** The underlying `ws` socket; accessing it makes calling code Node.js-specific. */
    get platformSocket(): WS.WebSocket;
    /** Current numeric socket connection state, using standard WebSocket values. */
    get readyState(): number;
    /** Sends a text or binary frame through the underlying `ws` connection. */
    send(data: string | ArrayBufferLike | ArrayBufferView): void;
    /** Initiates the socket's closing handshake with an optional code and reason. */
    close(code?: number, reason?: string): void;
    /** Registers a listener with normalized message payloads and close reasons. */
    on(event: string, listener: Listener): void;
    /** Removes the platform listener associated with the original callback. */
    off(event: string, listener: Listener): void;
    /** Registers a listener that is removed before it handles its first event. */
    once(event: string, listener: Listener): void;
    private _registerListener;
    private _removeListener;
    private _listenersFor;
    /**
     * Normalizes `ws` message payloads: text frames become strings,
     * binary frames stay as `Buffer`, and fragmented frames are merged.
     */
    private static _normalizeMessageData;
    private static _wrapListener;
}
export {};
//# sourceMappingURL=ws-adapter-node.d.ts.map