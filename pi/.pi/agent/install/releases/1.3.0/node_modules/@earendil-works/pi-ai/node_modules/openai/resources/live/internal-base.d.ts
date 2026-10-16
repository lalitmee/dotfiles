import * as LiveAPI from "./live.js";
import { OpenAI } from "../../client.js";
import { EventEmitter } from "../../core/EventEmitter.js";
import { OpenAIError } from "../../core/error.js";
import type { RawWebSocketData, ReconnectingEvent, UnsentMessage } from "../../internal/ws.js";
export type LiveStreamMessage = {
    type: 'connecting' | 'open' | 'closing';
} | {
    type: 'close';
    code: number;
    reason: string;
    unsent: UnsentMessage<LiveAPI.ClientEvent>[];
} | {
    type: 'reconnecting';
    reconnect: ReconnectingEvent;
} | {
    type: 'reconnected';
} | {
    type: 'message';
    message: LiveAPI.ServerEvent;
} | {
    type: 'raw';
    data: RawWebSocketData;
} | {
    type: 'error';
    error: WebSocketError;
};
export declare class WebSocketError extends OpenAIError {
    /**
     * The error data that the API sent back in an error event.
     *
     * This property is non-enumerable to avoid exposing the event through
     * JSON serialization, object spread, or Object.assign.
     */
    error?: LiveAPI.ErrorEvent | undefined;
    constructor(message: string, event: LiveAPI.ErrorEvent | null);
}
type Simplify<T> = {
    [KeyType in keyof T]: T[KeyType];
} & {};
type WebSocketEvents = Simplify<{
    event: (event: LiveAPI.ServerEvent) => void;
    raw: (data: RawWebSocketData) => void;
    error: (error: WebSocketError) => void;
    close: (code: number, reason: string, unsent: UnsentMessage<LiveAPI.ClientEvent>[]) => void;
    reconnecting: (event: ReconnectingEvent) => void;
    reconnected: () => void;
} & {
    [EventType in Exclude<NonNullable<LiveAPI.ServerEvent['type']>, 'error'>]: (event: Extract<LiveAPI.ServerEvent, {
        type?: EventType;
    }>) => unknown;
}>;
export declare abstract class LiveEmitter extends EventEmitter<WebSocketEvents> {
    /**
     * Send an event to the API.
     */
    abstract send(event: LiveAPI.ClientEvent): void;
    /**
     * Send raw data over the WebSocket without JSON serialization.
     */
    abstract sendRaw(data: RawWebSocketData): void;
    /**
     * Close the WebSocket connection.
     */
    abstract close(props?: {
        code: number;
        reason: string;
    }): void;
    protected _onError(event: null, message: string, cause: any): void;
    protected _onError(event: LiveAPI.ErrorEvent, message?: string | undefined): void;
}
export declare function buildURL(client: OpenAI, parameters: Record<string, unknown>): URL;
export {};
//# sourceMappingURL=internal-base.d.ts.map