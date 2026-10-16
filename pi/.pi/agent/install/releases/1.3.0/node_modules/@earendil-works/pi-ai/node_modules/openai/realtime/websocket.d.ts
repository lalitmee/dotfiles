import type { AzureOpenAI } from "../index.js";
import { OpenAI } from "../index.js";
import type { RealtimeClientEvent } from "../resources/realtime/realtime.js";
import { OpenAIRealtimeEmitter } from "./internal-base.js";
import type { AzureRealtimeConnectionConfig, RealtimeConnectionConfig } from "./internal-base.js";
/** Native WebSocket instance supplied by the current JavaScript runtime. */
type _WebSocket = typeof globalThis extends {
    /** Runtime-provided WebSocket constructor used for native Realtime connections. */
    WebSocket: infer ws extends abstract new (...args: any) => any;
} ? InstanceType<ws> : any;
/**
 * Connects to the Realtime API using the runtime's native `WebSocket` implementation.
 *
 * Browser use is blocked by default to prevent secret API-key exposure. Use an
 * ephemeral Realtime credential in browser clients; set
 * `dangerouslyAllowBrowser` only after independently securing the credential.
 * Register an SDK `error` listener and wait for `socket`'s `open` event before
 * sending Realtime client events.
 */
export declare class OpenAIRealtimeWebSocket extends OpenAIRealtimeEmitter {
    /** Secure Realtime WebSocket URL; Azure authentication query parameters are redacted. */
    url: URL;
    /** Underlying runtime-native WebSocket instance for connection lifecycle events. */
    socket: _WebSocket;
    /**
     * Immediately opens a native WebSocket session or attaches to an existing call.
     *
     * Clients with function-based credentials must use
     * {@link OpenAIRealtimeWebSocket.create}; Azure clients should use
     * {@link OpenAIRealtimeWebSocket.azure}. An ephemeral credential whose value
     * starts with `ek_` is permitted in browser runtimes automatically.
     *
     * @param props Exactly one model, transcription intent, or call ID, plus browser-safety settings.
     * @param client Existing client whose endpoint and API key should be reused.
     * @throws {OpenAIError} If browser access would expose an unapproved credential.
     */
    constructor(props: RealtimeConnectionConfig & {
        /** Allows browser execution; use only when the credential cannot expose a secret API key. */
        dangerouslyAllowBrowser?: boolean;
        /**
         * Callback to mutate the URL, needed for Azure.
         * @internal
         */
        onURL?: (url: URL) => void;
        /** Indicates the token was resolved by the factory just before connecting. @internal */
        __resolvedApiKey?: boolean;
        /** Credential captured by an async factory for this connection. @internal */
        __apiKey?: string | null;
    }, client?: Pick<OpenAI, 'apiKey' | 'baseURL'>);
    /**
     * Resolves a client's current API credential before opening a native Realtime WebSocket.
     *
     * Use this factory instead of the constructor when the client's `apiKey` is a function.
     *
     * @param client OpenAI client that owns the endpoint and refreshable or static credential.
     * @param props Exactly one model, transcription intent, or call ID, plus browser-safety settings.
     */
    static create(client: Pick<OpenAI, 'apiKey' | 'baseURL' | '_callApiKey'>, props: RealtimeConnectionConfig & {
        /** Allows browser execution after the caller has secured the supplied credential. */
        dangerouslyAllowBrowser?: boolean;
    }): Promise<OpenAIRealtimeWebSocket>;
    /**
     * Opens a native Azure deployment or transcription session, or an existing sideband call.
     *
     * Azure credentials are sent in WebSocket handshake headers and never appear
     * in the native socket URL. Browser WebSockets cannot set these headers;
     * use a server-side authentication proxy or the Node.js `ws` transport.
     *
     * @param client Azure OpenAI client that supplies the endpoint and credential.
     * @param options Deployment, transcription intent, or call ID, plus browser-safety settings.
     * @throws {Error} If the Azure credential or required deployment is unavailable.
     */
    static azure(client: Pick<AzureOpenAI, '_callApiKey' | 'apiVersion' | 'apiKey' | 'baseURL' | 'deploymentName'>, options?: AzureRealtimeConnectionConfig & {
        /** Allows browser execution after the caller has secured the supplied Azure credential. */
        dangerouslyAllowBrowser?: boolean;
    }): Promise<OpenAIRealtimeWebSocket>;
    /**
     * Serializes and sends a Realtime client event after the native WebSocket has opened.
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
export {};
//# sourceMappingURL=websocket.d.ts.map