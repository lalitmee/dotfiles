import { protectWebSocketOptionsFromCredentialRedirects } from "./ws.mjs";
/**
 * Adapts a Node.js `ws` socket to the SDK's platform-neutral WebSocket API.
 *
 * Text frames become strings, binary frames become `Buffer` values, fragmented
 * messages are merged, and close reasons are decoded before reaching listeners.
 */
export class NodeWebSocket {
    /** Wraps an existing socket created by the optional `ws` package. */
    constructor(ws) {
        /** Maps `(event, originalListener)` to every wrapped registration in listener order. */
        this._listenerMap = new Map();
        this._ws = ws;
        this._ws.on('redirect', (_url, request) => {
            try {
                const options = protectWebSocketOptionsFromCredentialRedirects({
                    followRedirects: true,
                    headers: request.getHeaders(),
                });
                if (options.followRedirects) {
                    return;
                }
            }
            catch {
                // Header inspection failure must never permit a credentialed redirect.
            }
            this._ws.terminate();
        });
    }
    /** The underlying `ws` socket; accessing it makes calling code Node.js-specific. */
    get platformSocket() {
        return this._ws;
    }
    /** Current numeric socket connection state, using standard WebSocket values. */
    get readyState() {
        return this._ws.readyState;
    }
    /** Sends a text or binary frame through the underlying `ws` connection. */
    send(data) {
        this._ws.send(data);
    }
    /** Initiates the socket's closing handshake with an optional code and reason. */
    close(code, reason) {
        this._ws.close(code, reason);
    }
    /** Registers a listener with normalized message payloads and close reasons. */
    on(event, listener) {
        const wrapped = NodeWebSocket._wrapListener(event, listener);
        this._registerListener(event, listener, wrapped);
    }
    /** Removes the platform listener associated with the original callback. */
    off(event, listener) {
        const wrappedListeners = this._listenerMap.get(event)?.get(listener);
        const [wrapped] = wrappedListeners?.slice(-1) ?? [];
        if (!wrapped) {
            return;
        }
        this._removeListener(event, listener, wrapped);
    }
    /** Registers a listener that is removed before it handles its first event. */
    once(event, listener) {
        let fired = false;
        const wrapped = NodeWebSocket._wrapListener(event, (...args) => {
            if (fired) {
                return;
            }
            fired = true;
            this._removeListener(event, listener, wrapped);
            listener(...args);
        });
        this._registerListener(event, listener, wrapped);
    }
    _registerListener(event, listener, wrapped) {
        const byListener = this._listenersFor(event);
        const wrappedListeners = byListener.get(listener);
        if (wrappedListeners) {
            wrappedListeners.push(wrapped);
        }
        else {
            byListener.set(listener, [wrapped]);
        }
        this._ws.on(event, wrapped);
    }
    _removeListener(event, listener, wrapped) {
        const byListener = this._listenerMap.get(event);
        const wrappedListeners = byListener?.get(listener);
        if (!byListener || !wrappedListeners) {
            return;
        }
        const index = wrappedListeners.lastIndexOf(wrapped);
        if (index === -1) {
            return;
        }
        wrappedListeners.splice(index, 1);
        if (wrappedListeners.length === 0) {
            byListener.delete(listener);
        }
        if (byListener.size === 0) {
            this._listenerMap.delete(event);
        }
        this._ws.removeListener(event, wrapped);
    }
    _listenersFor(event) {
        let map = this._listenerMap.get(event);
        if (!map) {
            map = new Map();
            this._listenerMap.set(event, map);
        }
        return map;
    }
    /**
     * Normalizes `ws` message payloads: text frames become strings,
     * binary frames stay as `Buffer`, and fragmented frames are merged.
     */
    static _normalizeMessageData(data, isBinary) {
        if (!isBinary) {
            if (Array.isArray(data)) {
                return Buffer.concat(data).toString();
            }
            if (data instanceof ArrayBuffer) {
                return Buffer.from(data).toString();
            }
            return data.toString();
        }
        if (Array.isArray(data)) {
            return Buffer.concat(data);
        }
        if (data instanceof ArrayBuffer) {
            return Buffer.from(data);
        }
        return data;
    }
    static _wrapListener(event, listener) {
        switch (event) {
            case 'message': {
                return (data, isBinary) => {
                    listener(NodeWebSocket._normalizeMessageData(data, isBinary), isBinary);
                };
            }
            case 'close': {
                return (code, reason) => {
                    listener(code, reason.toString());
                };
            }
            // 'open' and 'error' pass through unchanged
            default: {
                return listener;
            }
        }
    }
}
//# sourceMappingURL=ws-adapter-node.mjs.map