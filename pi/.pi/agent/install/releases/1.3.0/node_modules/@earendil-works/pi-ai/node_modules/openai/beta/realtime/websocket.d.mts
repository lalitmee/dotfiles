import type { AzureOpenAI } from "../../index.mjs";
import { OpenAI } from "../../index.mjs";
import type { RealtimeClientEvent } from "../../resources/beta/realtime/realtime.mjs";
import { OpenAIRealtimeEmitter } from "./internal-base.mjs";
import type { RealtimeConnectionConfig } from "./internal-base.mjs";
/** Native WebSocket instance supplied by the current JavaScript runtime. */
type _WebSocket = typeof globalThis extends {
    /** Runtime-provided WebSocket constructor used for native Realtime connections. */
    WebSocket: infer ws extends abstract new (...args: any) => any;
} ? InstanceType<ws> : any;
/**
 * Connects to the beta Realtime API using the runtime's native `WebSocket` implementation.
 *
 * Browser use is blocked by default to prevent secret API-key exposure. Prefer
 * an ephemeral Realtime credential in browsers and register an SDK `error`
 * listener before using the connection. Use the stable Realtime helper for
 * Azure sideband calls.
 */
export declare class OpenAIRealtimeWebSocket extends OpenAIRealtimeEmitter {
    /** Secure beta Realtime WebSocket URL; Azure authentication query parameters are redacted. */
    url: URL;
    /** Underlying runtime-native WebSocket instance for connection lifecycle events. */
    socket: _WebSocket;
    /**
     * Immediately opens a beta Realtime session or attaches to an existing non-Azure call.
     *
     * Clients with function-based credentials must use
     * {@link OpenAIRealtimeWebSocket.create}; Azure deployment sessions should use
     * {@link OpenAIRealtimeWebSocket.azure}. Ephemeral credentials starting with
     * `ek_` are permitted in browser runtimes automatically.
     *
     * @param props Exactly one of `model` or `callID` and optional browser-safety settings.
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
     * Resolves a client's current API credential before opening a beta Realtime WebSocket.
     *
     * Use this factory instead of the constructor when the client's `apiKey` is a function.
     *
     * @param client OpenAI client that owns the endpoint and refreshable or static credential.
     * @param props Exactly one of `model` or `callID` and optional browser-safety settings.
     */
    static create(client: Pick<OpenAI, 'apiKey' | 'baseURL' | '_callApiKey'>, props: RealtimeConnectionConfig & {
        /** Allows browser execution after the caller has secured the supplied credential. */
        dangerouslyAllowBrowser?: boolean;
    }): Promise<OpenAIRealtimeWebSocket>;
    /**
     * Opens a native beta Azure OpenAI Realtime session for a model deployment.
     *
     * Azure credentials are sent in WebSocket handshake headers and never appear
     * in the native socket URL. Browser WebSockets cannot set these headers;
     * use a server-side authentication proxy or the Node.js `ws` transport.
     *
     * @param client Azure OpenAI client that supplies the endpoint and credential.
     * @param options Optional deployment override and browser-safety settings.
     * @throws {Error} If the Azure credential or required deployment is unavailable.
     */
    static azure(client: Pick<AzureOpenAI, '_callApiKey' | 'apiVersion' | 'apiKey' | 'baseURL' | 'deploymentName'>, options?: {
        /** Azure model deployment; defaults to the deployment configured on the client. */
        deploymentName?: string;
        /** Allows browser execution after the caller has secured the supplied Azure credential. */
        dangerouslyAllowBrowser?: boolean;
    }): Promise<OpenAIRealtimeWebSocket>;
    /**
     * Serializes and sends a beta Realtime client event after the WebSocket has opened.
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
//# sourceMappingURL=websocket.d.mts.map