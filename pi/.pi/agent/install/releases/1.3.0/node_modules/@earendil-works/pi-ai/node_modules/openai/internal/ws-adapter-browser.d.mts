import type { WebSocketLike } from "./ws-adapter.mjs";
/** A generic event listener callback. */
type Listener = (...args: any[]) => void;
/** A DOM-style event handler passed to addEventListener/removeEventListener. */
type DOMEventHandler = (ev: any) => void;
/** Minimal browser WebSocket surface accepted by the platform-neutral adapter. */
interface WebSocket {
    /** Numeric connection state reported by the browser WebSocket. */
    readonly readyState: number;
    /** Representation used for received binary message frames. */
    binaryType: string;
    /** Sends a text or binary WebSocket frame. */
    send(data: string | ArrayBufferLike | ArrayBufferView): void;
    /** Initiates a closing handshake with an optional status code and reason. */
    close(code?: number, reason?: string): void;
    /** Subscribes to a browser-native WebSocket event. */
    addEventListener(type: string, listener: DOMEventHandler): void;
    /** Removes a previously registered browser-native event listener. */
    removeEventListener(type: string, listener: DOMEventHandler): void;
}
/**
 * Adapts a browser-native WebSocket to the SDK's platform-neutral event API.
 *
 * Binary messages are received as `ArrayBuffer` values, browser event objects
 * are converted into positional listener arguments, and browser errors are
 * normalized to `Error` instances.
 */
export declare class BrowserWebSocket implements WebSocketLike {
    private _ws;
    private _listenerMap;
    /** Wraps an existing browser socket and configures binary frames as array buffers. */
    constructor(ws: WebSocket);
    /** The browser-native socket; accessing it makes calling code platform-specific. */
    get platformSocket(): WebSocket;
    /** Current numeric browser connection state, using standard WebSocket values. */
    get readyState(): number;
    /** Sends a text or binary frame without changing its contents. */
    send(data: string | ArrayBufferLike | ArrayBufferView): void;
    /** Initiates the browser socket's closing handshake. */
    close(code?: number, reason?: string): void;
    /** Registers a listener and converts browser event objects to SDK event arguments. */
    on(event: string, listener: Listener): void;
    /** Removes the browser event wrapper associated with the original listener. */
    off(event: string, listener: Listener): void;
    /** Registers a listener that is removed before it handles its first event. */
    once(event: string, listener: Listener): void;
    private _addListener;
    private _removeListener;
    private _listenersFor;
    /**
     * Converts browser event objects to positional arguments matching the
     * {@link WebSocketLike} interface.
     */
    private static _wrapListener;
}
export {};
//# sourceMappingURL=ws-adapter-browser.d.mts.map