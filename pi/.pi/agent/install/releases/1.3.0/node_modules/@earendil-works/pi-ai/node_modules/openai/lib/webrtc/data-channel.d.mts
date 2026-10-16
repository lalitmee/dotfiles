import type { BrowserDataChannel, WebRTCConnectionEvent, WebRTCDataChannel } from "./types.mjs";
/** Typed protocol messages on an application-owned native RTCDataChannel. */
export declare class DataChannel<ClientEvent, ServerEvent extends {
    type: string;
}> {
    /** The borrowed native channel. dispose() never closes it. */
    readonly dataChannel: BrowserDataChannel;
    private readonly channel;
    private readonly events;
    private readonly connectionEvents;
    private disposed;
    /** Attaches listeners without negotiating, opening, or taking ownership of the channel. */
    constructor(channel: WebRTCDataChannel);
    /** Subscribes to one server event type with its generated payload; returns an independent unsubscribe function. */
    on<Type extends ServerEvent['type']>(type: Type, handler: (event: Extract<ServerEvent, {
        type: Type;
    }>) => unknown): () => void;
    /** Subscribes to future server events, including raw API errors; returns an unsubscribe function. */
    onEvent(handler: (event: ServerEvent) => unknown): () => void;
    /** Observes only this channel's local errors and lifecycle, not its owning peer connection. */
    onConnectionEvent(handler: (event: WebRTCConnectionEvent) => unknown): () => void;
    /** Sends immediately on an open channel. Throws on local failure; API acceptance is reported by server events. */
    send(event: ClientEvent): void;
    /** Detaches all SDK listeners and subscriptions, without closing the channel or stopping tracks. */
    dispose(): void;
    private assertActive;
    private readonly onMessage;
    private readonly onError;
    private readonly onOpen;
    private readonly onClose;
}
//# sourceMappingURL=data-channel.d.mts.map