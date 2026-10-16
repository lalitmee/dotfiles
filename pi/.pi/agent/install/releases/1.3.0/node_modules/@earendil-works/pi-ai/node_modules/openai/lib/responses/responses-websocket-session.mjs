var _ResponsesWebSocketSession_instances, _ResponsesWebSocketSession_connection, _ResponsesWebSocketSession_lanes, _ResponsesWebSocketSession_maxLanes, _ResponsesWebSocketSession_maxEvents, _ResponsesWebSocketSession_maxBytes, _ResponsesWebSocketSession_events, _ResponsesWebSocketSession_bytes, _ResponsesWebSocketSession_closed, _ResponsesWebSocketSession_socket, _ResponsesWebSocketSession_failedTransport, _ResponsesWebSocketSession_removeListeners, _ResponsesWebSocketSession_onEvent, _ResponsesWebSocketSession_onClose, _ResponsesWebSocketSession_onError, _ResponsesWebSocketSession_onSocketError, _ResponsesWebSocketSession_onReconnect, _ResponsesWebSocketSession_onReconnected, _ResponsesWebSocketSession_assertTransportAvailable, _ResponsesWebSocketSession_clearRecoveredTransportError, _ResponsesWebSocketSession_failLanes;
import { __classPrivateFieldGet, __classPrivateFieldSet } from "../../internal/tslib.mjs";
import { WebSocketError } from "../../resources/responses/internal-base.mjs";
import { OpenAIError } from "../../core/error.mjs";
import { ReadyState } from "../../internal/ws-adapter.mjs";
import { getWebSocketError, rawByteLength } from "../../internal/ws.mjs";
import { hasOwn, isObj } from "../../internal/utils/values.mjs";
import { getWebSocketEventBytes, getWebSocketEventPayload } from "../../resources/responses/ws-base.mjs";
import { getWebSocketEventBytes as getBetaWebSocketEventBytes, getWebSocketEventPayload as getBetaWebSocketEventPayload, } from "../../resources/beta/responses/ws-base.mjs";
import { ResponsesWebSocketLane, positiveInteger } from "./responses-websocket-lane.mjs";
export { ResponsesWebSocketLane } from "./responses-websocket-lane.mjs";
function parseEvent(serialized) {
    // SAFETY: Validate the envelope below, as the native transport does for server-defined payloads.
    const event = JSON.parse(serialized);
    if (!isObj(event) ||
        // oxlint-disable-next-line anti-slop/no-runtime-typeof -- Match the native event envelope at this untyped boundary.
        typeof Object.getOwnPropertyDescriptor(event, 'type')?.value !== 'string') {
        throw new OpenAIError('Invalid WebSocket event shape');
    }
    return event;
}
function serializeCustomEvent(incoming) {
    const snapshot = structuredClone(incoming);
    // Mask inherited serialization hooks throughout our copy, not the caller's event.
    const pending = [snapshot];
    const visited = new Set();
    while (pending.length > 0) {
        const value = pending.pop();
        // oxlint-disable-next-line anti-slop/no-runtime-typeof -- Traverse only objects in the untyped structured clone.
        if (value === null || typeof value !== 'object' || visited.has(value)) {
            continue;
        }
        visited.add(value);
        // Keep Date's standard JSON conversion, which is owned by Date.prototype.
        if (!(value instanceof Date) && !hasOwn(value, 'toJSON')) {
            Object.defineProperty(value, 'toJSON', { value: undefined });
        }
        for (const child of Object.values(value)) {
            pending.push(child);
        }
    }
    return JSON.stringify(snapshot);
}
/**
 * Routes events from an existing Responses socket without creating another reader.
 * Register lanes before sending. Unregistered events remain observable on the socket.
 * Closing this helper releases its listeners and lanes, but leaves the socket open.
 * Attaching to a closing or closed socket is rejected.
 * Reconnecting invalidates lanes: register new ones after restoring application state.
 * No request is replayed by this helper.
 */
