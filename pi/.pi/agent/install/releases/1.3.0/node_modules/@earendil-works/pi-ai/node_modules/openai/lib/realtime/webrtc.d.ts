import type { RealtimeClientEvent, RealtimeServerEvent } from "../../resources/realtime/realtime.js";
import { WebRTCConnection } from "../webrtc/connection.js";
import { DataChannel } from "../webrtc/data-channel.js";
export { WebRTCError } from "../webrtc/errors.js";
export type { WebRTCErrorCode, WebRTCErrorPhase } from "../webrtc/errors.js";
export type { ExchangeSdp, WebRTCConnectOptions, WebRTCConnectionEvent, WebRTCConfiguration, WebRTCState, } from "../webrtc/types.js";
/** Browser Realtime connection with application-owned SDP exchange and typed server-event subscriptions. */
export declare class OpenAIRealtimeWebRTC extends WebRTCConnection<RealtimeClientEvent, RealtimeServerEvent> {
}
/** Typed Realtime events on a borrowed data channel; dispose() never closes application resources. */
export declare class RealtimeDataChannel extends DataChannel<RealtimeClientEvent, RealtimeServerEvent> {
}
//# sourceMappingURL=webrtc.d.ts.map