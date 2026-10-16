import * as ForksAPI from "./forks.mjs";
import * as LiveAPI from "../live.mjs";
import { OpenAI } from "../../../client.mjs";
import { EventEmitter } from "../../../core/EventEmitter.mjs";
import { OpenAIError } from "../../../core/error.mjs";
import type { RawWebSocketData, ReconnectingEvent, UnsentMessage } from "../../../internal/ws.mjs";
import { ForksWSParameters } from "./ws-base.mjs";
export type ForksStreamMessage = {
    type: 'connecting' | 'open' | 'closing';
} | {
    type: 'close';
    code: number;
    reason: string;
    unsent: UnsentMessage<ForksAPI.ForkClientEvent>[];
} | {
    type: 'reconnecting';
    reconnect: ReconnectingEvent<ForksWSParameters>;
} | {
    type: 'reconnected';
} | {
    type: 'message';
    message: ForksAPI.ForkServerEvent;
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
    event: (event: ForksAPI.ForkServerEvent) => void;
    raw: (data: RawWebSocketData) => void;
    error: (error: WebSocketError) => void;
    close: (code: number, reason: string, unsent: UnsentMessage<ForksAPI.ForkClientEvent>[]) => void;
    reconnecting: (event: ReconnectingEvent<ForksWSParameters>) => void;
    reconnected: () => void;
} & {
    [EventType in Exclude<NonNullable<ForksAPI.ForkServerEvent['type']>, 'error'>]: (event: Extract<ForksAPI.ForkServerEvent, {
        type?: EventType;
    }>) => unknown;
}>;
export declare abstract class ForksEmitter extends EventEmitter<WebSocketEvents> {
    /**
     * Send an event to the API.
     */
    abstract send(event: ForksAPI.ForkClientEvent): void;
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
//# sourceMappingURL=internal-base.d.mts.map