import type { RealtimeClientEvent, RealtimeServerEvent } from "../../resources/realtime/realtime.mjs";
import { WebRTCConnection } from "../webrtc/connection.mjs";
import { DataChannel } from "../webrtc/data-channel.mjs";
export { WebRTCError } from "../webrtc/errors.mjs";
export type { WebRTCErrorCode, WebRTCErrorPhase } from "../webrtc/errors.mjs";
export type { ExchangeSdp, WebRTCConnectOptions, WebRTCConnectionEvent, WebRTCConfiguration, WebRTCState, } from "../webrtc/types.mjs";
/** Browser Realtime connection with application-owned SDP exchange and typed server-event subscriptions. */
export declare class OpenAIRealtimeWebRTC extends WebRTCConnection<RealtimeClientEvent, RealtimeServerEvent> {
}
/** Typed Realtime events on a borrowed data channel; dispose() never closes application resources. */
export declare class RealtimeDataChannel extends DataChannel<RealtimeClientEvent, RealtimeServerEvent> {
}
//# sourceMappingURL=webrtc.d.mts.map