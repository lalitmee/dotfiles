import type { RealtimeClientEvent, RealtimeServerEvent, ErrorEvent } from "../../resources/beta/realtime/realtime.js";
import { EventEmitter } from "../../lib/EventEmitter.js";
import { OpenAIError } from "../../error.js";
import type OpenAI from "../../index.js";
import { AzureOpenAI } from "../../index.js";
/** Parses frame data without exposing malformed payloads through JSON syntax errors. */
export declare function parseRealtimeEvent(data: string): RealtimeServerEvent;
/** An API-reported or client-side error encountered by a beta Realtime connection. */
export declare class OpenAIRealtimeError extends OpenAIError {
    /** Stable error name used to identify Realtime connection failures. */
    name: string;
    /**
     * The error data that the API sent back in an `error` event.
     */
    error?: ErrorEvent.Error | undefined;
    /**
     * The unique ID of the server event.
     */
    event_id?: string | undefined;
    /**
     * Creates a beta Realtime error, preserving server-provided details when available.
     *
     * @param message Human-readable API or connection error description.
     * @param event Server error event, or `null` for a client-side failure.
     */
    constructor(message: string, event: ErrorEvent | null);
}
/** Materializes mapped beta Realtime listener properties without changing their public types. */
type Simplify<T> = {
    [KeyType in keyof T]: T[KeyType];
} & {};
/**
 * Maps beta Realtime server event types to their corresponding strongly typed listener callbacks.
 *
 * The `event` listener observes every server event, `error` receives normalized
 * API or transport failures, and other keys match non-error server event types.
 */
type RealtimeEvents = Simplify<{
    /** Receives every server event before its event-specific listener is notified. */
    event: (event: RealtimeServerEvent) => void;
    /** Receives API-reported errors and client-side WebSocket failures. */
    error: (error: OpenAIRealtimeError) => void;
} & {
    [EventType in Exclude<RealtimeServerEvent['type'], 'error'>]: (event: Extract<RealtimeServerEvent, {
        /** Server-event discriminator associated with this specific listener. */
        type: EventType;
    }>) => unknown;
}>;
/**
 * Typed event emitter shared by the beta Realtime WebSocket implementations.
 *
 * Listen for `event` to receive all server events, or subscribe to a specific
 * server event's `type`. Always register an `error` listener; otherwise API and
 * transport failures are reported as unhandled promise rejections.
 */
export declare abstract class OpenAIRealtimeEmitter extends EventEmitter<RealtimeEvents> {
    /**
     * Serializes and sends a client event after the underlying WebSocket is open.
     * Serialization and transport failures are delivered to the `error` event.
     */
    abstract send(event: RealtimeClientEvent): void;
    /**
     * Closes the WebSocket with status code `1000` and reason `OK` by default.
     * Connection-closing failures are delivered to the `error` event.
     */
    abstract close(props?: {
        /** WebSocket close status code; defaults to `1000`. */
        code: number;
        /** WebSocket close reason; defaults to `OK`. */
        reason: string;
    }): void;
    protected _onError(event: null, message: string, cause: any): void;
    protected _onError(event: ErrorEvent, message?: string | undefined): void;
}
/** Reports whether the client is an Azure OpenAI client with Azure-specific Realtime routing. */
export declare function isAzure(client: Pick<OpenAI, 'apiKey' | 'baseURL'>): client is AzureOpenAI;
/** Starts a beta Realtime model session or attaches to one existing non-Azure call. */
export type RealtimeConnectionConfig = {
    /**
     * Start a new Realtime session using the given model.
     */
    model: string;
    /** Existing call identifier; cannot be supplied when starting a model-backed session. */
    callID?: undefined;
} | {
    /** Model name; cannot be supplied when attaching to an existing call. */
    model?: undefined;
    /**
     * Attach to an in-progress Realtime call over a sideband control connection.
     */
    callID: string;
};
/**
 * Builds the secure WebSocket URL for a beta Realtime session or non-Azure sideband call.
 *
 * @throws {Error} If both `model` and `callID`, or neither, are supplied, or an
 * Azure sideband call is requested through the beta helpers.
 */
export declare function buildRealtimeURL(client: Pick<OpenAI, 'apiKey' | 'baseURL'>, connection: string | RealtimeConnectionConfig): URL;
export {};
//# sourceMappingURL=internal-base.d.ts.map