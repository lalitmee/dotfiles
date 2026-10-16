import * as WS from 'ws';
import type { AzureOpenAI } from "../index.js";
import { OpenAI } from "../index.js";
import type { RealtimeClientEvent } from "../resources/realtime/realtime.js";
import { OpenAIRealtimeEmitter } from "./internal-base.js";
import type { AzureRealtimeConnectionConfig, RealtimeConnectionConfig } from "./internal-base.js";
/**
 * Connects to the Realtime API using the Node.js `ws` WebSocket implementation.
 *
 * Install the optional `ws` peer dependency before importing this entrypoint.
 * Subscribe to `socket`'s `open` and `close` events for connection lifecycle,
 * and register an SDK `error` listener for API or transport failures.
 */
export declare class OpenAIRealtimeWS extends OpenAIRealtimeEmitter {
    /** Secure Realtime WebSocket URL with its model, transcription intent, or call ID. */
    url: URL;
    /** Underlying `ws.WebSocket` instance for connection lifecycle and transport events. */
    socket: WS.WebSocket;
    /**
     * Immediately opens a model or transcription session, or attaches to an existing call.
     *
     * Pass an existing OpenAI client as the second argument to reuse its endpoint
     * and static credentials. Clients with function-based credentials must use
     * {@link OpenAIRealtimeWS.create}; Azure clients should use
     * {@link OpenAIRealtimeWS.azure}.
     *
     * @param props Exactly one model, transcription intent, or call ID, plus `ws` client settings.
     * @param client Existing client whose endpoint and API key should be reused.
     */
    constructor(props: RealtimeConnectionConfig & {
        /** Options passed directly to the underlying `ws.WebSocket` constructor. */
        options?: WS.ClientOptions | undefined;
        /** Indicates that a function-based credential was resolved by an async factory. @internal */
        __resolvedApiKey?: boolean;
        /** Credential captured by an async factory for this connection. @internal */
        __apiKey?: string | null;
    }, client?: Pick<OpenAI, 'apiKey' | 'baseURL'>);
    /**
     * Resolves a client's current API credential before opening a Realtime connection.
     *
     * Use this factory instead of the constructor when the client's `apiKey` is a function.
     *
     * @param client OpenAI client that owns the endpoint and refreshable or static credential.
     * @param props Exactly one model, transcription intent, or call ID, plus `ws` client settings.
     */
    static create(client: Pick<OpenAI, 'apiKey' | 'baseURL' | '_callApiKey'>, props: RealtimeConnectionConfig & {
        /** Options passed directly to the underlying `ws.WebSocket` constructor. */
        options?: WS.ClientOptions | undefined;
    }): Promise<OpenAIRealtimeWS>;
    /**
     * Opens an Azure deployment or transcription session, or an existing sideband call.
     *
     * Static Azure API keys are sent in the `api-key` header; function-based
     * credentials are resolved first and sent as bearer credentials. The client's
     * configured deployment is used unless a deployment, transcription intent, or call ID is supplied.
     *
     * @param client Azure OpenAI client that supplies the endpoint and credential.
     * @param props Deployment, transcription intent, or call ID, plus `ws` connection settings.
     * @throws {Error} If the Azure credential or required deployment is unavailable.
     */
    static azure(client: Pick<AzureOpenAI, '_callApiKey' | 'apiVersion' | 'apiKey' | 'baseURL' | 'deploymentName'>, props?: AzureRealtimeConnectionConfig & {
        /** Options passed directly to the underlying `ws.WebSocket` constructor. */
        options?: WS.ClientOptions | undefined;
    }): Promise<OpenAIRealtimeWS>;
    /**
     * Serializes and sends a Realtime client event after the WebSocket has opened.
     * Serialization and transport failures are delivered to the SDK `error` event.
     */
    send(event: RealtimeClientEvent): void;
    /**
     * Closes the WebSocket with status code `1000` and reason `OK` by default.
     * Connection-closing failures are delivered to the SDK `error` event.
     */
    close(props?: {
        /** WebSocket close status code; defaults to `1000`. */
        code: number;
        /** WebSocket close reason; defaults to `OK`. */
        reason: string;
    }): void;
}
//# sourceMappingURL=ws.d.ts.map