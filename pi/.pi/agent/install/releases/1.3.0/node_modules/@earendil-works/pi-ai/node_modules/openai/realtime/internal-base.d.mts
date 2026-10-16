import type { RealtimeClientEvent, RealtimeServerEvent, RealtimeErrorEvent, RealtimeError } from "../resources/realtime/realtime.mjs";
import { EventEmitter } from "../lib/EventEmitter.mjs";
import { OpenAIError } from "../error.mjs";
import type OpenAI from "../index.mjs";
import { AzureOpenAI } from "../index.mjs";
/** Parses frame data without exposing malformed payloads through JSON syntax errors. */
export declare function parseRealtimeEvent(data: string): RealtimeServerEvent;
/** An API-reported or client-side error encountered by an active Realtime connection. */
export declare class OpenAIRealtimeError extends OpenAIError {
    /** Stable error name used to identify Realtime connection failures. */
    name: string;
    /**
     * The error data that the API sent back in an `error` event.
     */
    error?: RealtimeError | undefined;
    /**
     * The unique ID of the server event.
     */
    event_id?: string | undefined;
    /**
     * Creates a Realtime error, preserving server-provided details when available.
     *
     * @param message Human-readable API or connection error description.
     * @param event Server error event, or `null` for a client-side failure.
     */
    constructor(message: string, event: RealtimeErrorEvent | null);
}
/** Materializes mapped Realtime listener properties without changing their public types. */
type Simplify<T> = {
    [KeyType in keyof T]: T[KeyType];
} & {};
/**
 * Maps Realtime server event types to their corresponding strongly typed listener callbacks.
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
 * Typed event emitter shared by Realtime WebSocket client implementations.
 *
 * Listen for `event` to receive all server events, or subscribe to a specific
 * server event's `type`. Always register an `error` listener; otherwise API and
 * transport failures are reported as unhandled promise rejections.
 */
export declare abstract class OpenAIRealtimeEmitter extends EventEmitter<RealtimeEvents> {
    /**
     * Serializes and sends a client event over the active WebSocket connection.
     *
     * Wait until the underlying socket is open before calling this method.
     * Serialization and transport failures are delivered to the `error` event.
     */
    abstract send(event: RealtimeClientEvent): void;
    /**
     * Closes the WebSocket with status code `1000` and reason `OK` by default.
     *
     * Connection-closing failures are delivered to the `error` event.
     */
    abstract close(props?: {
        /** WebSocket close status code; defaults to `1000`. */
        code: number;
        /** WebSocket close reason; defaults to `OK`. */
        reason: string;
    }): void;
    protected _onError(event: null, message: string, cause: any): void;
    protected _onError(event: RealtimeErrorEvent, message?: string | undefined): void;
}
/** Reports whether the client is an Azure OpenAI client with Azure-specific Realtime routing. */
export declare function isAzure(client: Pick<OpenAI, 'apiKey' | 'baseURL'>): client is AzureOpenAI;
interface RealtimeURLBuilderOptions {
    /**
     * Builds the exact WebSocket URL after the connection target has been validated.
     *
     * Return only a trusted `wss:` URL because the client's credentials are sent to
     * that endpoint. Model, call ID, transcription intent, and deployment query
     * parameters are not added to the returned URL.
     */
    buildRealtimeURL?: (client: Pick<OpenAI, 'apiKey' | 'baseURL'>, connection: RealtimeConnectionConfig) => URL;
}
/** Starts a model or transcription session, or attaches to exactly one existing call. */
export type RealtimeConnectionConfig = (RealtimeURLBuilderOptions & {
    /**
     * Start a new Realtime session using the given model.
     */
    model: string;
    /** Transcription intent; cannot be supplied when starting a model-backed session. */
    intent?: undefined;
    /** Existing call identifier; cannot be supplied when starting a model-backed session. */
    callID?: undefined;
}) | (RealtimeURLBuilderOptions & {
    /** Starts a transcription-only Realtime session without selecting a model. */
    intent: 'transcription';
    /** Model name; cannot be supplied when starting a transcription-only session. */
    model?: undefined;
    /** Existing call identifier; cannot be supplied with transcription intent. */
    callID?: undefined;
}) | (RealtimeURLBuilderOptions & {
    /** Model name; cannot be supplied when attaching to an existing call. */
    model?: undefined;
    /** Transcription intent; cannot be supplied when attaching to an existing call. */
    intent?: undefined;
    /**
     * Attach to an in-progress Realtime call over a sideband control connection.
     */
    callID: string;
});
/** Starts an Azure deployment or transcription session, or attaches to an existing call. */
export type AzureRealtimeConnectionConfig = (RealtimeURLBuilderOptions & {
    /**
     * Override the deployment configured on the Azure client.
     */
    deploymentName?: string;
    /** Transcription intent; cannot be combined with a model deployment. */
    intent?: undefined;
    /** Existing call identifier; cannot be combined with `deploymentName`. */
    callID?: undefined;
}) | (RealtimeURLBuilderOptions & {
    /** Starts an Azure transcription session; set its deployment later in `session.update`. */
    intent: 'transcription';
    /** Deployment override; cannot be supplied with transcription intent. */
    deploymentName?: undefined;
    /** Existing call identifier; cannot be supplied with transcription intent. */
    callID?: undefined;
}) | (RealtimeURLBuilderOptions & {
    /** Deployment override; cannot be supplied when attaching to an existing call. */
    deploymentName?: undefined;
    /** Transcription intent; cannot be supplied when attaching to an existing call. */
    intent?: undefined;
    /**
     * Attach to an in-progress Azure Realtime call over a sideband control connection.
     */
    callID: string;
});
/**
 * Builds the secure WebSocket URL for a model or transcription session, or a sideband call.
 *
 * All Azure sessions use the versioned GA Realtime endpoint. Model-backed
 * sessions select their deployment with `model`, transcription sessions use
 * `intent`, and sideband connections use `call_id`.
 *
 * @throws {Error} If the connection target is invalid or a custom URL does not use `wss:`.
 */
export declare function buildRealtimeURL(client: Pick<OpenAI, 'apiKey' | 'baseURL'>, connection: string | RealtimeConnectionConfig): URL;
/**
 * Resolves an Azure deployment, transcription intent, or an existing Realtime call.
 *
 * @throws {Error} If connection targets conflict, intent is invalid, or no deployment is available.
 */
export declare function getAzureRealtimeConnection(client: Pick<AzureOpenAI, 'deploymentName'>, connection: AzureRealtimeConnectionConfig): RealtimeConnectionConfig;
export {};
//# sourceMappingURL=internal-base.d.mts.map