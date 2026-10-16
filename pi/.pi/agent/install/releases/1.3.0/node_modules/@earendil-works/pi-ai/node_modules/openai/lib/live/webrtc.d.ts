import type { ConnectClientEvent as ClientEvent, ConnectServerEvent as ServerEvent } from "../../resources/live/sideband/sideband.js";
import { WebRTCConnection } from "../webrtc/connection.js";
import { DataChannel } from "../webrtc/data-channel.js";
export { WebRTCError } from "../webrtc/errors.js";
export type { WebRTCErrorCode, WebRTCErrorPhase } from "../webrtc/errors.js";
export type { ExchangeSdp, WebRTCConnectOptions, WebRTCConnectionEvent, WebRTCConfiguration, WebRTCState, } from "../webrtc/types.js";
/** Browser Live connection with application-owned SDP exchange and typed server-event subscriptions. */
export declare class OpenAILiveWebRTC extends WebRTCConnection<ClientEvent, ServerEvent> {
}
/** Typed Live events on a borrowed data channel; dispose() never closes application resources. */
export declare class LiveDataChannel extends DataChannel<ClientEvent, ServerEvent> {
}
//# sourceMappingURL=webrtc.d.ts.map