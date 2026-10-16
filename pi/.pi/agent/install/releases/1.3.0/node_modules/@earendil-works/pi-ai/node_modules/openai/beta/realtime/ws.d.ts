import * as WS from 'ws';
import type { AzureOpenAI } from "../../index.js";
import { OpenAI } from "../../index.js";
import type { RealtimeClientEvent } from "../../resources/beta/realtime/realtime.js";
import { OpenAIRealtimeEmitter } from "./internal-base.js";
import type { RealtimeConnectionConfig } from "./internal-base.js";
export declare class OpenAIRealtimeWS extends OpenAIRealtimeEmitter {
    /** Secure beta Realtime WebSocket URL, including the model or non-Azure call ID. */
    url: URL;
    /** Underlying `ws.WebSocket` instance for connection lifecycle and transport events. */
    socket: WS.WebSocket;
    /**
     * Immediately opens a beta Realtime model session or attaches to an existing non-Azure call.
     *
     * Clients with function-based credentials must use
     * {@link OpenAIRealtimeWS.create}; Azure deployment sessions should use
     * {@link OpenAIRealtimeWS.azure}.
     *
     * @param props Exactly one of `model` or `callID`, plus optional `ws` client settings.
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
     * Resolves a client's current API credential before opening a beta Realtime connection.
     *
     * Use this factory instead of the constructor when the client's `apiKey` is a function.
     *
     * @param client OpenAI client that owns the endpoint and refreshable or static credential.
     * @param props Exactly one of `model` or `callID`, plus optional `ws` client settings.
     */
    static create(client: Pick<OpenAI, 'apiKey' | 'baseURL' | '_callApiKey'>, props: RealtimeConnectionConfig & {
        /** Options passed directly to the underlying `ws.WebSocket` constructor. */
        options?: WS.ClientOptions | undefined;
    }): Promise<OpenAIRealtimeWS>;
    /**
     * Opens a beta Azure OpenAI Realtime session for the selected model deployment.
     *
     * Static Azure API keys are sent in the `api-key` header; function-based
     * credentials are resolved first and sent as bearer credentials. Use the
     * stable Realtime helper when attaching to an existing Azure call.
     *
     * @param client Azure OpenAI client that supplies the endpoint and credential.
     * @param props Optional deployment override and `ws` connection settings.
     * @throws {Error} If the Azure credential or required deployment is unavailable.
     */
    static azure(client: Pick<AzureOpenAI, '_callApiKey' | 'apiVersion' | 'apiKey' | 'baseURL' | 'deploymentName'>, props?: {
        /** Azure model deployment; defaults to the deployment configured on the client. */
        deploymentName?: string;
        /** Options passed directly to the underlying `ws.WebSocket` constructor. */
        options?: WS.ClientOptions | undefined;
    }): Promise<OpenAIRealtimeWS>;
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
//# sourceMappingURL=ws.d.ts.map