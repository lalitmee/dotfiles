import type { ResponsesEmitter } from "../../resources/responses/internal-base.js";
import type { WebSocketLike } from "../../internal/ws-adapter.js";
import { ResponsesWebSocketLane } from "./responses-websocket-lane.js";
export { ResponsesWebSocketLane } from "./responses-websocket-lane.js";
export type { ResponsesWebSocketEvent } from "./responses-websocket-lane.js";
/** Limits for this optional helper. They do not change the underlying socket's limits. */
export interface ResponsesWebSocketSessionOptions {
    /** Maximum lane IDs registered until the next reconnect, including detached lanes. */
    maxLanes: number;
    /** Maximum queued events across all lanes. */
    maxBufferedEvents: number;
    /** Maximum queued UTF-8 JSON bytes across all lanes. */
    maxBufferedBytes: number;
}
/**
 * Routes events from an existing Responses socket without creating another reader.
 * Register lanes before sending. Unregistered events remain observable on the socket.
 * Closing this helper releases its listeners and lanes, but leaves the socket open.
 * Attaching to a closing or closed socket is rejected.
 * Reconnecting invalidates lanes: register new ones after restoring application state.
 * No request is replayed by this helper.
 */
export declare class ResponsesWebSocketSession {
    #private;
    constructor(connection: ResponsesEmitter & {
        readonly socket: WebSocketLike;
    }, options: ResponsesWebSocketSessionOptions);
    /** Omit streamID for the protocol's default lane. A lane has one consumer.
     * IDs remain reserved until reconnect, including after close or failure:
     * a terminal response can still be followed by an automatic successor.
     */
    lane(streamID?: string, limits?: {
        maxBufferedEvents?: number;
        maxBufferedBytes?: number;
    }): ResponsesWebSocketLane;
    close(): void;
}
//# sourceMappingURL=responses-websocket-session.d.ts.map