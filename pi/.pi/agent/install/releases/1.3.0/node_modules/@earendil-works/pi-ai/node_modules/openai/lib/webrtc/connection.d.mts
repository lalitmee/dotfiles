import type { BrowserDataChannel, BrowserPeerConnection, WebRTCConfiguration, WebRTCConnectOptions, WebRTCConnectionEvent, WebRTCState } from "./types.mjs";
/** Browser-native WebRTC negotiation with application-owned SDP signaling. */
export declare class WebRTCConnection<ClientEvent, ServerEvent extends {
    type: string;
}> {
    /** Native peer connection; configure application-owned media before connect(). */
    readonly peerConnection: BrowserPeerConnection;
    /** Native ordered, reliable channel carrying protocol events. */
    readonly dataChannel: BrowserDataChannel;
    private readonly peer;
    private readonly adapter;
    private readonly connectionEvents;
    private currentState;
    private attempt;
    /** Creates native resources, but does not request media, contact a server, or begin negotiation. */
    constructor(configuration?: WebRTCConfiguration);
    /** Current state, including before subscriptions are registered; notifications are not replayed. */
    get state(): WebRTCState;
    /** Subscribes to one server event type with its generated payload; returns an independent unsubscribe function. */
    on<Type extends ServerEvent['type']>(type: Type, handler: (event: Extract<ServerEvent, {
        type: Type;
    }>) => unknown): () => void;
    /** Subscribes before connecting so initial server events are observable. API errors remain protocol data. */
    onEvent(handler: (event: ServerEvent) => unknown): () => void;
    /** Subscribes to local diagnostics and lifecycle. Setup failures reject connect() instead of emitting errors here. */
    onConnectionEvent(handler: (event: WebRTCConnectionEvent) => unknown): () => void;
    /** Sends without buffering; returning means local submission, not server acceptance. */
    send(event: ClientEvent): void;
    /** Negotiates once and waits for both native connection and data-channel readiness. Defaults to a 30-second deadline. */
    connect(options: WebRTCConnectOptions): Promise<void>;
    /** Idempotently closes owned native resources. It never stops application-supplied media tracks. */
    close(): void;
    private negotiate;
    private checkReady;
    private failSetup;
    private finish;
    private readonly onPeerState;
    private readonly onChannelEvent;
}
//# sourceMappingURL=connection.d.mts.map