export class ResponsesWebSocketSession {
    constructor(connection, options) {
        _ResponsesWebSocketSession_instances.add(this);
        _ResponsesWebSocketSession_connection.set(this, void 0);
        _ResponsesWebSocketSession_lanes.set(this, new Map());
        _ResponsesWebSocketSession_maxLanes.set(this, void 0);
        _ResponsesWebSocketSession_maxEvents.set(this, void 0);
        _ResponsesWebSocketSession_maxBytes.set(this, void 0);
        _ResponsesWebSocketSession_events.set(this, 0);
        _ResponsesWebSocketSession_bytes.set(this, 0);
        _ResponsesWebSocketSession_closed.set(this, false);
        _ResponsesWebSocketSession_socket.set(this, void 0);
        _ResponsesWebSocketSession_failedTransport.set(this, void 0);
        _ResponsesWebSocketSession_onEvent.set(this, (incoming) => {
            let event;
            let bytes;
            try {
                const payload = getWebSocketEventPayload(incoming) ?? getBetaWebSocketEventPayload(incoming);
                // Native events are copied from the wire, before any observer's mutations.
                // Clone custom inputs once to strip prototypes and evaluate accessors,
                // then retain only the JSON representation covered by byte accounting.
                let serialized = payload;
                if (serialized === undefined) {
                    serialized = serializeCustomEvent(incoming);
                }
                event = parseEvent(serialized);
                bytes =
                    payload === undefined
                        ? rawByteLength(serialized)
                        : (getBetaWebSocketEventBytes(incoming) ?? getWebSocketEventBytes(incoming));
            }
            catch {
                __classPrivateFieldGet(this, _ResponsesWebSocketSession_instances, "m", _ResponsesWebSocketSession_failLanes).call(this, new OpenAIError('Cannot snapshot custom WebSocket event'));
                return;
            }
            const routing = Object.getOwnPropertyDescriptor(event, 'stream_id');
            let streamID;
            if (routing) {
                const value = routing.value;
                // oxlint-disable-next-line anti-slop/no-runtime-typeof -- Raw event observers may mutate routing; only an own string value can select a lane, without invoking accessors.
                if (typeof value !== 'string') {
                    return;
                }
                streamID = value;
            }
            const entry = __classPrivateFieldGet(this, _ResponsesWebSocketSession_lanes, "f").get(streamID);
            if (!entry || entry.lane.ended) {
                return;
            }
            if (bytes > __classPrivateFieldGet(this, _ResponsesWebSocketSession_maxBytes, "f")) {
                entry.lane.fail(new OpenAIError('Responses WebSocket helper buffer limit exceeded'));
                return;
            }
            __classPrivateFieldSet(this, _ResponsesWebSocketSession_events, __classPrivateFieldGet(this, _ResponsesWebSocketSession_events, "f") + 1, "f");
            __classPrivateFieldSet(this, _ResponsesWebSocketSession_bytes, __classPrivateFieldGet(this, _ResponsesWebSocketSession_bytes, "f") + bytes, "f");
            entry.events += 1;
            entry.bytes += bytes;
            // Apply the lane's own limits first, releasing its backlog on overflow.
            entry.lane.push(event, bytes);
            while (__classPrivateFieldGet(this, _ResponsesWebSocketSession_events, "f") > __classPrivateFieldGet(this, _ResponsesWebSocketSession_maxEvents, "f") || __classPrivateFieldGet(this, _ResponsesWebSocketSession_bytes, "f") > __classPrivateFieldGet(this, _ResponsesWebSocketSession_maxBytes, "f")) {
                const bytePressure = __classPrivateFieldGet(this, _ResponsesWebSocketSession_bytes, "f") > __classPrivateFieldGet(this, _ResponsesWebSocketSession_maxBytes, "f");
                let largest = entry;
                let largestSize = 0;
                for (const candidate of __classPrivateFieldGet(this, _ResponsesWebSocketSession_lanes, "f").values()) {
                    // Attribute pressure to existing backlogs, excluding the incoming event.
                    const size = bytePressure
                        ? candidate.bytes - (candidate === entry ? bytes : 0)
                        : candidate.events - (candidate === entry ? 1 : 0);
                    // Strict comparison breaks ties by lane registration order.
                    if (size > largestSize) {
                        largest = candidate;
                        largestSize = size;
                    }
                }
                largest.lane.fail(new OpenAIError('Responses WebSocket helper buffer limit exceeded'));
            }
        });
        _ResponsesWebSocketSession_onClose.set(this, () => {
            if (__classPrivateFieldGet(this, _ResponsesWebSocketSession_closed, "f")) {
                return;
            }
            __classPrivateFieldSet(this, _ResponsesWebSocketSession_closed, true, "f");
            __classPrivateFieldGet(this, _ResponsesWebSocketSession_instances, "m", _ResponsesWebSocketSession_removeListeners).call(this);
            for (const { lane } of __classPrivateFieldGet(this, _ResponsesWebSocketSession_lanes, "f").values()) {
                lane.end(new OpenAIError('Responses WebSocket connection closed'));
            }
        });
        // oxlint-disable-next-line eslint/class-methods-use-this -- Each session owns a distinct listener so detaching one does not unhandle another session's errors.
        _ResponsesWebSocketSession_onError.set(this, () => {
            // API errors are routed as events. Other emitter errors may be recoverable
            // diagnostics; only the physical socket's errors end all lanes.
        });
        _ResponsesWebSocketSession_onSocketError.set(this, (cause) => {
            const error = new WebSocketError(cause.message, null);
            Object.assign(error, { cause });
            __classPrivateFieldSet(this, _ResponsesWebSocketSession_failedTransport, { socket: __classPrivateFieldGet(this, _ResponsesWebSocketSession_socket, "f"), error }, "f");
            for (const { lane } of __classPrivateFieldGet(this, _ResponsesWebSocketSession_lanes, "f").values()) {
                lane.end(error);
            }
        });
        _ResponsesWebSocketSession_onReconnect.set(this, () => {
            __classPrivateFieldGet(this, _ResponsesWebSocketSession_socket, "f")?.off('error', __classPrivateFieldGet(this, _ResponsesWebSocketSession_onSocketError, "f"));
            __classPrivateFieldSet(this, _ResponsesWebSocketSession_socket, undefined, "f");
            __classPrivateFieldGet(this, _ResponsesWebSocketSession_instances, "m", _ResponsesWebSocketSession_failLanes).call(this, new OpenAIError('Responses WebSocket reconnected state must be restored explicitly'));
            __classPrivateFieldGet(this, _ResponsesWebSocketSession_lanes, "f").clear();
        });
        _ResponsesWebSocketSession_onReconnected.set(this, () => {
            if (__classPrivateFieldGet(this, _ResponsesWebSocketSession_closed, "f")) {
                return;
            }
            __classPrivateFieldGet(this, _ResponsesWebSocketSession_socket, "f")?.off('error', __classPrivateFieldGet(this, _ResponsesWebSocketSession_onSocketError, "f"));
            __classPrivateFieldSet(this, _ResponsesWebSocketSession_socket, __classPrivateFieldGet(this, _ResponsesWebSocketSession_connection, "f").socket, "f");
            __classPrivateFieldGet(this, _ResponsesWebSocketSession_instances, "m", _ResponsesWebSocketSession_clearRecoveredTransportError).call(this, __classPrivateFieldGet(this, _ResponsesWebSocketSession_socket, "f"));
            __classPrivateFieldGet(this, _ResponsesWebSocketSession_socket, "f").on('error', __classPrivateFieldGet(this, _ResponsesWebSocketSession_onSocketError, "f"));
        });
        __classPrivateFieldSet(this, _ResponsesWebSocketSession_connection, connection, "f");
        __classPrivateFieldSet(this, _ResponsesWebSocketSession_maxLanes, positiveInteger(options.maxLanes), "f");
        __classPrivateFieldSet(this, _ResponsesWebSocketSession_maxEvents, positiveInteger(options.maxBufferedEvents), "f");
        __classPrivateFieldSet(this, _ResponsesWebSocketSession_maxBytes, positiveInteger(options.maxBufferedBytes), "f");
        if (connection.socket.readyState === ReadyState.CLOSING ||
            connection.socket.readyState === ReadyState.CLOSED) {
            throw new OpenAIError('Cannot attach a Responses WebSocket session to a closing or closed socket');
        }
        connection.on('event', __classPrivateFieldGet(this, _ResponsesWebSocketSession_onEvent, "f"));
        connection.on('error', __classPrivateFieldGet(this, _ResponsesWebSocketSession_onError, "f"));
        connection.on('close', __classPrivateFieldGet(this, _ResponsesWebSocketSession_onClose, "f"));
        connection.on('reconnecting', __classPrivateFieldGet(this, _ResponsesWebSocketSession_onReconnect, "f"));
        connection.on('reconnected', __classPrivateFieldGet(this, _ResponsesWebSocketSession_onReconnected, "f"));
        __classPrivateFieldGet(this, _ResponsesWebSocketSession_onReconnected, "f").call(this);
    }
    /** Omit streamID for the protocol's default lane. A lane has one consumer.
     * IDs remain reserved until reconnect, including after close or failure:
     * a terminal response can still be followed by an automatic successor.
     */
    lane(streamID, limits = {}) {
        if (__classPrivateFieldGet(this, _ResponsesWebSocketSession_closed, "f")) {
            throw new OpenAIError('Responses WebSocket session is closed');
        }
        __classPrivateFieldGet(this, _ResponsesWebSocketSession_instances, "m", _ResponsesWebSocketSession_assertTransportAvailable).call(this, __classPrivateFieldGet(this, _ResponsesWebSocketSession_connection, "f").socket);
        if (streamID !== undefined &&
            // oxlint-disable-next-line anti-slop/no-runtime-typeof -- Untyped JavaScript callers must not create non-string routing keys through RegExp coercion.
            (typeof streamID !== 'string' || !/^[A-Za-z0-9_.-]{1,256}$/u.test(streamID))) {
            throw new OpenAIError('Invalid Responses WebSocket stream ID');
        }
        if (__classPrivateFieldGet(this, _ResponsesWebSocketSession_lanes, "f").has(streamID)) {
            throw new OpenAIError('Responses WebSocket lane is already registered');
        }
        if (__classPrivateFieldGet(this, _ResponsesWebSocketSession_lanes, "f").size >= __classPrivateFieldGet(this, _ResponsesWebSocketSession_maxLanes, "f")) {
            throw new OpenAIError('Responses WebSocket lane limit exceeded');
        }
        const entry = {
            events: 0,
            bytes: 0,
            lane: new ResponsesWebSocketLane(streamID, (event) => {
                const { socket } = __classPrivateFieldGet(this, _ResponsesWebSocketSession_connection, "f");
                __classPrivateFieldGet(this, _ResponsesWebSocketSession_instances, "m", _ResponsesWebSocketSession_assertTransportAvailable).call(this, socket);
                if (socket.readyState !== ReadyState.OPEN) {
                    throw new OpenAIError('Wait for an open Responses WebSocket before sending');
                }
                // The emitter's reconnect queue may replay an uncertain write. Send
                // directly to the physical socket, including during its open callback.
                socket.send(JSON.stringify(event));
            }, (bytes) => {
                __classPrivateFieldSet(this, _ResponsesWebSocketSession_events, __classPrivateFieldGet(this, _ResponsesWebSocketSession_events, "f") - 1, "f");
                __classPrivateFieldSet(this, _ResponsesWebSocketSession_bytes, __classPrivateFieldGet(this, _ResponsesWebSocketSession_bytes, "f") - bytes, "f");
                entry.events -= 1;
                entry.bytes -= bytes;
            }, positiveInteger(limits.maxBufferedEvents ?? __classPrivateFieldGet(this, _ResponsesWebSocketSession_maxEvents, "f")), positiveInteger(limits.maxBufferedBytes ?? __classPrivateFieldGet(this, _ResponsesWebSocketSession_maxBytes, "f"))),
        };
        __classPrivateFieldGet(this, _ResponsesWebSocketSession_lanes, "f").set(streamID, entry);
        return entry.lane;
    }
    close() {
        __classPrivateFieldSet(this, _ResponsesWebSocketSession_closed, true, "f");
        __classPrivateFieldGet(this, _ResponsesWebSocketSession_instances, "m", _ResponsesWebSocketSession_removeListeners).call(this);
        __classPrivateFieldGet(this, _ResponsesWebSocketSession_instances, "m", _ResponsesWebSocketSession_failLanes).call(this, new OpenAIError('Responses WebSocket session is closed'));
        __classPrivateFieldGet(this, _ResponsesWebSocketSession_lanes, "f").clear();
    }
}
_ResponsesWebSocketSession_connection = new WeakMap(), _ResponsesWebSocketSession_lanes = new WeakMap(), _ResponsesWebSocketSession_maxLanes = new WeakMap(), _ResponsesWebSocketSession_maxEvents = new WeakMap(), _ResponsesWebSocketSession_maxBytes = new WeakMap(), _ResponsesWebSocketSession_events = new WeakMap(), _ResponsesWebSocketSession_bytes = new WeakMap(), _ResponsesWebSocketSession_closed = new WeakMap(), _ResponsesWebSocketSession_socket = new WeakMap(), _ResponsesWebSocketSession_failedTransport = new WeakMap(), _ResponsesWebSocketSession_onEvent = new WeakMap(), _ResponsesWebSocketSession_onClose = new WeakMap(), _ResponsesWebSocketSession_onError = new WeakMap(), _ResponsesWebSocketSession_onSocketError = new WeakMap(), _ResponsesWebSocketSession_onReconnect = new WeakMap(), _ResponsesWebSocketSession_onReconnected = new WeakMap(), _ResponsesWebSocketSession_instances = new WeakSet(), _ResponsesWebSocketSession_removeListeners = function _ResponsesWebSocketSession_removeListeners() {
    __classPrivateFieldGet(this, _ResponsesWebSocketSession_connection, "f").off('event', __classPrivateFieldGet(this, _ResponsesWebSocketSession_onEvent, "f"));
    __classPrivateFieldGet(this, _ResponsesWebSocketSession_connection, "f").off('error', __classPrivateFieldGet(this, _ResponsesWebSocketSession_onError, "f"));
    __classPrivateFieldGet(this, _ResponsesWebSocketSession_connection, "f").off('close', __classPrivateFieldGet(this, _ResponsesWebSocketSession_onClose, "f"));
    __classPrivateFieldGet(this, _ResponsesWebSocketSession_connection, "f").off('reconnecting', __classPrivateFieldGet(this, _ResponsesWebSocketSession_onReconnect, "f"));
    __classPrivateFieldGet(this, _ResponsesWebSocketSession_connection, "f").off('reconnected', __classPrivateFieldGet(this, _ResponsesWebSocketSession_onReconnected, "f"));
    __classPrivateFieldGet(this, _ResponsesWebSocketSession_socket, "f")?.off('error', __classPrivateFieldGet(this, _ResponsesWebSocketSession_onSocketError, "f"));
    __classPrivateFieldSet(this, _ResponsesWebSocketSession_socket, undefined, "f");
}, _ResponsesWebSocketSession_assertTransportAvailable = function _ResponsesWebSocketSession_assertTransportAvailable(socket) {
    // Native transports record failure before forwarding their public error event.
    const cause = getWebSocketError(socket);
    if (cause) {
        const error = new WebSocketError(cause.message, null);
        Object.assign(error, { cause });
        throw error;
    }
    __classPrivateFieldGet(this, _ResponsesWebSocketSession_instances, "m", _ResponsesWebSocketSession_clearRecoveredTransportError).call(this, socket);
    if (__classPrivateFieldGet(this, _ResponsesWebSocketSession_failedTransport, "f")) {
        throw __classPrivateFieldGet(this, _ResponsesWebSocketSession_failedTransport, "f").error;
    }
}, _ResponsesWebSocketSession_clearRecoveredTransportError = function _ResponsesWebSocketSession_clearRecoveredTransportError(socket) {
    // Application recovery callbacks can run before our reconnected listener.
    if (__classPrivateFieldGet(this, _ResponsesWebSocketSession_failedTransport, "f") &&
        socket !== __classPrivateFieldGet(this, _ResponsesWebSocketSession_failedTransport, "f").socket &&
        socket.readyState === ReadyState.OPEN) {
        __classPrivateFieldSet(this, _ResponsesWebSocketSession_failedTransport, undefined, "f");
    }
}, _ResponsesWebSocketSession_failLanes = function _ResponsesWebSocketSession_failLanes(error) {
    for (const { lane } of __classPrivateFieldGet(this, _ResponsesWebSocketSession_lanes, "f").values()) {
        lane.fail(error);
    }
};
//# sourceMappingURL=responses-websocket-session.mjs.map