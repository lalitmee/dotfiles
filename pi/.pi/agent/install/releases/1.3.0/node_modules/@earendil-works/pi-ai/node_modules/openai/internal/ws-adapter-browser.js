"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.BrowserWebSocket = void 0;
/**
 * Adapts a browser-native WebSocket to the SDK's platform-neutral event API.
 *
 * Binary messages are received as `ArrayBuffer` values, browser event objects
 * are converted into positional listener arguments, and browser errors are
 * normalized to `Error` instances.
 */
class BrowserWebSocket {
    /** Wraps an existing browser socket and configures binary frames as array buffers. */
    constructor(ws) {
        this._listenerMap = new Map();
        this._ws = ws;
        this._ws.binaryType = 'arraybuffer';
    }
    /** The browser-native socket; accessing it makes calling code platform-specific. */
    get platformSocket() {
        return this._ws;
    }
    /** Current numeric browser connection state, using standard WebSocket values. */
    get readyState() {
        return this._ws.readyState;
    }
    /** Sends a text or binary frame without changing its contents. */
    send(data) {
        this._ws.send(data);
    }
    /** Initiates the browser socket's closing handshake. */
    close(code, reason) {
        this._ws.close(code, reason);
    }
    /** Registers a listener and converts browser event objects to SDK event arguments. */
    on(event, listener) {
        const wrapped = BrowserWebSocket._wrapListener(event, listener);
        this._addListener(event, listener, wrapped);
    }
    /** Removes the browser event wrapper associated with the original listener. */
    off(event, listener) {
        const wrappedListeners = this._listenerMap.get(event)?.get(listener);
        const [wrapped] = wrappedListeners?.slice(-1) ?? [];
        if (wrapped) {
            this._removeListener(event, listener, wrapped);
        }
    }
    /** Registers a listener that is removed before it handles its first event. */
    once(event, listener) {
        let fired = false;
        const wrapped = BrowserWebSocket._wrapListener(event, (...args) => {
            if (fired) {
                return;
            }
            fired = true;
            this._removeListener(event, listener, wrapped);
            listener(...args);
        });
        this._addListener(event, listener, wrapped);
    }
    _addListener(event, listener, wrapped) {
        this._ws.addEventListener(event, wrapped);
        const byListener = this._listenersFor(event);
        const wrappedListeners = byListener.get(listener);
        if (!wrappedListeners) {
            byListener.set(listener, [wrapped]);
        }
        else if (!wrappedListeners.includes(wrapped)) {
            wrappedListeners.push(wrapped);
        }
    }
    _removeListener(event, listener, wrapped) {
        const byListener = this._listenerMap.get(event);
        const wrappedListeners = byListener?.get(listener);
        const index = wrappedListeners?.lastIndexOf(wrapped) ?? -1;
        if (!byListener || !wrappedListeners || index === -1) {
            return;
        }
        this._ws.removeEventListener(event, wrapped);
        wrappedListeners.splice(index, 1);
        if (wrappedListeners.length === 0) {
            byListener.delete(listener);
        }
        if (byListener.size === 0) {
            this._listenerMap.delete(event);
        }
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
     * Converts browser event objects to positional arguments matching the
     * {@link WebSocketLike} interface.
     */
    static _wrapListener(event, listener) {
        switch (event) {
            case 'message': {
                return (ev) => {
                    const isBinary = typeof ev.data !== 'string';
                    listener(ev.data, isBinary);
                };
            }
            case 'close': {
                return (ev) => {
                    listener(ev.code, ev.reason);
                };
            }
            case 'error': {
                return (ev) => {
                    // Some environments provide an ErrorEvent with a `.message`;
                    // fall back to a generic message when the event carries nothing.
                    const message = ev?.message || ev?.error?.message || 'WebSocket error';
                    const err = new Error(message);
                    if (ev?.error) {
                        // SAFETY: The locally created Error receives the browser error event's cause; the cast avoids requiring newer Error ambient declarations.
                        err.cause = ev.error;
                    }
                    listener(err);
                };
            }
            default: {
                // SAFETY: Non-special events use the native DOM handler contract directly; the adapter only wraps message, close, and error variants above.
                return listener;
            }
        }
    }
}
exports.BrowserWebSocket = BrowserWebSocket;
//# sourceMappingURL=ws-adapter-browser.js.map